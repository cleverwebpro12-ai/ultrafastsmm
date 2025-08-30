import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String id;
  final String serviceName;
  final String link;
  final int quantity;
  final double charge;
  final String status;
  final Timestamp createdAt;

  Order({
    required this.id,
    required this.serviceName,
    required this.link,
    required this.quantity,
    required this.charge,
    required this.status,
    required this.createdAt,
  });

  factory Order.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Order(
      id: doc.id,
      serviceName: data['serviceName'] ?? '',
      link: data['link'] ?? '',
      quantity: data['quantity'] ?? 0,
      charge: (data['charge'] ?? 0.0).toDouble(),
      status: data['status'] ?? 'Unknown',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'serviceName': serviceName,
      'link': link,
      'quantity': quantity,
      'charge': charge,
      'status': status,
      'createdAt': createdAt,
    };
  }
}
