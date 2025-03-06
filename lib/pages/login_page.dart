import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart';
import '../widgets/login/login_button.dart';
import '../widgets/login/login_header.dart';
import '../controllers/auth_controller.dart';
import '../widgets/login/connexion_form.dart'; // Importez ConnexionForm
import '../widgets/login/sign_up_form.dart'; // Importez SignupForm
import '../widgets/login/troubles_form.dart'; // Importez TroublesForm
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/settings_bloc.dart';

enum ViewState { initial, connexion, signup, troubles }

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  ViewState _currentView = ViewState.initial;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController signupEmailController = TextEditingController();
  final TextEditingController signupPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final Auth _auth = Auth();

  void _handleBackButton() {
    setState(() {
      if (_currentView == ViewState.connexion || _currentView == ViewState.signup) {
        _currentView = ViewState.initial;
      } else if (_currentView == ViewState.troubles) {
        _currentView = ViewState.signup;
      }
    });
  }

  void _login() async {
    try {
      final settingsBloc = context.read<SettingsBloc>();
      await _auth.signInWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
        settingsBloc,
      );
      Get.offNamed('/main');
    } catch (e) {
      Get.snackbar('Erreur', 'Connexion échouée : ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> _signUp() async {
    if (signupPasswordController.text != confirmPasswordController.text) {
      Get.snackbar(
        "Erreur",
        "Les mots de passe ne correspondent pas",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      final settingsBloc = context.read<SettingsBloc>();
      await _auth.createUserWithEmailAndPassword(
        signupEmailController.text.trim(),
        signupPasswordController.text.trim(),
        settingsBloc,
      );

      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        setState(() {
          _currentView = ViewState.troubles;
        });
      } else {
        Get.snackbar(
          "Erreur",
          "Inscription réussie mais impossible de se connecter",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Erreur",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Widget _buildContent() {
    switch (_currentView) {
      case ViewState.connexion:
        return buildConnexionContent();
      case ViewState.signup:
        return buildSignupContent();
      case ViewState.troubles:
        return buildTroublesContent();
      default:
        return buildInitialButtons();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // En-tête avec le contrôle du bouton de retour
          LoginHeader(
            isBackButtonEnabled: _currentView != ViewState.initial,
            onBackButtonPressed: _handleBackButton,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInitialButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 150),
          // Bouton "Se connecter"
          LoginButton(
            text: "SE CONNECTER",
            onPressed: () {
              setState(() {
                _currentView = ViewState.connexion;
              });
            },
          ),
          const SizedBox(height: 30),
          // Bouton "S'inscrire"
          LoginButton(
            text: "S'INSCRIRE",
            onPressed: () {
              setState(() {
                _currentView = ViewState.signup;
              });
            },
            isOutlined: true,
          ),
        ],
      ),
    );
  }

  Widget buildConnexionContent() {
    return ConnexionForm(
      emailController: emailController,
      passwordController: passwordController,
      onLoginPressed: _login,
      onSignupLinkPressed: () {
        setState(() {
          _currentView = ViewState.signup;
        });
      },
    );
  }

  Widget buildSignupContent() {
    return SignupForm(
      emailController: signupEmailController,
      passwordController: signupPasswordController,
      confirmPasswordController: confirmPasswordController,
      onSignupPressed: _signUp,
      onLoginLinkPressed: () {
        setState(() {
          _currentView = ViewState.connexion;
        });
      },
    );
  }

  Widget buildTroublesContent() {
    return TroublesForm(
      onTroublesSaved: () {
        Get.off(() => const MainPage());
      },
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    signupEmailController.dispose();
    signupPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
