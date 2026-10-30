import 'package:flutter/foundation.dart';

import '../models/product_model.dart';
import '../services/api_service_products.dart';

class ProductProvider extends ChangeNotifier {
  final ApiServiceProducts _api = ApiServiceProducts();

  List<Product> _products = [];
  List<String> _categoryList = [];
  bool _loading = false;
  String? _error;
  int _total = 0;
  String _selectedCategory = '';

  // Penanda request terbaru agar respons lama tidak menimpa hasil baru.
  int _requestId = 0;

  List<Product> get products => _products;
  List<String> get categoryList => _categoryList;
  bool get loading => _loading;
  String? get error => _error;
  int get total => _total;
  String get selectedCategory => _selectedCategory;

  Future<void> _load(Future<ProductsResponse> Function() call) async {
    final id = ++_requestId;
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await call();
      if (id != _requestId) return;
      _products = res.products;
      _total = res.total;
    } catch (e) {
      if (id != _requestId) return;
      _error = e.toString();
      _products = [];
    } finally {
      if (id == _requestId) {
        _loading = false;
        notifyListeners();
      }
    }
  }

  Future<void> fetchProducts({int limit = 30, int skip = 0}) {
    _selectedCategory = '';
    return _load(() => _api.getAllProducts(limit: limit, skip: skip));
  }

  Future<void> fetchCategories() async {
    try {
      _categoryList = await _api.getCategoryList();
      notifyListeners();
    } catch (_) {
      // Kategori pelengkap; kegagalannya tidak perlu menghentikan UI.
    }
  }

  Future<void> searchProducts(String query) {
    if (query.trim().isEmpty) return fetchProducts(limit: 0);
    _selectedCategory = '';
    return _load(() => _api.searchProducts(query.trim()));
  }

  Future<void> filterByCategory(String category) {
    _selectedCategory = category;
    return _load(() => _api.getProductsByCategory(category));
  }

  Future<void> sortProducts(String sortBy, String order) {
    return _load(() => _api.sortProducts(sortBy, order));
  }

  Future<Product?> addProduct(Map<String, dynamic> data) async {
    try {
      final product = await _api.addProduct(data);
      _products = [product, ..._products];
      _total++;
      notifyListeners();
      return product;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<Product?> updateProduct(int id, Map<String, dynamic> data) async {
    try {
      final product = await _api.updateProduct(id, data);
      final index = _products.indexWhere((item) => item.id == id);
      if (index != -1) {
        final updatedProducts = List<Product>.of(_products);
        updatedProducts[index] = product;
        _products = updatedProducts;
      }
      notifyListeners();
      return product;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }
}
