import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/user_avatar.dart';
import '../translations/app_translations.dart';

/// Example profile page demonstrating UserAvatar usage
/// Note: This is a simplified example. For a complete implementation,
/// consider adding the 'provider' package to pubspec.yaml dependencies
class UserProfilePage extends StatefulWidget {
  final AuthService? authService;

  const UserProfilePage({
    super.key,
    this.authService,
  });

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = widget.authService ?? AuthService();
    // Listen to auth changes and rebuild UI
    _authService.addListener(_onAuthChanged);
  }

  @override
  void dispose() {
    _authService.removeListener(_onAuthChanged);
    super.dispose();
  }

  void _onAuthChanged() {
    if (mounted) {
      setState(() {}); // Rebuild UI when auth state changes
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppTranslations.get('profile')),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: UserAvatar.medium(
              user: _authService.currentUser,
              onTap: () {
                // Handle avatar tap in app bar
                _showAvatarOptions(context);
              },
            ),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          final user = _authService.currentUser;
          
          if (user == null) {
            return const Center(
              child: Text('Not logged in'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Large avatar with edit capability
                EditableUserAvatar(
                  user: user,
                  radius: 60,
                  onEdit: () => _editAvatar(context),
                ),
                
                const SizedBox(height: 24),
                
                // User info card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Small avatar in list item
                            UserAvatar.small(user: user),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.fullName,
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Text(
                                    user.email,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        if (user.avatarUrl != null) ...[
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 8),
                          Text(
                            'Avatar URL:',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.avatarUrl!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Different avatar sizes demo
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Avatar Sizes',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                UserAvatar.small(user: user),
                                const SizedBox(height: 4),
                                const Text('Small'),
                              ],
                            ),
                            Column(
                              children: [
                                UserAvatar.medium(user: user),
                                const SizedBox(height: 4),
                                const Text('Medium'),
                              ],
                            ),
                            Column(
                              children: [
                                UserAvatar.large(user: user),
                                const SizedBox(height: 4),
                                const Text('Large'),
                              ],
                            ),
                            Column(
                              children: [
                                UserAvatar.extraLarge(user: user),
                                const SizedBox(height: 4),
                                const Text('Extra Large'),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _editAvatar(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Avatar'),
        content: const Text('Avatar editing functionality would be implemented here. This could include:\\n\\n• Photo picker from gallery\\n• Camera capture\\n• Avatar editor\\n• Remove current avatar'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAvatarOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('View Profile'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to full profile
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Avatar'),
              onTap: () {
                Navigator.pop(context);
                _editAvatar(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: () {
                Navigator.pop(context);
                _authService.logout();
              },
            ),
          ],
        ),
      ),
    );
  }}