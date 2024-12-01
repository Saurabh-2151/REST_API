import 'package:flutter/material.dart';
import 'package:rest__api/services/api_service.dart';

class UpdateProductScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const UpdateProductScreen({Key? key, required this.product}) : super(key: key);

  @override
  _UpdateProductScreenState createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    _titleController.text = widget.product['title'] ?? '';
    _priceController.text = widget.product['price'].toString();
    _imageUrlController.text = widget.product['image'] ?? '';
  }

  Future<void> _updateProductInfo() async {
    if (_titleController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _imageUrlController.text.isEmpty) {
      _showSnackBar('Please fill all fields');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final updatedProduct = {
      'title': _titleController.text.trim(),
      'price': double.tryParse(_priceController.text.trim()) ?? 0,
      'image': _imageUrlController.text.trim(),
    };

    try {
      final result = await _apiService.updateProduct(
        widget.product['id'],
        updatedProduct,
      );

      _showSnackBar('Product updated successfully');
      Navigator.pop(context, result);
    } catch (e) {
      _showSnackBar('Failed to update product: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Product')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'Image URL',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateProductInfo,
                  child: const Text('Update Product'),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Image.network(
                  _imageUrlController.text,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 100),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
