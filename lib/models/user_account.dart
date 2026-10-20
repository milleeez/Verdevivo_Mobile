class UserAccount {
  final String name;
  final String email;
  final String password;
  final DateTime createdAt;

  UserAccount({
    required this.name,
    required this.email,
    required this.password,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'password': password,
    'createdAt': createdAt.toIso8601String(),
  };

  factory UserAccount.fromJson(Map<String, dynamic> json) => UserAccount(
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    password: json['password'] ?? '',
    createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
  );
}

class AuthResult {
  final bool ok;
  final String? error;
  final UserAccount? account;

  AuthResult({required this.ok, this.error, this.account});
}
