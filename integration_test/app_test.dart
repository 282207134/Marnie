import '../test/support/fixtures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:marnie/app.dart';
import 'package:marnie/state/shop_state.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('all reference screens and complete shopping flow', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final shop = ShopState(await SharedPreferences.getInstance());
    final app = MarnieApp(state: shop);
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();

    Future<void> open(String route) async {
      app.navigatorKey.currentState!.pushNamedAndRemoveUntil(
        route,
        (_) => false,
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: route);
    }

    Future<void> capture(String name) async {
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: name);
      await binding.takeScreenshot(name);
    }

    for (final (name, route) in [
      ('01_splash', '/'),
      ('02_login', '/login'),
      ('03_sign_up', '/signup'),
      ('04_country', '/country'),
      ('05_rate_us', '/rate'),
      ('06_home', '/home'),
      ('07_menu', '/menu'),
      ('08_category', '/category'),
      ('09_filters', '/filters'),
      ('10_product', '/product'),
      ('11_reviews', '/reviews'),
      ('12_bag_empty', '/bag-empty'),
      ('13_bag', '/bag'),
      ('14_search', '/search'),
      ('15_saved', '/saved'),
      ('16_account', '/account'),
      ('17_map', '/map'),
      ('18_settings', '/settings'),
    ]) {
      if (route == '/bag') seedPreviewBag(shop);
      await open(route);
      await capture(name);
      if (route == '/home') {
        await tester.drag(find.byType(ListView).first, const Offset(0, -740));
        await capture('06b_home_collections');
        await tester.drag(find.byType(ListView).first, const Offset(0, -1500));
        await capture('06c_home_newsletter');
      }
      if (route == '/filters') {
        await tester.drag(find.byType(ListView).first, const Offset(0, -900));
        await capture('09b_filters_sizes_price');
      }
      if (route == '/product') {
        await tester.drag(find.byType(ListView).first, const Offset(0, -700));
        await capture('10b_product_options');
      }
      if (route == '/bag') {
        await tester.drag(find.byType(ListView).first, const Offset(0, -600));
        await capture('13b_bag_checkout');
      }
    }
    await tester.tap(find.text('PROFILE'));
    await tester.pumpAndSettle();
    await capture('19_settings_profile');
    await tester.tap(find.text('GENERAL'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(shop.darkMode, true);
    await capture('20_settings_dark');
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    await open('/scan');
    await capture('21_scan');

    // Validate login and country selection through the real controls.
    await open('/login');
    await tester.enterText(find.byType(TextFormField).at(0), 'Brandi Willz');
    await tester.enterText(find.byType(TextFormField).at(1), 'marnie123');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(shop.signedIn, true);
    expect(find.text('Winter Vibes'), findsOneWidget);
    await open('/country');
    await tester.tap(find.text('SINGAPORE'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('CONTINUE'));
    await tester.pumpAndSettle();
    expect(shop.country, 'Singapore');

    // Search returns matching products and opens the selected result.
    await open('/search');
    await tester.enterText(find.byType(TextField), 'Black Denim');
    await tester.pumpAndSettle();
    expect(find.text('BLACK DENIM JACKET'), findsOneWidget);
    await tester.tap(find.text('BLACK DENIM JACKET'));
    await tester.pumpAndSettle();
    expect(find.text('Black Denim Jacket'), findsOneWidget);

    // Favorites update immediately in the saved view.
    await open('/product');
    final wasSaved = shop.saved.contains('denim');
    await tester.tap(
      find.byTooltip(wasSaved ? 'Unsave product' : 'Save product'),
    );
    await tester.pumpAndSettle();
    expect(shop.saved.contains('denim'), !wasSaved);
    await open('/saved');
    expect(shop.saved.contains('denim'), true);

    // Filters affect catalog results, and reset restores the full catalog.
    await open('/category');
    await tester.tap(find.text('FILTERS'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('TOPS'));
    await tester.drag(find.byType(ListView).first, const Offset(0, -1200));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('SAVE FILTERS'));
    await tester.tap(find.text('SAVE FILTERS'));
    await tester.pumpAndSettle();
    expect(shop.filter.collections, {'Tops'});
    expect(find.text('Greyish Purple Blouse'), findsOneWidget);
    expect(find.text('Printed Dress'), findsNothing);
    shop.update(() => shop.filter = CatalogFilter());

    // Add a product, edit quantity, and submit a local demo order.
    shop.update(() => shop.bag.clear());
    await open('/product');
    await tester.drag(find.byType(ListView).first, const Offset(0, -900));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('ADD TO BAG'));
    await tester.tap(find.text('ADD TO BAG'));
    await tester.pumpAndSettle();
    expect(shop.itemCount, 1);
    await open('/bag');
    await tester.tap(find.byTooltip('Edit shopping bag'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Increase Denim Jacket'));
    await tester.pumpAndSettle();
    expect(shop.itemCount, 2);
    expect(shop.subtotal, closeTo(599.98, .001));
    await tester.drag(find.byType(ListView).first, const Offset(0, -700));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('CHECKOUT'));
    await tester.tap(find.text('CHECKOUT'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('PLACE DEMO ORDER'));
    await tester.pumpAndSettle();
    expect(shop.orders, hasLength(1));
    expect(shop.bag, isEmpty);
    expect(find.text('It’s lonely here'), findsOneWidget);

    // Persisted state round-trip (same storage adapter used by the app).
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final restored = ShopState(shop.preferences);
    expect(restored.country, 'Singapore');
    expect(restored.orders, hasLength(1));
    expect(restored.saved.contains('denim'), true);
    await open('/home');
    expect(tester.takeException(), isNull);
  });
}
