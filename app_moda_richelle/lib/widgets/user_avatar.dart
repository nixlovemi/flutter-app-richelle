import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';

/// A reusable widget for displaying user avatars with fallbacks
class UserAvatar extends StatelessWidget {
  final User? user;
  final double radius;
  final String? overrideUrl;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const UserAvatar({
    super.key,
    this.user,
    this.radius = 20,
    this.overrideUrl,
    this.onTap,
    this.backgroundColor,
    this.foregroundColor,
  });

  /// Factory constructor for small avatars (like in lists)
  const UserAvatar.small({
    super.key,
    required this.user,
    this.overrideUrl,
    this.onTap,
    this.backgroundColor,
    this.foregroundColor,
  }) : radius = 16;

  /// Factory constructor for medium avatars (like in app bars)
  const UserAvatar.medium({
    super.key,
    required this.user,
    this.overrideUrl,
    this.onTap,
    this.backgroundColor,
    this.foregroundColor,
  }) : radius = 20;

  /// Factory constructor for large avatars (like in profile pages)
  const UserAvatar.large({
    super.key,
    required this.user,
    this.overrideUrl,
    this.onTap,
    this.backgroundColor,
    this.foregroundColor,
  }) : radius = 40;

  /// Factory constructor for extra large avatars
  const UserAvatar.extraLarge({
    super.key,
    required this.user,
    this.overrideUrl,
    this.onTap,
    this.backgroundColor,
    this.foregroundColor,
  }) : radius = 60;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final avatarUrl = overrideUrl ?? user?.avatarUrl;
    
    // Debug: Print avatar information
    if (kDebugMode) {
      debugPrint('🖼️ UserAvatar: avatarUrl = $avatarUrl');
      debugPrint('🖼️ UserAvatar: user?.fullName = ${user?.fullName}');
      debugPrint('🖼️ UserAvatar: radius = $radius');
    }
    
    Widget avatarChild;

    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      // Show network image with error fallback
      avatarChild = CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ?? theme.colorScheme.primary.withOpacity(0.1),
        foregroundImage: NetworkImage(avatarUrl),
        onForegroundImageError: (exception, stackTrace) {
          // This will fall back to the child (initials) if image fails to load
        },
        child: _buildInitials(context),
      );
    } else {
      // Show initials fallback
      avatarChild = CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ?? theme.colorScheme.primary.withOpacity(0.1),
        child: _buildInitials(context),
      );
    }

    // Wrap in GestureDetector if onTap is provided
    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: avatarChild,
      );
    }

    return avatarChild;
  }

  /// Build initials text widget
  Widget _buildInitials(BuildContext context) {
    final theme = Theme.of(context);
    final userName = user?.fullName ?? 'User';
    
    // Get first letter of first name and last name
    final names = userName.trim().split(' ');
    String initials = '';
    
    if (names.isNotEmpty) {
      initials += names.first.isNotEmpty ? names.first[0].toUpperCase() : '';
      if (names.length > 1 && names.last.isNotEmpty) {
        initials += names.last[0].toUpperCase();
      }
    }
    
    // Fallback if no initials could be derived
    if (initials.isEmpty) {
      initials = 'U'; // Default to 'U' for User
    }

    return Text(
      initials,
      style: TextStyle(
        color: foregroundColor ?? theme.colorScheme.primary,
        fontSize: radius * 0.6, // Scale font size with avatar size
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

/// A specialized widget for avatar with edit capability
class EditableUserAvatar extends StatelessWidget {
  final User? user;
  final double radius;
  final VoidCallback? onEdit;
  final String? overrideUrl;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const EditableUserAvatar({
    super.key,
    this.user,
    this.radius = 40,
    this.onEdit,
    this.overrideUrl,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        UserAvatar(
          user: user,
          radius: radius,
          overrideUrl: overrideUrl,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
        ),
        if (onEdit != null)
          Positioned(
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: onEdit,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surface,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.edit,
                  size: radius * 0.4,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}