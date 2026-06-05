import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/register_usecase.dart';
import '../presentation/providers/auth_provider.dart';

class AuthModule {
  late final AuthRepository _repository;
  late final LoginUseCase _loginUseCase;
  late final RegisterUseCase _registerUseCase;
  late final AuthProvider _authProvider;

  AuthModule({required http.Client httpClient, required SharedPreferences prefs}) {
    _repository = AuthRepositoryImpl(client: httpClient, prefs: prefs);
    _loginUseCase = LoginUseCase(_repository);
    _registerUseCase = RegisterUseCase(_repository);
    _authProvider = AuthProvider(
      loginUseCase: _loginUseCase,
      registerUseCase: _registerUseCase,
    );
  }

  AuthProvider get authProvider => _authProvider;
}