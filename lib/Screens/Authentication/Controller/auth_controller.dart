import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chatters_town/Models/user_model.dart';
import 'package:chatters_town/Screens/Authentication/repositary/auth_repositary.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(
    authRepository: authRepository,
    ref: ref,
  );
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;
  AuthController({
    required this.authRepository,
    required this.ref,
  });

  void signinWithEmailandPass(
      BuildContext context, String email, String password) {
    authRepository.signinWithEmail(context, email, password);
  }

  void creatNewUser(BuildContext context, String email, String password) {
    authRepository.creatNewUser(context, email, password);
  }

  void saveUserInfo(
    BuildContext context,
    String firstname,
    String lastname,
    String number,
    String profilepic,
    String userid,
    String username,
    String email,
    String password,
  ) async {
    UserModel user = UserModel(
        userid: userid,
        firstname: firstname,
        username: username,
        lastname: lastname,
        email: email,
        password: password,
        number: number,
        profilepicture: profilepic,
        isOnline: true);
    authRepository.saveUserInfoToFireBase(context, user);
  }

  Future readUser() => authRepository.readUser();

  Stream<UserModel> userDataById(String userId) {
    return authRepository.userData(userId);
  }

  void setUserState(bool isOnline) {
    authRepository.setUserState(isOnline);
  }
}
