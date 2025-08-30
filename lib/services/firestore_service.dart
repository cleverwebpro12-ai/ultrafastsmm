// firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '/models/order_model.dart' as my_order;
import '/models/service_model.dart';
import '/models/transaction_model.dart' as my_transaction;
import '/models/user_model.dart';
import 'dart:math';

final firestoreServiceProvider = Provider<FirestoreService>(
  (ref) => FirestoreService(FirebaseFirestore.instance, FirebaseAuth.instance),
);
final userProvider = StreamProvider<UserModel>(
  (ref) => ref.watch(firestoreServiceProvider).getUser(),
);
final ordersProvider = StreamProvider<List<my_order.Order>>(
  (ref) => ref.watch(firestoreServiceProvider).getOrders(),
);
final transactionsProvider = StreamProvider<List<my_transaction.Transaction>>(
  (ref) => ref.watch(firestoreServiceProvider).getTransactions(),
);

class FirestoreService {
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  FirestoreService(this._db, this._auth);

  String get _uid => _auth.currentUser!.uid;

  Future<void> createUser(User user, String username) async {
    final apiKey = _generateApiKey();
    await _db.collection('users').doc(user.uid).set({
      'username': username,
      'email': user.email,
      'balance': 0.0,
      'apiKey': apiKey,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<UserModel> getUser() {
    return _db
        .collection('users')
        .doc(_uid)
        .snapshots()
        .map((snap) => UserModel.fromFirestore(snap));
  }

  Stream<List<my_order.Order>> getOrders() {
    return _db
        .collection('users')
        .doc(_uid)
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => my_order.Order.fromFirestore(doc))
              .toList(),
        );
  }

  Stream<List<my_transaction.Transaction>> getTransactions() {
    return _db
        .collection('users')
        .doc(_uid)
        .collection('transactions')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => my_transaction.Transaction.fromFirestore(doc))
              .toList(),
        );
  }

  Future<void> placeOrder(
    Service service,
    String link,
    int quantity,
    double charge,
  ) async {
    final userDoc = await _db.collection('users').doc(_uid).get();
    final currentBalance = (userDoc.data()!['balance'] as num).toDouble();

    if (currentBalance >= charge) {
      final newBalance = currentBalance - charge;

      final order = my_order.Order(
        id: '', // Firestore will generate
        serviceName: service.name,
        link: link,
        quantity: quantity,
        charge: charge,
        status:
            'Pending', // Logic for admin balance can be here or in a cloud function
        createdAt: Timestamp.now(),
      );

      final transaction = my_transaction.Transaction(
        id: '', // Firestore will generate
        type: 'Order',
        amount: charge,
        description: 'Order for ${service.name}',
        createdAt: Timestamp.now(),
      );

      WriteBatch batch = _db.batch();
      batch.update(_db.collection('users').doc(_uid), {'balance': newBalance});
      batch.set(
        _db.collection('users').doc(_uid).collection('orders').doc(),
        order.toMap(),
      );
      batch.set(
        _db.collection('users').doc(_uid).collection('transactions').doc(),
        transaction.toMap(),
      );

      await batch.commit();
    } else {
      throw Exception('Insufficient balance');
    }
  }

  Future<void> addDeposit(double amount) async {
    final transaction = my_transaction.Transaction(
      id: '', // Firestore will generate
      type: 'Deposit',
      amount: amount,
      description: 'Manual Deposit',
      createdAt: Timestamp.now(),
    );

    WriteBatch batch = _db.batch();
    batch.update(_db.collection('users').doc(_uid), {
      'balance': FieldValue.increment(amount),
    });
    batch.set(
      _db.collection('users').doc(_uid).collection('transactions').doc(),
      transaction.toMap(),
    );

    await batch.commit();
  }

  String _generateApiKey() {
    final random = Random();
    const allChars = 'AaBbCcDdlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final randomString = List.generate(
      32,
      (index) => allChars[random.nextInt(allChars.length)],
    ).join();
    return randomString;
  }
}
