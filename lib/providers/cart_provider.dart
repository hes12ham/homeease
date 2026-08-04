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
        price: service.price,
      ));
    }
    notifyListeners();
  }

  void removeItem(String serviceId) {
    _items.removeWhere((item) => item.serviceId == serviceId);
    notifyListeners();
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
  }
}
