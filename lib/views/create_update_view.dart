import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/providers/product_provider.dart';
import 'package:myapp/routes/app_routes.dart';
import 'package:myapp/types/product.dart';

import '../widgets/custom_input_text.dart';
import '../widgets/drawer_widget.dart';

class CreateUpdateView extends ConsumerWidget {
  final String? productId;
  const CreateUpdateView({super.key, this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController nameCtrl = TextEditingController();
    final TextEditingController priceCtrl = TextEditingController();
    final TextEditingController stockCtrl = TextEditingController();
    final TextEditingController urlImageCtrl = TextEditingController();
    final TextEditingController descriptionCtrl = TextEditingController();

    final productIdProv = productId == null
        ? ref.watch(productEmptyProvider)
        : ref.watch(productByIdProvider(productId!));

    return Scaffold(
      appBar: AppBar(
        title: Text(productId == null ? "Crear Producto" : "Actualizar Producto"),
      ),
      drawer: const DrawerWidget(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              child: Column(
                children: [
                  productIdProv.when(
                    data: (product) {
                      if (productId != null) {
                        // Update inputs controllers
                        nameCtrl.text = product.name;
                        priceCtrl.text = product.price.toString();
                        stockCtrl.text = product.stock.toString();
                        urlImageCtrl.text = product.urlImage;
                        descriptionCtrl.text = product.description;
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Nombre del Producto",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          CustomInputText(
                            label: 'Nombre del Producto',
                            hintText: product.name,
                            controller: nameCtrl,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Precio",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          CustomInputText(
                            label: 'Precio',
                            hintText: product.price.toString(),
                            controller: priceCtrl,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Stock",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          CustomInputText(
                            label: 'Stock',
                            hintText: product.stock.toString(),
                            controller: stockCtrl,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "URL de la Imagen",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          CustomInputText(
                            label: 'URL de la Imagen',
                            hintText: product.urlImage,
                            controller: urlImageCtrl,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Descripción",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          CustomInputText(
                            label: 'Descripción',
                            hintText: product.description,
                            controller: descriptionCtrl,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.blue),
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                              ),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              final Product productSubmit = Product(
                                id: productId ?? '',
                                name: nameCtrl.text,
                                price: double.parse(priceCtrl.text),
                                stock: double.parse(stockCtrl.text),
                                urlImage: urlImageCtrl.text,
                                description: descriptionCtrl.text,
                                v: 0,
                              );

                              if (productId == null) {
                                // Crear
                                ref.read(createProductProvider(productSubmit));
                              } else {
                                // Actualizar
                                ref.read(updateProductProvider(productSubmit));
                              }

                              context.push(AppRoutes.productsListView);
                              ref.invalidate(productsProvider);
                            },
                            child: Text(
                              productId == null ? 'Crear' : 'Actualizar',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      );
                    },
                    error: (err, trc) {
                      return Column(
                        children: [Text('$err'), Text('$trc')],
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
