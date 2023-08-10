import 'package:Radiance/common/values/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:Radiance/pages/message/chat/controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'chat_left_list.dart';
import 'chat_right_list.dart';

class ChatList extends GetView<ChatController> {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(()=>Container(
      color: AppColors.primaryBackground,
      padding: EdgeInsets.only(bottom: 80.h,top: 10.h),
      child: GestureDetector(
        child: CustomScrollView(
          controller: controller.myScrollController,
          reverse: true,
          slivers: [
            SliverPadding(
                padding: EdgeInsets.symmetric(
                  vertical: 0.w,
                  horizontal: 0.w,
            ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context,index){
                      var item = controller.state.msgcontent[index];
                      if(controller.token==item.token){
                        return ChatRightList(item);
                      }
                      return ChatLeftList(item);
                    },
                  childCount: controller.state.msgcontent.length
                ) ,
                
              ),
            ),
            SliverPadding(padding: EdgeInsets.symmetric(
              vertical: 0.w,horizontal: 0.w
            ),
              sliver: SliverToBoxAdapter(
                child: controller.state.isloading.value?const Align(
                  alignment: Alignment.center,
                  child: Text('loading...'),
                ):Container(),
              ),
            )
          ],
        ),
        onTap: (){
          controller.closeAllPop();
        },
      ),
    ));
  }
}
