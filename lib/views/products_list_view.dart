import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/types/product.dart';
import '../providers/product_provider.dart';
import '../widgets/card_item_product.dart';
import '../widgets/drawer_widget.dart';

class ProductsListView extends ConsumerWidget {
  const ProductsListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productProv = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Productos"),
        backgroundColor: Colors.blueGrey,
        elevation: 0,
      ),
      drawer: const DrawerWidget(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 150.0,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text("Nuestros Productos", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blueGrey.shade800, Colors.blueGrey.shade600],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Text(
                    "Descubre la moda de gimnasio que se adapta a ti",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      shadows: [Shadow(blurRadius: 8.0, color: Colors.black.withOpacity(0.5), offset: Offset(2.0, 2.0))],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return productProv.when(
                    data: (List<Product> products) {
                      if (index >= products.length) return null;
                      final product = products[index];
                      return CardItemProduct(
                        id: product.id,
                        url: product.urlImage,
                        name: product.name,
                        price: product.price,
                        stock: product.stock,
                        description: product.description,
                      );
                    },
                    error: (err, stack) => ListTile(
                      title: Text('Error: ${err.toString()}'),
                    ),
                    loading: () => Center(child: CircularProgressIndicator()),
                  );
                },
                childCount: productProv.maybeWhen(
                  data: (products) => products.length,
                  orElse: () => 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
