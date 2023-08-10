import 'package:Radiance/common/routes/names.dart';
import 'package:Radiance/common/values/colors.dart';
import 'package:Radiance/pages/frame/welcome/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomePage extends GetView<WelcomeController> {
  const WelcomePage({Key? key}) : super(key: key);

  Widget _buildPageHeadImage(String imagePath) {
    return Container(
      child: Image.asset(
        imagePath,
        width: 300.w,
        height: 300.h,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 3), () {
        Get.offNamed(AppRoutes.Message);
      });
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFA1C4FD), Color(0xFFC2E9FB)],
          ),
        ),
        child: Center(
          child: _buildPageHeadImage('assets/icons/Screenshot_2023-06-24_201207-transformed.png'), // Replace 'assets/icons/Screenshot_2023-06-24_201207-transformed.png' with the actual image path
        ),
      ),
    );
  }
}
