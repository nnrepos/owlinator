import 'package:flutter/material.dart';
import 'Authentication.dart';

class LoginRegisterPage extends StatefulWidget {
  LoginRegisterPage({required this.auth, required this.onSignedIn});
  final AuthImplementation auth;
  final VoidCallback onSignedIn;

  @override
  _LoginRegisterPageState createState() => _LoginRegisterPageState();
}

enum FormType { login, register }

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  final formKey = new GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String _email = '';
  String _password = '';

  //methods
  bool validateAndSave() {
    final form = formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit() async {
    if(validateAndSave()){
      try {
        if(_formType == FormType.login){
          String userId = await widget.auth.signIn(_email, _password);
          print("userId: " + userId + " logged in");

        } else {
          String userId = await widget.auth.signUp(_email, _password);
          print("userId: " + userId + " sign up");
        }

        widget.onSignedIn();
      }
      catch(e){
        print("Error: " + e.toString());
      }
    }
  }

  void moveToRegister() {
    formKey.currentState!.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState!.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: _formType == FormType.login ? Text("Login") : Text("Register")
        ),
        body: Container(
            margin: EdgeInsets.all(15.0),
            child: Form(
                key: formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: createInputs() + createButtons())
            )
        )
    );
  }

  List<Widget> createInputs() {
    return [
      SizedBox(height: 10.0),
      logo(),
      SizedBox(height: 20.0),
      TextFormField(
          decoration: InputDecoration(labelText: 'Email'),
          validator: (email) {
            if (email == null || email.isEmpty) {
              return 'Please enter an email';
            } else {
              bool emailValid = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(email);
              if (!emailValid) {
                return 'Please enter a valid email';
              }
            }
            return null;
          },
          onSaved: (value) {
            _email = value!;
          }),
      SizedBox(height: 10.0),
      TextFormField(
          decoration: InputDecoration(labelText: 'Password'),
          obscureText: true,
          validator: (pass) {
            if (pass == null) {
              return 'Password is required';
            } else if (pass.isEmpty) {
              return 'Password is required';
            }
            return null;
          },
          onSaved: (value) {
            _password = value!;
          }),
      SizedBox(height: 20.0),
    ];
  }

  Widget logo() {
    return Hero(
      tag:'Hero',
      child: Text('Logo')
    );
  }

  List<Widget> createButtons(){
    if(_formType == FormType.login) {
      return [
        TextButton(
          child: Text('Do Not Have an Account? Create Account', style: TextStyle(fontSize: 13.0)),
          style: TextButton.styleFrom(primary: Colors.red),
          onPressed: moveToRegister
        ),
        TextButton(
            child: Text('Login', style: TextStyle(fontSize: 20.0)),
            style: TextButton.styleFrom(primary: Colors.white, backgroundColor: Colors.green),
            onPressed: validateAndSubmit
        ),
      ];
    } else {
      return [
        TextButton(
            child: Text('Already Have an Account? Login', style: TextStyle(fontSize: 13.0)),
            style: TextButton.styleFrom(primary: Colors.red),
            onPressed: moveToLogin
        ),
        TextButton(
            child: Text('Create Account', style: TextStyle(fontSize: 20.0)),
            style: TextButton.styleFrom(primary: Colors.white, backgroundColor: Colors.green),
            onPressed: validateAndSubmit
        ),
      ];

    }
  }
}