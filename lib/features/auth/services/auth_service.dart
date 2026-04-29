class AuthSession {
  const AuthSession({
    required this.token,
    this.role,
  });

  final String token;
  final String? role;
}

abstract class TokenStore {
  Future<void> save(String token);
  Future<String?> read();
}

class InMemoryTokenStore implements TokenStore {
  String? _token;

  @override
  Future<void> save(String token) async {
    _token = token;
  }

  @override
  Future<String?> read() async => _token;
}

abstract class AuthService {
  Future<AuthSession> login({
    required String userIdOrEmail,
    required String password,
  });
}

class MockAuthService implements AuthService {
  MockAuthService({required this.tokenStore});

  final TokenStore tokenStore;

  @override
  Future<AuthSession> login({
    required String userIdOrEmail,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    final token = 'mock_${DateTime.now().millisecondsSinceEpoch}';
    await tokenStore.save(token);
    return AuthSession(token: token);
  }
}
