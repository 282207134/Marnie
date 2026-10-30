import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class CatalogFilter {
  CatalogFilter({
    Set<String>? collections,
    Set<String>? colors,
    this.size = 'M',
    this.price = const RangeValues(0, 350),
  }) : collections = collections ?? {},
       colors = colors ?? {};
  final Set<String> collections, colors;
  String size;
  RangeValues price;
  CatalogFilter copy() => CatalogFilter(
    collections: {...collections},
    colors: {...colors},
    size: size,
    price: price,
  );
  bool matches(Product p) =>
      (collections.isEmpty || collections.contains(p.collection)) &&
      (colors.isEmpty || colors.contains(p.color)) &&
      p.price >= price.start &&
      p.price <= price.end;
}

class ShopState extends ChangeNotifier {
  ShopState(this.preferences) {
    _restore();
  }
  final SharedPreferences preferences;
  final Set<String> saved = {'bag', 'sweater', 'skirt', 'knit'};
  final List<BagItem> bag = [];
  final List<Map<String, dynamic>> orders = [];
  CatalogFilter filter = CatalogFilter();
  String country = 'Slovenia', username = 'Brandi Willz', email = '';
  bool darkMode = false, signedIn = false, subscribed = false;
  int rating = 1;

  void _restore() {
    country = preferences.getString('country') ?? country;
    username = preferences.getString('username') ?? username;
    email = preferences.getString('email') ?? '';
    darkMode = preferences.getBool('darkMode') ?? false;
    signedIn = preferences.getBool('signedIn') ?? false;
    subscribed = preferences.getBool('subscribed') ?? false;
    rating = preferences.getInt('rating') ?? 1;
    try {
      final raw = preferences.getString('orders');
      if (raw != null) {
        orders.addAll((jsonDecode(raw) as List).cast<Map<String, dynamic>>());
      }
    } on Object {
      orders.clear();
    }
    final ids = preferences.getStringList('saved');
    if (ids != null) {
      saved
        ..clear()
        ..addAll(ids.where((id) => products.any((p) => p.id == id)));
    }
    try {
      final raw = preferences.getString('bag');
      if (raw != null) {
        bag.addAll((jsonDecode(raw) as List).map((e) => BagItem.fromJson(e)));
      }
    } on Object {
      bag.clear();
    }
  }

  Future<void> _persist() async {
    await Future.wait([
      preferences.setString('country', country),
      preferences.setString('username', username),
      preferences.setString('email', email),
      preferences.setBool('darkMode', darkMode),
      preferences.setBool('signedIn', signedIn),
      preferences.setBool('subscribed', subscribed),
      preferences.setInt('rating', rating),
      preferences.setStringList('saved', saved.toList()),
      preferences.setString(
        'bag',
        jsonEncode(bag.map((e) => e.toJson()).toList()),
      ),
      preferences.setString('orders', jsonEncode(orders)),
    ]);
  }

  void update(VoidCallback change) {
    change();
    notifyListeners();
    _persist();
  }

  void toggleSaved(String id) => update(() {
    if (!saved.remove(id)) saved.add(id);
  });
  void addToBag(Product product, String size, String color, int quantity) =>
      update(() {
        final item = BagItem(
          product: product,
          size: size,
          color: color,
          quantity: quantity,
        );
        final index = bag.indexWhere((e) => e.key == item.key);
        if (index < 0) {
          bag.add(item);
        } else {
          bag[index].quantity += quantity;
        }
      });
  void changeQuantity(BagItem item, int quantity) => update(() {
    if (quantity < 1) {
      bag.remove(item);
    } else {
      item.quantity = quantity;
    }
  });
  int get itemCount => bag.fold(0, (n, e) => n + e.quantity);
  double get subtotal =>
      bag.fold(0, (n, e) => n + e.product.price * e.quantity);
  double get taxes => (subtotal * .15 * 100).round() / 100;
  double get total => subtotal + taxes;
  void signOut() => update(() {
    signedIn = false;
  });
  void placeDemoOrder() => update(() {
    orders.insert(0, {
      'date': DateTime.now().toIso8601String(),
      'total': total,
      'items': bag.map((e) => e.toJson()).toList(),
    });
    bag.clear();
  });
}

class ShopScope extends InheritedNotifier<ShopState> {
  const ShopScope({super.key, required ShopState state, required super.child})
    : super(notifier: state);
  static ShopState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ShopScope>()!.notifier!;
}
