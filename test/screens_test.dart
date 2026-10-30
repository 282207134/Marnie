import 'support/fixtures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:marnie/app.dart';
import 'package:marnie/core/widgets.dart';
import 'package:marnie/state/shop_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    for (final (family, file) in [
      ('Playfair Display', 'PlayfairDisplay.ttf'),
      ('Bebas Neue', 'BebasNeue-Regular.ttf'),
      ('Montserrat', 'Montserrat.ttf'),
    ]) {
      final loader = FontLoader(family)
        ..addFont(rootBundle.load('assets/fonts/$file'));
      await loader.load();
    }
  });
  for (final width in [375.0, 320.0]) {
    testWidgets('all screens render at width $width without layout errors', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width * 3, 812 * 3);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      SharedPreferences.setMockInitialValues({});
      final shop = ShopState(await SharedPreferences.getInstance());
      final app = MarnieApp(state: shop);
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'Splash at $width');
      for (final route in [
        '/login',
        '/signup',
        '/country',
        '/rate',
        '/home',
        '/menu',
        '/category',
        '/filters',
        '/product',
        '/reviews',
        '/bag-empty',
        '/bag',
        '/search',
        '/saved',
        '/account',
        '/map',
        '/settings',
        '/scan',
      ]) {
        if (route == '/bag') seedPreviewBag(shop);
        app.navigatorKey.currentState!.pushNamedAndRemoveUntil(
          route,
          (_) => false,
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: '$route at $width');
        final scrolls = find.byType(Scrollable);
        if (scrolls.evaluate().isNotEmpty) {
          await tester.drag(scrolls.first, const Offset(0, -1100));
          await tester.pumpAndSettle();
          expect(
            tester.takeException(),
            isNull,
            reason: 'scrolled $route at $width',
          );
        }
      }
    });
  }
  testWidgets('login validates password and preserves saved profile email', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'email': 'brandi@example.com'});
    final shop = ShopState(await SharedPreferences.getInstance());
    await tester.pumpWidget(MarnieApp(state: shop, initialRoute: '/login'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'Brandi Willz');
    await tester.enterText(find.byType(TextFormField).at(1), '123');
    await tester.tap(find.byType(PrimaryButton));
    await tester.pumpAndSettle();
    expect(shop.signedIn, false);
    expect(find.text('Use at least 6 characters'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(1), 'marnie123');
    await tester.tap(find.byType(PrimaryButton));
    await tester.pumpAndSettle();
    expect(shop.signedIn, true);
    expect(shop.email, 'brandi@example.com');
    expect(find.text('Winter Vibes'), findsOneWidget);
  });
}
