import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../models/models.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;
  int get itemCount => _items.length;
  bool get isEmpty => _items.isEmpty;

  double get subtotal =>
      _items.fold(0.0, (sum, item) => sum + item.total);

  double get total => subtotal;

  void addItem(ServiceModel service) {
    final existingIndex =
        _items.indexWhere((item) => item.serviceId == service.id);

    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(
        serviceId: service.id,
        nameEn: service.nameEn,
        nameAr: service.nameAr,
        category: service.category,
        price: service.price,
      ));
    }
    notifyListeners();
    _saveCart();
  }

  // Save cart to local storage
  Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = _items.map((item) => item.toMap()).toList();
      await prefs.setString('saved_cart', json.encode(cartJson));
    } catch (_) {}
  }

  // Load cart from local storage
  Future<void> loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartString = prefs.getString('saved_cart');
      if (cartString != null) {
        final List<dynamic> cartList = json.decode(cartString);
        _items.clear();
        _items.addAll(cartList.map((item) => CartItem.fromMap(item as Map<String, dynamic>)).toList();
        notifyListeners();
      }
    } catch (_) {}
  }

  void removeItem(String serviceId) {
    _items.removeWhere((item) => item.serviceId == serviceId);
    notifyListeners();
    _saveCart();
  }

  void updateQuantity(String serviceId, int quantity) {
    final index = _items.indexWhere((item) => item.serviceId == serviceId);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void incrementQuantity(String serviceId) {
    final index = _items.indexWhere((item) => item.serviceId == serviceId);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(String serviceId) {
    final index = _items.indexWhere((item) => item.serviceId == serviceId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
    _saveCart();
  }
}
