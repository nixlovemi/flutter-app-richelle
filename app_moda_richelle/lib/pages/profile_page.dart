import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../translations/app_translations.dart';
import '../login_page.dart';
import '../services/auth_service.dart';
import '../utils/alert_dialog_utils.dart';
import 'settings_page.dart';

class ProfilePage extends StatefulWidget {
  final AuthService authService;
  
  const ProfilePage({super.key, required this.authService});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

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
                      AppTranslations.get('profile'),
                      style: AppTheme.headingMedium.copyWith(
                        color: AppTheme.deepRose,
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
                            color: AppTheme.primaryPink,
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
    return Container(
      width: double.infinity,
      decoration: AppTheme.loginBodyGradientDecoration,
      child: Column(
        children: [
          const SizedBox(height: 40),
          // Profile avatar
          CircleAvatar(
            radius: 50,
            backgroundColor: AppTheme.white.withValues(alpha: 0.2),
            child: Icon(
              Icons.person,
              size: 60,
              color: Colors.white.withValues(alpha: 0.8),
            ),
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Help & Support coming soon!'),
                          backgroundColor: AppTheme.primaryPink,
                        ),
                      );
                    },
                  ),
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
                  foregroundColor: AppTheme.primaryPink,
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
}