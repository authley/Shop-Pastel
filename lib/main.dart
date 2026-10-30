import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'models/product_model.dart';
import 'providers/product_provider.dart';
import 'screens/add_product_screen.dart';
import 'screens/detail_product_screen.dart';
import 'screens/edit_product_screen.dart';
import 'screens/list_product_screen.dart';
import 'theme/pastel_theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ProductProvider(),
      child: const MyApp(),
    ),
  );
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ListProductScreen(),
    ),
    GoRoute(
      path: '/detail/:id',
      builder: (context, state) {
        final product = state.extra;
        if (product is Product) {
          return DetailProductScreen(product: product);
        }
        return const ListProductScreen();
      },
    ),
    GoRoute(
      path: '/add',
      builder: (context, state) => const AddProductScreen(),
    ),
    GoRoute(
      path: '/edit/:id',
      builder: (context, state) {
        final product = state.extra;
        if (product is Product) {
          return EditProductScreen(product: product);
        }
        return const ListProductScreen();
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pastel Shop',
      debugShowCheckedModeBanner: false,
      theme: Pastel.theme,
      routerConfig: _router,
    );
  }
}
