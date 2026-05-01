/// Examples of how to use AppBar in different scenarios
/// This file shows various AppBar implementations for the TimelessApp

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../translations/app_translations.dart';
import '../utils/snackbar_utils.dart';

// Example 1: Login Page with AppBar (Alternative to current custom header)
class LoginPageWithAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar automatically shows back button if navigation stack exists
      appBar: AppBar(
        title: Text(AppTranslations.get('login')),
        backgroundColor: AppTheme.secondary,
        foregroundColor: AppTheme.primary,
        elevation: 0,
        // Custom back button (optional - AppBar has automatic one)
        leading: Navigator.canPop(context) ? IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
          tooltip: AppTranslations.get('goBack'),
        ) : null,
        // Curved bottom (requires custom shape)
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(50),
          ),
        ),
      ),
      body: Container(
        decoration: AppTheme.loginBodyGradientDecoration,
        child: Center(
          child: Text('Login form content here...'),
        ),
      ),
    );
  }
}

// Example 2: Settings Page with AppBar
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppTranslations.get('settings')),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        // Add action buttons on the right
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              // Save settings
              SnackBarUtils.showSuccess(
                context,
                AppTranslations.get('settingsSaved'),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ListTile(
            leading: Icon(Icons.notifications, color: AppTheme.primary),
            title: Text('Notifications'),
            subtitle: Text('Manage your notification preferences'),
            trailing: Switch(value: true, onChanged: (val) {}),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.language, color: AppTheme.primary),
            title: Text('Language'),
            subtitle: Text('Change app language'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to language selection
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.palette, color: AppTheme.primary),
            title: Text('Theme'),
            subtitle: Text('Dark mode, colors'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to theme settings
            },
          ),
        ],
      ),
    );
  }
}

// Example 3: Profile Edit Page with AppBar
class ProfileEditPage extends StatefulWidget {
  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppTranslations.get('editProfile')),
        backgroundColor: AppTheme.secondary,
        foregroundColor: AppTheme.primary,
        // Multiple action buttons
        actions: [
          TextButton(
            onPressed: () {
              // Save profile changes
              Navigator.pop(context);
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: AppTheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile photo
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppTheme.surfaceLight,
                  child: Icon(Icons.person, size: 50, color: AppTheme.primary),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: AppTheme.primary,
                    child: Icon(Icons.edit, size: 15, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          // Form fields
          TextField(
            controller: _nameController,
            decoration: AppTheme.inputDecoration(
              hintText: 'Full Name',
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _emailController,
            decoration: AppTheme.inputDecoration(
              hintText: 'Email',
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            decoration: AppTheme.inputDecoration(
              hintText: 'Phone',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
          ),
        ],
        ),
      ),
    );
  }
}

// Example 4: Product Details Page with Custom AppBar
class ProductDetailsPage extends StatelessWidget {
  final String productName;
  
  ProductDetailsPage({required this.productName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productName),
        backgroundColor: Colors.transparent,
        foregroundColor: AppTheme.primary,
        elevation: 0,
        // Custom actions for product page
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () {
              // Add to favorites
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // Share product
            },
          ),
        ],
      ),
      // Extended height AppBar with image
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            backgroundColor: AppTheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(productName),
              background: Container(
                decoration: AppTheme.loginBodyGradientDecoration,
                child: Icon(
                  Icons.shopping_bag,
                  size: 100,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  // Add to cart
                },
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Product Description',
                      style: AppTheme.headingMedium,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'This is a detailed description of the product...',
                      style: AppTheme.bodyMedium,
                    ),
                    SizedBox(height: 20),
                    Text(
                      '\$99.99',
                      style: AppTheme.headingLarge.copyWith(
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

// Example 5: How to navigate with AppBars
class NavigationExamples {
  
  // Navigate to a page with AppBar
  static void navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsPage()),
    );
    // AppBar automatically shows back button!
  }
  
  // Navigate to profile edit
  static void navigateToProfileEdit(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileEditPage()),
    );
  }
  
  // Navigate to product details
  static void navigateToProduct(BuildContext context, String productName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsPage(productName: productName),
      ),
    );
  }
}

// Example 6: Custom AppBar themes for different sections
class CustomAppBarThemes {
  
  // Shopping section AppBar
  static AppBar shoppingAppBar(String title) {
    return AppBar(
      title: Text(title),
      backgroundColor: AppTheme.primary,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: () {},
        ),
      ],
    );
  }
  
  // Profile section AppBar
  static AppBar profileAppBar(String title) {
    return AppBar(
      title: Text(title),
      backgroundColor: AppTheme.secondary,
      foregroundColor: AppTheme.primary,
      elevation: 0,
    );
  }
  
  // Settings section AppBar
  static AppBar settingsAppBar(String title) {
    return AppBar(
      title: Text(title),
        backgroundColor: AppTheme.surfaceLight,
      foregroundColor: AppTheme.black,
      centerTitle: true,
    );
  }
}