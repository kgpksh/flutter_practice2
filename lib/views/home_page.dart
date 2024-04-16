import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice2/bloc/auth/auth_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(AuthInitialEvent());
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('HomePage'),
            actions: [
              Visibility(
                  visible: state is AuthLoggedIn && state.isVerified,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/storeManage');
                    },
                    child: Text('Manage my store'),
                  )),
              Visibility(
                  visible: state is AuthLoggedIn && !state.isVerified,
                  child: TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(FirebaseEmailVerifyEvent());
                    },
                    child: Text('Verify account'),
                  )),
              Visibility(
                visible: state is! AuthLoggedIn,
                child: TextButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/loginView'),
                  child: Text('Log in'),
                ),
              ),
              Visibility(
                visible: state is AuthLoggedIn,
                child: TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(FirebaseEmailLogoutEvent());
                  },
                  child: Text('Log out'),
                ),
              ),
              SizedBox(
                width: 30,
              )
            ],
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                ClipRect(
                    child: Stack(
                  children: [
                    Positioned.fill(
                        child: Container(
                      color: Colors.greenAccent,
                    )),
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/webApiList'),
                      child: Text('WebApiList'),
                    ),
                  ],
                )),
                const SizedBox(
                  height: 50,
                ),
                ClipRect(
                    child: Stack(
                  children: [
                    Positioned.fill(
                        child: Container(
                      color: Colors.greenAccent,
                    )),
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/cubitWebApiList'),
                      child: Text('CubitWebApiList'),
                    ),
                  ],
                )),
                const SizedBox(
                  height: 50,
                ),
                ClipRect(
                    child: Stack(
                  children: [
                    Positioned.fill(
                        child: Container(
                      color: Colors.greenAccent,
                    )),
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/cubitCopyWith'),
                      child: Text('CubitCopyWith'),
                    ),
                  ],
                )),
                const SizedBox(
                  height: 50,
                ),
                ClipRect(
                    child: Stack(
                      children: [
                        Positioned.fill(
                            child: Container(
                              color: Colors.greenAccent,
                            )),
                        TextButton(
                          onPressed: () =>
                              Navigator.of(context).pushNamed('/showStores'),
                          child: Text('Show Stores State'),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        );
      },
    );
  }
}
