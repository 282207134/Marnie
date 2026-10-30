import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import '../models/product.dart';
import '../state/shop_state.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, required this.product});
  final Product product;
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String size = 'M';
  String? color;
  int quantity = 1, photo = 1;
  Widget selector<T>(
    String title,
    T value,
    List<T> values,
    ValueChanged<T?> onChanged,
  ) => Expanded(
    child: Column(
      children: [
        Text(title, style: caption(9, Theme.of(context).colorScheme.onSurface)),
        const SizedBox(height: 14),
        DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            value: value,
            style: display(31, color: Theme.of(context).colorScheme.onSurface),
            icon: const Icon(Icons.keyboard_arrow_down, size: 21),
            items: values
                .map((v) => DropdownMenuItem(value: v, child: Text('$v')))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    ),
  );
  @override
  Widget build(BuildContext context) {
    final p = widget.product, shop = ShopScope.of(context);
    final currentColor = color ?? p.color;
    return PageShell(
      header: false,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 457,
            child: Stack(
              children: [
                PageView.builder(
                  controller: null,
                  itemCount: 4,
                  onPageChanged: (i) => setState(() => photo = i),
                  itemBuilder: (_, _) =>
                      const ColoredBox(color: MarnieColors.image),
                ),
                SizedBox(
                  height: 68,
                  child: Row(
                    children: [
                      IconButton(
                        tooltip: 'Menu',
                        onPressed: () => go(context, '/menu'),
                        icon: const Icon(Icons.menu),
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: 'Share product',
                        icon: const Icon(Icons.share_outlined),
                        onPressed: () async {
                          await Clipboard.setData(
                            ClipboardData(
                              text: '${p.name} · ${p.priceLabel} · Marnie',
                            ),
                          );
                          if (context.mounted) {
                            notice(context, 'Product details copied.');
                          }
                        },
                      ),
                      PopupMenuButton<String>(
                        tooltip: 'Product options',
                        onSelected: (value) {
                          if (value == 'saved') {
                            shop.toggleSaved(p.id);
                          } else {
                            go(context, '/category');
                          }
                        },
                        itemBuilder: (_) => [
                          PopupMenuItem(
                            value: 'saved',
                            child: Text(
                              shop.saved.contains(p.id)
                                  ? 'Remove from saved'
                                  : 'Save product',
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'shop',
                            child: Text('Shop collection'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 36,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < 4; i++)
                        Container(
                          width: 7,
                          height: 7,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i == photo
                                ? const Color(0xff888888)
                                : const Color(0xffbbbbbb),
                          ),
                        ),
                    ],
                  ),
                ),
                Positioned(
                  right: 21,
                  bottom: 34,
                  child: CircleAction(
                    size: 54,
                    tooltip: shop.saved.contains(p.id)
                        ? 'Unsave product'
                        : 'Save product',
                    icon: shop.saved.contains(p.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    onPressed: () => shop.toggleSaved(p.id),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(21, 50, 21, 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.name, style: display(33)),
                Row(
                  children: [
                    Text(p.priceLabel, style: label(18, MarnieColors.muted)),
                    if (p.discount)
                      Container(
                        margin: const EdgeInsets.only(left: 18),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        color: const Color(0xff68b74d),
                        child: Text('-25%', style: caption(9, Colors.white)),
                      ),
                  ],
                ),
                const SizedBox(height: 7),
                Text(
                  'Orci varius natoque penatibus et magnis dis parturient montes, '
                  'nascetur ridiculus mus. Suspendisse potenti.',
                  style: caption(12, Theme.of(context).colorScheme.onSurface),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => go(context, '/reviews'),
                  child: Row(
                    children: [
                      const Icon(Icons.star_half, size: 23),
                      const SizedBox(width: 13),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: label(
                                24,
                                Theme.of(context).colorScheme.onSurface,
                              ),
                              children: [
                                const TextSpan(text: '4.2'),
                                TextSpan(text: ' /5', style: caption(10)),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Text('★ ★ ★ ★ ', style: label(16)),
                              const Text(
                                '★',
                                style: TextStyle(color: MarnieColors.muted),
                              ),
                              Text('  129 RATINGS', style: caption(9)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    selector('SIZE', size, [
                      'S',
                      'M',
                      'L',
                      'XL',
                      'XXL',
                    ], (v) => setState(() => size = v!)),
                    Container(
                      width: 1,
                      height: 53,
                      margin: const EdgeInsets.only(top: 24),
                      color: MarnieColors.line,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'COLOR',
                            style: caption(
                              9,
                              Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 18),
                          PopupMenuButton<String>(
                            tooltip: 'Choose color',
                            initialValue: currentColor,
                            onSelected: (v) => setState(() => color = v),
                            itemBuilder: (_) => {p.color, 'Black', 'White'}
                                .map(
                                  (c) =>
                                      PopupMenuItem(value: c, child: Text(c)),
                                )
                                .toList(),
                            child: Semantics(
                              label: currentColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 37,
                                    height: 37,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: currentColor == 'Black'
                                            ? [
                                                Colors.grey.shade700,
                                                Colors.black,
                                              ]
                                            : [
                                                const Color(0xffdddddd),
                                                const Color(0xffaaaaaa),
                                              ],
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 21,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 53,
                      margin: const EdgeInsets.only(top: 24),
                      color: MarnieColors.line,
                    ),
                    selector('QUANT', quantity, [
                      1,
                      2,
                      3,
                      4,
                      5,
                    ], (v) => setState(() => quantity = v!)),
                  ],
                ),
                const SizedBox(height: 30),
                for (final (title, detail) in [
                  (
                    'Materials',
                    '100% cotton denim. Machine wash cold with similar colors. Do not bleach. Air dry.',
                  ),
                  (
                    'Find my size',
                    'S: 86–91 cm · M: 92–97 cm · L: 98–103 cm · XL: 104–109 cm · XXL: 110–115 cm. Chest measurements.',
                  ),
                  (
                    'Shipping info',
                    'Free standard shipping on orders over \$250. Estimated delivery: 3–5 business days. Returns within 30 days.',
                  ),
                ])
                  ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 14),
                    childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 18),
                    collapsedShape: const Border(
                      top: BorderSide(color: MarnieColors.line),
                    ),
                    shape: const Border(
                      top: BorderSide(color: MarnieColors.line),
                    ),
                    trailing: const Icon(Icons.add, size: 20),
                    title: Text(title.toUpperCase(), style: label(16)),
                    children: [Text(detail, style: caption(11))],
                  ),
                const SizedBox(height: 14),
                PrimaryButton(
                  'Add to bag',
                  onPressed: () {
                    shop.addToBag(p, size, currentColor, quantity);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Added to your bag'),
                        action: SnackBarAction(
                          label: 'VIEW BAG',
                          onPressed: () => go(context, '/bag'),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 17),
                Center(
                  child: Text(
                    'FREE SHIPPING STARTING \$250',
                    style: caption(9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});
  @override
  Widget build(BuildContext context) => PageShell(
    title: 'Reviews',
    dark: true,
    child: ListView(
      children: [
        for (final (i, (name, title, stars)) in [
          ('Sarah Montegre', 'Simply amazing!', 5),
          ('Bradley James Jr', 'A bit mediocre...', 3),
          ('Vanessa Muller', 'It’s really cool', 4),
        ].indexed)
          Container(
            padding: const EdgeInsets.fromLTRB(21, 20, 21, 35),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xff333333), width: 2),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 51,
                  height: 51,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffaaaaaa),
                  ),
                ),
                const SizedBox(width: 22),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              name.toUpperCase(),
                              style: label(18, MarnieColors.paper),
                            ),
                          ),
                          Text('11 OCT', style: caption(9)),
                        ],
                      ),
                      Row(
                        children: [
                          for (int j = 0; j < 5; j++)
                            Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Icon(
                                Icons.star,
                                size: 15,
                                color: j < stars
                                    ? MarnieColors.paper
                                    : const Color(0xff777777),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      if (i == 1)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: Row(
                            children: [
                              for (int j = 0; j < 3; j++)
                                Container(
                                  width: 40,
                                  height: 40,
                                  margin: const EdgeInsets.only(right: 13),
                                  color: const Color(0xffaaaaaa),
                                ),
                            ],
                          ),
                        )
                      else
                        const Divider(color: Color(0xff444444)),
                      const SizedBox(height: 15),
                      Text(
                        title.toUpperCase(),
                        style: label(18, MarnieColors.paper),
                      ),
                      Text(
                        'Morbi ultricies odio in purus feugiat efficitur. Quisque sit amet nisl eget augue...',
                        style: caption(12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    ),
  );
}
