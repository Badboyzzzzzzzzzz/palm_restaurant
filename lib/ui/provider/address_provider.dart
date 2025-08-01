import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/data/repository/delivery_adress_repository.dart';
import 'package:palm_ecommerce_app/models/delivery.dart';
import 'package:palm_ecommerce_app/ui/provider/async_values.dart';

class AddressProvider extends ChangeNotifier {
  final DeliveryAddressRepository addressRepository;
  AsyncValue<List<DeliveryAddressModel>> _addresses = AsyncValue.empty();
  bool _isLoading = false;
  String? _error;
  List<DeliveryAddressModel> _cachedAddresses = [];

  AddressProvider({required this.addressRepository});

  AsyncValue<List<DeliveryAddressModel>> get addresses => _addresses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchAddresses() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _addresses = AsyncValue.loading();
      notifyListeners();
      final addresses = await addressRepository.getDeliveryAddresses();
      if (addresses.isEmpty) {
        _addresses = AsyncValue.empty();
      } else {
        _cachedAddresses = addresses;
        _addresses = AsyncValue.success(_cachedAddresses);
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _addresses = AsyncValue.error(e);
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }
  Future<bool> addAddress(DeliveryAddressModel address) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await addressRepository.addDeliveryAddress(address);
      await fetchAddresses();
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateAddress(DeliveryAddressModel address) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await addressRepository.updateDeliveryAddress(address);
      await fetchAddresses();
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteAddress(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await addressRepository.deleteDeliveryAddress(id);
      await fetchAddresses();
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
