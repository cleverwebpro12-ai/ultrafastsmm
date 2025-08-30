// login_page.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '/services/auth_service.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final usernameController = useTextEditingController();
    final isLogin = useState(true);

    final formKey = GlobalKey<FormState>();

    // Use a theme extension for cleaner code
    final theme = Theme.of(context);
    final inputTheme = theme.inputDecorationTheme;
    final primaryColor = theme.primaryColor;
    final textTheme = theme.textTheme;

    // A helper function to create a themed InputDecoration
    InputDecoration themedInputDecoration(
      String labelText,
      String hintText,
      IconData icon,
    ) {
      return InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(icon),
        filled: inputTheme.filled,
        fillColor: inputTheme.fillColor,
        border: inputTheme.border,
        enabledBorder: inputTheme.enabledBorder,
        focusedBorder: inputTheme.focusedBorder,
        errorBorder: inputTheme.errorBorder,
        focusedErrorBorder: inputTheme.focusedErrorBorder,
        hintStyle: inputTheme.hintStyle,
        contentPadding: inputTheme.contentPadding,
      );
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.flash_on,
                    size: 60,
                    color: Color(0xFF0A84FF),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'UltrafastSMM',
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isLogin.value
                        ? 'Sign in to your SMM panel account'
                        : 'Join UltrafastSMM and boost your social media',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: textTheme.bodyMedium?.color?.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 40),
                  if (!isLogin.value)
                    Column(
                      children: [
                        TextFormField(
                          controller: usernameController,
                          decoration: themedInputDecoration(
                            'Full Name',
                            'Enter your full name',
                            Icons.person,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a full name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: themedInputDecoration(
                      'Email Address',
                      'Enter your email',
                      Icons.email,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: themedInputDecoration(
                      'Password',
                      'Enter your password',
                      Icons.lock,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        if (isLogin.value) {
                          await ref
                              .read(authServiceProvider)
                              .signInWithEmail(
                                emailController.text,
                                passwordController.text,
                              );
                        } else {
                          await ref
                              .read(authServiceProvider)
                              .signUpWithEmail(
                                emailController.text,
                                passwordController.text,
                                usernameController.text,
                              );
                        }
                      }
                    },
                    child: Text(
                      isLogin.value ? 'Sign In' : 'Create Account',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      isLogin.value = !isLogin.value;
                      formKey.currentState?.reset();
                      emailController.clear();
                      passwordController.clear();
                      usernameController.clear();
                    },
                    child: Text(
                      isLogin.value
                          ? 'Don\'t have an account? Sign up'
                          : 'Already have an account? Sign in',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
