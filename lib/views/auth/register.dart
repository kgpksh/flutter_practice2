import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice2/bloc/auth/auth_bloc.dart';
import 'package:flutter_practice2/secret_keys.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _spring_email;
  late final TextEditingController _spring_password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _spring_email = TextEditingController();
    _spring_password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _spring_email.dispose();
    _spring_password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFirebaseEmailRegistered) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Register'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                TextField(
                  controller: _email,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration:
                      const InputDecoration(hintText: 'Enter your email here'),
                ),
                TextField(
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                      hintText: 'Enter your password here'),
                ),
                TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(FirebaseEmailRegisterEvent(
                            email: _email.text,
                            password: _password.text,
                          ));
                    },
                    child: Text('Register')),
                const Divider(),

                TextField(
                  controller: _spring_email,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration:
                  const InputDecoration(hintText: 'Enter your email here'),
                ),
                TextField(
                  controller: _spring_password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                      hintText: 'Enter your password here'),
                ),
                TextButton(
                    onPressed: () async {
                      Dio dio = Dio(BaseOptions(baseUrl: 'http://${SecretKeys().localHost}:8080/'));
                      await dio.post('member/register', data: {
                        'username' : _spring_email.text,
                        'nickname' : 'nickname',
                        'password' : _spring_password.text
                      });
                    },
                    child: Text('Spring Register')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
