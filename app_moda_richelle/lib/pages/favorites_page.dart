import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../translations/app_translations.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

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
                      AppTranslations.get('favorites'),
                      style: AppTheme.headingMedium.copyWith(
                        color: AppTheme.deepRose,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main content with decorative bubble
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: AppTheme.loginBodyGradientDecoration,
                  child: Center(
                    child: Text(
                      '${AppTranslations.get('favorites')} Content',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                
                // Decorative bubble at bottom right (60% visible)
                Positioned(
                  bottom: -60,
                  right: -60,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: AppTheme.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.white.withValues(alpha: 0.2),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}