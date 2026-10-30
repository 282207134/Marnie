import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import '../state/shop_state.dart';

class BagPage extends StatefulWidget {
  const BagPage({super.key, this.forceEmpty = false});
  final bool forceEmpty;
  @override
  State<BagPage> createState() => _BagPageState();
}

class _BagPageState extends State<BagPage> {
  bool editing = false;
  Future<void> checkout(ShopState shop) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order summary', style: display(27)),
        content: Text(
          '${shop.itemCount} items · \$${shop.total.toStringAsFixed(2)}\n\n'
          'This is a local demo order. No payment will be taken.',
          style: caption(12),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('CANCEL', style: label()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('PLACE DEMO ORDER', style: label()),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      shop.placeDemoOrder();
      notice(context, 'Demo order saved. Find it in Account → History.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context),
        empty = widget.forceEmpty || ShopScope.of(context).bag.isEmpty;
    return PageShell(
      title: empty ? 'Bag' : 'Bag (${shop.bag.length})',
      actions: empty
          ? []
          : [
              IconButton(
                tooltip: 'Edit shopping bag',
                onPressed: () => setState(() => editing = !editing),
                icon: Icon(editing ? Icons.check : Icons.playlist_add_check),
              ),
            ],
      child: empty
          ? LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(21, 0, 21, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: constraints.maxHeight * .3),
                    const Icon(
                      Icons.checkroom,
                      size: 43,
                      color: Color(0xffaaaaaa),
                    ),
                    const SizedBox(height: 24),
                    Text('It’s lonely here', style: display(33)),
                    const SizedBox(height: 9),
                    Text(
                      'Start shopping and add more items to the bag, and then there will be joy here...',
                      style: caption(12),
                    ),
                    const SizedBox(height: 22),
                    TextButton(
                      onPressed: () => go(context, '/category'),
                      child: Text(
                        'START SHOPPING  →',
                        style: label(15, MarnieColors.muted),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(21, 25, 21, 35),
              children: [
                for (final item in shop.bag)
                  Container(
                    padding: const EdgeInsets.only(bottom: 26),
                    margin: const EdgeInsets.only(bottom: 26),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xffdddddd)),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () =>
                              go(context, '/product', arguments: item.product),
                          child: Container(
                            width: MediaQuery.sizeOf(context).width * .354,
                            height: 194,
                            color: MarnieColors.image,
                          ),
                        ),
                        const SizedBox(width: 25),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 26),
                              Text(item.product.name, style: display(23)),
                              const SizedBox(height: 4),
                              Text(
                                item.product.priceLabel,
                                style: label(16, MarnieColors.muted),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'COLOR: ${item.color.toUpperCase()}, SIZE: ${item.size}',
                                style: caption(9),
                              ),
                              Text(
                                'QUANTITY: ${item.quantity}',
                                style: caption(9),
                              ),
                              if (editing)
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 4,
                                  children: [
                                    IconButton(
                                      tooltip: 'Decrease ${item.product.name}',
                                      visualDensity: VisualDensity.compact,
                                      onPressed: () => shop.changeQuantity(
                                        item,
                                        item.quantity - 1,
                                      ),
                                      icon: const Icon(Icons.remove, size: 18),
                                    ),
                                    Text('${item.quantity}', style: label()),
                                    IconButton(
                                      tooltip: 'Increase ${item.product.name}',
                                      visualDensity: VisualDensity.compact,
                                      onPressed: () => shop.changeQuantity(
                                        item,
                                        item.quantity + 1,
                                      ),
                                      icon: const Icon(Icons.add, size: 18),
                                    ),
                                    IconButton(
                                      tooltip: 'Remove ${item.product.name}',
                                      visualDensity: VisualDensity.compact,
                                      onPressed: () =>
                                          shop.changeQuantity(item, 0),
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        size: 18,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                Row(
                  children: [
                    Text(
                      'TAXES\nSUB-TOTAL',
                      style: label(16, MarnieColors.muted),
                    ),
                    const Spacer(),
                    Text(
                      '\$${shop.taxes.toStringAsFixed(2)}\n\$${shop.subtotal.toStringAsFixed(2)}',
                      textAlign: TextAlign.right,
                      style: label(16, MarnieColors.muted),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Text('Total', style: display(32)),
                    const Spacer(),
                    Text(
                      '\$${shop.total.toStringAsFixed(2)}',
                      style: display(30),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                PrimaryButton('Checkout', onPressed: () => checkout(shop)),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'LOCAL DEMO · NO PAYMENT REQUIRED',
                    style: caption(8),
                  ),
                ),
              ],
            ),
    );
  }
}
