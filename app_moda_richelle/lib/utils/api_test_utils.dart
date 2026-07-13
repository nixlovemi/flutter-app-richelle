/// Development utilities for testing API integration
class ApiTestUtils {
  /// Example Laravel API endpoints that your backend should implement
  static const Map<String, String> expectedEndpoints = {
    'login': 'POST /api/auth/login',
    'logout': 'POST /api/auth/logout',
    'user': 'GET /api/auth/user',
    'register': 'POST /api/auth/register', // Optional
  };

  /// Example Laravel login controller response format
  static const String exampleLoginResponse = '''
  {
    "token": "1|abc123def456...",
    "token_type": "Bearer",
    "user": {
      "id": 1,
      "name": "Test User",
      "email": "test@example.com",
      "email_verified_at": null,
      "created_at": "2026-02-20T00:00:00.000000Z",
      "updated_at": "2026-02-20T00:00:00.000000Z"
    },
    "expires_at": "2026-02-21T00:00:00.000000Z"
  }
  ''';

  /// Example Laravel error response format
  static const String exampleErrorResponse = '''
  {
    "message": "The given data was invalid.",
    "errors": {
      "email": ["The email field is required."],
      "password": ["The password field is required."]
    }
  }
  ''';

  /// Laravel API routes you should have in your routes/api.php
  static const String laravelRoutes = '''
  Route::prefix('auth')->group(function () {
      Route::post('login', [AuthController::class, 'login']);
      Route::post('logout', [AuthController::class, 'logout'])->middleware('auth:sanctum');
      Route::get('user', [AuthController::class, 'user'])->middleware('auth:sanctum');
  });
  ''';

  /// Example Laravel AuthController methods
  static const String laravelControllerExample = '''
  public function login(Request \$request)
  {
      \$request->validate([
          'email' => 'required|email',
          'password' => 'required',
      ]);

      if (!Auth::attempt(\$request->only('email', 'password'))) {
          return response()->json([
              'message' => 'Invalid credentials'
          ], 401);
      }

      \$user = Auth::user();
      \$token = \$user->createToken('auth-token')->plainTextToken;

      return response()->json([
          'token' => \$token,
          'token_type' => 'Bearer',
          'user' => \$user,
          'expires_at' => now()->addDays(7)
      ]);
  }

  public function logout(Request \$request)
  {
      \$request->user()->currentAccessToken()->delete();
      return response()->json(['message' => 'Logged out successfully']);
  }

  public function user(Request \$request)
  {
      return response()->json(\$request->user());
  }
  ''';
}