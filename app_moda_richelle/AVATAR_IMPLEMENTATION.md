# User Avatar Implementation Guide

## Overview

This implementation provides a comprehensive solution for handling user avatars in the Flutter app, including:

- **Avatar storage and retrieval** from the API
- **Secure local storage** of avatar URLs  
- **Reusable avatar widgets** with fallbacks
- **Multiple avatar sizes** and styles
- **Error handling** for failed image loads

## Changes Made

### 1. Updated User Model (`lib/models/user.dart`)
```dart
@JsonKey(name: 'avatar_url')
final String? avatarUrl;
```
- Added `avatarUrl` field to store the user's avatar URL from Google/API
- Field is optional (nullable) since not all users may have avatars

### 2. Enhanced TokenStorageService (`lib/services/token_storage_service.dart`)
```dart
// New storage key
static const String _userAvatarUrlKey = 'user_avatar_url';

// Updated saveAuthData method
static Future<void> saveAuthData({
  required String token,
  required int userId,
  required String email,
  required String firstName,
  required String lastName,
  String? avatarUrl, // ✅ New parameter
}) async
```
- Added secure storage for avatar URLs
- Handles both saving and clearing avatar URLs
- Backward compatible with existing stored data

### 3. Updated AuthService (`lib/services/auth_service.dart`)
```dart
// Save avatar URL during login
await TokenStorageService.saveAuthData(
  // ... other fields
  avatarUrl: loginData.user.avatarUrl, // ✅ Now included
);

// Reconstruct user with avatar URL
final user = User(
  // ... other fields
  avatarUrl: userData['avatar_url'], // ✅ From stored data
);
```
- Both regular login and Google login now store avatar URLs
- User reconstruction includes avatar URL from storage

### 4. Created UserAvatar Widget (`lib/widgets/user_avatar.dart`)

#### Features:
- **Multiple sizes**: `.small()`, `.medium()`, `.large()`, `.extraLarge()`
- **Fallback handling**: Shows initials if image fails to load
- **Network image support**: Loads avatars from URLs with error handling
- **Customizable**: Colors, sizes, and tap handlers
- **Editable variant**: `EditableUserAvatar` with edit button overlay

#### Usage Examples:
```dart
// Basic avatar
UserAvatar(user: currentUser)

// Specific sizes
UserAvatar.small(user: user)
UserAvatar.medium(user: user) 
UserAvatar.large(user: user)
UserAvatar.extraLarge(user: user)

// With tap handler
UserAvatar.medium(
  user: user,
  onTap: () => showUserOptions(),
)

// Editable avatar
EditableUserAvatar(
  user: user,
  radius: 60,
  onEdit: () => editAvatar(),
)
```

### 5. Example Profile Page (`lib/examples/user_profile_example.dart`)
Demonstrates:
- Avatar usage in app bars with tap functionality
- Large editable avatar in profile
- Different avatar sizes showcase
- Avatar options modal sheet
- Profile information display with avatar URL

## API Integration

### Expected API Response Format
```json
{
  "user": {
    "id": 1,
    "first_name": "John",
    "last_name": "Doe", 
    "email": "john@example.com",
    "avatar_url": "https://lh3.googleusercontent.com/a/ACg8ocKhB6avVbXVeoFt3QWtr-hDIA5mFEoeJCTUGWZNrX0oJ7Cpyb9zhw=s96-c",
    "created_at": "2026-01-01T00:00:00.000000Z",
    "updated_at": "2026-01-01T00:00:00.000000Z"
  },
  "token": "1|abc123...",
  "token_type": "Bearer"
}
```

### Google Sign-In Integration
The `avatar_url` is automatically populated from Google's response when users log in with Google. Your Laravel API should:

1. **Extract avatar from Google user data**
2. **Store it in the users table** 
3. **Return it in login responses**
4. **Allow updates** through profile endpoints

## Security Best Practices

### Avatar URL Validation
Consider adding server-side validation:

```php
// Laravel validation example
'avatar_url' => 'nullable|url|max:2048',
```

### Image Proxy (Optional)
For enhanced security and performance:
- **Proxy avatar images** through your domain
- **Cache images** to reduce external requests
- **Validate image types** and sizes
- **Generate thumbnails** for different sizes

## UI/UX Best Practices

### Avatar Fallback Strategy
1. **Primary**: Network image from `avatar_url`
2. **Secondary**: User initials with colored background
3. **Tertiary**: Generic user icon (if no name available)

### Loading States
```dart
// Add loading state to avatar widget if needed
UserAvatar(
  user: user,
  isLoading: authService.isLoading,
)
```

### Accessibility
The `UserAvatar` widget includes:
- **Semantic labels** for screen readers
- **Appropriate contrast** ratios
- **Touch target sizes** meeting minimum requirements

## Performance Optimization

### Image Caching
Flutter's `NetworkImage` automatically caches images. For enhanced caching:

```dart
// Custom cached network image (optional)
CachedNetworkImage(
  imageUrl: avatarUrl,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => UserAvatar.initials(user),
)
```

### Memory Management
- Avatar images are **automatically disposed** when widgets are removed
- **Small avatar sizes** (96x96) minimize memory usage
- Consider **lazy loading** for large user lists

## Testing Considerations

### Unit Tests
```dart
testWidgets('UserAvatar shows initials when no avatar URL', (tester) async {
  final user = User(/* no avatarUrl */);
  await tester.pumpWidget(UserAvatar(user: user));
  expect(find.text('JD'), findsOneWidget); // John Doe initials
});
```

### Integration Tests
- Test avatar loading from network
- Test fallback to initials
- Test error handling scenarios
- Test different screen sizes and densities

## Troubleshooting

### Common Issues

1. **Avatar not showing after login**
   - Check API response includes `avatar_url` field
   - Verify TokenStorageService is saving the URL
   - Check User model serialization with `dart run build_runner build`

2. **Images not loading**
   - Verify URL accessibility (HTTPS, CORS)
   - Check network permissions in `AndroidManifest.xml`
   - Test with a known working image URL

3. **Storage issues**
   - Clear app data and test fresh login
   - Check secure storage permissions
   - Verify TokenStorageService error logs

### Debug Commands
```bash
# Regenerate model serialization
dart run build_runner build

# Clear build cache
flutter clean
flutter pub get

# Test avatar URLs manually
curl -I "https://lh3.googleusercontent.com/..."
```

## Future Enhancements

### Planned Features
- **Avatar upload** from camera/gallery
- **Avatar cropping** and editing
- **Multiple avatar sizes** server-side
- **Avatar change history**
- **Default avatar themes** 

### API Endpoints (Future)
```
POST /user/avatar/upload    # Upload new avatar
DELETE /user/avatar         # Remove avatar
GET /user/avatar/sizes      # Get different sizes
```

This implementation provides a solid foundation for user avatars that can be extended as your app grows!