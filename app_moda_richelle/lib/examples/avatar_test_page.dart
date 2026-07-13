import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/token_storage_service.dart';
import '../widgets/user_avatar.dart';

class AvatarTestPage extends StatefulWidget {
  const AvatarTestPage({super.key});

  @override
  State<AvatarTestPage> createState() => _AvatarTestPageState();
}

class _AvatarTestPageState extends State<AvatarTestPage> {
  User? testUser;
  String? storedAvatarUrl;

  @override
  void initState() {
    super.initState();
    _loadTestData();
  }

  Future<void> _loadTestData() async {
    // Get current stored data
    final userData = await TokenStorageService.getUserData();
    if (userData != null) {
      storedAvatarUrl = userData['avatar_url'];
      testUser = User(
        id: userData['id'],
        firstName: userData['first_name'],
        lastName: userData['last_name'],
        email: userData['email'],
        avatarUrl: userData['avatar_url'], 
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }

    if (kDebugMode) {
      debugPrint('🧪 AvatarTest: storedAvatarUrl = $storedAvatarUrl');
      debugPrint('🧪 AvatarTest: testUser.avatarUrl = ${testUser?.avatarUrl}');
    }

    setState(() {});
  }

  Future<void> _testStoreAvatar() async {
    // Test storing a Google avatar URL
    const testAvatarUrl = 'https://lh3.googleusercontent.com/a/ACg8ocKhB6avVbXVeoFt3QWtr-hDIA5mFEoeJCTUGWZNrX0oJ7Cpyb9zhw=s96-c';
    
    await TokenStorageService.saveAuthData(
      token: 'test_token',
      userId: 1,
      email: 'test@example.com',
      firstName: 'Test',
      lastName: 'User',
      avatarUrl: testAvatarUrl,
    );

    if (kDebugMode) {
      debugPrint('🧪 AvatarTest: Stored test avatar URL: $testAvatarUrl');
    }

    // Reload data
    await _loadTestData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avatar Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Avatar Debug Information:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            Text('Stored Avatar URL: ${storedAvatarUrl ?? "null"}'),
            const SizedBox(height: 8),
            
            Text('User Avatar URL: ${testUser?.avatarUrl ?? "null"}'),
            const SizedBox(height: 8),
            
            Text('User Name: ${testUser?.fullName ?? "No user"}'),
            const SizedBox(height: 16),

            const Text(
              'Avatar Widget Test:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    UserAvatar.large(user: testUser),
                    const SizedBox(height: 8),
                    const Text('Current User'),
                  ],
                ),
                Column(
                  children: [
                    UserAvatar.large(
                      user: User(
                        id: 1,
                        firstName: 'Test',
                        lastName: 'Google',
                        email: 'test@google.com',
                        avatarUrl: 'https://lh3.googleusercontent.com/a/ACg8ocKhB6avVbXVeoFt3QWtr-hDIA5mFEoeJCTUGWZNrX0oJ7Cpyb9zhw=s96-c',
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('Test URL'),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _testStoreAvatar,
                child: const Text('Store Test Avatar URL'),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loadTestData,
                child: const Text('Reload Data'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}