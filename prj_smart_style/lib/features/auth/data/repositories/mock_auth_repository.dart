// import '../../domain/entities/user_entity.dart';
// import '../../domain/repositories/auth_repository.dart';

// class MockAuthRepository implements AuthRepository {
//   UserEntity? _currentUser;

//   @override
//   Future<UserEntity> login({
//     required String email,
//     required String password,
//   }) async {
//     await Future.delayed(const Duration(milliseconds: 800));

//     if (email != 'test@test.com' || password != 'Password1!') {
//       throw Exception('Invalid credentials');
//     }

//     _currentUser = const UserEntity(
//       id: "user_001",
//       fullName: 'Test Test',
//       email: 'test@test.com',
//       privacyPolicyAcceptedAt: null,
//     );

//     return _currentUser!;
//   }

//   @override
//   Future<UserEntity> register({
//     required String fullName,
//     required String email,
//     required String password,
//   }) async {
//     await Future.delayed(const Duration(milliseconds: 800));

//     _currentUser = UserEntity(
//       id: "user_002",
//       fullName: fullName,
//       email: email,
//       privacyPolicyAcceptedAt: DateTime.now(),
//     );

//     return _currentUser!;
//   }

//   @override
//   Future<void> logout() async {
//     await Future.delayed(const Duration(milliseconds: 300));
//     _currentUser = null;
//   }

//   @override
//   Future<UserEntity?> getCurrentUser() async {
//     await Future.delayed(const Duration(milliseconds: 300));
//     return _currentUser;
//   }

//   @override
//   Future<UserEntity> updateUserName({
//     required String userId,
//     required String fullName,
//   }) async {
//     await Future.delayed(const Duration(milliseconds: 500));

//     if (_currentUser == null) {
//       throw Exception('No current user');
//     }

//     _currentUser = UserEntity(
//       id: _currentUser!.id,
//       fullName: fullName,
//       email: _currentUser!.email,
//       privacyPolicyAcceptedAt: _currentUser!.privacyPolicyAcceptedAt,
//     );

//     return _currentUser!;
//   }
// }
