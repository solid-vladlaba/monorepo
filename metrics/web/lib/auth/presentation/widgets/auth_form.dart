import 'package:flutter/material.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/auth/presentation/strings/auth_strings.dart';
import 'package:metrics/auth/presentation/validators/email_validator.dart';
import 'package:metrics/auth/presentation/validators/password_validator.dart';
import 'package:metrics/auth/presentation/widgets/sign_in_option_button.dart';
import 'package:metrics/auth/presentation/widgets/strategy/google_sign_in_option_appearance_strategy.dart';
import 'package:metrics/base/presentation/widgets/tappable_area.dart';
import 'package:metrics/common/presentation/button/widgets/metrics_positive_button.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/widgets/metrics_text_form_field.dart';
import 'package:provider/provider.dart';

/// Shows an authentication form to sign in.
class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  /// Global key that uniquely identifies the [Form] widget and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  /// Controls the email text being edited.
  final TextEditingController _emailController = TextEditingController();

  /// Controls the password text being edited.
  final TextEditingController _passwordController = TextEditingController();

  /// Indicates whether to hide the password or not.
  bool _isPasswordObscure = true;

  @override
  Widget build(BuildContext context) {
    final iconColor =
        MetricsTheme.of(context).loginTheme.passwordVisibilityIconColor;
    final passwordIcon =
        _isPasswordObscure ? 'icons/eye_on.svg' : 'icons/eye_off.svg';

    return Consumer<AuthNotifier>(
      builder: (_, notifier, __) {
        return Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MetricsTextFormField(
                key: const Key(AuthStrings.email),
                controller: _emailController,
                validator: EmailValidator.validate,
                errorText: notifier.emailErrorMessage,
                hint: AuthStrings.email,
                keyboardType: TextInputType.emailAddress,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: MetricsTextFormField(
                  key: const Key(AuthStrings.password),
                  controller: _passwordController,
                  validator: PasswordValidator.validate,
                  errorText: notifier.passwordErrorMessage,
                  obscureText: _isPasswordObscure,
                  hint: AuthStrings.password,
                  suffixIcon: TappableArea(
                    onTap: _changePasswordObscure,
                    builder: (context, isHovered, child) => child,
                    child: Image.network(
                      passwordIcon,
                      color: iconColor,
                    ),
                  ),
                ),
              ),
              if (notifier.isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: LinearProgressIndicator(),
                ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, top: 72.0),
                child: MetricsPositiveButton(
                  key: const Key(AuthStrings.signIn),
                  onPressed: notifier.isLoading ? null : () => _submit(),
                  label: AuthStrings.signIn,
                ),
              ),
              SignInOptionButton(
                strategy: GoogleSignInOptionAppearanceStrategy(),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Starts sign in process.
  void _submit() {
    if (_formKey.currentState.validate()) {
      Provider.of<AuthNotifier>(context, listen: false)
          .signInWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
    }
  }

  /// Changes the [_isPasswordObscure] value to the opposite one.
  void _changePasswordObscure() {
    setState(() => _isPasswordObscure = !_isPasswordObscure);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
