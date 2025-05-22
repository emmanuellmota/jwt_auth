import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_auth/bloc/jwt_authentication_event.dart';
import 'package:jwt_auth/bloc/jwt_authentication_state.dart';
import 'package:jwt_auth/jwt_authentication_repository.dart';
import 'package:jwt_auth/models/jwt_response_error.dart';

class JwtAuthenticationBloc
    extends Bloc<JwtAuthenticationEvent, JwtAuthenticationState> {
  final JwtAuthenticationRepository _authenticationRepository;

  JwtAuthenticationBloc({
    required JwtAuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const JwtAuthenticationState.unknown()) {
    on<JwtAuthenticationInitializationRequested>(_onInitializationRequested);
    // on<JwtAuthenticationSubscriptionRequested>(_onSubscriptionRequested);
    on<JwtAuthenticationLoginRequested>(_onLoginRequested);
    // on<JwtAuthenticationRefreshTokenRequested>(_onRefreshTokenRequested);
    on<JwtAuthenticationLogoutPressed>(_onLogoutPressed);
  }

  Future<void> _onInitializationRequested(
    JwtAuthenticationInitializationRequested event,
    Emitter<JwtAuthenticationState> emit,
  ) async {
    try {
      await _authenticationRepository.initialize();

      return emit.onEach(
        _authenticationRepository.jwtTokenStream,
        onData: (jwtToken) async {
          if (jwtToken == null) {
            return emit(const JwtAuthenticationState.unauthenticated());
          } else {
            return emit(JwtAuthenticationState.authenticated(jwtToken));
          }
        },
        onError: addError,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Future<void> _onSubscriptionRequested(
  //   JwtAuthenticationSubscriptionRequested event,
  //   Emitter<JwtAuthenticationState> emit,
  // ) {
  //   return emit.onEach(
  //     _authenticationRepository.statusStream,
  //     onData: (status) async {
  //       switch (status) {
  //         case JwtAuthenticationStatus.unauthenticated:
  //           return emit(const JwtAuthenticationState.unauthenticated());
  //         case JwtAuthenticationStatus.authenticated:
  //           final jwtToken = _authenticationRepository.jwtToken;
  //           return emit(
  //             jwtToken != null
  //                 ? JwtAuthenticationState.authenticated(jwtToken)
  //                 : const JwtAuthenticationState.unauthenticated(),
  //           );
  //         case JwtAuthenticationStatus.unknown:
  //           return emit(const JwtAuthenticationState.unknown());
  //       }
  //     },
  //     onError: addError,
  //   );
  // }

  void _onLogoutPressed(
    JwtAuthenticationLogoutPressed event,
    Emitter<JwtAuthenticationState> emit,
  ) {
    _authenticationRepository.logout();
    return emit(const JwtAuthenticationState.unauthenticated());
  }

  Future<void> _onLoginRequested(
    JwtAuthenticationLoginRequested event,
    Emitter<JwtAuthenticationState> emit,
  ) async {
    try {
      var jwtToken =
          await _authenticationRepository.login(event.username, event.password);
      return emit(JwtAuthenticationState.authenticated(jwtToken));
    } on JwtResponseError catch (e) {
      return emit(JwtAuthenticationState.error(e));
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    // print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }
  // JwtToken? _tryGetUser() async {
  //   return _authenticationRepository.jwtToken;
  // }
}
