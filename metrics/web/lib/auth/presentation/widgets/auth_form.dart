import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:metrics/auth/presentation/model/auth_error_message.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/auth/presentation/strings/auth_strings.dart';
import 'package:metrics/auth/presentation/widgets/auth_input_field.dart';
import 'package:provider/provider.dart';

/// Shows an authentication form to sign in.
class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  /// Minimum length of the password.
  static const _minPasswordLength = 6;

  /// Global key that uniquely identifies the [Form] widget and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  /// Controls the email text being edited.
  final TextEditingController _emailController = TextEditingController();

  /// Controls the password text being edited.
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AuthInputField(
            key: const Key(AuthStrings.email),
            label: AuthStrings.email,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
          ),
          AuthInputField(
            key: const Key(AuthStrings.password),
            label: AuthStrings.password,
            controller: _passwordController,
            obscureText: true,
            validator: _validatePassword,
          ),
          Selector<AuthNotifier, AuthErrorMessage>(
            selector: (_, state) => state.authErrorMessage,
            builder: (_, authErrorMessage, __) {
              if (authErrorMessage == null) return Container();

              return Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  authErrorMessage.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            },
          ),
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            alignment: Alignment.centerRight,
            child: RaisedButton(
              key: const Key(AuthStrings.signIn),
              onPressed: () => _submit(),
              child: const Text(AuthStrings.signIn),
            ),
          ),
        ],
      ),
    );
  }

  /// Checks if an email field is not empty and has the right format,
  /// otherwise returns an error message.
  String _validateEmail(String value) {
    if (value.isEmpty) {
      return AuthStrings.requiredEmailErrorMessage;
    }

    if (!EmailValidator.validate(value)) {
      return AuthStrings.invalidEmailErrorMessage;
    }

    return null;
  }

  /// Checks if a password field is not empty and match the minimum length,
  /// otherwise returns an error message.
  String _validatePassword(String value) {
    if (value.isEmpty) {
      return AuthStrings.requiredPasswordErrorMessage;
    }

    if (value.length < _minPasswordLength) {
      return AuthStrings.getPasswordMinLengthErrorMessage(_minPasswordLength);
    }

    return null;
  }

  /// Starts sign in process
  void _submit() {
    if (_formKey.currentState.validate()) {
      Provider.of<AuthNotifier>(context, listen: false)
          .signInWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}