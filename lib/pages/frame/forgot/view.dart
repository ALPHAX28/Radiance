import 'package:Radiance/common/values/values.dart';
import 'package:Radiance/common/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'index.dart';

class ForgotPage extends GetView<ForgotController> {
  AppBar _buildAppBar() {
    return AppBar();
  }
  Widget _buildLogo() {
    return Column(children: [
      Container(
        margin: EdgeInsets.only(top: 0.h, bottom: 3.h),
        child: Image.asset(
          'assets/icons/Radiance_Logo.png', // Replace 'assets/images/logo.png' with the actual logo image path
          width: 200.w,
          height: 200.h,
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: 0.h, bottom: 30.h),
        child: Text(
          "Forgot password",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.primaryText,
            fontWeight: FontWeight.normal,
            fontSize: 16.sp,
          ),
        ),
      )
    ],);
  }
  Widget _buildForgetBtn() {
    return GestureDetector(
        child: Container(
          width: 295.w,
          height: 44.h,
          margin: EdgeInsets.only(top:60.h,bottom: 30.h),
          padding: EdgeInsets.all(0.h),
          decoration: BoxDecoration(
            color: AppColors.primaryElement,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Text(
                  "Submit",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primaryElementText,
                    fontWeight: FontWeight.normal,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          controller.handleEmailForgot();
        });
  }


  Widget _buildEmailInput(){
    return Container(
        width: 295.w,
        height: 44.h,
        margin: EdgeInsets.only(bottom: 20.h,top: 0.h),
        padding: EdgeInsets.all(0.h),
        decoration: BoxDecoration(
          color: AppColors.primaryBackground,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: TextField(
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            hintText: "Enter your email address",
            contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            hintStyle: TextStyle(
              color: AppColors.primarySecondaryElementText,
            ),
          ),
          style: TextStyle(
            color: AppColors.primaryText,
            fontFamily: "Avenir",
            fontWeight: FontWeight.normal,
            fontSize: 14.sp,
          ),
          onChanged: (value){
            controller.state.email.value=value;
          },
          maxLines: 1,
          autocorrect: false, // 自动纠正
          obscureText: false, // 隐藏输入内容, 密码框
        )
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      body: CustomScrollView(slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(
            vertical: 15.w,
            horizontal: 15.w,
          ),
          sliver: SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(bottom: 0.h,top: 0.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildLogo(),
                  _buildEmailInput(),
                  _buildForgetBtn(),
                ],),),
          ),
        ),
      ]),
    );
  }
}
