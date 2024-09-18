abstract class Page2_1state {}

class Initstate extends Page2_1state {}

class TogglePasswordVisibilityState extends Page2_1state {
  final bool showPassword;

  TogglePasswordVisibilityState({required this.showPassword});
}

class Register extends Page2_1state {}

class ValidatePassword extends Page2_1state {}
