import 'package:flutter/material.dart';
import 'package:rest__api/services/api_service.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final ApiService apiService = ApiService();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  Map<String, dynamic>? addedProduct;

  Future<void> addNewProduct() async {
    final title = titleController.text.trim();
    final price = double.tryParse(priceController.text.trim());
    final imageUrl = imageUrlController.text.trim();

    if (title.isEmpty || price == null || price <= 0 || imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all fields with valid data')));
      return;
    }

    final newProduct = {
      'title': title,
      'price': price,
      'image': imageUrl,
    };

    try {
      final result = await apiService.addProduct(newProduct);
      setState(() {
        addedProduct = result;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product added successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add product')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: imageUrlController,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: addNewProduct,
              child: const Text('Add Product'),
            ),
            const SizedBox(height: 20),
            if (addedProduct != null) ...[
              Text("${addedProduct!['id']}"),
              Text(addedProduct!['title'], style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold)),
              Text("\$${addedProduct!['price']}",
                  style: const TextStyle(fontSize: 16)),
              SizedBox(
                height: 200,
                child: Image.network(addedProduct!['image'], fit: BoxFit.cover),
              ),
            ],
          ],
        ),
      ),
    );
  }
}