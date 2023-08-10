import 'package:Radiance/common/values/colors.dart';
import 'package:Radiance/pages/contact/widgets/contact_list.dart';
// import 'package:Radiance/pages/frame/welcome/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Radiance/pages/contact/index.dart';

class ContactPage extends GetView<ContactController> {
  const ContactPage({Key? key}) : super(key: key);
  AppBar _buildAppBar(){
    return AppBar(
      title: Text(
        "Contact",
        style: TextStyle(
          color: AppColors.primaryText,
          fontSize: 16.sp,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: _buildAppBar(),
     body:Container(
       width: 360.w,
       height: 780.h,
       child: const ContactList()
     )
   );
  }
}
