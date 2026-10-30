import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/product.dart';
import '../state/shop_state.dart';
import 'theme.dart';

void go(BuildContext context, String route, {Object? arguments}) =>
    Navigator.of(context).pushNamed(route, arguments: arguments);
void closePage(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.pop(context);
  } else {
    Navigator.pushReplacementNamed(context, '/home');
  }
}

void notice(BuildContext context, String message) =>
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));

class PageShell extends StatelessWidget {
  const PageShell({
    super.key,
    required this.child,
    this.title = '',
    this.menu = false,
    this.actions = const [],
    this.bottom,
    this.dark = false,
    this.header = true,
  });
  final Widget child;
  final String title;
  final bool menu, dark, header;
  final List<Widget> actions;
  final Widget? bottom;
  @override
  Widget build(BuildContext context) {
    final content = Scaffold(
      backgroundColor: dark ? MarnieColors.ink : null,
      body: SafeArea(
        minimum: const EdgeInsets.only(top: 44, bottom: 20),
        child: Column(
          children: [
            if (header)
              Container(
                height: 68,
                color: dark
                    ? MarnieColors.ink
                    : Theme.of(context).brightness == Brightness.dark
                    ? MarnieColors.ink
                    : const Color(0xfffafafa),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(title.toUpperCase(), style: label(18)),
                    Row(
                      children: [
                        IconButton(
                          tooltip: menu ? 'Menu' : 'Close',
                          onPressed: () =>
                              menu ? go(context, '/menu') : closePage(context),
                          icon: Icon(menu ? Icons.menu : Icons.close),
                        ),
                        const Spacer(),
                        ...actions,
                      ],
                    ),
                  ],
                ),
              ),
            Expanded(child: child),
            ?bottom,
          ],
        ),
      ),
    );
    final effectiveDark =
        dark || Theme.of(context).brightness == Brightness.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: effectiveDark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: dark ? Theme(data: marnieTheme(true), child: content) : content,
    );
  }
}

class ShopActions extends StatelessWidget {
  const ShopActions({super.key});
  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: 'Shopping bag',
          onPressed: () => go(context, '/bag'),
          icon: Badge(
            isLabelVisible: shop.itemCount > 0,
            backgroundColor: MarnieColors.ink,
            label: Text('${shop.itemCount}'),
            child: const Icon(Icons.shopping_bag_outlined),
          ),
        ),
        IconButton(
          tooltip: 'Search',
          onPressed: () => go(context, '/search'),
          icon: const Icon(Icons.search),
        ),
      ],
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
    this.text, {
    super.key,
    required this.onPressed,
    this.light = false,
    this.color,
    this.leading,
  });
  final String text;
  final VoidCallback? onPressed;
  final bool light;
  final Color? color;
  final Widget? leading;
  @override
  Widget build(BuildContext context) => Container(
    height: 54,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: color != null
            ? [color!, color!.withValues(alpha: .9)]
            : light
            ? [const Color(0xffd6d6d6), const Color(0xffeeeeee)]
            : [const Color(0xff444444), const Color(0xff222222)],
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: .25),
          blurRadius: 27,
          offset: const Offset(0, 19),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leading != null) ...[leading!, const SizedBox(width: 16)],
              Text(
                text.toUpperCase(),
                style: label(
                  16,
                  light ? MarnieColors.ink : const Color(0xffeeeeee),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class CircleAction extends StatelessWidget {
  const CircleAction({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 42,
    this.tooltip = '',
  });
  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final String tooltip;
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: const Color(0xfffafafa),
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: .2),
          blurRadius: 22,
          offset: const Offset(0, 15),
        ),
      ],
    ),
    child: IconButton(
      tooltip: tooltip,
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      icon: Icon(icon, size: 21, color: MarnieColors.ink),
    ),
  );
}

class UnderlineTitle extends StatelessWidget {
  const UnderlineTitle(this.text, {super.key, this.size = 30, this.color});
  final String text;
  final double size;
  final Color? color;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(text, style: display(size, color: color)),
      const SizedBox(height: 14),
      Container(
        width: 46,
        height: 4,
        color: color ?? Theme.of(context).colorScheme.onSurface,
      ),
    ],
  );
}

class ProductCard extends StatelessWidget {
  const ProductCard(
    this.product, {
    super.key,
    this.favorite = false,
    this.compact = false,
  });
  final Product product;
  final bool favorite, compact;
  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    return GestureDetector(
      onTap: () => go(context, '/product', arguments: product),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                const Positioned.fill(
                  child: ColoredBox(color: MarnieColors.image),
                ),
                if (favorite)
                  Positioned(
                    right: 13,
                    bottom: 20,
                    child: CircleAction(
                      tooltip: shop.saved.contains(product.id)
                          ? 'Remove ${product.name} from saved'
                          : 'Save ${product.name}',
                      icon: shop.saved.contains(product.id)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      onPressed: () => shop.toggleSaved(product.id),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Text(
            product.name,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: display(compact ? 18 : 20),
          ),
          Text(product.priceLabel, style: label(14, MarnieColors.muted)),
        ],
      ),
    );
  }
}

class BottomTabs extends StatelessWidget {
  const BottomTabs(this.selected, {super.key});
  final int selected;
  @override
  Widget build(BuildContext context) => Container(
    height: 76,
    decoration: BoxDecoration(
      color: Theme.of(context).scaffoldBackgroundColor,
      border: const Border(top: BorderSide(color: Color(0xffe2e2e2))),
    ),
    child: Row(
      children: [
        for (final (i, (icon, title, route)) in [
          (Icons.shopping_bag_outlined, 'Home', '/home'),
          (Icons.qr_code_scanner, 'Scan', '/scan'),
          (Icons.playlist_add_check, 'Saved', '/saved'),
          (Icons.account_circle_outlined, 'Account', '/account'),
        ].indexed)
          Expanded(
            child: InkWell(
              onTap: () => go(context, route),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 29,
                    color: selected == i ? null : MarnieColors.muted,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    title.toUpperCase(),
                    style: label(13, selected == i ? null : MarnieColors.muted),
                  ),
                ],
              ),
            ),
          ),
      ],
    ),
  );
}

Future<void> showInfo(BuildContext context, String title, String message) =>
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: display(25)),
        content: Text(message, style: caption(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('CLOSE', style: label()),
          ),
        ],
      ),
    );
