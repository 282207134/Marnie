import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme.dart';
import '../core/widgets.dart';
import '../state/shop_state.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});
  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle.light,
    child: Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff222222), Color(0xff444444)],
          ),
        ),
        child: SafeArea(
          minimum: const EdgeInsets.fromLTRB(21, 60, 21, 45),
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 22),
                      Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: const LinearGradient(
                            colors: [Color(0xffdddddd), Color(0xfffafafa)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 25,
                              offset: Offset(0, 15),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/images/marnie-mark.png',
                            width: 30.33,
                            height: 28.67,
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Text(
                        'Marnie',
                        style: display(46, color: MarnieColors.paper),
                      ),
                      const SizedBox(height: 10),
                      const UnderlineTitle(
                        'Quality is not an Act,\nIt’s a Habit.',
                        size: 33,
                        color: MarnieColors.paper,
                      ),
                      const Spacer(),
                      const SizedBox(height: 65),
                      PrimaryButton(
                        'Login',
                        light: true,
                        onPressed: () => go(context, '/login'),
                      ),
                      const SizedBox(height: 20),
                      PrimaryButton(
                        'Login with Twitter',
                        leading: Image.asset(
                          'assets/images/twitter.png',
                          width: 18,
                          height: 15,
                        ),
                        color: const Color(0xff4198c7),
                        onPressed: () => showInfo(
                          context,
                          'Twitter login',
                          'Social sign-in requires a connected authentication service. Use the local login to explore Marnie.',
                        ),
                      ),
                      const SizedBox(height: 40),
                      const Divider(color: Color(0xff666666)),
                      const SizedBox(height: 15),
                      Center(
                        child: TextButton(
                          onPressed: () => go(context, '/signup'),
                          child: Text(
                            'NEW TO THIS? SIGN UP',
                            style: label(16, MarnieColors.muted),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key, this.signUp = false});
  final bool signUp;
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final formKey = GlobalKey<FormState>();
  final username = TextEditingController(),
      password = TextEditingController(),
      repeat = TextEditingController(),
      email = TextEditingController();
  bool terms = true;
  @override
  void dispose() {
    for (final c in [username, password, repeat, email]) {
      c.dispose();
    }
    super.dispose();
  }

  void submit() {
    if (!formKey.currentState!.validate()) return;
    if (widget.signUp && !terms) {
      notice(context, 'Please accept the terms and conditions.');
      return;
    }
    final shop = ShopScope.of(context);
    shop.update(() {
      shop.username = username.text.trim();
      if (widget.signUp) shop.email = email.text.trim();
      shop.signedIn = true;
    });
    Navigator.pushNamedAndRemoveUntil(
      context,
      widget.signUp ? '/country' : '/home',
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) => PageShell(
    title: widget.signUp ? 'Sign up' : 'Login',
    child: LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(21, 25, 21, 15),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight - 40),
          child: IntrinsicHeight(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UnderlineTitle(
                    widget.signUp
                        ? 'Join us... the new face of the fashion industry.'
                        : 'Log in to your account now & explore a world of aesthetic fashion...',
                    size: 29,
                  ),
                  SizedBox(height: widget.signUp ? 30 : 95),
                  TextFormField(
                    controller: username,
                    decoration: const InputDecoration(hintText: 'Username'),
                    textInputAction: TextInputAction.next,
                    validator: (s) => s == null || s.trim().isEmpty
                        ? 'Enter your username'
                        : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: password,
                    obscureText: true,
                    decoration: const InputDecoration(hintText: 'Password'),
                    textInputAction: widget.signUp
                        ? TextInputAction.next
                        : TextInputAction.done,
                    onFieldSubmitted: (_) {
                      if (!widget.signUp) submit();
                    },
                    validator: (s) => (s?.length ?? 0) < 6
                        ? 'Use at least 6 characters'
                        : null,
                  ),
                  if (widget.signUp) ...[
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: repeat,
                      obscureText: true,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'Re-Enter Password',
                      ),
                      validator: (s) =>
                          s != password.text ? 'Passwords must match' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(hintText: 'Email'),
                      validator: (s) =>
                          s != null &&
                              RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(s)
                          ? null
                          : 'Enter a valid email',
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Checkbox(
                          value: terms,
                          onChanged: (v) => setState(() => terms = v!),
                        ),
                        TextButton(
                          onPressed: () => showInfo(
                            context,
                            'Terms & conditions',
                            'This local shopping demo stores your profile and preferences on this device. No purchases or payments are submitted.',
                          ),
                          child: Text('TERMS & CONDITIONS   →', style: label()),
                        ),
                      ],
                    ),
                  ] else
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => showInfo(
                          context,
                          'Reset password',
                          'This build uses a local demo account. Enter any username and a password of at least 6 characters to continue.',
                        ),
                        child: Text('FORGOT PASSWORD?   →', style: label()),
                      ),
                    ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    widget.signUp ? 'Sign up' : 'Login',
                    onPressed: submit,
                  ),
                  const Spacer(),
                  const SizedBox(height: 50),
                  const Divider(),
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(
                        context,
                        widget.signUp ? '/login' : '/signup',
                      ),
                      child: Text(
                        widget.signUp
                            ? 'ALREADY DID THIS? LOG IN'
                            : 'NEW TO THIS? SIGN UP',
                        style: label(16, MarnieColors.muted),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class CountryPage extends StatefulWidget {
  const CountryPage({super.key});
  @override
  State<CountryPage> createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  String? selected;
  static const countries = [
    'Singapore',
    'Sint Maarten',
    'Slovakia',
    'Slovenia',
    'Solomon Islands',
    'Somalia',
    'South Africa',
    'South Korea',
    'South Sudan',
  ];
  @override
  Widget build(BuildContext context) {
    final shop = ShopScope.of(context);
    final current = selected ?? shop.country;
    return PageShell(
      title: 'Choose a country',
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 20),
              itemCount: countries.length,
              itemBuilder: (context, i) => Material(
                color: current == countries[i]
                    ? Theme.of(context).colorScheme.surface
                    : Colors.transparent,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 21),
                  minVerticalPadding: 13,
                  leading: SizedBox(
                    width: 27,
                    child: current == countries[i]
                        ? const Icon(Icons.shopping_bag_outlined, size: 22)
                        : null,
                  ),
                  title: Text(
                    countries[i].toUpperCase(),
                    style: label(
                      18,
                      current == countries[i] ? null : MarnieColors.muted,
                    ),
                  ),
                  onTap: () => setState(() => selected = countries[i]),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(21, 16, 21, 30),
            child: PrimaryButton(
              'Continue',
              onPressed: () {
                shop.update(() => shop.country = selected ?? shop.country);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (_) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class RatePage extends StatefulWidget {
  const RatePage({super.key});
  @override
  State<RatePage> createState() => _RatePageState();
}

class _RatePageState extends State<RatePage> {
  int selected = 1;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xff777777),
    body: Center(
      child: Container(
        margin: const EdgeInsets.all(21),
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
        color: MarnieColors.paper,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 52,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text('RATE US', style: label(18, MarnieColors.ink)),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      tooltip: 'Close',
                      onPressed: () => closePage(context),
                      icon: const Icon(Icons.close, color: MarnieColors.ink),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(12, 28, 12, 35),
              child: UnderlineTitle(
                'Rate your experience\nwith this app...',
                size: 27,
                color: MarnieColors.ink,
              ),
            ),
            Row(
              children: [
                for (final (i, (icon, text)) in [
                  (Icons.sentiment_very_dissatisfied, 'SO BAD'),
                  (Icons.sentiment_neutral, 'OKAY'),
                  (Icons.sentiment_satisfied, 'GOOD'),
                  (Icons.sentiment_very_satisfied, 'AMAZING'),
                ].indexed)
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selected = i),
                      child: Container(
                        height: 74,
                        color: i == selected
                            ? MarnieColors.ink
                            : const Color(0xffeeeeee),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              icon,
                              color: i == selected
                                  ? Colors.white
                                  : MarnieColors.muted,
                            ),
                            const SizedBox(height: 7),
                            Text(
                              text,
                              style: caption(
                                9,
                                i == selected
                                    ? Colors.white
                                    : MarnieColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 45),
            PrimaryButton(
              'Submit',
              onPressed: () {
                final shop = ShopScope.of(context);
                shop.update(() => shop.rating = selected);
                closePage(context);
                notice(context, 'Thank you for your feedback!');
              },
            ),
          ],
        ),
      ),
    ),
  );
}
