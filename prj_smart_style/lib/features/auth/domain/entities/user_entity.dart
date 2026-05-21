class UserEntity {
  final String id;
  final String fullName;
  final String email;
  final DateTime? privacyPolicyAcceptedAt;

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.email,
    this.privacyPolicyAcceptedAt,
  });
}
