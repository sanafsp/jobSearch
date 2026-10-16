class ChangePasswordModel {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  ChangePasswordModel({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });
}