import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../theme/app_theme.dart';
import '../utils/alert_dialog_utils.dart';
import '../translations/app_translations.dart';
import '../services/auth_service.dart';
import '../services/error_message_service.dart';
import '../models/registration_request.dart';

class RegistrationPage extends StatefulWidget {
  final AuthService authService;
  
  const RegistrationPage({super.key, required this.authService});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegistration() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final registrationRequest = RegistrationRequest(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          passwordConfirmation: _confirmPasswordController.text,
        );

        final response = await widget.authService.register(registrationRequest);

        if (response.isSuccess && response.data != null) {
          // Registration successful - user needs to verify email
          if (mounted) {
            // Debug what we're getting from API
            if (kDebugMode) {
              print('📧 API Main Message: "${response.data?.message}"');
              print('📧 API Body Message: "${response.data?.body?.message}"');
            }
            
            // Use ONLY the API body message if it exists, otherwise use main message
            String message;
            if (response.data?.body?.message != null && response.data!.body!.message.isNotEmpty) {
              message = response.data!.body!.message;
            } else if (response.data?.message != null && response.data!.message.isNotEmpty) {
              message = response.data!.message;
            } else {
              // Only use app translation as absolute last resort
              message = AppTranslations.get('registrationEmailSent');
            }
            
            await AlertDialogUtils.showSimpleAlert(
              context: context,
              title: AppTranslations.get('success'),
              message: message,
            );
            
            // Navigate back to login page (user is NOT logged in)
            if (mounted) {
              Navigator.pop(context);
            }
          }
        } else {
          // Registration failed - show error message
          if (mounted) {
            final errorMessage = ErrorMessageService.getRegistrationErrorMessage(response.error);

            AlertDialogUtils.showSimpleAlert(
              context: context,
              title: AppTranslations.get('registrationFailed'),
              message: errorMessage,
            );
          }
        }
      } catch (e) {
        // Handle unexpected errors
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.loginBodyGradientDecoration,
        child: Column(
          children: [
            // Header with Back Button
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
                  child: Row(
                    children: [
                      // Back button
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
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppTranslations.get('createAccount'),
                              style: AppTheme.headingLarge.copyWith(
                                color: AppTheme.primary,
                                fontSize: 36,
                              ),
                            ),
                            Text(
                              AppTranslations.get('createAccountSubtitle'),
                              style: AppTheme.bodyLarge.copyWith(
                                color: AppTheme.black.withValues(alpha: 0.9),
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
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

                    Text(
                      AppTranslations.get('fillInformation'),
                      style: AppTheme.bodyLarge.copyWith(
                        color: AppTheme.white.withValues(alpha: 0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 35),

                    // Registration Form
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // First Name Field
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppTranslations.get('firstName'),
                                style: AppTheme.whiteLabelText,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: AppTheme.inputShadowDecoration,
                                child: TextFormField(
                                  controller: _firstNameController,
                                  textCapitalization: TextCapitalization.words,
                                  style: AppTheme.bodyLarge,
                                  decoration: AppTheme.inputDecoration(
                                    hintText: AppTranslations.get('firstNamePlaceholder'),
                                    prefixIcon: Icon(
                                      Icons.person_outlined,
                                      color: AppTheme.mediumGrey,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return AppTranslations.get('firstNameRequired');
                                    }
                                    if (value.trim().length < 2) {
                                      return AppTranslations.get('firstNameTooShort');
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Last Name Field
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppTranslations.get('lastName'),
                                style: AppTheme.whiteLabelText,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: AppTheme.inputShadowDecoration,
                                child: TextFormField(
                                  controller: _lastNameController,
                                  textCapitalization: TextCapitalization.words,
                                  style: AppTheme.bodyLarge,
                                  decoration: AppTheme.inputDecoration(
                                    hintText: AppTranslations.get('lastNamePlaceholder'),
                                    prefixIcon: Icon(
                                      Icons.person_outlined,
                                      color: AppTheme.mediumGrey,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return AppTranslations.get('lastNameRequired');
                                    }
                                    if (value.trim().length < 2) {
                                      return AppTranslations.get('lastNameTooShort');
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Email Field
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppTranslations.get('email'),
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
                                    hintText: AppTranslations.get('emailPlaceholder'),
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
                                AppTranslations.get('password'),
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
                                    hintText: AppTranslations.get('passwordPlaceholder'),
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
                                    
                                    // Check for uppercase letter
                                    if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                      return AppTranslations.get('passwordNoUppercase');
                                    }
                                    
                                    // Check for lowercase letter
                                    if (!RegExp(r'[a-z]').hasMatch(value)) {
                                      return AppTranslations.get('passwordNoLowercase');
                                    }
                                    
                                    // Check for number
                                    if (!RegExp(r'[0-9]').hasMatch(value)) {
                                      return AppTranslations.get('passwordNoNumber');
                                    }
                                    
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Confirm Password Field
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppTranslations.get('confirmPassword'),
                                style: AppTheme.whiteLabelText,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: AppTheme.inputShadowDecoration,
                                child: TextFormField(
                                  controller: _confirmPasswordController,
                                  obscureText: !_isConfirmPasswordVisible,
                                  style: AppTheme.bodyLarge,
                                  decoration: AppTheme.inputDecoration(
                                    hintText: AppTranslations.get('confirmPasswordPlaceholder'),
                                    prefixIcon: Icon(
                                      Icons.lock_outlined,
                                      color: AppTheme.mediumGrey,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isConfirmPasswordVisible
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: AppTheme.mediumGrey,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                        });
                                      },
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return AppTranslations.get('confirmPasswordRequired');
                                    }
                                    if (value != _passwordController.text) {
                                      return AppTranslations.get('passwordsDoNotMatch');
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),

                          // Create Account Button
                          Container(
                            width: double.infinity,
                            decoration: AppTheme.buttonShadowDecoration,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleRegistration,
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
                                      AppTranslations.get('createAccount'),
                                      style: AppTheme.buttonText.copyWith(
                                        color: AppTheme.black,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
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