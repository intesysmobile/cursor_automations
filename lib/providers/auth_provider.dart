import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  const AuthState({
    required this.isAuthenticated,
    this.errorMessage,
  });

  final bool isAuthenticated;
  final String? errorMessage;

  AuthState copyWith({
    bool? isAuthenticated,
    String? errorMessage,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      errorMessage: errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier()
      : super(
          const AuthState(isAuthenticated: false),
        );

  static const _validUsername = 'SolarAdmin';
  static const _validPassword = 'MilkyWay';

  void login(String username, String password) {
    if (username == _validUsername && password == _validPassword) {
      state = const AuthState(isAuthenticated: true);
    } else {
      state = const AuthState(
        isAuthenticated: false,
        errorMessage: 'Credenziali non valide',
      );
    }
  }

  void logout() {
    state = const AuthState(isAuthenticated: false);
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier());

