
import 'package:dynamic_delivery/src/repository/authentication_repository.dart';
import 'package:dynamic_delivery/src/repository/user_repository.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController{
  static ProfileController get instance=>Get.find();

  final _authRepo=Get.put(AuthenticationRepository());
  final _userRepo=Get.put(UserRepository());

  getUserData(){
    final email=_authRepo.firebaseUser.value?.email;
    if(email!=null){
      return _userRepo.getUserDetails(email);
    }
    else{
      Get.snackbar("Error", "Login to continue ");
    }
  }
}