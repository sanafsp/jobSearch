import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_project/Constants/core/color.dart';
import 'package:job_project/Model/logged_user_model.dart';
import 'package:job_project/Repository/local_storage.dart';
import 'package:job_project/Utils/validations_utils.dart';
import 'package:job_project/View/jobSeeker/profile.dart';
import 'package:job_project/View/jobSeeker/resume.dart';
import 'package:job_project/View/login/signin.dart';

import '../../Constants/app_styles.dart';

final TextEditingController _currentPasswordController =
    TextEditingController();
final TextEditingController _newPasswordController = TextEditingController();
final TextEditingController _confirmPasswordController =
    TextEditingController();

class AdminDrawer extends StatelessWidget {
  final String userId;
  AdminDrawer({
    super.key,
    required this.userId,
  });

  LoggedUserModel? loggedUserModel;
  String currentPasswordErrror = '';
  String errorNewPassword = '';
  String errorConfirmPassword = '';

  Future<bool> _changePassword(BuildContext context) async {
    try {
      final String currentPassword = _currentPasswordController.text.trim();
      final String newPassword = _newPasswordController.text.trim();
      final String confirmPassword = _confirmPasswordController.text.trim();

   
      if (newPassword != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("New passwords do not match"),
          ),
        );
        return false;
      }

      final User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User is not logged in"),
          ),
        );
        return false;
      }

      if (user.email == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("This account does not have an email login"),
          ),
        );
        return false;
      }

      // Reauthenticate the user
      final AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);

      if (!context.mounted) return false;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password changed successfully"),
          backgroundColor: Colors.green,
        ),
      );

      // Clear password fields
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();

      return true;
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'wrong-password':
        case 'invalid-credential':
          errorMessage = "Current password is incorrect";
          break;

        case 'weak-password':
          errorMessage = "New password is too weak";
          break;

        case 'requires-recent-login':
          errorMessage = "Please log in again before changing your password";
          break;

        case 'network-request-failed':
          errorMessage = "Network error. Please check your internet connection";
          break;

        case 'user-not-found':
          errorMessage = "User account not found";
          break;

        default:
          errorMessage = "Unable to change password. Please try again";
      }

      if (!context.mounted) return false;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );

      return false;
    } catch (e) {
      if (!context.mounted) return false;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong. Please try again"),
          backgroundColor: Colors.red,
        ),
      );

      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      // padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Design.buttonColor,
          ),
          child: 
             Row(
              children: [
                CircleAvatar(child: Icon(Icons.person_2_outlined)),
                SizedBox(width: 30,),

                Text(
            "Admin",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
              ],
             )
          // Text(
          //   "My profile",
          //   style: TextStyle(
          //     color: Colors.white,
          //     fontSize: 24,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
        ),
        ListTile(
          leading: const Icon(Icons.home_outlined),
          title: const Text("Home"),
          onTap: () {
            Navigator.pop(context);
          },
        ),
       
        ListTile(
          leading: const Icon(Icons.security_outlined),
          title: const Text("Change password"),
          onTap: () {
            Navigator.pop(context);

            _currentPasswordController.clear();
            _newPasswordController.clear();
            _confirmPasswordController.clear();

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) {
                bool isChangingPassword = false;

                return StatefulBuilder(
                  builder: (context, setDialogState) {
                    return Dialog(
                      insetPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.85,
                        ),
                        child: SingleChildScrollView(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          padding: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).viewInsets.bottom + 2),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Top icon
                                Container(
                                  height: 65,
                                  width: 65,
                                  decoration: BoxDecoration(
                                    color: Design.buttonColor.withOpacity(0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.lock_reset_rounded,
                                    size: 34,
                                    color: Design.buttonColor,
                                  ),
                                ),

                                const SizedBox(height: 15),

                                // Title
                                Text(
                                  "Change Password",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Design.heading,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                // Subtitle
                                Text(
                                  "Create a new password to keep your account secure.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ),

                                const SizedBox(height: 25),

                                // StatefulBuilder(builder: (context, setDialogState) {
                                //   return
                                TextField(
                                  controller: _currentPasswordController,
                                  onChanged: (v) async {
                                    if (loggedUserModel == null) {
                                      loggedUserModel =
                                          await LocalStorage.getLoggedUser();
                                    }
                                    setDialogState(() {
                                      if (!loggedUserModel!.password!
                                          .contains(v)) {
                                        currentPasswordErrror =
                                            'Incorrect Password!';
                                      } else {
                                        currentPasswordErrror = '';
                                      }
                                    });
                                    print(
                                        'currentPassword error is $currentPasswordErrror');
                                  },
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: "Current Password",
                                    prefixIcon: const Icon(
                                      Icons.lock_outline,
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade100,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide(
                                        color: Design.buttonColor,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                  // );
                                  // }
                                ),

                                if (currentPasswordErrror != '')
                                  SizedBox(
                                    height: 10,
                                  ),

                                if (currentPasswordErrror != '')
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        currentPasswordErrror,
                                        style: AppStyles.errorTextStyle,
                                      ),
                                    ],
                                  ),

                                const SizedBox(height: 14),

                                // New password

                                TextField(
                                  controller: _newPasswordController,
                                  onChanged: (v) {
                                    InputValidationClasss passwordValidation =
                                        ValidationsUtils.isValidPassword(
                                            password: v);
                                    setDialogState(() {
                                      errorNewPassword =
                                          passwordValidation.errorMessage;
                                    });
                                  },
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: "New Password",
                                    prefixIcon: const Icon(
                                      Icons.lock_reset_outlined,
                                    ),
                                    helperText: "Minimum 6 characters",
                                    helperStyle: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 11,
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade100,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: const BorderSide(
                                        color: Design.buttonColor,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),

                                if (errorNewPassword != '')
                                  SizedBox(
                                    height: 10,
                                  ),
                                if (errorNewPassword != '')
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .8,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          errorNewPassword,
                                          style: AppStyles.errorTextStyle,
                                        )),
                                      ],
                                    ),
                                  ),

                                const SizedBox(height: 14),

                                // Confirm password

                                TextField(
                                  controller: _confirmPasswordController,
                                  onChanged: (v) {
                                    InputValidationClasss passwordValidation =
                                        ValidationsUtils.isValidConfirmPassword(
                                            confirmPassword: v,
                                            password: _newPasswordController
                                                .text
                                                .trim());
                                    setDialogState(() {
                                      errorConfirmPassword =
                                          passwordValidation.errorMessage;
                                    });
                                  },
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: "Confirm New Password",
                                    prefixIcon: const Icon(
                                      Icons.verified_user_outlined,
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade100,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide(
                                        color: Design.buttonColor,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),

                                if (errorConfirmPassword != '')
                                  SizedBox(
                                    height: 10,
                                  ),

                                if (errorConfirmPassword != '')
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .8,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          errorConfirmPassword,
                                          style: AppStyles.errorTextStyle,
                                        )),
                                      ],
                                    ),
                                  ),

                                const SizedBox(height: 22),

                                // Security information
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.06),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        size: 18,
                                        color: Design.buttonColor,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          "Use a strong password that you haven't used before.",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 22),

                                // Buttons
                                Row(
                                  children: [
                                    // Cancel
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: isChangingPassword
                                            ? null
                                            : () {
                                                Navigator.pop(dialogContext);
                                              },
                                        style: OutlinedButton.styleFrom(
                                          minimumSize:
                                              const Size(double.infinity, 50),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                          side: BorderSide(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                        child: const Text(
                                          "Cancel",
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 12),

                                    // Change password
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: isChangingPassword
                                            ? null
                                            : () async {
                                                setDialogState(() {
                                                  isChangingPassword = true;
                                                });

                                                final bool success =
                                                    await _changePassword(
                                                  dialogContext,
                                                );

                                                if (!dialogContext.mounted) {
                                                  return;
                                                }

                                                if (success) {
                                                  Navigator.pop(dialogContext);
                                                } else {
                                                  setDialogState(() {
                                                    isChangingPassword = false;
                                                  });
                                                }
                                              },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Design.buttonColor,
                                          foregroundColor: Colors.white,
                                          minimumSize:
                                              const Size(double.infinity, 50),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                        ),
                                        child: isChangingPassword
                                            ? const SizedBox(
                                                height: 22,
                                                width: 22,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2.5,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : const Text(
                                                "Update",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout_outlined),
          title: const Text("Logout"),
          onTap: () async {
            showGeneralDialog(
              context: context,
              barrierDismissible: true,
              barrierLabel: "Logout",
              barrierColor: Colors.black54,
              transitionDuration: const Duration(milliseconds: 300),
              pageBuilder: (context, animation, secondaryAnimation) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  title: const Text(
                    "Logout",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: const Text(
                    "Are you sure you want to logout?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // Close dialog first
                        Navigator.pop(context);

                        // Delete saved user information
                        await FirebaseAuth.instance.signOut();
                        await LocalStorage.deleteLoggedUserInfo();

                        // Go to Login page
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },
                      child: const Text("Logout"),
                    ),
                  ],
                );
              },
              transitionBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                // Right → Left animation
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;

                final tween = Tween(
                  begin: begin,
                  end: end,
                ).chain(
                  CurveTween(
                    curve: Curves.easeOut,
                  ),
                );

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            );
          },
        ),
        SizedBox(
          height: 50,
        ),

        Expanded(child: SizedBox()),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Version: 1.0.0'),
          ],
        ),

         SizedBox(
          height: 50,
        ),

      ],
    ));
  }
}
