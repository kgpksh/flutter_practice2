import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice2/app_router.dart';
import 'package:flutter_practice2/bloc/auth/auth_bloc.dart';
import 'package:flutter_practice2/service/auth/firebase_email_provider.dart';
import 'package:flutter_practice2/views/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => FirebaseEmailProvider()),
      ],
      child: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(
          context.read<FirebaseEmailProvider>(),
        ),
        child: MaterialApp(
          onGenerateRoute: _appRouter.onGenerateroute,
          title: 'Flutter Practice2',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: HomePage(),
        ),
      ),
    );
  }
}
