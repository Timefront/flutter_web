import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rts_web/inventory/inventory_controller.dart';
import 'package:rts_web/utils/constants.dart';
import 'package:rts_web/widgets/custom_snackbar.dart';

import '../API/API.dart';

class AuthController extends GetxController {

  String _email = "";
  String _password = "";
  String _forgottenEmail = "";
  String _authUID = "";
  String _errorMessage = "";
  bool _signingUp = false;
  bool _signingIn = false;
  bool _isOnSignUpMode = true;
  bool _sendingForgottenEmail = false;
  RxBool _isUserSignedIn = false.obs;

  get email => _email;
  get password => _password;
  get forgottenEmail => _forgottenEmail;
  get authUID => _authUID;
  get signingUp => _signingUp;
  get signingIn => _signingIn;
  get isOnSignUpMode => _isOnSignUpMode;
  get sendingForgottenEmail => _sendingForgottenEmail;
  get isUserSignedIn => _isUserSignedIn;
  get errorMessage => _errorMessage;

  var api = API();

  @override
  void onInit() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        _isUserSignedIn.value = false;
      } else {
        _isUserSignedIn.value = true;
        _authUID = user.uid;
      }
    });
    super.onInit();
  }

  void createUser() async {
    _signingUp = true;
    update();
    if (_email == "" || _password == "") {
      _errorMessage = "There are empty fields";
    } else {//TODO: Try this
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        ).then((value) {
          api.registerUser(_email, value.user!.uid);
          signInUser();
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          _errorMessage = 'Password is too weak';
        } else if (e.code == 'email-already-in-use') {
          _errorMessage = 'Email is already in use';
        }
      } catch (e) {
        print(e);
      }
      // await api.createFirebaseUser(_email, _password);
    }
    _signingUp = false;
    update();
  }

  void signInUser() async {
    _authUID = '';
    _signingIn = true;
    update();
    InventoryController inventoryController = Get.put(InventoryController());
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _password
      ).then((value) {
        _authUID = value.user!.uid;
        inventoryController.getUserAssets();
        update();
        Get.toNamed(INVENTORY);
        createSnackbar('success', "Welcome to Timefront!");
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        createSnackbar('error', "Email and password provided do not match");
      } else {
        createSnackbar('error', e.message.toString());
      }
    }
    _signingIn = false;
    update();
  }

  void getUserDetails(String uid) async {
    api.getUserDetails(uid);
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void resetPassword() async {
    _sendingForgottenEmail = true;
    update();
    await FirebaseAuth.instance.sendPasswordResetEmail(email: _forgottenEmail);
    _sendingForgottenEmail = false;
    update();
    createSnackbar('success', 'An email was sent to $_forgottenEmail!');
  }

  void changeMode() {
    _isOnSignUpMode = !_isOnSignUpMode;
    update();
  }

  void redirectTo(String name) {
    Get.toNamed(name);
  }

  void changeEmail(String email) {
    _email = email;
  }

  void changePassword(String password) {
    _password = password;
  }

  void changeForgottenEmail(String email) {
    _forgottenEmail = email;
  }

}