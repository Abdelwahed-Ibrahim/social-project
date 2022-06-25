abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates {}

class RegisterLoadingState extends RegisterStates {}

class CreateUserLoadingState extends RegisterStates {}

class CreateUserSuccessState extends RegisterStates {}

class CreateUserErrorState extends RegisterStates {
  final String error;

  CreateUserErrorState(this.error);
}

class RegisterSuccessState extends RegisterStates {
  final String uId;

  RegisterSuccessState(this.uId);
}

class RegisterErrorState extends RegisterStates {
  final String error;

  RegisterErrorState(this.error);
}

class RegisterChangePasswordVisibilityState extends RegisterStates {}
