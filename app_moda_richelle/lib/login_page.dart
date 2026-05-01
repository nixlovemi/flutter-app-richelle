import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'utils/alert_dialog_utils.dart';
import 'translations/app_translations.dart';
import 'pages/home_page.dart';
import 'pages/registration_page.dart';
import 'services/auth_service.dart';
import 'services/error_message_service.dart';
// import 'widgets/language_picker.dart';

class LoginPage extends StatefulWidget {
  final AuthService authService;
  
  const LoginPage({super.key, required this.authService});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
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
        final response = await widget.authService.login(
          _emailController.text.trim(),
          _passwordController.text,
        );

        if (response.isSuccess) {
          // Login successful - check if we can go back or need to navigate to home
          if (mounted) {
            if (Navigator.canPop(context)) {
              // We came from somewhere (like profile tab), go back with success result
              Navigator.pop(context, true); // Return true to indicate successful login
            } else {
              // This is the main entry point, navigate to home  
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage(
                  authService: widget.authService, // Use the same instance passed from main
                )),
              );
            }
          }
        } else {
          // Login failed - show error message
          if (mounted) {
            final errorMessage = ErrorMessageService.getLoginErrorMessage(response.error);

            AlertDialogUtils.showSimpleAlert(
              context: context,
              title: AppTranslations.get('loginFailed'),
              message: errorMessage,
            );
          }
        }
      } catch (e) {
        // Handle unexpected errors with more specific messages
        if (mounted) {
          final errorMessage = ErrorMessageService.getExceptionMessage(e as Exception);
          
          AlertDialogUtils.showSimpleAlert(
            context: context,
            title: AppTranslations.get('error'),
            message: errorMessage,
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

  void _handleGoogleLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await widget.authService.loginWithGoogle();

      if (response.isSuccess) {
        // Google login successful
        if (mounted) {
          if (Navigator.canPop(context)) {
            // We came from somewhere (like profile tab), go back with success result
            Navigator.pop(context, true);
          } else {
            // This is the main entry point, navigate to home  
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage(
                authService: widget.authService,
              )),
            );
          }
        }
      } else {
        // Google login failed
        if (mounted) {
          final errorMessage = ErrorMessageService.getGoogleLoginErrorMessage(response.error);
          
          AlertDialogUtils.showSimpleAlert(
            context: context,
            title: AppTranslations.get('socialLogin'),
            message: errorMessage,
          );
        }
      }
    } catch (e) {
      // Handle unexpected errors with more specific messages
      if (mounted) {
        final errorMessage = ErrorMessageService.getExceptionMessage(e as Exception);
        
        AlertDialogUtils.showSimpleAlert(
          context: context,
          title: AppTranslations.get('error'),
          message: errorMessage,
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
                color: AppTheme.surface,
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
                          // Back button - only show if we can go back
                          if (Navigator.canPop(context))
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              child: IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: AppTheme.primary,
                                  size: 24,
                                ),
                                tooltip: AppTranslations.get('goBack'),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 40,
                                  minHeight: 40,
                                ),
                              ),
                            ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppTranslations.welcome,
                                  style: AppTheme.headingLarge.copyWith(
                                    color: AppTheme.primary,
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
                    const SizedBox(height: 25),

                    // Welcome Text
                    /*
                    Text(
                      AppTranslations.welcome,
                      style: AppTheme.headingMedium.copyWith(
                        color: AppTheme.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    */

                    Text(
                      AppTranslations.get('chooseLoginMethod'),
                      style: AppTheme.bodyLarge.copyWith(
                        color: AppTheme.white.withValues(alpha: 0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 35),

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
                                    if (value.length < 8) {
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
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),

                    // Or divider
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: AppTheme.white.withValues(alpha: 0.3),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            AppTranslations.get('or'),
                            style: AppTheme.bodyMedium.copyWith(
                              color: AppTheme.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: AppTheme.white.withValues(alpha: 0.3),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Google Login Button
                    FractionallySizedBox(
                      widthFactor: 0.7, // 70% of screen width
                      child: Container(
                        decoration: AppTheme.buttonShadowDecoration,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleGoogleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.white,
                            foregroundColor: AppTheme.black,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: AppTheme.lightGrey.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            disabledBackgroundColor: AppTheme.lightGrey,
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.red[600]!,
                                    ),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      margin: const EdgeInsets.only(right: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.red[600],
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'G',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      AppTranslations.get('continueWithGoogle'),
                                      style: AppTheme.buttonText.copyWith(
                                        color: AppTheme.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Sign Up Button
                    Container(
                      width: double.infinity,
                      decoration: AppTheme.buttonShadowDecoration,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegistrationPage(
                                authService: widget.authService,
                              ),
                            ),
                          );
                        },
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