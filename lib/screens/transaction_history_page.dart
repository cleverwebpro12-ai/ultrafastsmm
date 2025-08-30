import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '/services/firestore_service.dart';
import '../theme/AppTheme.dart';

class TransactionHistoryPage extends ConsumerWidget {
  const TransactionHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsStream = ref.watch(transactionsProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History', style: textTheme.headlineSmall),
      ),
      body: transactionsStream.when(
        data: (transactions) {
          if (transactions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.receipt_long_rounded,
                    size: 80,
                    color: AppTheme.subtextColor,
                  ),
                  const SizedBox(height: 16),
                  Text('No transactions found.', style: textTheme.titleMedium),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(24.0),
            itemCount: transactions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final tx = transactions[index];
              final isDeposit = tx.type == 'Deposit';
              final color = isDeposit
                  ? AppTheme.successColor
                  : AppTheme.errorColor;
              final icon = isDeposit
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded;

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(icon, color: color),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(tx.description, style: textTheme.bodyLarge),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat.yMd().add_jm().format(
                              tx.createdAt.toDate(),
                            ),
                            style: textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${isDeposit ? '+' : '-'}\$${tx.amount.toStringAsFixed(2)}',
                      style: textTheme.titleMedium?.copyWith(color: color),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
