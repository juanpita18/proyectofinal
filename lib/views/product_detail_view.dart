import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/product_provider.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/product_detail_widget.dart';

class ProductDetailView extends ConsumerWidget {
  final String? productId;
  const ProductDetailView({super.key, this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Asegurarse con un print
    final productByidRef = ref.watch(productByIdProvider(productId ?? ''));
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Detail View"),
      ),
      drawer: const DrawerWidget(),
      body: productByidRef.when(
        data: (item) => ProductDetailWidget(
          id: item.id,
          url: item.urlImage,
          name: item.name,
          price: item.price,
          stock: item.stock,
          description: item.description,
        ),
        error: (error, stackTrace) => Column(
          children: [
            Text(error.toString()),
            Text(stackTrace.toString()),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
