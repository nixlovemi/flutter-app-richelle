import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../translations/app_translations.dart';
import '../login_page.dart';
import '../utils/alert_dialog_utils.dart';
import '../services/auth_service.dart';
import '../widgets/user_avatar.dart';
import '../examples/avatar_test_page.dart';
import 'settings_page.dart';
import 'registration_page.dart';

class HomePage extends StatefulWidget {
  final AuthService authService;
  
  const HomePage({super.key, required this.authService});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.authService.addListener(_handleAuthStateChanged);
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.authService != widget.authService) {
      oldWidget.authService.removeListener(_handleAuthStateChanged);
      widget.authService.addListener(_handleAuthStateChanged);
    }
  }

  void _handleAuthStateChanged() {
    if (!mounted) return;

    // If the user is logged out/deleted while on profile tab,
    // redirect to Home tab to prevent interacting with profile actions.
    if (!widget.authService.isAuthenticated && _selectedIndex == 3) {
      setState(() {
        _selectedIndex = 0;
      });
      return;
    }

    // Keep HomePage in sync with auth updates.
    setState(() {});
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildHomeContent() {
    return Stack(
      children: [
        // Main background
        Container(
          width: double.infinity,
          decoration: AppTheme.loginBodyGradientDecoration,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.home,
                  size: 80,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
                const SizedBox(height: 20),
                Text(
                  AppTranslations.get('homeContent'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
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
    );
  }

  Widget _buildCartContent() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: AppTheme.loginBodyGradientDecoration,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart,
                  size: 80,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
                const SizedBox(height: 20),
                Text(
                  AppTranslations.get('cart'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  AppTranslations.get('cartEmpty'),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        
        // Decorative elements
        Positioned(
          top: 50,
          left: -30,
          child: Container(
            width: 100,
            height: 100,
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
    );
  }

  Widget _buildFavoritesContent() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: AppTheme.loginBodyGradientDecoration,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite,
                  size: 80,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
                const SizedBox(height: 20),
                Text(
                  AppTranslations.get('favorites'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  AppTranslations.get('favoritesEmpty'),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        
        // Heart decorations
        Positioned(
          top: 80,
          right: 30,
          child: Icon(
            Icons.favorite_border,
            size: 60,
            color: AppTheme.white.withValues(alpha: 0.2),
          ),
        ),
        Positioned(
          bottom: 120,
          left: 40,
          child: Icon(
            Icons.favorite_border,
            size: 40,
            color: AppTheme.white.withValues(alpha: 0.2),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileContent() {
    // Check if user is authenticated
    if (!widget.authService.isAuthenticated) {
      // Show login form in profile tab
      return _buildProfileLoginContent();
    }
    
    // Show authenticated user profile options
    return _buildAuthenticatedProfileContent();
  }
  
  Widget _buildProfileLoginContent() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: AppTheme.loginBodyGradientDecoration,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppTheme.white.withValues(alpha: 0.2),
                  child: Icon(
                    Icons.person_outline,
                    size: 60,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  AppTranslations.get('profile'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  AppTranslations.get('loginToAccess'),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LoginPage(authService: widget.authService),
                        ),
                      ).then((loginSuccessful) {
                        // Refresh the profile tab only if login was successful
                        if (loginSuccessful == true) {
                          setState(() {});
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      AppTranslations.get('login'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegistrationPage(authService: widget.authService),
                      ),
                    ).then((registrationCompleted) {
                      // Refresh if registration flow completed
                      if (registrationCompleted == true) {
                        setState(() {});
                      }
                    });
                  },
                  child: Text(
                    AppTranslations.get('createAccount'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildAuthenticatedProfileContent() {
    final user = widget.authService.currentUser;
    
    // Debug: Print avatar information
    if (kDebugMode) {
      debugPrint('🖼️ HomePage: User avatar URL: ${user?.avatarUrl}');
      debugPrint('🖼️ HomePage: User full name: ${user?.fullName}');
    }
    
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: AppTheme.loginBodyGradientDecoration,
          child: Column(
            children: [
              const SizedBox(height: 60),
              // Profile avatar with Google image support
              UserAvatar.extraLarge(
                user: user,
                backgroundColor: AppTheme.white.withValues(alpha: 0.2),
                foregroundColor: Colors.white.withValues(alpha: 0.8),
              ),
              const SizedBox(height: 20),
              Text(
                AppTranslations.get('profile'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              
              // Profile options
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _buildProfileOption(
                        Icons.person_outline,
                        AppTranslations.get('editProfile'),
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileEditPage(authService: widget.authService),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                      _buildProfileOption(
                        Icons.settings_outlined,
                        AppTranslations.get('settings'),
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SettingsPage(authService: widget.authService),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 15),
                      _buildProfileOption(
                        Icons.help_outline,
                        AppTranslations.get('helpSupport'),
                        () {},
                      ),
                      // Debug avatar test button (only in debug mode)
                      if (kDebugMode) ...[
                        const SizedBox(height: 15),
                        _buildProfileOption(
                          Icons.bug_report,
                          'Avatar Debug Test',
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AvatarTestPage(),
                              ),
                            );
                          },
                        ),
                      ],
                      const SizedBox(height: 30),
                      _buildProfileOption(
                        Icons.logout,
                        AppTranslations.get('logout'),
                        () async {
                          final result = await AlertDialogUtils.showConfirmationAlert(
                            context: context,
                            title: AppTranslations.get('logout'),
                            message: AppTranslations.get('logoutConfirmation'),
                          );
                          if (result == true && mounted) {
                            await widget.authService.logout();
                            // Refresh the profile tab to show login form
                            setState(() {});
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.white.withValues(alpha: 0.8),
          size: 24,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.white.withValues(alpha: 0.6),
          size: 16,
        ),
        onTap: onTap,
      ),
    );
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
              
              // Show logout option only if user is authenticated
              if (widget.authService.isAuthenticated)
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: AppTheme.primary,
                    size: 24,
                  ),
                  title: Text(
                    AppTranslations.get('logout'),
                    style: AppTheme.bodyLarge,
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    final result = await AlertDialogUtils.showConfirmationAlert(
                      context: context,
                      title: AppTranslations.get('logout'),
                      message: AppTranslations.get('logoutConfirmation'),
                    );
                    if (result == true && mounted) {
                      await widget.authService.logout();
                      // Refresh the profile tab to show login form
                      setState(() {});
                    }
                  },
                ),
              
              // Show login option if user is not authenticated
              if (!widget.authService.isAuthenticated)
                ListTile(
                  leading: Icon(
                    Icons.login,
                    color: AppTheme.primary,
                    size: 24,
                  ),
                  title: Text(
                    AppTranslations.get('login'),
                    style: AppTheme.bodyLarge,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LoginPage(authService: widget.authService),
                      ),
                    ).then((loginSuccessful) {
                      // Refresh after returning from login only if successful
                      if (loginSuccessful == true) {
                        setState(() {});
                      }
                    });
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
      backgroundColor: AppTheme.surfaceLight,
      body: Column(
        children: [
          // Header with search and menu
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppTheme.surface,
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

          // Main content area - changes based on selected tab
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                _buildHomeContent(),
                _buildCartContent(),
                _buildFavoritesContent(),
                _buildProfileContent(),
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
          selectedItemColor: AppTheme.primary,
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

  @override
  void dispose() {
    widget.authService.removeListener(_handleAuthStateChanged);
    super.dispose();
  }
}