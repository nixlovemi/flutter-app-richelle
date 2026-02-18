# 🎨 Moda Richelle - Theme System Documentation

## Overview
The app uses a centralized theme system located in `lib/theme/app_theme.dart`. This file contains all colors, fonts, button styles, and design elements that can be easily modified to customize the entire app's appearance.

## 🎨 Color Palette

### Primary Colors
- **Primary Pink**: `Color(0xFFE91E63)` - Main brand color
- **Light Pink**: `Color(0xFFFFE0E6)` - Background tints  
- **Dark Pink**: `Color(0xFFAD1457)` - Darker accents
- **Accent Rose**: `Color(0xFFF8BBD9)` - Secondary elements
- **Soft Pink**: `Color(0xFFFCE4EC)` - Subtle backgrounds

### Neutral Colors  
- **White**: `Color(0xFFFFFFFF)` - Cards, backgrounds
- **Black**: `Color(0xFF212121)` - Primary text
- **Dark Grey**: `Color(0xFF424242)` - Secondary text
- **Light Grey**: `Color(0xFFE0E0E0)` - Borders, dividers
- **Medium Grey**: `Color(0xFF9E9E9E)` - Placeholder text

## 📝 Typography

### Font Family
- **Primary Font**: `'Roboto'` (can be changed to any Google Font)

### Text Styles
- **Heading Large**: 32px, Bold - For main titles
- **Heading Medium**: 24px, Semi-bold - For section headers  
- **Heading Small**: 20px, Semi-bold - For card titles
- **Body Large**: 16px, Regular - For main content
- **Body Medium**: 14px, Regular - For descriptions
- **Button Text**: 16px, Semi-bold - For buttons
- **Label Text**: 14px, Medium - For form labels

## 🎯 Quick Customization Guide

### To Change the Main Brand Color:
1. Open `lib/theme/app_theme.dart`
2. Modify the `primaryPink` color value
3. Optionally update related colors (`darkPink`, `lightPink`, etc.)

```dart
static const Color primaryPink = Color(0xFF7B68EE); // Example: Purple theme
```

### To Change the Font:
1. Add your font to `pubspec.yaml` under fonts section
2. Update the `fontFamily` constant in `app_theme.dart`

```dart
static const String fontFamily = 'YourCustomFont';
```

### to Change Button Styles:
1. Modify the button styles in `app_theme.dart`:
   - `primaryButtonStyle` - Main action buttons
   - `secondaryButtonStyle` - Secondary buttons  
   - `socialButtonStyle` - Social media buttons

### To Update Input Field Styles:
1. Modify the `inputDecoration` function parameters
2. Adjust border radius, colors, padding as needed

## 🚀 Files Structure

```
lib/
├── theme/
│   └── app_theme.dart     # 🎨 Main theme configuration
├── main.dart              # Uses AppTheme.themeData
└── login_page.dart        # Uses theme colors & styles
```

## 💡 Pro Tips

1. **Consistent Spacing**: Use multiples of 8 (8, 16, 24, 32, 40) for consistent spacing
2. **Color Variations**: Use `.withOpacity()` to create lighter versions of existing colors
3. **Theme Testing**: Change one color and see how it affects the entire app instantly
4. **Dark Mode**: Extend the theme system by creating `AppTheme.darkThemeData` later

## 🎭 Current Design Features

✅ **Pink gradient backgrounds** inspired by fashion apps  
✅ **Rounded corners** (20px) for modern look  
✅ **Soft shadows** for depth and elegance  
✅ **Circular social buttons** with proper spacing  
✅ **Custom input fields** with pink focus states  
✅ **Typography hierarchy** for visual clarity

---

**Need to customize?** Just edit `lib/theme/app_theme.dart` and the changes will apply to the entire app! 🎨