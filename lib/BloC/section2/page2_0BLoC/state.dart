abstract class Page2_0state {}

class Initstate extends Page2_0state {}

class TogglePasswordVisibilityState extends Page2_0state {
  final bool showPassword;

  TogglePasswordVisibilityState({required this.showPassword});
}

class Signin extends Page2_0state {}

class SignInWithGoogle extends Page2_0state {}


