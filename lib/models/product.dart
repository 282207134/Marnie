class Product {
  const Product(
    this.id,
    this.name,
    this.price,
    this.collection,
    this.color, {
    this.discount = false,
  });

  final String id, name, collection, color;
  final double price;
  final bool discount;
  String get priceLabel => '${price.toStringAsFixed(2)} USD';
}

const products = [
  Product(
    'denim',
    'Denim Jacket',
    299.99,
    'Outerwear',
    'Denim',
    discount: true,
  ),
  Product('blouse', 'Greyish Purple Blouse', 89.99, 'Tops', 'Purple'),
  Product('dress', 'Printed Dress', 139.99, 'Dresses', 'White'),
  Product('boots', 'Brown Boots', 199.99, 'Shoes', 'Brown'),
  Product('knit', 'Colorful Knit Sweatshirt', 229.99, 'Sweatshirts', 'Blue'),
  Product('bag', 'Reversible Stubbed Bag', 49.99, 'Bags', 'Black'),
  Product('sweater', 'White Sweater', 89.99, 'Tops', 'White'),
  Product('skirt', 'Violet Skirt', 39.99, 'Dresses', 'Purple'),
  Product('crimson', 'Crimson Knit Sweatshirt', 229.99, 'Sweatshirts', 'Pink'),
  Product('skull', 'Skull’s Sweater', 199.99, 'Tops', 'Black'),
  Product('chelsea', 'Black Chelsea Boots', 129.99, 'Shoes', 'Black'),
  Product('blackdenim', 'Black Denim Jacket', 179.99, 'Outerwear', 'Black'),
  Product('scarf', 'Black Knit-Scarf', 39.99, 'Accessories', 'Black'),
];

Product productById(String id) => products.firstWhere((p) => p.id == id);

class BagItem {
  BagItem({
    required this.product,
    required this.size,
    required this.color,
    this.quantity = 1,
  });
  final Product product;
  final String size, color;
  int quantity;
  String get key => '${product.id}/$size/$color';
  Map<String, Object> toJson() => {
    'id': product.id,
    'size': size,
    'color': color,
    'quantity': quantity,
  };
  factory BagItem.fromJson(Map<String, dynamic> json) => BagItem(
    product: productById(json['id'] as String),
    size: json['size'] as String,
    color: json['color'] as String,
    quantity: json['quantity'] as int,
  );
}
