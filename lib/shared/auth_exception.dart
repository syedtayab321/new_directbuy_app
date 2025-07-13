abstract class AuthFailure {
  final String message;
  const AuthFailure(this.message);
}

class ServerFailure extends AuthFailure {
  const ServerFailure(super.message);
}

class EmailAlreadyInUseFailure extends AuthFailure {
  const EmailAlreadyInUseFailure() : super('Email already in use');
}

class InvalidEmailFailure extends AuthFailure {
  const InvalidEmailFailure() : super('Invalid email');
}

class WeakPasswordFailure extends AuthFailure {
  const WeakPasswordFailure() : super('Password is too weak');
}

class UserNotFoundFailure extends AuthFailure {
  const UserNotFoundFailure() : super('User not found');
}

class WrongPasswordFailure extends AuthFailure {
  const WrongPasswordFailure() : super('Wrong password');
}