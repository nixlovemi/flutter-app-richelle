import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'utils/alert_dialog_utils.dart';
import 'translations/app_translations.dart';
import 'pages/home_page.dart';
import 'services/auth_service.dart';
// import 'widgets/language_picker.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Auto-login check is now handled in main.dart AuthWrapper
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await _authService.login(
          _emailController.text.trim(),
          _passwordController.text,
        );

        if (response.isSuccess) {
          // Login successful - navigate to home page
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          }
        } else {
          // Login failed - show error message
          if (mounted) {
            String errorMessage = response.error?.message ?? AppTranslations.get('loginFailed');
            
            // Check for specific field errors
            if (response.error?.errors != null) {
              final emailError = response.error!.getFieldError('email');
              final passwordError = response.error!.getFieldError('password');
              
              if (emailError != null) {
                errorMessage = emailError;
              } else if (passwordError != null) {errorMessage = passwordError; }
              else { errorMessage = response.error!.allMessages;} 
            }

            AlertDialogUtils.showSimpleAlert(
              context: context,
              title: AppTranslations.get('loginFailed'),
              message: errorMessage,
            );
          }
        }
      } catch (e) {
        // Handle unexpected errors
        if (mounted) {
          AlertDialogUtils.showSimpleAlert(
            context: context,
            title: AppTranslations.get('error'),
            message: AppTranslations.get('unexpectedError'),
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
  }

  void _handleGoogleLogin() {
    AlertDialogUtils.showSimpleAlert(
      context: context,
      title: AppTranslations.get('socialLogin'),
      message: AppTranslations.get('googleLoginClicked'),
    );
  }

  void _handleAppleLogin() {
    AlertDialogUtils.showSimpleAlert(
      context: context,
      title: AppTranslations.get('socialLogin'),
      message: AppTranslations.get('appleLoginClicked'),
    );
  }

  void _handleFacebookLogin() {
    AlertDialogUtils.showSimpleAlert(
      context: context,
      title: AppTranslations.get('socialLogin'),
      message: AppTranslations.get('facebookLoginClicked'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.loginBodyGradientDecoration,
        child: Column(
          children: [
            // Full Width Header with Curved Bottom - Combined
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.lightRose,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(50),
                ),
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
                child: Container(
                  padding: const EdgeInsets.fromLTRB(AppTheme.sidePadding, 10, AppTheme.sidePadding, 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppTranslations.welcome,
                                  style: AppTheme.headingLarge.copyWith(
                                    color: AppTheme.deepRose,
                                    fontSize: 36,
                                  ),
                                ),
                                Text(
                                  AppTranslations.loginSubtitle,
                                  style: AppTheme.bodyLarge.copyWith(
                                    color: AppTheme.black.withValues(alpha: 0.9),
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          /* LanguageToggleButton(
                            onLanguageChanged: () {
                              setState(() {
                                // Rebuild UI when language changes
                              });
                            },
                          ),
                          */
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Main Content Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.sidePadding),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Login Form
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Email Field
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppTranslations.email,
                                style: AppTheme.whiteLabelText,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: AppTheme.inputShadowDecoration,
                                child: TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: AppTheme.bodyLarge,
                                  decoration: AppTheme.inputDecoration(
                                    hintText: AppTranslations.emailPlaceholder,
                                    prefixIcon: Icon(
                                      Icons.email_outlined,
                                      color: AppTheme.mediumGrey,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return AppTranslations.get('emailRequired');
                                    }
                                    if (!value.contains('@')) {
                                      return AppTranslations.get('emailInvalid');
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Password Field
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppTranslations.password,
                                style: AppTheme.whiteLabelText,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: AppTheme.inputShadowDecoration,
                                child: TextFormField(
                                  controller: _passwordController,
                                  obscureText: !_isPasswordVisible,
                                  style: AppTheme.bodyLarge,
                                  decoration: AppTheme.inputDecoration(
                                    hintText: AppTranslations.passwordPlaceholder,
                                    prefixIcon: Icon(
                                      Icons.lock_outlined,
                                      color: AppTheme.mediumGrey,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordVisible
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: AppTheme.mediumGrey,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isPasswordVisible = !_isPasswordVisible;
                                        });
                                      },
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return AppTranslations.get('passwordRequired');
                                    }
                                    if (value.length < 6) {
                                      return AppTranslations.get('passwordTooShort');
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),

                          // Login Button
                          Container(
                            width: double.infinity,
                            decoration: AppTheme.buttonShadowDecoration,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleLogin,
                              style: AppTheme.primaryButtonStyle,
                              child: _isLoading
                                  ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          AppTheme.black,
                                        ),
                                      ),
                                    )
                                  : Text(
                                      AppTranslations.login,
                                      style: AppTheme.buttonText.copyWith(
                                        color: AppTheme.black,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Forgot Password
                          Center(
                            child: TextButton(
                              onPressed: () => AlertDialogUtils.showSimpleAlert(
                                context: context,
                                title: AppTranslations.get('passwordRecovery'),
                                message: AppTranslations.get('forgotPasswordClicked'),
                              ),
                              child: Text(
                                AppTranslations.forgotPassword,
                                style: AppTheme.bodyMedium.copyWith(
                                  color: AppTheme.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),

                    // Social Media Login Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Apple Login
                        Container(
                          width: AppTheme.socialButtonSize,
                          height: AppTheme.socialButtonSize,
                          decoration: AppTheme.socialButtonDecoration,
                          child: IconButton(
                            onPressed: _handleAppleLogin,
                            icon: Icon(
                              Icons.apple,
                              color: AppTheme.black,
                              size: AppTheme.socialButtonIconSize,
                            ),
                          ),
                        ),

                        // Google Login
                        Container(
                          width: AppTheme.socialButtonSize,
                          height: AppTheme.socialButtonSize,
                          decoration: AppTheme.socialButtonDecoration,
                          child: IconButton(
                            onPressed: _handleGoogleLogin,
                            icon: Text(
                              'G',
                              style: TextStyle(
                                fontSize: AppTheme.socialButtonIconSize - 5,
                                fontWeight: FontWeight.bold,
                                color: Colors.red[600],
                              ),
                            ),
                          ),
                        ),

                        // Facebook Login
                        Container(
                          width: AppTheme.socialButtonSize,
                          height: AppTheme.socialButtonSize,
                          decoration: AppTheme.socialButtonDecoration,
                          child: IconButton(
                            onPressed: _handleFacebookLogin,
                            icon: Text(
                              'f',
                              style: TextStyle(
                                fontSize: AppTheme.socialButtonIconSize - 5,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[700],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Sign Up Button
                    Container(
                      width: double.infinity,
                      decoration: AppTheme.buttonShadowDecoration,
                      child: OutlinedButton(
                        onPressed: () => AlertDialogUtils.showSimpleAlert(
                          context: context,
                          title: AppTranslations.get('registration'),
                          message: AppTranslations.get('signUpClicked'),
                        ),
                        style: AppTheme.secondaryButtonStyle,
                        child: Text(
                          AppTranslations.signUp,
                          style: AppTheme.buttonText.copyWith(
                            color: AppTheme.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}