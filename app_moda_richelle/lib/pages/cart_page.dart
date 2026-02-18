import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../translations/app_translations.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightPink,
      body: Column(
        children: [
          // Simple header
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppTheme.lightRose,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.black.withValues(alpha: 0.3),
                  blurRadius: 1,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppTheme.sidePadding, 
                  15, 
                  AppTheme.sidePadding, 
                  20
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back,
                        color: AppTheme.black,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      AppTranslations.get('cart'),
                      style: AppTheme.headingMedium.copyWith(
                        color: AppTheme.deepRose,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main content
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: AppTheme.loginBodyGradientDecoration,
              child: Center(
                child: Text(
                  '${AppTranslations.get('cart')} Content',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}