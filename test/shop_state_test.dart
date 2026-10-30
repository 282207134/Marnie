import 'support/fixtures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:marnie/models/product.dart';
import 'package:marnie/state/shop_state.dart';

void main() {
  late ShopState shop;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    shop = ShopState(await SharedPreferences.getInstance());
  });
  test('bag merges matching variants and separates different sizes', () {
    shop.addToBag(products[0], 'M', 'Denim', 2);
    shop.addToBag(products[0], 'M', 'Denim', 1);
    shop.addToBag(products[0], 'L', 'Denim', 1);
    expect(shop.bag.length, 2);
    expect(shop.bag.first.quantity, 3);
    expect(shop.itemCount, 4);
    shop.changeQuantity(shop.bag.first, 0);
    expect(shop.bag.length, 1);
    expect(shop.itemCount, 1);
  });
  test('totals include quantity, round tax, and reconcile', () {
    seedPreviewBag(shop);
    expect(shop.subtotal, closeTo(739.97, .001));
    expect(shop.taxes, 111.00);
    expect(shop.total, closeTo(850.97, .001));
  });
  test(
    'collection, color and price filters intersect and copies are isolated',
    () {
      final f = CatalogFilter(
        collections: {'Tops'},
        colors: {'White'},
        price: const RangeValues(50, 100),
      );
      expect(products.where(f.matches).map((p) => p.id), ['sweater']);
      final draft = f.copy();
      draft.collections.add('Shoes');
      expect(f.collections, {'Tops'});
    },
  );
  test('bag, favorites and preferences restore after a new session', () async {
    shop.addToBag(products[0], 'M', 'Denim', 2);
    shop.toggleSaved('denim');
    shop.update(() {
      shop.country = 'Singapore';
      shop.darkMode = true;
      shop.username = 'Marnie Tester';
    });
    await Future<void>.delayed(Duration.zero);
    final restored = ShopState(shop.preferences);
    expect(restored.bag.single.quantity, 2);
    expect(restored.saved, contains('denim'));
    expect(restored.country, 'Singapore');
    expect(restored.darkMode, true);
    expect(restored.username, 'Marnie Tester');
  });
  test('demo checkout records order before clearing bag', () async {
    shop.addToBag(products[2], 'M', 'White', 1);
    shop.placeDemoOrder();
    expect(shop.bag, isEmpty);
    expect(shop.orders.single['total'], closeTo(160.99, .001));
    await Future<void>.delayed(Duration.zero);
    expect(ShopState(shop.preferences).orders, hasLength(1));
  });
  test('corrupt persisted bag does not prevent startup', () async {
    SharedPreferences.setMockInitialValues({'bag': 'not valid JSON'});
    final restored = ShopState(await SharedPreferences.getInstance());
    expect(restored.bag, isEmpty);
  });
}
