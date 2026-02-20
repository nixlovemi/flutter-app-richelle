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
        backgroundColor: AppTheme.lightRose,
        foregroundColor: AppTheme.deepRose,
        elevation: 2,
        shadowColor: AppTheme.black.withValues(alpha: 0.1),
        // The back button appears automatically!
      ),
      backgroundColor: AppTheme.lightPink,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Account Section
          _buildSectionHeader('Account'),
          _buildSettingsTile(
            icon: Icons.person_outline,
            title: AppTranslations.get('editProfile'),
            subtitle: 'Update your personal information',
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
            title: 'Change Password',
            subtitle: 'Update your account password',
            onTap: () {
              // Navigate to change password page
            },
          ),
          
          const SizedBox(height: 20),
          
          // Preferences Section
          _buildSectionHeader('Preferences'),
          _buildSwitchTile(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Receive push notifications',
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          _buildSwitchTile(
            icon: Icons.dark_mode_outlined,
            title: 'Dark Mode',
            subtitle: 'Switch to dark theme',
            value: _darkModeEnabled,
            onChanged: (value) {
              setState(() {
                _darkModeEnabled = value;
              });
            },
          ),
          _buildSettingsTile(
            icon: Icons.language,
            title: 'Language',
            subtitle: _selectedLanguage,
            onTap: () {
              _showLanguageDialog();
            },
          ),
          
          const SizedBox(height: 20),
          
          // About Section
          _buildSectionHeader('About'),
          _buildSettingsTile(
            icon: Icons.help_outline,
            title: AppTranslations.get('helpSupport'),
            subtitle: 'Get help and contact support',
            onTap: () {
              // Navigate to help page
            },
          ),
          _buildSettingsTile(
            icon: Icons.info_outline,
            title: 'About App',
            subtitle: 'Version 1.0.0',
            onTap: () {
              _showAboutDialog();
            },
          ),
          _buildSettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            subtitle: 'Read our privacy policy',
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
          color: AppTheme.deepRose,
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
            color: AppTheme.primaryPink.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryPink,
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
            color: AppTheme.primaryPink.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryPink,
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
          activeColor: AppTheme.primaryPink,
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text('English'),
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
              title: Text('Português'),
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
      applicationName: 'Moda Richelle',
      applicationVersion: '1.0.0',
      applicationIcon: Icon(
        Icons.shopping_bag,
        color: AppTheme.primaryPink,
        size: 48,
      ),
      children: [
        Text('A modern fashion shopping app built with Flutter.'),
        SizedBox(height: 16),
        Text('© 2026 Moda Richelle. All rights reserved.'),
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
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
            ),
            child: Text('Logout'),
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
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    if (widget.authService.currentUser != null) {
      final user = widget.authService.currentUser!;
      _nameController.text = '${user.firstName} ${user.lastName}';
      _emailController.text = user.email;
      // Phone would come from user data if available
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppTranslations.get('editProfile')),
        backgroundColor: AppTheme.lightRose,
        foregroundColor: AppTheme.deepRose,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: Text(
              'Save',
              style: TextStyle(
                color: _isLoading ? AppTheme.mediumGrey : AppTheme.deepRose,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: AppTheme.lightPink,
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
                      backgroundColor: AppTheme.primaryPink.withValues(alpha: 0.2),
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: AppTheme.primaryPink,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.primaryPink,
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
              controller: _nameController,
              decoration: AppTheme.inputDecoration(
                hintText: 'Full Name',
                prefixIcon: const Icon(Icons.person_outline),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _emailController,
              decoration: AppTheme.inputDecoration(
                hintText: 'Email',
                prefixIcon: const Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _phoneController,
              decoration: AppTheme.inputDecoration(
                hintText: 'Phone Number',
                prefixIcon: const Icon(Icons.phone_outlined),
              ),
              keyboardType: TextInputType.phone,
            ),
            
            const SizedBox(height: 30),
            
            // Additional Options
            _buildProfileOption(
              Icons.lock_outline,
              'Change Password',
              'Update your account password',
              () {
                // Navigate to change password page
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Change password coming soon!')),
                );
              },
            ),
            
            const SizedBox(height: 12),
            
            _buildProfileOption(
              Icons.delete_outline,
              'Delete Account',
              'Permanently delete your account',
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
        leading: Icon(icon, color: AppTheme.primaryPink),
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
              leading: Icon(Icons.photo_camera, color: AppTheme.primaryPink),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                // Implement camera functionality
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: AppTheme.primaryPink),
              title: const Text('Choose from Gallery'),
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

    // Simulate save operation
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
      
      Navigator.pop(context);
    }
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure you want to permanently delete your account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement account deletion
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}