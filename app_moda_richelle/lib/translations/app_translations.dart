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
    'email': 'E-mail',
    'emailPlaceholder': 'Digite seu endereço de e-mail',
    'password': 'Senha',
    'passwordPlaceholder': 'Digite sua senha',
    'login': 'ENTRAR',
    'forgotPassword': 'Esqueceu a senha?',
    'signUp': 'CRIAR CONTA',
    
    // Validation Messages
    'emailRequired': 'Por favor, insira seu e-mail',
    'emailInvalid': 'Por favor, insira um endereço de e-mail válido',
    'passwordRequired': 'Por favor, insira sua senha',
    'passwordTooShort': 'A senha deve ter pelo menos 6 caracteres',
    
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
    
    // General
    'appName': 'Moda Richelle',
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
    'networkError': 'Erro de rede:',
    'parseError': 'Falha ao processar resposta:',
    'unexpectedError': 'Ocorreu um erro inesperado. Tente novamente.',
    'userNotAuthenticated': 'Usuário não autenticado',
    'requestFailed': 'Solicitação falhou com status:',
    'loginToAccess': 'Faça login para acessar recursos exclusivos',
    'createAccount': 'Criar nova conta',
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
  };
  
  // English translations
  static const Map<String, String> _englishTranslations = {
    // Login Page
    'welcome': 'Welcome!',
    'loginSubtitle': 'Sign in and start your journey!',
    'email': 'Email',
    'emailPlaceholder': 'Enter your email address',
    'password': 'Password',
    'passwordPlaceholder': 'Enter your password',
    'login': 'SIGN IN',
    'forgotPassword': 'Forgot password?',
    'signUp': 'CREATE ACCOUNT',
    
    // Validation Messages
    'emailRequired': 'Please enter your email',
    'emailInvalid': 'Please enter a valid email address',
    'passwordRequired': 'Please enter your password',
    'passwordTooShort': 'Password must be at least 6 characters',
    
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
    
    // General
    'appName': 'Moda Richelle',
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
    'parseError': 'Failed to parse response:',
    'unexpectedError': 'An unexpected error occurred. Please try again.',
    'userNotAuthenticated': 'User not authenticated',
    'requestFailed': 'Request failed with status:',
    'loginToAccess': 'Login to access exclusive features',
    'createAccount': 'Create new account',
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