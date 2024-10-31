class User {
  final String userName;
  final String otp;

  User({required this.userName, required this.otp});

  Map<String, String> toJson() {
    return {
      'userName': userName,
      'otp': otp,
    };
  }
}
