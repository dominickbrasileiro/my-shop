class AuthException implements Exception {
  static const Map<String, String> errors = {
    'EMAIL_EXISTS': 'E-mail already in use',
    'OPERATION_NOT_ALLOWED': 'Operation not allowed',
    'TOO_MANY_ATTEMPTS_TRY_LATER': 'Too many attempts, please try again later',
    'EMAIL_NOT_FOUND': 'E-mail not found',
    'INVALID_PASSWORD': 'Invalid password',
    'USER_DISABLED': 'User is disabled',
  };

  final String key;

  AuthException(this.key);

  @override
  String toString() {
    if (errors.containsKey(key)) {
      return errors[key]!;
    }

    return 'Unexpected error';
  }
}
