# Flutter JWT Authentication Plugin

This plugin provides an easy-to-use JWT (JSON Web Token) authentication solution for Flutter applications. It simplifies token storage, retrieval, and renewal, allowing for secure and seamless user session management.

## Features

- **Login & Logout**: Easily authenticate users and clear sessions.
- **Token Storage**: Securely store and access tokens using `flutter_secure_storage`.
- **Token Renewal**: Automatically manage token expiration and refresh.
- **State management**: Useful state management with Bloc.

## Installation

Add the plugin to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_jwt_auth: ^1.0.0
  flutter_secure_storage: ^5.0.2
  dio: ^5.7.0
  flutter_bloc: ^8.1.6
```

flutter pub get

## Usage

This plugin uses some library, the most important is Bloc for state management and Dio for http client request management.
Dio is useful for the interceptors feature. This plugin automatically refresh token when expired.

### Initialize the Plugin

Initialize the plugin with any required configuration before using it. This should typically be done at the start of your app, such as in the main method.

```dart
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
  final Dio = Dio();
  late final JwtAuthenticationRepository _authenticationRepository;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    super.initState();

    _authenticationRepository = JwtAuthenticationRepository(
      config: JwtAuthConfig(
        tokenUrl: 'http://10.0.2.2:5244/api/v1/auth/token', //your login endpoint
        refreshUrl: 'http://10.0.2.2:5244/api/v1/auth/refreshToken', //your refreshToken endpoint
        logLevel: JwtAuthLogLevel.none,
      ),
    );

    dio.interceptors.add(JwtAuthenticationInterceptor(repository)); //for authomatically refresh token
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
```


