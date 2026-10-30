import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import '../models/product.dart';
import '../state/shop_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final email = TextEditingController();
  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  Widget section(String title, VoidCallback onTap) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Row(
      children: [
        Text(title, style: display(33)),
        const Spacer(),
        TextButton(
          onPressed: onTap,
          child: Text('SEE ALL  +', style: label()),
        ),
      ],
    ),
  );
  Widget collection(String title, String count, double height) => InkWell(
    onTap: () => go(context, '/category', arguments: title),
    child: Container(
      height: height,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xfffafafa),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .09),
            blurRadius: 35,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(title.toUpperCase(), style: label(19)),
          Text('$count ITEMS', style: caption(10)),
        ],
      ),
    ),
  );
  @override
  Widget build(BuildContext context) => PageShell(
    title: 'Home',
    menu: true,
    actions: const [ShopActions()],
    child: ListView(
      children: [
        Container(
          height: 333,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xffaaaaaa), Color(0xffaaaaaa), Color(0xff555555)],
              stops: [0, .45, 1],
            ),
          ),
          padding: const EdgeInsets.all(21),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Winter Vibes',
                style: display(33, color: MarnieColors.paper),
              ),
              Text(
                'COLD & BRILLIANT STRT \$29.99',
                style: label(16, MarnieColors.paper),
              ),
              const SizedBox(height: 16),
              CircleAction(
                icon: Icons.add,
                tooltip: 'Explore winter collection',
                onPressed: () => go(context, '/category', arguments: 'New-ins'),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(21, 40, 0, 30),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: section('Popular', () => go(context, '/category')),
              ),
              SizedBox(
                height: 285,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  separatorBuilder: (_, _) => const SizedBox(width: 16),
                  itemBuilder: (_, i) => SizedBox(
                    width: 140,
                    child: ProductCard(
                      productById(['crimson', 'skull', 'knit'][i]),
                      compact: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 21),
          child: Column(
            children: [
              const Divider(),
              const SizedBox(height: 35),
              section('Collections', () => go(context, '/category')),
              collection('Women', '247', 160),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        collection('Men', '112', 160),
                        const SizedBox(height: 14),
                        collection('Kids', '62', 160),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(child: collection('New-ins', '23', 334)),
                ],
              ),
              const SizedBox(height: 65),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Newsletter', style: display(33)),
              ),
              Text(
                'Morbi ultricies odio in purus feugiat efficitur. Quisque sit amet nisl eget augue...',
                style: caption(12),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Enter your Email',
                      ),
                    ),
                  ),
                  CircleAction(
                    icon: Icons.send_outlined,
                    tooltip: 'Subscribe to newsletter',
                    onPressed: () {
                      if (!RegExp(
                        r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                      ).hasMatch(email.text.trim())) {
                        notice(context, 'Enter a valid email address.');
                        return;
                      }
                      final shop = ShopScope.of(context);
                      shop.update(() {
                        shop.subscribed = true;
                        shop.email = email.text.trim();
                      });
                      email.clear();
                      notice(context, 'You’re on the list. Welcome to Marnie!');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 65),
              Container(
                height: 190,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.all(23),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: MarnieColors.pink,
                  boxShadow: [
                    BoxShadow(
                      color: MarnieColors.pink.withValues(alpha: .24),
                      offset: const Offset(12, 14),
                    ),
                    BoxShadow(
                      color: MarnieColors.pink.withValues(alpha: .18),
                      offset: const Offset(22, 28),
                    ),
                    const BoxShadow(
                      color: Colors.black12,
                      blurRadius: 24,
                      offset: Offset(0, 24),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Winter Winks',
                      style: display(33, color: Colors.white),
                    ),
                    Text(
                      '25% TO 50% FREE IN EVERY PURCHASE',
                      style: label(15, Colors.white),
                    ),
                    const SizedBox(height: 15),
                    CircleAction(
                      icon: Icons.add,
                      tooltip: 'Explore winter offers',
                      onPressed: () =>
                          go(context, '/category', arguments: 'New-ins'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 70),
            ],
          ),
        ),
      ],
    ),
  );
}

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});
  Widget item(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 18),
    leading: Icon(icon, size: 23),
    title: Text(title.toUpperCase(), style: label(18)),
    onTap: onTap,
  );
  @override
  Widget build(BuildContext context) => PageShell(
    actions: [
      IconButton(
        tooltip: 'Log out',
        onPressed: () {
          ShopScope.of(context).signOut();
          Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
        },
        icon: const Icon(Icons.power_settings_new),
      ),
    ],
    child: ListView(
      children: [
        item(
          context,
          Icons.explore_outlined,
          'Explore',
          () => go(context, '/home'),
        ),
        item(
          context,
          Icons.layers_outlined,
          'Shop',
          () => go(context, '/category'),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(68, 5, 20, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final title in ['Men', 'Women', 'Kids', 'New-ins'])
                InkWell(
                  onTap: () => go(context, '/category', arguments: title),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: Text(
                      title,
                      style: display(33, color: MarnieColors.muted),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(53, 0, 21, 25),
          child: Divider(),
        ),
        item(
          context,
          Icons.photo_outlined,
          'Gallery',
          () => go(context, '/category', arguments: 'New-ins'),
        ),
        item(
          context,
          Icons.map_outlined,
          'Find a store',
          () => go(context, '/map'),
        ),
        item(
          context,
          Icons.settings_outlined,
          'Settings',
          () => go(context, '/settings'),
        ),
        item(
          context,
          Icons.favorite_border,
          'Saved',
          () => go(context, '/saved'),
        ),
        item(
          context,
          Icons.account_circle_outlined,
          'Account',
          () => go(context, '/account'),
        ),
        item(
          context,
          Icons.help_outline,
          'Help & support',
          () => showInfo(
            context,
            'Help & support',
            'Explore collections, save your favorites and build your bag. Your selections stay on this device. Visit Account → Settings to update your profile.',
          ),
        ),
      ],
    ),
  );
}

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key, this.category = 'Women', this.saved = false});
  final String category;
  final bool saved;
  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  String collection = 'All';
  bool editing = false;
  List<Product> visibleProducts(ShopState shop) {
    if (widget.saved) return shop.saved.map(productById).toList();
    final ids = switch (widget.category) {
      'Men' => ['denim', 'skull', 'blackdenim', 'boots', 'crimson'],
      'Kids' => ['knit', 'sweater', 'scarf', 'crimson'],
      'New-ins' => products.map((p) => p.id).toList(),
      _ => [
        'blouse',
        'dress',
        'boots',
        'knit',
        'skirt',
        'bag',
        'denim',
        'sweater',
      ],
    };
    return ids
        .map(productById)
        .where(
          (p) =>
              shop.filter.matches(p) &&
              (collection == 'All' || p.collection == collection),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context),
        items = visibleProducts(ShopScope.of(context));
    return PageShell(
      title: widget.saved ? 'Saved' : widget.category,
      menu: !widget.saved,
      actions: widget.saved
          ? [
              IconButton(
                tooltip: 'Edit saved items',
                onPressed: () => setState(() => editing = !editing),
                icon: Icon(editing ? Icons.check : Icons.playlist_add_check),
              ),
            ]
          : const [ShopActions()],
      bottom: widget.saved ? const BottomTabs(2) : null,
      child: Column(
        children: [
          if (!widget.saved)
            Container(
              height: 66,
              padding: const EdgeInsets.symmetric(horizontal: 21),
              color: Theme.of(context).colorScheme.surface,
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: collection,
                        icon: const Icon(Icons.keyboard_arrow_down, size: 22),
                        style: display(
                          32,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        items:
                            [
                                  'All',
                                  'Outerwear',
                                  'Tops',
                                  'Dresses',
                                  'Shoes',
                                  'Bags',
                                  'Sweatshirts',
                                  'Accessories',
                                ]
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged: (v) => setState(() => collection = v!),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton.icon(
                    onPressed: () => go(context, '/filters'),
                    iconAlignment: IconAlignment.end,
                    icon: const Icon(Icons.filter_list, size: 22),
                    label: Text('FILTERS', style: label()),
                  ),
                ],
              ),
            ),
          if (editing)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text('Tap a heart to remove an item.', style: caption(11)),
            ),
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            widget.saved
                                ? Icons.favorite_border
                                : Icons.search_off,
                            size: 37,
                            color: MarnieColors.muted,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            widget.saved
                                ? 'Your favorites live here'
                                : 'No matches just yet',
                            style: display(26),
                          ),
                          const SizedBox(height: 20),
                          PrimaryButton(
                            widget.saved
                                ? 'Explore collections'
                                : 'Reset filters',
                            onPressed: () {
                              if (widget.saved) {
                                go(context, '/category');
                              } else {
                                shop.update(
                                  () => shop.filter = CatalogFilter(),
                                );
                                setState(() => collection = 'All');
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(21, 28, 21, 25),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 22,
                          childAspectRatio: .49,
                        ),
                    itemCount: items.length,
                    itemBuilder: (_, i) => ProductCard(
                      items[i],
                      favorite: widget.saved || i.isEven,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class FiltersPage extends StatefulWidget {
  const FiltersPage({super.key});
  @override
  State<FiltersPage> createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  CatalogFilter? draft;
  static const collections = [
    'All',
    'Outerwear',
    'Blazers',
    'Tops',
    'Dresses',
    'T-shirts',
    'Sweatshirts',
    'Trousers',
    'Jeans',
    'Bags',
    'Accessories',
    'Shoes',
  ];
  static const colors = <String, Color>{
    'White': Color(0xffeeeeee),
    'Grey': Color(0xffcccccc),
    'Pink': Color(0xffe91e63),
    'Purple': Color(0xffb735e8),
    'Blue': Color(0xff2196f3),
    'Lime': Color(0xffb2e500),
    'Brown': Color(0xffc5a06b),
    'Black': Color(0xff555555),
  };
  Widget heading(String title, String subtitle) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: display(33)),
      Text(subtitle.toUpperCase(), style: label(15, MarnieColors.muted)),
      const SizedBox(height: 14),
    ],
  );
  Widget divider() => const Padding(
    padding: EdgeInsets.symmetric(vertical: 35),
    child: Divider(),
  );
  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    final f = draft ??= shop.filter.copy();
    return PageShell(
      title: 'Filters',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(21, 50, 21, 40),
        children: [
          heading(
            'Collections',
            f.collections.isEmpty
                ? 'All collections'
                : '${f.collections.length} selected',
          ),
          Wrap(
            spacing: 12,
            runSpacing: 13,
            children: [
              for (final name in collections)
                Builder(
                  builder: (_) {
                    final active = name == 'All'
                        ? f.collections.isEmpty
                        : f.collections.contains(name);
                    return InkWell(
                      onTap: () => setState(() {
                        if (name == 'All') {
                          f.collections.clear();
                        } else if (!f.collections.remove(name)) {
                          f.collections.add(name);
                        }
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: active
                              ? const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xff444444),
                                    Color(0xff222222),
                                  ],
                                )
                              : null,
                          color: active ? null : const Color(0xffdddddd),
                          boxShadow: active
                              ? const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 16,
                                    offset: Offset(0, 10),
                                  ),
                                ]
                              : null,
                        ),
                        child: Text(
                          name.toUpperCase(),
                          style: label(
                            15,
                            active ? Colors.white : MarnieColors.muted,
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
          divider(),
          heading(
            'Colors',
            f.colors.isEmpty ? 'All colors' : f.colors.join(', '),
          ),
          Wrap(
            spacing: 17,
            runSpacing: 17,
            children: [
              for (final entry in colors.entries)
                Semantics(
                  label: entry.key,
                  selected: f.colors.contains(entry.key),
                  button: true,
                  child: InkWell(
                    onTap: () => setState(() {
                      if (!f.colors.remove(entry.key)) f.colors.add(entry.key);
                    }),
                    customBorder: const CircleBorder(),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: entry.value,
                        border: Border.all(
                          width: f.colors.contains(entry.key) ? 5 : 4,
                          color: f.colors.contains(entry.key)
                              ? const Color(0xffbbbbbb)
                              : const Color(0xffdddddd),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 16,
                            offset: Offset(0, 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          divider(),
          heading('Sizes', '${f.size} selected'),
          Row(
            children: [
              for (final size in ['S', 'M', 'L', 'XL', 'XXL'])
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => f.size = size),
                    child: Container(
                      height: 74,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: f.size == size ? MarnieColors.ink : null,
                        boxShadow: f.size == size
                            ? const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 25,
                                  offset: Offset(0, 12),
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        size,
                        style: label(
                          20,
                          f.size == size ? Colors.white : MarnieColors.muted,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          divider(),
          heading(
            'Price Range',
            'From \$${f.price.start.round()} to \$${f.price.end.round()}',
          ),
          RangeSlider(
            values: f.price,
            min: 0,
            max: 350,
            divisions: 14,
            labels: RangeLabels(
              '\$${f.price.start.round()}',
              '\$${f.price.end.round()}',
            ),
            activeColor: MarnieColors.ink,
            inactiveColor: MarnieColors.line,
            onChanged: (v) => setState(() => f.price = v),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final n in [0, 50, 100, 150, 200, 250, 350])
                Text('\$$n', style: label(14, MarnieColors.muted)),
            ],
          ),
          const SizedBox(height: 55),
          PrimaryButton(
            'Save filters',
            onPressed: () {
              shop.update(() => shop.filter = f.copy());
              closePage(context);
            },
          ),
          const SizedBox(height: 15),
          Center(
            child: TextButton(
              onPressed: () => setState(() => draft = CatalogFilter()),
              child: Text(
                'RESET FILTERS',
                style: label(14, MarnieColors.muted),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final query = TextEditingController(text: 'Black');
  @override
  void dispose() {
    query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final term = query.text.toLowerCase().trim(), shop = ShopScope.of(context);
    final results = products
        .where(
          (p) =>
              (p.name.toLowerCase().contains(term) ||
                  p.collection.toLowerCase().contains(term)) &&
              shop.filter.matches(p),
        )
        .toList();
    return PageShell(
      child: Column(
        children: [
          Container(
            height: 66,
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.only(left: 19, right: 10),
            child: Row(
              children: [
                const Icon(Icons.search, color: MarnieColors.muted),
                const SizedBox(width: 23),
                Expanded(
                  child: TextField(
                    controller: query,
                    style: label(18),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: 'Search Marnie',
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                IconButton(
                  tooltip: 'Search filters',
                  onPressed: () => go(context, '/filters'),
                  icon: const Icon(Icons.filter_list),
                ),
              ],
            ),
          ),
          Expanded(
            child: results.isEmpty
                ? Center(child: Text('No products found', style: display(25)))
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 18),
                    itemCount: results.length,
                    itemBuilder: (_, i) => ListTile(
                      leading: const Icon(
                        Icons.history,
                        color: Color(0xffaaaaaa),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18,
                      ),
                      title: Text(
                        results[i].name.toUpperCase(),
                        style: label(18),
                      ),
                      subtitle: Text(
                        results[i].collection.toUpperCase(),
                        style: caption(10),
                      ),
                      onTap: () =>
                          go(context, '/product', arguments: results[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
