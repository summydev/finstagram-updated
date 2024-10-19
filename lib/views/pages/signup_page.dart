import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:finstagram/model/services/service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SignupPageState();
  }
}

class _SignupPageState extends State<SignupPage> {
  double? _deviceHeight, _deviceWidth;
  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();
  String? name, email, password;
  File? image;
  FirebaseService? _firebaseService;
  bool _isLoading = false;
  String? _signupError;

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
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _textTitle(),
                  SizedBox(height: 20), // Added spacing
                  _profileImageWidget(),
                  SizedBox(height: 20), // Added spacing
                  _signupForm(),
                  if (_signupError != null) _errorMessage(),
                  SizedBox(height: 20), // Added spacing
                  _signupButton(),
                  SizedBox(height: 10), //
                  _loginPageLink(),
                  if (_isLoading) _loadingIndicator(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _textTitle() {
    return const Text(
      'F-instagram',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 38,
        color: Colors.redAccent, // Branded color
      ),
    );
  }

  Widget _signupButton() {
    return MaterialButton(
      onPressed: _isLoading ? null : _registerUser,
      minWidth: _deviceWidth! * 0.6,
      height: _deviceHeight! * 0.07,
      color: Colors.redAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30), // Rounded button
      ),
      child: const Text(
        'Sign Up',
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevation: 5, // Add elevation for a shadow effect
    );
  }

  Widget _signupForm() {
    return Form(
      key: _signupFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _nameTextField(),
          SizedBox(height: 20), // Spacing between fields
          _emailTextField(),
          SizedBox(height: 20), // Spacing between fields
          _passwordTextField(),
        ],
      ),
    );
  }

  Widget _nameTextField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Name',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15), // Rounded borders
        ),
        filled: true,
        fillColor: Colors.grey[200], // Light background color
        contentPadding: EdgeInsets.all(15),
      ),
      validator: (value) => value!.isNotEmpty ? null : 'Please enter a name',
      onSaved: (value) {
        setState(() {
          name = value;
        });
      },
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15), // Rounded borders
        ),
        filled: true,
        fillColor: Colors.grey[200], // Light background color
        contentPadding: EdgeInsets.all(15),
      ),
      validator: (value) {
        bool result = value!.contains(
          RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'),
        );
        return result ? null : "Please enter a valid email";
      },
      onChanged: (value) {
        setState(() {
          email = value;
        });
      },
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password **',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15), // Rounded borders
        ),
        filled: true,
        fillColor: Colors.grey[200], // Light background color
        contentPadding: EdgeInsets.all(15),
      ),
      validator: (value) {
        return value!.length > 6
            ? null
            : "Please enter a password greater than 6 characters";
      },
      onChanged: (value) {
        setState(() {
          password = value.toString();
        });
      },
    );
  }

  Widget _profileImageWidget() {
    var imageProvider = image != null
        ? FileImage(image!)
        : const NetworkImage(
        'https://images.pexels.com/photos/3761264/pexels-photo-3761264.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1');
    return GestureDetector(
      onTap: () {
        FilePicker.platform.pickFiles(type: FileType.image).then((result) {
          setState(() {
            image = File(result!.files.first.path!);
          });
        });
      },
      child: CircleAvatar(
        radius: _deviceWidth! * 0.15,
        backgroundImage: imageProvider as ImageProvider,
        backgroundColor: Colors.grey[200],
        child: image == null
            ? Icon(Icons.add_a_photo, size: 50, color: Colors.grey[700])
            : null,
      ),
    );
  }

  Widget _loadingIndicator() {
    return const CircularProgressIndicator();
  }

  Widget _errorMessage() {
    return Text(
      _signupError!,
      style: const TextStyle(color: Colors.red, fontSize: 16),
    );
  }

  void _registerUser() async {
    if (_signupFormKey.currentState!.validate() && image != null) {
      setState(() {
        _isLoading = true;
        _signupError = null;
      });
      _signupFormKey.currentState!.save();
      bool result = await _firebaseService!.registerUser(
          name: name!, email: email!, password: password!, image: image!);
      setState(() {
        _isLoading = false;
      });
      if (result) {
        Navigator.pop(context);
      } else {
        setState(() {
          _signupError = "Signup failed. Please try again.";
        });
      }
    } else {
      setState(() {
        _signupError = "Please fill out all fields and upload an image.";
      });
    }
  }
  Widget _loginPageLink() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, 'login'),
      child: const Text(
        'Have an account? Login',
        style: TextStyle(
          color: Colors.blue,
          fontSize: 20.0,
        ),
      ),
    );
  }
}
