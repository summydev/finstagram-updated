import 'package:finstagram/model/services/service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  FirebaseService? _firebaseService;
  double? _deviceHeight, _deviceWidth;
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool _isLoading = false; // For showing loading state
  String? _loginError; // For displaying error messages

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _textTitle(),
              _loginForm(),
              if (_loginError != null) _errorMessage(), // Display error
              _loginButton(),
              _registerPageLink(),
              if (_isLoading) _loadingIndicator() // Display loading indicator
            ],
          ),
        ),
      ),
    );
  }

  Widget _textTitle() {
    return const Text(
      'F-instagram',
      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 38),
    );
  }

  Widget _loginButton() {
    return MaterialButton(
      onPressed: _isLoading ? null : loginUser, // Disable button if loading
      minWidth: _deviceWidth! * 0.76,
      height: _deviceHeight! * 0.06,
      color: Colors.redAccent,
      child: const Text(
        'Login',
        style: TextStyle(color: Colors.white, fontSize: 20.0),
      ),
    );
  }

  Widget _loginForm() {
    return SizedBox(
      height: _deviceHeight! * 0.20,
      child: Form(
        key: _loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _emailTextField(),
            _passwordTextField(),
          ],
        ),
      ),
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Email...',
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.email),
      ),
      onChanged: (value) {
        setState(() {
          email = value;
        });
      },
      validator: (value) {
        bool result = value!.contains(
            RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'));
        return result ? null : "Please enter a valid email";
      },
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      obscureText: true, // To hide password text
      decoration: InputDecoration(
        hintText: 'Password **',
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.lock),
      ),
      onChanged: (value) {
        setState(() {
          password = value.toString();
        });
      },
      validator: (value) {
        return value!.length > 6
            ? null
            : "Please enter a password greater than 6 characters";
      },
    );
  }

  Widget _loadingIndicator() {
    return const CircularProgressIndicator(); // Simple loading spinner
  }

  Widget _errorMessage() {
    return Text(
      _loginError!,
      style: const TextStyle(color: Colors.red, fontSize: 16),
    );
  }

  void loginUser() async {
    if (_loginFormKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _loginError = null;
      });

      bool result = await _firebaseService!.loginUser(
          email: email!, password: password!);

      setState(() {
        _isLoading = false;
      });

      if (result) {
        Navigator.popAndPushNamed(context, 'home');
      } else {
        setState(() {
          _loginError = "Login failed. Please check your credentials.";
        });
      }
    }
  }

  Widget _registerPageLink() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, 'signup'),
      child: const Text(
        'Don\'t have an account?',
        style: TextStyle(
          color: Colors.blue,
          fontSize: 20.0,
        ),
      ),
    );
  }
}

