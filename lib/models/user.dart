import 'package:flutter/material.dart';
import '../enums/symptom.dart'; // Assuming Symptom enum is in a separate file

class User with ChangeNotifier {
  String _selectedFlow = '';
  final List<Symptom> _selectedSymptoms = [];

  // Getters
  String get selectedFlow => _selectedFlow;
  List<Symptom> get selectedSymptoms => List<Symptom>.from(_selectedSymptoms);

  // Set flow intensity
  void setFlow(String flow) {
    _selectedFlow = flow;
    notifyListeners();
  }

  // Toggle symptoms using Symptom enum
  void toggleSymptom(Symptom symptom) {
    if (_selectedSymptoms.contains(symptom)) {
      _selectedSymptoms.remove(symptom);
    } else {
      _selectedSymptoms.add(symptom);
    }
    notifyListeners();
  }

  // Cart management
  final Map<String, int> _cart = {};
  final Map<String, double> _itemPrices = {
    'Stayfree Secure Pads': 189.0,
    'Ibuprofen (Pain Relief)': 120.0,
    'Sofy Antibacterial Pads': 250.0,
    'Heat Patch (Cramps)': 150.0,
    'Stayfree Overnight Pads': 199.0,
    'Menstrual Cup (Medium)': 300.0,
    'Whisper Ultra Pads': 212.0,
  };

  Map<String, int> get cartItems => Map.from(_cart);

  double get cartTotal {
    double total = 0;
    _cart.forEach((item, quantity) {
      total += (_itemPrices[item] ?? 0) * quantity;
    });
    return total;
  }

  void addToCart(String item) {
    _cart[item] = (_cart[item] ?? 0) + 1;
    notifyListeners();
  }

  void removeFromCart(String item) {
    if (_cart[item] != null && _cart[item]! > 0) {
      _cart[item] = _cart[item]! - 1;
      if (_cart[item] == 0) _cart.remove(item);
      notifyListeners();
    }
  }
}