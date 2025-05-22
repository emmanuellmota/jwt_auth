import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_auth/bloc/jwt_authentication_bloc.dart';
import 'package:jwt_auth/bloc/jwt_authentication_event.dart';
import 'dart:async';

import 'package:jwt_auth/jwt_authentication_repository.dart';
import 'package:jwt_auth/models/jwt_auth_config.dart';
import 'package:jwt_auth/models/jwt_auth_log_level.dart';
import 'package:jwt_auth_example/app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final JwtAuthenticationRepository _authenticationRepository;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    super.initState();

    _authenticationRepository = JwtAuthenticationRepository(
      config: JwtAuthConfig(
        tokenUrl: 'http://10.0.2.2:5244/api/v1/auth/token',
        refreshUrl: 'http://10.0.2.2:5244/api/v1/auth/refreshToken',
        logLevel: JwtAuthLogLevel.none,
      ),
    );
  }

  @override
  void dispose() {
    _authenticationRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: BlocProvider(
        lazy: false,
        create: (_) => JwtAuthenticationBloc(
          authenticationRepository: _authenticationRepository,
        )..add(JwtAuthenticationInitializationRequested()),
        child: const AppView(),
      ),
    );
  }
}
