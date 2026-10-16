import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job_project/Model/logged_user_model.dart';
import 'package:job_project/Repository/local_storage.dart';
import 'package:job_project/View/admin/admin_home.dart';
import 'package:job_project/Widget/companyBottom.dart';
import 'package:job_project/Widget/workersbottom.dart';
import 'package:job_project/View/login/signin.dart';
import 'package:job_project/Constants/core/color.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});
  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  @override
  void initState() {
    super.initState();
    checkIsLoggedIn();
  }

  checkIsLoggedIn() async {
    bool isLoggedIn = await LocalStorage.isLoggedIn();
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    if (isLoggedIn) {
      LoggedUserModel loggedUserModel = await LocalStorage.getLoggedUser();
      String role = loggedUserModel.role!;
      if (role == 'Company') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Companybottom(),
          ),
        );
      } else if (role == 'Admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AdminHomeScreen(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Workersbottom(),
          ),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: Design.buttonColor,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: const AnimatedCenterImage(
        imagePath: 'assets/job_search_icon.jpeg',
      ),
    );
  }
}

class AnimatedCenterImage extends StatefulWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final Duration duration;
  const AnimatedCenterImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.duration = const Duration(milliseconds: 1500),
  });
  @override
  State<AnimatedCenterImage> createState() => _AnimatedCenterImageState();
}

class _AnimatedCenterImageState extends State<AnimatedCenterImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _verticalAnimation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _verticalAnimation = Tween<double>(
      begin: 120,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _verticalAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _verticalAnimation.value),
            child: child,
          );
        },
        child: Image.asset(
          widget.imagePath,
          height: 150,
          width: 150,
          // width: widget.width ?? 200,
          // height: widget.height ?? 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

