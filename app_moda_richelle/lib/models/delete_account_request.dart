/// Request model for deleting user account
class DeleteAccountRequest {
  final String password;
  final bool confirmation;

  DeleteAccountRequest({
    required this.password,
    required this.confirmation,
  });

  Map<String, dynamic> toJson() {
    return {
      'password': password,
      'confirmation': confirmation,
    };
  }
}