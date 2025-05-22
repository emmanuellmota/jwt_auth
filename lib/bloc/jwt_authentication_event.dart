sealed class JwtAuthenticationEvent {
  const JwtAuthenticationEvent();
}

final class JwtAuthenticationInitializationRequested
    extends JwtAuthenticationEvent {}

// final class JwtAuthenticationSubscriptionRequested
//     extends JwtAuthenticationEvent {}

final class JwtAuthenticationRefreshTokenRequested
    extends JwtAuthenticationEvent {}

final class JwtAuthenticationLoginRequested extends JwtAuthenticationEvent {
  final String username;
  final String password;

  const JwtAuthenticationLoginRequested({
    required this.username,
    required this.password,
  });
}

final class JwtAuthenticationLogoutPressed extends JwtAuthenticationEvent {}
