/// Examples of how to use AppBar in different scenarios
/// This file shows various AppBar implementations for the Moda Richelle app

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../translations/app_translations.dart';

// Example 1: Login Page with AppBar (Alternative to current custom header)
class LoginPageWithAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar automatically shows back button if navigation stack exists
      appBar: AppBar(
        title: Text(AppTranslations.get('login')),
        backgroundColor: AppTheme.lightRose,
        foregroundColor: AppTheme.deepRose,
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
        backgroundColor: AppTheme.primaryPink,
        foregroundColor: Colors.white,
        // Add action buttons on the right
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              // Save settings
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Settings saved!')),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ListTile(
            leading: Icon(Icons.notifications, color: AppTheme.primaryPink),
            title: Text('Notifications'),
            subtitle: Text('Manage your notification preferences'),
            trailing: Switch(value: true, onChanged: (val) {}),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.language, color: AppTheme.primaryPink),
            title: Text('Language'),
            subtitle: Text('Change app language'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to language selection
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.palette, color: AppTheme.primaryPink),
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
        backgroundColor: AppTheme.lightRose,
        foregroundColor: AppTheme.deepRose,
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
                color: AppTheme.deepRose,
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
                  backgroundColor: AppTheme.lightPink,
                  child: Icon(Icons.person, size: 50, color: AppTheme.deepRose),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: AppTheme.primaryPink,
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
        foregroundColor: AppTheme.deepRose,
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
            backgroundColor: AppTheme.primaryPink,
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
                        color: AppTheme.primaryPink,
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
      backgroundColor: AppTheme.primaryPink,
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
      backgroundColor: AppTheme.lightRose,
      foregroundColor: AppTheme.deepRose,
      elevation: 0,
    );
  }
  
  // Settings section AppBar
  static AppBar settingsAppBar(String title) {
    return AppBar(
      title: Text(title),
      backgroundColor: AppTheme.lightPink,
      foregroundColor: AppTheme.black,
      centerTitle: true,
    );
  }
}