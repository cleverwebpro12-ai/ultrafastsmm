import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../services/firestore_service.dart';

class OrdersPage extends ConsumerWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersStream = ref.watch(ordersProvider);

    return ordersStream.when(
      data: (orders) {
        if (orders.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No orders yet.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }
        return LayoutBuilder(
          builder: (context, constraints) {
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                order.serviceName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            _buildStatusChip(order.status),
                          ],
                        ),
                        const Divider(height: 24),
                        _buildOrderDetailRow(
                          Icons.calendar_today,
                          'Date:',
                          DateFormat.yMd().add_jm().format(
                            order.createdAt.toDate(),
                          ),
                          constraints.maxWidth,
                        ),
                        const SizedBox(height: 8),
                        _buildOrderDetailRow(
                          Icons.link,
                          'Link:',
                          order.link,
                          constraints.maxWidth,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _buildOrderDetailRow(
                                Icons.format_list_numbered,
                                'Quantity:',
                                order.quantity.toString(),
                                constraints.maxWidth / 2,
                              ),
                            ),
                            Expanded(
                              child: _buildOrderDetailRow(
                                Icons.monetization_on,
                                'Charge:',
                                '\$${order.charge.toStringAsFixed(2)}',
                                constraints.maxWidth / 2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildOrderDetailRow(
    IconData icon,
    String label,
    String value,
    double maxWidth,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(color: Colors.grey[600])),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
            overflow: maxWidth < 400
                ? TextOverflow.ellipsis
                : TextOverflow.visible,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    IconData icon;
    switch (status) {
      case 'Completed':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'Pending':
        color = Colors.orange;
        icon = Icons.hourglass_top;
        break;
      default:
        color = Colors.red;
        icon = Icons.cancel;
    }
    return Chip(
      avatar: Icon(icon, color: Colors.white, size: 16),
      label: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
    );
  }
}
