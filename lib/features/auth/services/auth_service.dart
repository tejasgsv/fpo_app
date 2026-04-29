import '../../../core/state/platform_store.dart';

class AuthSession {
  const AuthSession({
    required this.token,
    required this.role,
    required this.accountId,
    required this.displayName,
    required this.accountStatus,
  });

  final String token;
  final PlatformRole role;
  final String accountId;
  final String displayName;
  final FpoApplicationStatus? accountStatus;
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
  MockAuthService({required this.tokenStore, required this.platformStore});

  final TokenStore tokenStore;
  final PlatformStore platformStore;

  @override
  Future<AuthSession> login({
    required String userIdOrEmail,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    final token = 'mock_${DateTime.now().millisecondsSinceEpoch}';
    await tokenStore.save(token);

    final loginValue = userIdOrEmail.trim();
    final lowerValue = loginValue.toLowerCase();
    final isAdmin = lowerValue.contains('admin');

    if (isAdmin) {
      return AuthSession(
        token: token,
        role: PlatformRole.admin,
        accountId: 'platform_admin',
        displayName: 'Super Admin',
        accountStatus: null,
      );
    }

    final application = platformStore.findApplicationByLoginValue(loginValue);
    if (application == null) {
      return AuthSession(
        token: token,
        role: PlatformRole.fpo,
        accountId: loginValue,
        displayName: loginValue,
        accountStatus: FpoApplicationStatus.pending,
      );
    }

    return AuthSession(
      token: token,
      role: PlatformRole.fpo,
      accountId: application.id,
      displayName: application.fpoName,
      accountStatus: application.status,
    );
  }
}
