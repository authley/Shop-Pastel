import 'package:flutter/material.dart';

import '../models/product_model.dart';
import '../theme/pastel_theme.dart';

class ProductForm extends StatefulWidget {
  final Product? initial;
  final String submitLabel;
  final Future<void> Function(Map<String, dynamic> data) onSubmit;

  const ProductForm({
    super.key,
    this.initial,
    required this.submitLabel,
    required this.onSubmit,
  });

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _priceController;
  late final TextEditingController _categoryController;
  late final TextEditingController _brandController;
  late final TextEditingController _stockController;
  late final TextEditingController _thumbnailController;
  late final TextEditingController _descriptionController;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final product = widget.initial;
    _titleController = TextEditingController(text: product?.title ?? '');
    _priceController = TextEditingController(
      text: product == null ? '' : product.price.toString(),
    );
    _categoryController = TextEditingController(text: product?.category ?? '');
    _brandController = TextEditingController(text: product?.brand ?? '');
    _stockController = TextEditingController(
      text: product == null ? '' : product.stock.toString(),
    );
    _thumbnailController = TextEditingController(
      text: product?.thumbnail ?? '',
    );
    _descriptionController = TextEditingController(
      text: product?.description ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _brandController.dispose();
    _stockController.dispose();
    _thumbnailController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    try {
      await widget.onSubmit({
        'title': _titleController.text.trim(),
        'price': double.parse(_priceController.text.trim()),
        'category': _categoryController.text.trim(),
        'brand': _brandController.text.trim(),
        'stock': int.tryParse(_stockController.text.trim()) ?? 0,
        'thumbnail': _thumbnailController.text.trim(),
        'description': _descriptionController.text.trim(),
      });
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) return 'Wajib diisi';
    return null;
  }

  String? _validPrice(String? value) {
    if (value == null || value.trim().isEmpty) return 'Wajib diisi';
    final price = double.tryParse(value.trim());
    if (price == null || price < 0) return 'Masukkan harga yang valid';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _field(_titleController, 'Nama produk', validator: _required),
          const SizedBox(height: 14),
          _field(
            _priceController,
            'Harga',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: _validPrice,
          ),
          const SizedBox(height: 14),
          _field(_categoryController, 'Kategori', validator: _required),
          const SizedBox(height: 14),
          _field(_brandController, 'Merek'),
          const SizedBox(height: 14),
          _field(_stockController, 'Stok', keyboardType: TextInputType.number),
          const SizedBox(height: 14),
          _field(_thumbnailController, 'URL gambar'),
          const SizedBox(height: 14),
          _field(_descriptionController, 'Deskripsi', maxLines: 4),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _submitting ? null : _submit,
            icon: _submitting
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.save_rounded),
            label: Text(widget.submitLabel),
            style: FilledButton.styleFrom(
              backgroundColor: Pastel.accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Pastel.lavender),
        ),
      ),
    );
  }
}
