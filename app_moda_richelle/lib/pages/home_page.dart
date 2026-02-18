import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../translations/app_translations.dart';
import '../login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.black.withValues(alpha: 0.3),
                blurRadius: 1,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.lightGrey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              
              // Profile option
              ListTile(
                leading: Icon(
                  Icons.person_outline,
                  color: AppTheme.primaryPink,
                  size: 24,
                ),
                title: Text(
                  AppTranslations.get('profile'),
                  style: AppTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to profile page
                },
              ),
              
              // Logout option
              ListTile(
                leading: Icon(
                  Icons.logout,
                  color: AppTheme.primaryPink,
                  size: 24,
                ),
                title: Text(
                  AppTranslations.get('logout'),
                  style: AppTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightPink,
      body: Column(
        children: [
          // Header with search and menu
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
                    // Search bar
                    Expanded(
                      child: Container(
                        decoration: AppTheme.inputShadowDecoration,
                        child: TextField(
                          decoration: AppTheme.inputDecoration(
                            hintText: AppTranslations.get('search'),
                            prefixIcon: Icon(
                              Icons.search,
                              color: AppTheme.mediumGrey,
                              size: 20,
                            ),
                          ),
                          style: AppTheme.bodyMedium,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    // Menu button
                    Container(
                      width: 45,
                      height: 45,
                      decoration: AppTheme.socialButtonDecoration,
                      child: IconButton(
                        onPressed: _showMenu,
                        icon: Icon(
                          Icons.menu,
                          color: AppTheme.black,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main content area (blank for now)
          Expanded(
            child: Stack(
              children: [
                // Main background
                Container(
                  width: double.infinity,
                  decoration: AppTheme.loginBodyGradientDecoration,
                  child: Center(
                    child: Text(
                      AppTranslations.get('homeContent'),
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

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          boxShadow: [
            BoxShadow(
              color: AppTheme.black.withValues(alpha: 0.3),
              blurRadius: 1,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: AppTheme.primaryPink,
          unselectedItemColor: AppTheme.mediumGrey,
          selectedFontSize: 12,
          unselectedFontSize: 10,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              label: AppTranslations.get('home'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.shopping_cart_outlined),
              activeIcon: const Icon(Icons.shopping_cart),
              label: AppTranslations.get('cart'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.favorite_border),
              activeIcon: const Icon(Icons.favorite),
              label: AppTranslations.get('favorites'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline),
              activeIcon: const Icon(Icons.person),
              label: AppTranslations.get('profile'),
            ),
          ],
        ),
      ),
    );
  }
}