abstract class Forgetpasswordstate{}

class Initstate extends Forgetpasswordstate{}

class UpdatePassword extends Forgetpasswordstate{}

class ValidityPassword extends Forgetpasswordstate{}

class TogglePasswordVisibilityState1 extends Forgetpasswordstate {
  final bool show1;

  TogglePasswordVisibilityState1({required this.show1});
}

class TogglePasswordVisibilityState2 extends Forgetpasswordstate {
  final bool show2;

  TogglePasswordVisibilityState2({required this.show2});
}

