import 'package:Radiance/common/routes/names.dart';
import 'package:flutter/material.dart';
import 'package:Radiance/common/values/values.dart';
import 'package:Radiance/common/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'index.dart';

class SignInPage extends GetView<SignInController> {
  // logo
  Widget _buildLogo() {
    return Container(
      margin: EdgeInsets.only(top: 100.h, bottom: 8.h),
      child: Image.asset(
        'assets/icons/Radiance_Logo.png', // Replace 'assets/images/logo.png' with the actual logo image path
        width: 200.w,
        height: 200.h,
      ),
    );
  }




  Widget _buildThirdPartyGoogleLogin() {
    return GestureDetector(
      child: Container(
        width: 295.w,
        height: 44.h,
        margin: EdgeInsets.only(bottom: 15.h),
        padding: EdgeInsets.all(10.h),
        decoration: BoxDecoration(
          color: AppColors.primaryBackground,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 40.w, right: 30.w),
              child: Image.asset("assets/icons/google.png"),
            ),
            Container(
              child: Text(
                "Sign in with Google",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.normal,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        controller.handleSignIn("google");
      },
    );
  }


  Widget _buildThirdPartyFacebookLogin() {
    return GestureDetector(
        child: Container(
          width: 295.w,
          height: 44.h,
          margin: EdgeInsets.only(bottom: 15.h),
          padding: EdgeInsets.all(10.h),
          decoration: BoxDecoration(
            color: AppColors.primaryBackground,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(left: 40.w, right: 30.w),
                  child: Image.asset("assets/icons/facebook.png")),
              Container(
                child: Text(
                  "Sign in with Facebook",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.normal,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          toastInfo(msg: "Coming soon");
          // controller.handleSignIn("facebook");
        });
  }

  Widget _buildThirdPartyAppleLogin() {
    return GestureDetector(
        child: Container(
          width: 295.w,
          height: 44.h,
          margin: EdgeInsets.only(bottom: 15.h),
          padding: EdgeInsets.all(10.h),
          decoration: BoxDecoration(
            color: AppColors.primaryBackground,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(left: 40.w, right: 30.w),
                  child: Image.asset("assets/icons/apple.png")),
              Container(
                child: Text(
                  "Sign in with Apple",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.normal,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          toastInfo(msg: "coming soon");
          // controller.handleSignIn("apple");
        });
  }

  Widget _buildThirdPartyPhoneLogin() {
    return GestureDetector(
        child: Container(
          width: 295.w,
          height: 44.h,
          margin: EdgeInsets.only(bottom: 40.h),
          padding: EdgeInsets.all(10.h),
          decoration: BoxDecoration(
            color: AppColors.primaryBackground,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 2,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Text(
                  "Sign in with phone number",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.normal,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          controller.handleSignIn("phone");
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primarySecondaryBackground,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: <Widget>[
            _buildLogo(),
            _buildThirdPartyGoogleLogin(),
            _buildThirdPartyFacebookLogin(),
            _buildThirdPartyAppleLogin(),
            Container(
              margin: EdgeInsets.only(top: 20.h, bottom: 35.h),
              child: Row(children: <Widget>[
                Expanded(
                    child: Divider(
                      height: 2.h,
                      indent: 50,
                      color: AppColors.primarySecondaryElementText,
                    )),
                Text("  or  "),
                Expanded(
                    child: Divider(
                      height: 2.h,
                      endIndent: 50,
                      color: AppColors.primarySecondaryElementText,
                    )),
              ]),
            ),
            _buildThirdPartyPhoneLogin(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Text(
                    "Already have an account?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.normal,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
                Container(
                  child: GestureDetector(
                      child: Text(
                        "Sign in here ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.primaryElement,
                          fontWeight: FontWeight.normal,
                          fontSize: 12.sp,
                        ),
                      ),
                      onTap: () {
                        controller.handleSignIn("email");
                      }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
