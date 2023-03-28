import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final auth = FirebaseAuth.instance;

  var _isLoading = false;
  var _isLogin = true;
   final _formKey = GlobalKey<FormState>();

  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  void _submitAuthForm(
    String email,
    String password,
    String userName,
    bool isLogin,
    BuildContext ctx,
  ) async {
    // ignore: unused_local_variable
    UserCredential userCredential;
    try {
      setState(() {
         _isLoading = true;
      });
      if (isLogin) {
        userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      } else {
        userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      }
    } on PlatformException catch (err) {
      var message = "An error occured please check your credentails";

      if (err.message != null) {
        message = err.message!;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ));

      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      // ignore: avoid_print
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      _submitAuthForm(_userEmail.trim(), _userPassword.trim(), _userName.trim(),
          _isLogin, context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _isLogin
          ? const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/login.png'), fit: BoxFit.cover),
            )
          : const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/register.png'), fit: BoxFit.cover),
            ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 35, top: 130),
              child: Text(
                _isLogin ? 'Welcome\nBack' : 'Create\nAccount',
                style: const TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   SingleChildScrollView(
      reverse: true,
      padding: const EdgeInsets.only(
        top: 35,
        left: 25,
      ),
      child: Column(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Container(
                      padding: const EdgeInsets.only(
                          top: 54.0, left: 20.0, right: 30.0),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            key: const ValueKey('email'),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                labelText: 'EMAIL',
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                )),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            enableSuggestions: false,
                            validator: (value) {
                              if (value!.isEmpty || !value.contains('@')) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _userEmail = value!;
                            },
                          ),
                          if (!
                          _isLogin) const SizedBox(height: 20.0),
                          if (!
                          _isLogin)
                            TextFormField(
                              key: const ValueKey('username'),
                              decoration: InputDecoration(
                                  labelText: 'USERNAME',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  labelStyle:
                                      const TextStyle(color: Colors.black),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  )),
                              autocorrect: true,
                              textCapitalization: TextCapitalization.words,
                              enableSuggestions: false,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a username';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _userName = value!;
                              },
                              // ignore: missing_return
                            ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            key: const ValueKey('password'),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              labelText: 'PASSWORD',
                              labelStyle: const TextStyle(color: Colors.black),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            obscureText: true,

                            // ignore: missing_return
                            validator: (value) {
                              if (value!.isEmpty || value.length < 7) {
                                return 'Please enter a long password';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _userPassword = value!;
                            },
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          if (
                            _isLoading)
                            const CircularProgressIndicator(
                              strokeWidth: 1.0,
                            ),
                          if (!
                          _isLoading)
                            SizedBox(
                              height: 40.0,
                              child: Material(
                                borderRadius: BorderRadius.circular(5.0),
                                shadowColor: Colors.black,
                                color: Colors.black,
                                elevation: 10.0,
                                child: TextButton(
                                  onPressed: _trySubmit,
                                  child: Center(
                                    child: Text(
                                      
                                      _isLogin ? "Login" : "Sign up",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(
                            height: 25,
                          ),
                          if (!
                          _isLoading)
                            SizedBox(
                              height: 40.0,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    
                                    _isLogin = !
                                    _isLogin;
                                  });
                                },
                                child: Center(
                                  child: Text(
                                    
                                    _isLogin
                                        ? "Create new account"
                                        : "I already have an account",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          Padding(
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context)
                                      .viewInsets
                                      .bottom)),
                        ],
                      )),
                ),
              ),
            ],
          ),
        ],
      ),
    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
