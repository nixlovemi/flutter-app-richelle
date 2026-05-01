import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../translations/app_translations.dart';
import '../login_page.dart';
import '../services/auth_service.dart';
import '../services/error_message_service.dart';
import '../utils/alert_dialog_utils.dart';
import '../utils/snackbar_utils.dart';
import '../widgets/user_avatar.dart';
import '../examples/avatar_test_page.dart';
import 'settings_page.dart';
import 'registration_page.dart';

class ProfilePage extends StatefulWidget {
  final AuthService authService;
  
  const ProfilePage({super.key, required this.authService});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  void initState() {
    super.initState();
    widget.authService.addListener(_handleAuthStateChanged);
  }

  @override
  void didUpdateWidget(covariant ProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.authService != widget.authService) {
      oldWidget.authService.removeListener(_handleAuthStateChanged);
      widget.authService.addListener(_handleAuthStateChanged);
    }
  }

  void _handleAuthStateChanged() {
    if (!mounted) return;

    // If user logs out or account is deleted, leave this page immediately.
    if (!widget.authService.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final navigator = Navigator.of(context);
        if (navigator.canPop()) {
          navigator.pop();
        } else {
          setState(() {});
        }
      });
      return;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceLight,
      body: Column(
        children: [
          // Simple header
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
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back,
                        color: AppTheme.black,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      AppTranslations.get('profile'),
                      style: AppTheme.headingMedium.copyWith(
                        color: AppTheme.primary,
                      ),
                    ),
                    const Spacer(),
                    // Show logout button only if authenticated
                    if (widget.authService.isAuthenticated)
                      Container(
                        decoration: AppTheme.socialButtonDecoration,
                        child: IconButton(
                          onPressed: () async {
                            final result = await AlertDialogUtils.showConfirmationAlert(
                              context: context,
                              title: AppTranslations.get('logout'),
                              message: AppTranslations.get('logoutConfirmation'),
                            );
                            if (result == true && mounted) {
                              await widget.authService.logout();
                              // Refresh the page to show login state
                              setState(() {});
                            }
                          },
                          icon: Icon(
                            Icons.logout,
                            color: AppTheme.primary,
                            size: 20,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Main content - changes based on authentication status
          Expanded(
            child: widget.authService.isAuthenticated 
                ? _buildAuthenticatedContent()
                : _buildLoginPrompt(),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthenticatedContent() {
    final user = widget.authService.currentUser;
    
    // Debug: Print avatar information
    if (kDebugMode) {
      debugPrint('🖼️ ProfilePage: User avatar URL: ${user?.avatarUrl}');
      debugPrint('🖼️ ProfilePage: User full name: ${user?.fullName}');
    }
    
    return Container(
      width: double.infinity,
      decoration: AppTheme.loginBodyGradientDecoration,
      child: Column(
        children: [
          const SizedBox(height: 40),
          // Profile avatar with Google image support
          UserAvatar.extraLarge(
            user: user,
            backgroundColor: AppTheme.white.withValues(alpha: 0.2),
            foregroundColor: Colors.white.withValues(alpha: 0.8),
          ),
          const SizedBox(height: 20),
          // User info
          if (user != null) ...[
            Text(
              '${user.firstName} ${user.lastName}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              user.email,
              style: TextStyle(
                color: Colors.grey.withValues(alpha: 0.6),
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
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
                      // TODO: Create ProfileEditPage
                      SnackBarUtils.showInfo(
                        context,
                        ErrorMessageService.getComingSoonMessage('profile edit'),
                      );
                      /*
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileEditPage(authService: widget.authService),
                        ),
                      ).then((result) {
                        // Refresh the profile page if profile was updated
                        if (result == true) {
                          setState(() {});
                        }
                      });
                      */
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
                    () {
                      SnackBarUtils.showInfo(
                        context,
                        ErrorMessageService.getComingSoonMessage('help support'),
                      );
                    },
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginPrompt() {
    return Container(
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
              AppTranslations.get('loginToAccess'),
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(authService: widget.authService),
                    ),
                  ).then((loginSuccessful) {
                    // Refresh if login was successful
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
            const SizedBox(height: 20),
            // Create Account Button/Link
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegistrationPage(authService: widget.authService),
                    ),
                  ).then((registrationCompleted) {
                    // Refresh if registration flow completed (even if user still needs to verify email)
                    if (registrationCompleted == true) {
                      setState(() {});
                    }
                  });
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  AppTranslations.get('createAccount'),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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

  @override
  void dispose() {
    widget.authService.removeListener(_handleAuthStateChanged);
    super.dispose();
  }
}