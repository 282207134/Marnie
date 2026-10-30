import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import '../models/product.dart';
import '../state/shop_state.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});
  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    return PageShell(
      header: false,
      bottom: const BottomTabs(3),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 235,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xff888888),
                  Color(0xff777777),
                  Color(0xff555555),
                ],
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      tooltip: 'Menu',
                      onPressed: () => go(context, '/menu'),
                      icon: const Icon(Icons.menu, color: Colors.white),
                    ),
                    const Spacer(),
                    IconButton(
                      tooltip: 'Log out',
                      onPressed: () {
                        shop.signOut();
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/',
                          (_) => false,
                        );
                      },
                      icon: const Icon(
                        Icons.power_settings_new,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 56,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffaaaaaa),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              shop.username,
                              style: display(33, color: MarnieColors.paper),
                            ),
                            Text(
                              shop.username.replaceAll(' ', '').toUpperCase(),
                              style: label(16, MarnieColors.paper),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          for (final (icon, title) in [
            (Icons.schedule, 'Pending orders'),
            (Icons.sell_outlined, 'Promotions'),
            (Icons.credit_card, 'Cards'),
            (Icons.history, 'History'),
            (Icons.mail_outline, 'Subscription'),
            (Icons.settings_outlined, 'Settings'),
          ])
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 18),
              leading: Icon(icon, size: 23),
              title: Text(title.toUpperCase(), style: label(18)),
              onTap: () {
                switch (title) {
                  case 'Settings':
                    go(context, '/settings');
                  case 'Pending orders':
                    showInfo(
                      context,
                      'Pending orders',
                      shop.orders.isEmpty
                          ? 'You have no pending orders. Explore the latest collections and find something you love.'
                          : '${shop.orders.length} local demo order(s) saved. Demo orders are not shipped.',
                    );
                  case 'Promotions':
                    showInfo(
                      context,
                      'Winter Winks',
                      'Explore our winter edit. Free shipping starts at \$250.',
                    );
                  case 'Cards':
                    showInfo(
                      context,
                      'Your cards',
                      'No cards saved. This demo does not collect payment information.',
                    );
                  case 'History':
                    showInfo(
                      context,
                      'Order history',
                      shop.orders.isEmpty
                          ? 'Your order history is empty.'
                          : shop.orders
                                .map(
                                  (o) =>
                                      '${(o['date'] as String).substring(0, 10)} · \$${(o['total'] as num).toStringAsFixed(2)} · Demo order',
                                )
                                .join('\n\n'),
                    );
                  case 'Subscription':
                    shop.update(() => shop.subscribed = !shop.subscribed);
                    notice(
                      context,
                      shop.subscribed
                          ? 'Newsletter subscription enabled.'
                          : 'Newsletter subscription disabled.',
                    );
                }
              },
            ),
        ],
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool profile = false, cacheCleared = false, initialized = false;
  final username = TextEditingController(), email = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      final shop = ShopScope.of(context);
      username.text = shop.username;
      email.text = shop.email;
      initialized = true;
    }
  }

  @override
  void dispose() {
    username.dispose();
    email.dispose();
    super.dispose();
  }

  Widget row(
    String title,
    String subtitle, {
    Widget? trailing,
    VoidCallback? onTap,
  }) => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 21),
    title: Text(title.toUpperCase(), style: label(18)),
    subtitle: Text(subtitle.toUpperCase(), style: caption(9)),
    trailing: trailing,
    onTap: onTap,
  );
  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    return PageShell(
      title: 'Settings',
      child: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.surface,
            height: 66,
            child: Row(
              children: [
                for (final value in [false, true])
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => profile = value),
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 21),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 2,
                              color: profile == value
                                  ? Theme.of(context).colorScheme.onSurface
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                        child: Text(
                          value ? 'PROFILE' : 'GENERAL',
                          style: label(
                            16,
                            profile == value ? null : MarnieColors.muted,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: profile
                ? SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(21, 35, 21, 35),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Your profile', style: display(33)),
                          const SizedBox(height: 30),
                          TextFormField(
                            controller: username,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                            ),
                            validator: (s) => s == null || s.trim().isEmpty
                                ? 'Enter your name'
                                : null,
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: email,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                            ),
                            validator: (s) =>
                                s == null ||
                                    s.isEmpty ||
                                    RegExp(
                                      r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                                    ).hasMatch(s)
                                ? null
                                : 'Enter a valid email',
                          ),
                          const SizedBox(height: 20),
                          row(
                            'Country',
                            shop.country,
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => go(context, '/country'),
                          ),
                          const SizedBox(height: 35),
                          PrimaryButton(
                            'Save profile',
                            onPressed: () {
                              if (!formKey.currentState!.validate()) return;
                              shop.update(() {
                                shop.username = username.text.trim();
                                shop.email = email.text.trim();
                              });
                              FocusScope.of(context).unfocus();
                              notice(context, 'Profile saved.');
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.only(top: 30),
                          children: [
                            row(
                              'Clear cache',
                              cacheCleared ? '0 KB' : '837 KB',
                              onTap: () {
                                PaintingBinding.instance.imageCache.clear();
                                setState(() => cacheCleared = true);
                                notice(
                                  context,
                                  'Image cache cleared. Your bag and favorites are saved.',
                                );
                              },
                            ),
                            const SizedBox(height: 13),
                            row(
                              'Dark mode',
                              shop.darkMode ? 'Enabled' : 'Disabled',
                              trailing: Switch(
                                value: shop.darkMode,
                                activeThumbColor: MarnieColors.ink,
                                onChanged: (v) =>
                                    shop.update(() => shop.darkMode = v),
                              ),
                            ),
                            const SizedBox(height: 13),
                            row(
                              'Country',
                              shop.country,
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => go(context, '/country'),
                            ),
                            const SizedBox(height: 13),
                            row(
                              'Rate us',
                              'Share your experience',
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => go(context, '/rate'),
                            ),
                          ],
                        ),
                      ),
                      row('Version', '1.0.0'),
                      const SizedBox(height: 28),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class StorePage extends StatefulWidget {
  const StorePage({super.key});
  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  int selected = 0;
  bool directions = false;
  static const stores = [
    ('Marnie Bullyvard', '15121 NW 8th St, Hollywood, FL 33028', '1.2'),
    ('Marnie Downtown', 'Downtown collection studio', '2.4'),
    ('Marnie West', 'Westside collection studio', '3.1'),
    ('Marnie North', 'Northside collection studio', '4.2'),
    ('Marnie South', 'Southside collection studio', '5.0'),
  ];
  @override
  Widget build(BuildContext context) {
    final store = stores[selected];
    return PageShell(
      title: 'Find a store',
      dark: true,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(21, 0, 21, 20),
        children: [
          SizedBox(
            height: 245,
            child: Stack(
              children: [
                if (directions)
                  const Positioned.fill(
                    child: CustomPaint(painter: _RoutePainter()),
                  ),
                for (final (i, point) in [
                  const Offset(.3, .02),
                  const Offset(.88, .1),
                  const Offset(.08, .34),
                  const Offset(.77, .44),
                  const Offset(.21, .62),
                ].indexed)
                  Positioned(
                    left: point.dx * (MediaQuery.sizeOf(context).width - 84),
                    top: point.dy * 235,
                    child: GestureDetector(
                      onTap: () => setState(() {
                        selected = i;
                        directions = false;
                      }),
                      child: Semantics(
                        label: stores[i].$1,
                        button: true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (selected == i)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                color: MarnieColors.paper,
                                child: Text(
                                  '⌁  ${stores[i].$3} MI',
                                  style: label(14, MarnieColors.ink),
                                ),
                              ),
                            const Icon(
                              Icons.bookmark,
                              color: MarnieColors.paper,
                              size: 34,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  left: MediaQuery.sizeOf(context).width * .36,
                  bottom: 25,
                  child: Container(
                    width: 94,
                    height: 94,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xff292929),
                    ),
                    child: Container(
                      width: 47,
                      height: 47,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xff444444),
                      ),
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffcccccc),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Theme(
            data: marnieTheme(false),
            child: Container(
              color: MarnieColors.paper,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 134,
                    alignment: Alignment.bottomRight,
                    padding: const EdgeInsets.all(21),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xffaaaaaa), Color(0xff555555)],
                      ),
                    ),
                    child: CircleAction(
                      icon: Icons.phone,
                      size: 48,
                      tooltip: 'Contact store',
                      onPressed: () => showInfo(
                        context,
                        'Contact ${store.$1}',
                        'Contact details are unavailable in this demo. Visit us in store to explore the collection.',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(26, 35, 26, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          store.$1,
                          style: display(27, color: MarnieColors.ink),
                        ),
                        Text(
                          '${store.$3} MILES FROM YOU',
                          style: label(14, MarnieColors.muted),
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 16),
                        Text('ADDRESS', style: label(16, MarnieColors.ink)),
                        Text(store.$2, style: caption(12)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(13, 0, 13, 14),
                    child: PrimaryButton(
                      directions
                          ? 'Route preview · ${store.$3} miles'
                          : 'Get directions',
                      onPressed: () => setState(() => directions = !directions),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(child: Text('OFFLINE STORE PREVIEW', style: caption(8))),
        ],
      ),
    );
  }
}

class _RoutePainter extends CustomPainter {
  const _RoutePainter();
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * .5, size.height * .72)
      ..lineTo(size.width * .5, size.height * .4)
      ..lineTo(size.width * .34, size.height * .4)
      ..lineTo(size.width * .34, size.height * .14);
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xff777777)
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant _RoutePainter oldDelegate) => false;
}

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});
  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final code = TextEditingController();
  @override
  void dispose() {
    code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PageShell(
    title: 'Scan',
    bottom: const BottomTabs(1),
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          const SizedBox(height: 45),
          const Icon(
            Icons.qr_code_scanner,
            size: 110,
            color: MarnieColors.muted,
          ),
          const SizedBox(height: 40),
          Text(
            'Find your next favorite',
            style: display(28),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          Text(
            'Enter a product code to explore the collection.\nTry DENIM or SWEATER.',
            style: caption(12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          TextField(
            controller: code,
            decoration: const InputDecoration(hintText: 'Product code'),
          ),
          const SizedBox(height: 35),
          PrimaryButton(
            'Find product',
            onPressed: () {
              final matches = products
                  .where((p) => p.id == code.text.trim().toLowerCase())
                  .toList();
              if (matches.isEmpty) {
                notice(context, 'Product not found. Try DENIM or SWEATER.');
              } else {
                go(context, '/product', arguments: matches.first);
              }
            },
          ),
        ],
      ),
    ),
  );
}
