import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jwt_auth/bloc/jwt_authentication_bloc.dart';
import 'package:jwt_auth/bloc/jwt_authentication_event.dart';
import 'package:jwt_auth/bloc/jwt_authentication_state.dart';
import 'package:jwt_auth/jwt_authentication_repository.dart';
import 'package:jwt_auth/models/jwt_response_error.dart';
import 'package:jwt_auth/models/jwt_token.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'jwt_authentication_bloc_test.mocks.dart';

// import 'jwt_authentication_repository_test.mocks.dart';

@GenerateMocks([JwtAuthenticationRepository])
void main() {
  late JwtAuthenticationRepository mockAuthenticationRepository;
  late JwtAuthenticationBloc authenticationBloc;

  setUp(() {
    mockAuthenticationRepository = MockJwtAuthenticationRepository();
    authenticationBloc = JwtAuthenticationBloc(
      authenticationRepository: mockAuthenticationRepository,
    );
  });

  tearDown(() {
    authenticationBloc.close();
  });

  group('JwtAuthenticationBloc', () {
    blocTest<JwtAuthenticationBloc, JwtAuthenticationState>(
      'emette [unauthenticated] se il token JWT è null durante l\'inizializzazione',
      build: () {
        when(mockAuthenticationRepository.initialize())
            .thenAnswer((_) async => null);
        when(mockAuthenticationRepository.jwtTokenStream)
            .thenAnswer((_) => Stream.value(null));
        return authenticationBloc;
      },
      act: (bloc) => bloc.add(JwtAuthenticationInitializationRequested()),
      expect: () => [const JwtAuthenticationState.unauthenticated()],
    );

    blocTest<JwtAuthenticationBloc, JwtAuthenticationState>(
      'emette [authenticated] se il login ha successo',
      build: () {
        when(mockAuthenticationRepository.login('username', 'password'))
            .thenAnswer((_) async => const JwtToken(
                  accessToken: 'jwtToken',
                  expiresAt: 1222,
                  refreshToken: 'refreshToken',
                  refreshTokenExpiresAt: 1222,
                  username: 'username',
                ));
        return authenticationBloc;
      },
      act: (bloc) => bloc.add(const JwtAuthenticationLoginRequested(
        username: 'username',
        password: 'password',
      )),
      expect: () => [
        JwtAuthenticationState.authenticated(const JwtToken(
          accessToken: 'jwtToken',
          expiresAt: 1222,
          refreshToken: 'refreshToken',
          refreshTokenExpiresAt: 1222,
          username: 'username',
        )),
      ],
    );

    blocTest<JwtAuthenticationBloc, JwtAuthenticationState>(
      'emette [error] se il login fallisce con JwtResponseError',
      build: () {
        when(mockAuthenticationRepository.login('username', 'password'))
            .thenThrow(JwtResponseError(
          isSuccess: false,
          message: 'Errore di login',
          stacktrace: 'An error occurred',
        ));
        return authenticationBloc;
      },
      act: (bloc) => bloc.add(const JwtAuthenticationLoginRequested(
        username: 'username',
        password: 'password',
      )),
      expect: () => [
        JwtAuthenticationState.error(JwtResponseError(
          isSuccess: false,
          message: 'Errore di login',
          stacktrace: 'An error occurred',
        )),
      ],
    );

    blocTest<JwtAuthenticationBloc, JwtAuthenticationState>(
      'emette [unauthenticated] quando si esegue il logout',
      build: () {
        when(mockAuthenticationRepository.logout()).thenReturn(null);
        return authenticationBloc;
      },
      act: (bloc) => bloc.add(JwtAuthenticationLogoutPressed()),
      expect: () => [
        const JwtAuthenticationState.unauthenticated(),
      ],
    );
  });
}

// import 'package:jwt_auth/bloc/jwt_authentication_bloc.dart';
// import 'package:jwt_auth/bloc/jwt_authentication_event.dart';
// import 'package:jwt_auth/bloc/jwt_authentication_state.dart';
// import 'package:jwt_auth/jwt_authentication_repository.dart';
// import 'package:test/test.dart';
// import 'package:bloc_test/bloc_test.dart';
// import 'package:mockito/mockito.dart';

// // Usa `Mockito` per creare una classe mock del repository
// class JwtAuthenticationRepositoryMock extends Mock
//     implements JwtAuthenticationRepository {}

// void main() {
//   late JwtAuthenticationRepositoryMock authenticationRepository;

//   setUp(() {
//     authenticationRepository = JwtAuthenticationRepositoryMock();
//   });

//   group(
//       JwtAuthenticationBloc(authenticationRepository: authenticationRepository),
//       () {
//     late JwtAuthenticationBloc jwtAuthenticationBloc;

//     setUp(() {
//       jwtAuthenticationBloc = JwtAuthenticationBloc(
//           authenticationRepository: authenticationRepository);
//     });

//     test('initial state is unknown', () {
//       expect(
//           jwtAuthenticationBloc.state, const JwtAuthenticationState.unknown());
//     });

//     blocTest(
//       'emits [1] when CounterIncrementPressed is added',
//       build: () => jwtAuthenticationBloc,
//       act: (bloc) => bloc..add(JwtAuthenticationInitializationRequested()),
//       expect: () => [1],
//     );
//   });
// }
