import 'app_language.dart';

/// Main translations class containing all app texts
class AppTranslations {
  static AppLanguage _currentLanguage = AppLanguage.portuguese;
  
  /// Get current selected language
  static AppLanguage get currentLanguage => _currentLanguage;
  
  /// Change app language
  static void setLanguage(AppLanguage language) {
    _currentLanguage = language;
  }
  
  /// Get translation for a key based on current language
  static String get(String key) {
    final translations = _currentLanguage == AppLanguage.portuguese
        ? _portugueseTranslations
        : _englishTranslations;
    
    return translations[key] ?? key; // Return key if translation not found
  }
  
  // Portuguese translations (Brazilian Portuguese)
  static const Map<String, String> _portugueseTranslations = {
    // Login Page
    'welcome': 'Bem-vindo!',
    'loginSubtitle': 'Faça login e comece sua jornada!',
    'chooseLoginMethod': 'Escolha como deseja fazer login',
    'or': 'ou',
    'google': 'Google',
    'facebook': 'Facebook',
    'email': 'E-mail',
    'emailPlaceholder': 'Digite seu endereço de e-mail',
    'password': 'Senha',
    'passwordPlaceholder': 'Digite sua senha',
    'confirmPassword': 'Confirmar Senha',
    'confirmPasswordPlaceholder': 'Confirme sua senha',
    'login': 'ENTRAR',
    'forgotPassword': 'Esqueceu a senha?',
    'signUp': 'CRIAR CONTA',
    'continueWithGoogle': 'Google Login',
    
    // Validation Messages
    'emailRequired': 'Por favor, insira seu e-mail',
    'emailInvalid': 'Por favor, insira um endereço de e-mail válido',
    'passwordRequired': 'Por favor, insira sua senha',
    'passwordTooShort': 'A senha deve ter pelo menos 8 caracteres',
    'passwordNoUppercase': 'A senha deve conter pelo menos uma letra maiúscula',
    'passwordNoLowercase': 'A senha deve conter pelo menos uma letra minúscula',
    'passwordNoNumber': 'A senha deve conter pelo menos um número',
    'confirmPasswordRequired': 'Por favor, confirme sua senha',
    'passwordsDoNotMatch': 'As senhas não coincidem',
    'firstNameRequired': 'Por favor, insira seu nome',
    'firstNameTooShort': 'O nome deve ter pelo menos 2 caracteres',
    'lastNameRequired': 'Por favor, insira seu sobrenome',
    'lastNameTooShort': 'O sobrenome deve ter pelo menos 2 caracteres',
    'pleaseEnterPassword': 'Por favor, digite sua senha',
    'firstNamePlaceholder': 'Digite seu nome',
    'lastNamePlaceholder': 'Digite seu sobrenome',
    
    // Alert Dialog
    'ok': 'OK',
    'yes': 'Sim',
    'no': 'Não',
    'cancel': 'Cancelar',
    'confirm': 'Confirmar',
    
    // Alert Titles
    'loginAction': 'Login Realizado',
    'loginFailed': 'Falha no Login',
    'socialLogin': 'Login Social',
    'passwordRecovery': 'Recuperação de Senha',
    'registration': 'Cadastro',
    'error': 'Erro',
    'success': 'Sucesso',
    'warning': 'Aviso',
    'info': 'Informação',
    
    // Alert Messages
    'loginAttempted': 'Tentativa de login realizada com o e-mail: ',
    'googleLoginClicked': 'Login com Google foi acionado!',
    'appleLoginClicked': 'Login com Apple foi acionado!',
    'facebookLoginClicked': 'Login com Facebook foi acionado!',
    'forgotPasswordClicked': 'Recuperação de senha foi acionada!',
    'signUpClicked': 'Criação de conta foi acionada!',
    
    // Google Sign-In Messages
    'googleSignInCancelled': 'Login com Google foi cancelado',
    'googleSignInError': 'Erro no login com Google',
    'signInWithGoogle': 'Entrar com Google',
    
    // General
    'appName': 'TimelessApp',
    'loading': 'Carregando...',
    'retry': 'Tentar novamente',
    'close': 'Fechar',
    
    // Home Page
    'search': 'Buscar',
    'home': 'Home',
    'cart': 'Carrinho',
    'favorites': 'Favoritos',
    'profile': 'Perfil',
    'homeContent': 'Área de Conteúdo Principal',
    'logout': 'Sair',
    
    // Cart Page
    'cartEmpty': 'Seu carrinho está vazio',
    
    // Favorites Page
    'favoritesEmpty': 'Nenhum favorito ainda',
    
    // Profile Page
    'editProfile': 'Editar Perfil',
    'settings': 'Configurações',
    'helpSupport': 'Ajuda e Suporte',
    'logoutConfirm': 'Tem certeza que deseja sair?',
    
    // API and Network Error Messages
    'noInternetConnection': 'Sem conexão com a internet. Verifique sua conexão e tente novamente.',
    'serverError': 'Erro no servidor. Tente novamente mais tarde.',
    'serverTimeout': 'O servidor não respondeu a tempo. Verifique sua conexão e tente novamente.',
    'serverUnavailable': 'Nossos serviços estão temporariamente indisponíveis. Tente novamente em alguns minutos.',
    'networkError': 'Erro de rede:',
    'parseError': 'Falha ao processar resposta:',
    'unexpectedError': 'Ocorreu um erro inesperado. Tente novamente.',
    'connectionFailed': 'Falha na conexão com o servidor. Verifique sua internet e tente novamente.',
    'userNotAuthenticated': 'Usuário não autenticado',
    'requestFailed': 'Solicitação falhou com status:',
    'loginToAccess': 'Faça login para acessar recursos exclusivos',
    'createAccount': 'Criar nova conta',
    'createAccountSubtitle': 'Junte-se a nós hoje!',
    'fillInformation': 'Preencha suas informações para começar',
    'registrationSuccess': 'Conta criada com sucesso!',
    'registrationEmailSent': 'Um e-mail de confirmação foi enviado para seu endereço. Por favor, clique no link para verificar sua conta antes de fazer login.',
    'registrationFailed': 'Falha ao criar conta',
    'registerComingSoon': 'Registro em breve!',
    'logoutConfirmation': 'Tem certeza de que deseja sair?',
    'goBack': 'Voltar',
    'changePassword': 'Alterar senha',
    'deleteAccount': 'Excluir conta',
    'notifications': 'Notificações',
    'language': 'Idioma',
    'about': 'Sobre',
    'privacyPolicy': 'Política de privacidade',
    'version': 'Versão',
    
    // Settings Page
    'account': 'Conta',
    'updatePersonalInfo': 'Atualize suas informações pessoais',
    'updateAccountPassword': 'Atualize sua senha da conta',
    'preferences': 'Preferências',
    'receivePushNotifications': 'Receber notificações push',
    'darkMode': 'Modo escuro',
    'switchToDarkTheme': 'Alternar para tema escuro',
    'getHelpAndSupport': 'Obtenha ajuda e entre em contato com o suporte',
    'aboutApp': 'Sobre o aplicativo',
    'version100': 'Versão 1.0.0',
    'readPrivacyPolicy': 'Leia nossa política de privacidade',
    'selectLanguage': 'Selecionar idioma',
    'english': 'Inglês',
    'portuguese': 'Português',
    'appDescription': 'Um aplicativo moderno de moda construído com Flutter.',
    'copyright': '© 2026 TimelessApp. Todos os direitos reservados.',
    'save': 'Salvar',
    'firstName': 'Nome',
    'lastName': 'Sobrenome',
    'pleaseEnterFirstName': 'Por favor, digite seu nome',
    'pleaseEnterLastName': 'Por favor, digite seu sobrenome',
    'changePasswordComingSoon': 'Alteração de senha em breve!',
    'profileEditComingSoon': 'Edição de perfil em breve!',
    'helpSupportComingSoon': 'Ajuda e suporte em breve!',
    'settingsSaved': 'Configurações salvas!',
    'permanentlyDeleteAccount': 'Excluir permanentemente sua conta',
    'takePhoto': 'Tirar foto',
    'chooseFromGallery': 'Escolher da galeria',
    'profileUpdatedSuccessfully': 'Perfil atualizado com sucesso!',
    'failedToUpdateProfile': 'Falha ao atualizar perfil',
    'errorUpdatingProfile': 'Erro ao atualizar perfil:',
    'deleteAccountConfirmation': 'Tem certeza de que deseja excluir permanentemente sua conta? Esta ação não pode ser desfeita.',
    'delete': 'Excluir',
  };
  
  // English translations
  static const Map<String, String> _englishTranslations = {
    // Login Page
    'welcome': 'Welcome!',
    'loginSubtitle': 'Sign in and start your journey!',
    'chooseLoginMethod': 'Choose how you want to sign in',
    'or': 'or',
    'google': 'Google',
    'facebook': 'Facebook',
    'email': 'Email',
    'emailPlaceholder': 'Enter your email address',
    'password': 'Password',
    'passwordPlaceholder': 'Enter your password',
    'confirmPassword': 'Confirm Password',
    'confirmPasswordPlaceholder': 'Confirm your password',
    'login': 'SIGN IN',
    'forgotPassword': 'Forgot password?',
    'signUp': 'CREATE ACCOUNT',
    'continueWithGoogle': 'Google Login',
    
    // Validation Messages
    'emailRequired': 'Please enter your email',
    'emailInvalid': 'Please enter a valid email address',
    'passwordRequired': 'Please enter your password',
    'passwordTooShort': 'Password must be at least 8 characters',
    'passwordNoUppercase': 'Password must contain at least one uppercase letter',
    'passwordNoLowercase': 'Password must contain at least one lowercase letter',
    'passwordNoNumber': 'Password must contain at least one number',
    'confirmPasswordRequired': 'Please confirm your password',
    'passwordsDoNotMatch': 'Passwords do not match',
    'firstNameRequired': 'Please enter your first name',
    'firstNameTooShort': 'First name must be at least 2 characters',
    'lastNameRequired': 'Please enter your last name',
    'lastNameTooShort': 'Last name must be at least 2 characters',
    'pleaseEnterPassword': 'Please enter your password',
    'firstNamePlaceholder': 'Enter your first name',
    'lastNamePlaceholder': 'Enter your last name',
    
    // Alert Dialog
    'ok': 'OK',
    'yes': 'Yes',
    'no': 'No',
    'cancel': 'Cancel',
    'confirm': 'Confirm',
    
    // Alert Titles
    'loginAction': 'Login Action',
    'loginFailed': 'Login Failed',
    'socialLogin': 'Social Login',
    'passwordRecovery': 'Password Recovery',
    'registration': 'Registration',
    'error': 'Error',
    'success': 'Success',
    'warning': 'Warning',
    'info': 'Information',
    
    // Alert Messages
    'loginAttempted': 'Login attempted with email: ',
    'googleLoginClicked': 'Google Login button clicked!',
    'appleLoginClicked': 'Apple Login button clicked!',
    'facebookLoginClicked': 'Facebook Login button clicked!',
    'forgotPasswordClicked': 'Forgot password clicked!',
    'signUpClicked': 'Sign up clicked!',
    
    // Google Sign-In Messages
    'googleSignInCancelled': 'Google Sign-In was cancelled',
    'googleSignInError': 'Google Sign-In error',
    'signInWithGoogle': 'Sign in with Google',
    
    // General
    'appName': 'TimelessApp',
    'loading': 'Loading...',
    'retry': 'Retry',
    'close': 'Close',
    
    // Home Page
    'search': 'Search',
    'home': 'Home',
    'cart': 'Cart',
    'favorites': 'Favorites',
    'profile': 'Profile',
    'homeContent': 'Home Content Area',
    'logout': 'Logout',
    
    // Cart Page
    'cartEmpty': 'Your shopping cart is empty',
    
    // Favorites Page
    'favoritesEmpty': 'No favorites yet',
    
    // Profile Page
    'editProfile': 'Edit Profile',
    'settings': 'Settings',
    'helpSupport': 'Help & Support',
    'logoutConfirm': 'Are you sure you want to logout?',
    
    // API and Network Error Messages
    'noInternetConnection': 'No internet connection. Please check your connection and try again.',
    'serverError': 'Server error. Please try again later.',
    'serverTimeout': 'Server did not respond in time. Please check your connection and try again.',
    'serverUnavailable': 'Our services are temporarily unavailable. Please try again in a few minutes.',
    'networkError': 'Network error:',
    'parseError': 'Failed to parse response:',
    'unexpectedError': 'An unexpected error occurred. Please try again.',
    'connectionFailed': 'Failed to connect to server. Please check your internet and try again.',
    'userNotAuthenticated': 'User not authenticated',
    'requestFailed': 'Request failed with status:',
    'loginToAccess': 'Login to access exclusive features',
    'createAccount': 'Create new account',
    'createAccountSubtitle': 'Join us today!',
    'fillInformation': 'Fill in your information to get started',
    'registrationSuccess': 'Account created successfully!',
    'registrationEmailSent': 'A confirmation email has been sent to your address. Please click the link to verify your account before logging in.',
    'registrationFailed': 'Failed to create account',
    'registerComingSoon': 'Registration coming soon!',
    'logoutConfirmation': 'Are you sure you want to logout?',
    'goBack': 'Go back',
    'changePassword': 'Change password',
    'deleteAccount': 'Delete account',
    'notifications': 'Notifications',
    'language': 'Language',
    'about': 'About',
    'privacyPolicy': 'Privacy policy',
    'version': 'Version',
    
    // Settings Page
    'account': 'Account',
    'updatePersonalInfo': 'Update your personal information',
    'updateAccountPassword': 'Update your account password',
    'preferences': 'Preferences',
    'receivePushNotifications': 'Receive push notifications',
    'darkMode': 'Dark Mode',
    'switchToDarkTheme': 'Switch to dark theme',
    'getHelpAndSupport': 'Get help and contact support',
    'aboutApp': 'About App',
    'version100': 'Version 1.0.0',
    'readPrivacyPolicy': 'Read our privacy policy',
    'selectLanguage': 'Select Language',
    'english': 'English',
    'portuguese': 'Português',
    'appDescription': 'A modern fashion shopping app built with Flutter.',
    'copyright': '© 2026 TimelessApp. All rights reserved.',
    'save': 'Save',
    'firstName': 'First Name',
    'lastName': 'Last Name',
    'pleaseEnterFirstName': 'Please enter your first name',
    'pleaseEnterLastName': 'Please enter your last name',
    'changePasswordComingSoon': 'Change password coming soon!',
    'profileEditComingSoon': 'Profile editing coming soon!',
    'helpSupportComingSoon': 'Help & Support coming soon!',
    'settingsSaved': 'Settings saved!',
    'permanentlyDeleteAccount': 'Permanently delete your account',
    'takePhoto': 'Take Photo',
    'chooseFromGallery': 'Choose from Gallery',
    'profileUpdatedSuccessfully': 'Profile updated successfully!',
    'failedToUpdateProfile': 'Failed to update profile',
    'errorUpdatingProfile': 'Error updating profile:',
    'deleteAccountConfirmation': 'Are you sure you want to permanently delete your account? This action cannot be undone.',
    'delete': 'Delete',
  };
  
  // Helper methods for commonly used strings
  static String get welcome => get('welcome');
  static String get loginSubtitle => get('loginSubtitle');
  static String get email => get('email');
  static String get emailPlaceholder => get('emailPlaceholder');
  static String get password => get('password');
  static String get passwordPlaceholder => get('passwordPlaceholder');
  static String get login => get('login');
  static String get forgotPassword => get('forgotPassword');
  static String get signUp => get('signUp');
  static String get ok => get('ok');
  static String get yes => get('yes');
  static String get no => get('no');
  static String get cancel => get('cancel');
  static String get confirm => get('confirm');
}