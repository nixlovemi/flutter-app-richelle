import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../translations/app_translations.dart';
import '../services/auth_service.dart';

/// Real implementation: Settings page with AppBar for the app
class SettingsPage extends StatefulWidget {
  final AuthService authService;
  
  const SettingsPage({super.key, required this.authService});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Standard AppBar with back button and title
      appBar: AppBar(
        title: Text(AppTranslations.get('settings')),
        backgroundColor: AppTheme.surface,
        foregroundColor: AppTheme.primary,
        elevation: 2,
        shadowColor: AppTheme.black.withValues(alpha: 0.1),
        // The back button appears automatically!
      ),
      backgroundColor: AppTheme.surfaceLight,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Account Section
          _buildSectionHeader(AppTranslations.get('account')),
          _buildSettingsTile(
            icon: Icons.person_outline,
            title: AppTranslations.get('editProfile'),
            subtitle: AppTranslations.get('updatePersonalInfo'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileEditPage(authService: widget.authService),
                ),
              );
            },
          ),
          _buildSettingsTile(
            icon: Icons.security,
            title: AppTranslations.get('changePassword'),
            subtitle: AppTranslations.get('updateAccountPassword'),
            onTap: () {
              // Navigate to change password page
            },
          ),
          
          const SizedBox(height: 20),
          
          // Preferences Section
          _buildSectionHeader(AppTranslations.get('preferences')),
          _buildSwitchTile(
            icon: Icons.notifications_outlined,
            title: AppTranslations.get('notifications'),
            subtitle: AppTranslations.get('receivePushNotifications'),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          _buildSwitchTile(
            icon: Icons.dark_mode_outlined,
            title: AppTranslations.get('darkMode'),
            subtitle: AppTranslations.get('switchToDarkTheme'),
            value: _darkModeEnabled,
            onChanged: (value) {
              setState(() {
                _darkModeEnabled = value;
              });
            },
          ),
          _buildSettingsTile(
            icon: Icons.language,
            title: AppTranslations.get('language'),
            subtitle: _selectedLanguage,
            onTap: () {
              _showLanguageDialog();
            },
          ),
          
          const SizedBox(height: 20),
          
          // About Section
          _buildSectionHeader(AppTranslations.get('about')),
          _buildSettingsTile(
            icon: Icons.help_outline,
            title: AppTranslations.get('helpSupport'),
            subtitle: AppTranslations.get('getHelpAndSupport'),
            onTap: () {
              // Navigate to help page
            },
          ),
          _buildSettingsTile(
            icon: Icons.info_outline,
            title: AppTranslations.get('aboutApp'),
            subtitle: AppTranslations.get('version100'),
            onTap: () {
              _showAboutDialog();
            },
          ),
          _buildSettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: AppTranslations.get('privacyPolicy'),
            subtitle: AppTranslations.get('readPrivacyPolicy'),
            onTap: () {
              // Navigate to privacy policy
            },
          ),
          
          const SizedBox(height: 30),
          
          // Logout button (only if authenticated)
          if (widget.authService.isAuthenticated)
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final shouldLogout = await _showLogoutDialog();
                  if (shouldLogout == true) {
                    await widget.authService.logout();
                    if (mounted) {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade400,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout),
                    const SizedBox(width: 8),
                    Text(AppTranslations.get('logout')),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
      child: Text(
        title,
        style: AppTheme.headingMedium.copyWith(
          color: AppTheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppTheme.primary,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          subtitle,
          style: AppTheme.bodyMedium.copyWith(
            color: AppTheme.mediumGrey,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: AppTheme.mediumGrey,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppTheme.primary,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          subtitle,
          style: AppTheme.bodyMedium.copyWith(
            color: AppTheme.mediumGrey,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.primary,
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppTranslations.get('selectLanguage')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text(AppTranslations.get('english')),
              value: 'English',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text(AppTranslations.get('portuguese')),
              value: 'Português',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: AppTranslations.get('appName'),
      applicationVersion: '1.0.0',
      applicationIcon: Icon(
        Icons.shopping_bag,
        color: AppTheme.primary,
        size: 48,
      ),
      children: [
        Text(AppTranslations.get('appDescription')),
        SizedBox(height: 16),
        Text(AppTranslations.get('copyright')),
      ],
    );
  }

  Future<bool?> _showLogoutDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppTranslations.get('logout')),
        content: Text(AppTranslations.get('logoutConfirmation')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppTranslations.get('cancel')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
            ),
            child: Text(AppTranslations.get('logout')),
          ),
        ],
      ),
    );
  }
}

/// Profile Edit Page with AppBar
class ProfileEditPage extends StatefulWidget {
  final AuthService authService;
  
  const ProfileEditPage({super.key, required this.authService});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    if (widget.authService.currentUser != null) {
      final user = widget.authService.currentUser!;
      _firstNameController.text = user.firstName;
      _lastNameController.text = user.lastName;
      _emailController.text = user.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppTranslations.get('editProfile')),
        backgroundColor: AppTheme.surface,
        foregroundColor: AppTheme.primary,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: Text(
              AppTranslations.get('save'),
              style: TextStyle(
                color: _isLoading ? AppTheme.mediumGrey : AppTheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: AppTheme.surfaceLight,
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Profile Photo Section
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: AppTheme.white,
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: AppTheme.primary.withValues(alpha: 0.2),
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: IconButton(
                        onPressed: _changeProfilePhoto,
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 40,
                          minHeight: 40,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Form Fields
            TextFormField(
              controller: _firstNameController,
              decoration: AppTheme.inputDecoration(
                hintText: AppTranslations.get('firstName'),
                prefixIcon: const Icon(Icons.person_outline),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppTranslations.get('pleaseEnterFirstName');
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _lastNameController,
              decoration: AppTheme.inputDecoration(
                hintText: AppTranslations.get('lastName'),
                prefixIcon: const Icon(Icons.person_outline),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppTranslations.get('pleaseEnterLastName');
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _emailController,
              enabled: false, // Make email field disabled/read-only
              decoration: AppTheme.inputDecoration(
                hintText: AppTranslations.get('email'),
                prefixIcon: const Icon(Icons.email_outlined),
              ).copyWith(
                fillColor: Colors.grey.withValues(alpha: 0.1), // Gray background for disabled field
                filled: true,
              ),
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: Colors.grey.shade600, // Gray text color for disabled field
                fontStyle: FontStyle.italic,
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Additional Options
            _buildProfileOption(
              Icons.lock_outline,
              AppTranslations.get('changePassword'),
              AppTranslations.get('updateAccountPassword'),
              () {
                // Navigate to change password page
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppTranslations.get('changePasswordComingSoon'))),
                );
              },
            ),
            
            const SizedBox(height: 12),
            
            _buildProfileOption(
              Icons.delete_outline,
              AppTranslations.get('deleteAccount'),
              AppTranslations.get('permanentlyDeleteAccount'),
              () {
                _showDeleteAccountDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primary),
        title: Text(title, style: AppTheme.bodyLarge),
        subtitle: Text(subtitle, style: AppTheme.bodyMedium),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.mediumGrey),
        onTap: onTap,
      ),
    );
  }

  void _changeProfilePhoto() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_camera, color: AppTheme.primary),
              title: Text(AppTranslations.get('takePhoto')),
              onTap: () {
                Navigator.pop(context);
                // Implement camera functionality
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: AppTheme.primary),
              title: Text(AppTranslations.get('chooseFromGallery')),
              onTap: () {
                Navigator.pop(context);
                // Implement gallery functionality
              },
            ),
          ],
        ),
      ),
    );
  }

  void _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await widget.authService.updateProfile(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
      );
      
      if (mounted) {
        if (response.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppTranslations.get('profileUpdatedSuccessfully')),
              backgroundColor: AppTheme.primary,
            ),
          );
          Navigator.pop(context, true); // Return true to indicate success
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.error?.message ?? AppTranslations.get('failedToUpdateProfile')),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppTranslations.get('errorUpdatingProfile')} $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppTranslations.get('deleteAccount')),
        content: Text(AppTranslations.get('deleteAccountConfirmation')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppTranslations.get('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement account deletion
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(AppTranslations.get('delete')),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}