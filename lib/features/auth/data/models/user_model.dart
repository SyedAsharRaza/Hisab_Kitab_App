import '../../domain/entities/user_entity.dart';

// data layer
class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
    required super.name,
  });
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String? ?? '',
      email: map['email'] as String? ?? '',
      name: map['name'] as String? ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
    };
  }
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(uid: entity.uid, email: entity.email, name: entity.name);
  }
}