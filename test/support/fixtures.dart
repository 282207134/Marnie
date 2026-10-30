import 'package:marnie/models/product.dart';
import 'package:marnie/state/shop_state.dart';

void seedPreviewBag(ShopState shop) => shop.update(() {
  shop.bag
    ..clear()
    ..addAll([
      BagItem(product: products[0], size: 'S', color: 'Denim', quantity: 2),
      BagItem(product: products[2], size: 'M', color: 'White'),
    ]);
});
