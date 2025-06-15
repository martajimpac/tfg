class AuthenticationRepositoryException implements Exception {
  final String message;
  AuthenticationRepositoryException(this.message); // Mensaje genérico o código
  @override
  String toString() => message;
}

class InvalidCredentialsException extends AuthenticationRepositoryException {
  InvalidCredentialsException() : super('invalid_credentials');
}

class EmailNotConfirmedException extends AuthenticationRepositoryException {
  EmailNotConfirmedException() : super('email_not_confirmed');
}

class EmailAlreadyRegisteredException extends AuthenticationRepositoryException {
  EmailAlreadyRegisteredException() : super('email_already_registered');
}

class PasswordTooShortException extends AuthenticationRepositoryException {
  PasswordTooShortException() : super('password_too_short');
}

class InvalidEmailFormatException extends AuthenticationRepositoryException {
  InvalidEmailFormatException() : super('invalid_email_format');
}

class RateLimitExceededException extends AuthenticationRepositoryException {
  final String operation;
  RateLimitExceededException(this.operation) : super('rate_limit_exceeded_$operation');
}

class ChangePasswordIncorrectException extends AuthenticationRepositoryException {
  ChangePasswordIncorrectException() : super('change_password_incorrect_current');
}

class ChangePasswordNoChangedException extends AuthenticationRepositoryException {
  ChangePasswordNoChangedException() : super('change_password_no');
}

class ChangePasswordFailedException extends AuthenticationRepositoryException {
  ChangePasswordFailedException() : super('change_password_failed');
}