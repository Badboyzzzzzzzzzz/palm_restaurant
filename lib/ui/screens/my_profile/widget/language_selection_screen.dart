import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:palm_ecommerce_app/ui/provider/language_provider.dart';
import 'package:palm_ecommerce_app/util/themes.dart';
import 'package:palm_ecommerce_app/l10n/app_localizations.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();
    final currentLanguage = languageProvider.currentLocale.languageCode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppLocalizations.of(context)!.language,
          style: semiBoldText20.copyWith(color: Colors.white),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primaryBackgroundColor,
              secondaryBackgroundColor,
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(
                    Icons.language,
                    size: 60,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.language,
                    style: semiBoldText20.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.preferLangauge,
                    style: regularText14.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Language options
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // English option
                    _buildLanguageOption(
                      languageCode: 'en',
                      languageName: 'English',
                      nativeName: 'English',
                      flag: '🇺🇸',
                      isSelected: currentLanguage == 'en',
                      onTap: () => _changeLanguage('en'),
                    ),

                    const SizedBox(height: 16),

                    // Khmer option
                    _buildLanguageOption(
                      languageCode: 'km',
                      languageName: 'ខ្មែរ',
                      nativeName: 'Khmer',
                      flag: '🇰🇭',
                      isSelected: currentLanguage == 'km',
                      onTap: () => _changeLanguage('km'),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom info
            Container(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Language changes will be applied immediately',
                style: regularText12.copyWith(
                  color: Colors.white.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required String languageCode,
    required String languageName,
    required String nativeName,
    required String flag,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? Colors.white.withOpacity(0.2) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: isSelected
                ? Colors.white.withOpacity(0.2)
                : Colors.grey.withOpacity(0.1),
          ),
          child: Center(
            child: Text(
              flag,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
        title: Text(
          languageName,
          style: semiBoldText16.copyWith(
            color: isSelected ? Colors.white : blackColor,
          ),
        ),
        subtitle: Text(
          nativeName,
          style: regularText12.copyWith(
            color: isSelected ? Colors.white.withOpacity(0.8) : greyColor,
          ),
        ),
        trailing: isSelected
            ? Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 20,
                ),
              )
            : const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
        onTap: onTap,
      ),
    );
  }

  void _changeLanguage(String languageCode) async {
    final languageProvider = context.read<LanguageProvider>();

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        );
      },
    );
    // Change language
    await languageProvider.changeLanguage(languageCode);
    // Hide loading indicator
    Navigator.of(context).pop();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          languageCode == 'en'
              ? 'Language changed to English'
              : 'ភាសាត្រូវបានប្តូរទៅជាខ្មែរ',
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
