import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_auth/bloc/jwt_authentication_bloc.dart';
import 'package:jwt_auth/bloc/jwt_authentication_event.dart';
import 'package:jwt_auth/bloc/jwt_authentication_state.dart';
import 'package:jwt_auth/models/jwt_authentication_status.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Jwt Auth Example'),
        ),
        body: Column(
          children: [
            Center(
              child: BlocBuilder<JwtAuthenticationBloc, JwtAuthenticationState>(
                // bloc: blocAuthentication,
                builder: (context, state) {
                  switch (state.status) {
                    case JwtAuthenticationStatus.authenticated:
                      return const Text('authenticated');
                    case JwtAuthenticationStatus.unauthenticated:
                      return const Text('unauthenticated');
                    case JwtAuthenticationStatus.unknown:
                      return const Text('unknown');
                    case JwtAuthenticationStatus.error:
                      return const Text('error');
                    default:
                      return const Spacer();
                  }
                },
              ),
            ),
            Center(
              child: BlocBuilder<JwtAuthenticationBloc, JwtAuthenticationState>(
                // bloc: blocAuthentication,
                builder: (context, state) {
                  switch (state.status) {
                    case JwtAuthenticationStatus.authenticated:
                      return Column(
                        children: [
                          Text('Welcome ${state.username}'),
                          ElevatedButton(
                            onPressed: () => {
                              context
                                  .read<JwtAuthenticationBloc>()
                                  .add(JwtAuthenticationLogoutPressed()),
                            },
                            child: const Text('Logout'),
                          ),
                        ],
                      );
                    case JwtAuthenticationStatus.unauthenticated:
                    case JwtAuthenticationStatus.unknown:
                    case JwtAuthenticationStatus.error:
                      return Column(
                        children: [
                          ElevatedButton(
                            onPressed: () => {
                              context
                                  .read<JwtAuthenticationBloc>()
                                  .add(const JwtAuthenticationLoginRequested(
                                    username: "luca.evaroni@methodia.it",
                                    password: "x0y7|p!M5N9x",
                                  )),
                            },
                            child: const Text('Login'),
                          ),
                          Visibility(
                              visible:
                                  state.status == JwtAuthenticationStatus.error,
                              child: Text('Error: ${state.error?.message}')),
                        ],
                      );

                    default:
                      return const Spacer();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
