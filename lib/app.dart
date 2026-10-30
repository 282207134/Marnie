import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'features/account.dart';
import 'features/bag.dart';
import 'features/catalog.dart';
import 'features/onboarding.dart';
import 'features/product.dart';
import 'models/product.dart';
import 'state/shop_state.dart';

class MarnieApp extends StatelessWidget {
  MarnieApp({super.key, required this.state, this.initialRoute});
  final ShopState state;
  final String? initialRoute;
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) => ShopScope(
    state: state,
    child: ListenableBuilder(
      listenable: state,
      builder: (context, _) => MaterialApp(
        title: 'Marnie',
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        theme: marnieTheme(false),
        darkTheme: marnieTheme(true),
        themeMode: state.darkMode ? ThemeMode.dark : ThemeMode.light,
        initialRoute: initialRoute ?? (state.signedIn ? '/home' : '/'),
        onGenerateRoute: (settings) {
          final page = switch (settings.name) {
            '/' => const SplashPage(),
            '/login' => const AuthPage(),
            '/signup' => const AuthPage(signUp: true),
            '/country' => const CountryPage(),
            '/rate' => const RatePage(),
            '/home' => const HomePage(),
            '/menu' => const MenuPage(),
            '/category' => CatalogPage(
              category: settings.arguments as String? ?? 'Women',
            ),
            '/filters' => const FiltersPage(),
            '/product' => ProductPage(
              product: settings.arguments as Product? ?? products[0],
            ),
            '/reviews' => const ReviewsPage(),
            '/bag' => const BagPage(),
            '/bag-empty' => const BagPage(forceEmpty: true),
            '/search' => const SearchPage(),
            '/saved' => const CatalogPage(saved: true),
            '/account' => const AccountPage(),
            '/map' => const StorePage(),
            '/settings' => const SettingsPage(),
            '/scan' => const ScanPage(),
            _ => const HomePage(),
          };
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => page,
          );
        },
      ),
    ),
  );
}
