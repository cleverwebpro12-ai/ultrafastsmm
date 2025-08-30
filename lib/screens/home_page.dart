import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';

class HomePage extends ConsumerWidget {
  final UserModel user;
  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersStream = ref.watch(ordersProvider);

    return ordersStream.when(
      data: (orders) {
        final totalSpent = orders.fold<double>(
          0,
          (sum, item) => sum + item.charge,
        );
        final pendingOrders = orders.where((o) => o.status == 'Pending').length;
        final completedOrders = orders
            .where((o) => o.status == 'Completed')
            .length;

        return LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Text(
                  'Welcome, ${user.username}!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                GridView.count(
                  crossAxisCount: crossAxisCount,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    _buildStatCard(
                      'Total Orders',
                      orders.length.toString(),
                      Icons.shopping_cart,
                      Colors.indigo,
                    ),
                    _buildStatCard(
                      'Pending Orders',
                      pendingOrders.toString(),
                      Icons.hourglass_top,
                      Colors.orange,
                    ),
                    _buildStatCard(
                      'Completed Orders',
                      completedOrders.toString(),
                      Icons.check_circle,
                      Colors.green,
                    ),
                    _buildStatCard(
                      'Total Spent',
                      '\$${totalSpent.toStringAsFixed(2)}',
                      Icons.monetization_on,
                      Colors.red,
                    ),
                  ],
                ),
                // You can add more widgets here for recent orders, news, etc.
              ],
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.7), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 32, color: Colors.white),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: TextStyle(color: Colors.white.withOpacity(0.9)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
