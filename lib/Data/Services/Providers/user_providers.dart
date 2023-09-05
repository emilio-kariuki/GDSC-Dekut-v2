import '../repositories/user_repositories.dart';

class UserProviders {
  //* register a user using firebase auth

  Future<bool> createAccount(
      {required String email,
      required String password,
      required String name}) async {
    var response = UserRepository().registerUser(
      email: email,
      password: password,
      name: name,
    );
    return response;
  }

  //* login a user using firebase auth

  Future<bool> loginAccount(
      {required String email, required String password}) async {
    var response = UserRepository().loginUser(
      email: email,
      password: password,
    );
    return response;
  }

  //* logout a user using firebase auth

  Future<bool> logoutAccount() async {
    var response = UserRepository().logoutUser();
    return response;
  }

  //* reset password using firebase auth

  Future<bool> resetPassword({required String email}) async {
    var response = UserRepository().resetPassword(email: email);
    return response;
  }

  //* change password using firebase auth

  Future<bool> changePassword(
      {required String email,
      required String oldPassword,
      required String newPassword}) async {
    var response = UserRepository().changePassword(
      email: email,
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
    return response;
  }

  //* delete account using firebase auth

  Future<bool> deleteAccount(
      {required String email, required String password}) async {
    var response =
        UserRepository().deleteUser(email: email, password: password);
    return response;
  }

  //* sign in with google using firebase auth

  Future<bool> signInWithGoogle() async {
    var response = UserRepository().signInWithGoogle();
    return response;
  }
}
