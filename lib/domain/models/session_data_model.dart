/// Hold user information related to their session.
class SessionData {
  final String uid;
  final String username;
  final String email;
  final DateTime expiresAt;
  final String? avatar;

  SessionData({
    required this.uid,
    required this.username,
    required this.email,
    required this.expiresAt,
    this.avatar,
  });
}
