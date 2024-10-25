class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? password;
  final String? role;

  UserModel(
    this.id,
    this.name,
    this.email,
    this.password,
    this.role,
  );

  //# Object for fetch from Firebase
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      map['id'],
      map['name'],
      map['email'],
      map['password'],
      map['role'],
    );
  }

  //# Object for saving to Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role,
    };
  }
}
