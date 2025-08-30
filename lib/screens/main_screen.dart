import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '/models/user_model.dart';
import '/screens/deposit_page.dart';
import '/screens/home_page.dart';
import '/screens/orders_page.dart';
import '/screens/profile_page.dart';
import '/screens/services_page.dart';
import '/services/firestore_service.dart';
import '../theme/AppTheme.dart'; // Import the new theme

class MainScreen extends ConsumerStatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0;

  final List<String> _pageTitles = [
    'Dashboard',
    'New Order',
    'Order History',
    'Add Funds',
    'Account',
  ];

  final List<IconData> _pageIcons = [
    Icons.dashboard_rounded,
    Icons.add_circle_outline_rounded,
    Icons.history_rounded,
    Icons.account_balance_wallet_rounded,
    Icons.person_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final userStream = ref.watch(userProvider);

    return MaterialApp(
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: userStream.when(
        data: (userModel) {
          final pages = [
            HomePage(user: userModel),
            // const ServicesPage(),
            Container(),
            const OrdersPage(),
            const DepositPage(), // Assuming you will create this page
            ProfilePage(user: userModel),
          ];

          final appBar = AppBar(
            title: Text(
              _pageTitles[_selectedIndex],
              style: AppTheme.textTheme.headlineSmall,
            ),
            actions: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Text(
                    'Balance: \$${userModel.balance.toStringAsFixed(2)}',
                    style: AppTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.successColor,
                    ),
                  ),
                ),
              ),
            ],
          );

          if (kIsWeb) {
            // WEB LAYOUT
            return Scaffold(
              appBar: appBar,
              body: Row(
                children: [
                  NavigationRail(
                    selectedIndex: _selectedIndex,
                    onDestinationSelected: (index) =>
                        setState(() => _selectedIndex = index),
                    labelType: NavigationRailLabelType.all,
                    destinations: List.generate(_pageTitles.length, (index) {
                      return NavigationRailDestination(
                        icon: Icon(_pageIcons[index]),
                        label: Text(_pageTitles[index]),
                      );
                    }),
                  ),
                  const VerticalDivider(thickness: 1, width: 1),
                  Expanded(
                    child: IndexedStack(index: _selectedIndex, children: pages),
                  ),
                ],
              ),
            );
          } else {
            // MOBILE LAYOUT
            return Scaffold(
              appBar: appBar,
              body: IndexedStack(index: _selectedIndex, children: pages),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: (index) => setState(() => _selectedIndex = index),
                items: List.generate(_pageTitles.length, (index) {
                  return BottomNavigationBarItem(
                    icon: Icon(_pageIcons[index]),
                    label: _pageTitles[index],
                  );
                }),
              ),
            );
          }
        },
        loading: () =>
            Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (err, stack) =>
            Scaffold(body: Center(child: Text('Error: $err'))),
      ),
    );
  }
}
