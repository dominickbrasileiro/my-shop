import 'package:flutter/material.dart';
import 'package:fshop/core/exceptions/auth_exception.dart';
import 'package:fshop/providers/auth_provider.dart';
import 'package:provider/provider.dart';

enum AuthMode {
  Register,
  Login,
}

class AuthCardWidget extends StatefulWidget {
  @override
  _AuthCardWidgetState createState() => _AuthCardWidgetState();
}

class _AuthCardWidgetState extends State<AuthCardWidget> {
  bool _isLoading = false;
  AuthMode _authMode = AuthMode.Login;
  late TextEditingController _passwordController;

  final _formKey = GlobalKey<FormState>();

  final Map<String, String> _authFormData = {
    'email': '',
    'password': '',
  };

  void _showErrorDialog(String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Auth Error'),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _formKey.currentState!.save();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      if (_authMode == AuthMode.Login) {
        await authProvider.login(
          _authFormData['email']!,
          _authFormData['password']!,
        );
      } else {
        await authProvider.signUp(
          _authFormData['email']!,
          _authFormData['password']!,
        );
      }
    } on AuthException catch (e) {
      _showErrorDialog('$e.');
    } catch (e) {
      _showErrorDialog('An unexpected error ocurred.');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    setState(() {
      if (_authMode == AuthMode.Login) {
        _authMode = AuthMode.Register;
      } else {
        _authMode = AuthMode.Login;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: screenSize.width * 0.75,
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'E-mail is required';
                  }

                  if (!value.contains('@')) {
                    return 'Invalid format';
                  }

                  return null;
                },
                onSaved: (value) => _authFormData['email'] = value!,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }

                  if (value.length < 6) {
                    return 'Password must contain 6 characters at least';
                  }

                  return null;
                },
                onSaved: (value) => _authFormData['password'] = value!,
              ),
              if (_authMode == AuthMode.Register)
                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Password Confirmation'),
                  keyboardType: TextInputType.emailAddress,
                  obscureText: true,
                  validator: _authMode == AuthMode.Register
                      ? (value) {
                          if (value != _passwordController.text) {
                            return 'Passwords does not match';
                          }

                          return null;
                        }
                      : null,
                ),
              SizedBox(height: 20),
              if (_isLoading)
                Container(
                  height: 32,
                  width: 32,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                )
              else
                ElevatedButton(
                  onPressed: !_isLoading ? _submit : null,
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 8,
                      ),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  child:
                      Text(_authMode == AuthMode.Login ? 'Login' : 'Register'),
                ),
              if (!_isLoading)
                TextButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                    _authMode == AuthMode.Login ? 'Register' : 'Back to Login',
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
