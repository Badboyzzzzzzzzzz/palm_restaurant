import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  static const String _defaultLanguageCode = 'en';
  static const List<String> _supportedLanguages = ['en', 'km'];

  Locale _currentLocale = const Locale(_defaultLanguageCode);
  Locale get currentLocale => _currentLocale;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  final Completer<void> _initializationCompleter = Completer<void>();
  Future<void> get initialized => _initializationCompleter.future;

  LanguageProvider() {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageKey);

      if (_isValidLanguageCode(languageCode)) {
        _currentLocale = Locale(languageCode!);
      } else {
        // Use default only if necessary
        _currentLocale = const Locale(_defaultLanguageCode);
        await prefs.setString(_languageKey, _defaultLanguageCode);
      }
    } catch (e) {
      _currentLocale = const Locale(_defaultLanguageCode);
    } finally {
      _isInitialized = true;
      if (!_initializationCompleter.isCompleted) {
        _initializationCompleter.complete();
      }
      notifyListeners();
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    if (!_isValidLanguageCode(languageCode)) return;
    try {
      _currentLocale = Locale(languageCode);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);
      notifyListeners();
    } catch (e) {
      // Ignore errors silently; fallback is already handled
    }
  }
  Future<Locale> ensureLanguageInitialized() async {
    if (!_isInitialized) {
      await initialized;
    }

    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(_languageKey);

    if (_isValidLanguageCode(savedLanguage)) {
      _currentLocale = Locale(savedLanguage!);
    } else {
      _currentLocale = const Locale(_defaultLanguageCode);
      await prefs.setString(_languageKey, _defaultLanguageCode);
    }

    notifyListeners();
    return _currentLocale;
  }
  Future<void> reloadLanguageSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageKey);
      if (_isValidLanguageCode(languageCode)) {
        _currentLocale = Locale(languageCode!);
      } else {
        _currentLocale = const Locale(_defaultLanguageCode);
        await prefs.setString(_languageKey, _defaultLanguageCode);
      }
      notifyListeners();
    } catch (e) {
      _currentLocale = const Locale(_defaultLanguageCode);
      notifyListeners();
    }
  }

  bool _isValidLanguageCode(String? code) {
    return code != null && _supportedLanguages.contains(code);
  }
}
