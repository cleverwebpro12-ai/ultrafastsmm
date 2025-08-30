import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '/models/user_model.dart';
import '/screens/transaction_history_page.dart';
import '/services/auth_service.dart';
import '../theme/AppTheme.dart';

class ProfilePage extends ConsumerWidget {
  final UserModel user;
  const ProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildProfileInfoRow(context, 'Username', user.username),
                const Divider(height: 24),
                _buildProfileInfoRow(context, 'Email', user.email),
                const Divider(height: 24),
                _buildProfileInfoRow(
                  context,
                  'API Key',
                  user.apiKey,
                  isApiKey: true,
                  onCopy: () {
                    Clipboard.setData(ClipboardData(text: user.apiKey));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('API Key Copied!')),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Material(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TransactionHistoryPage(),
                ),
              ),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Transaction History', style: textTheme.titleMedium),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppTheme.subtextColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => ref.read(authServiceProvider).signOut(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfoRow(
    BuildContext context,
    String title,
    String value, {
    bool isApiKey = false,
    VoidCallback? onCopy,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: textTheme.bodyMedium),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
              if (isApiKey)
                IconButton(
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  onPressed: onCopy,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
