
import 'package:flutter/material.dart';
// import 'package:Radiance/common/middlewares/middlewares.dart';

import 'package:get/get.dart';

import '../../pages/frame/email_login/bindings.dart';
import '../../pages/frame/email_login/view.dart';
import '../../pages/frame/forgot/bindings.dart';
import '../../pages/frame/forgot/view.dart';
import '../../pages/frame/phone/bindings.dart';
import '../../pages/frame/phone/view.dart';
import '../../pages/frame/register/bindings.dart';
import '../../pages/frame/register/view.dart';
import '../../pages/frame/send_code/bindings.dart';
import '../../pages/frame/send_code/view.dart';
import '../../pages/frame/welcome/index.dart';
import '../../pages/frame/sign_in/index.dart';
import '../../pages/message/photoview/binding.dart';
import '../../pages/message/photoview/view.dart';
import '../middlewares/router_auth.dart';
import 'routes.dart';
import '../../pages/message/index.dart';
import '../../pages/profile/index.dart';
import '../../pages/contact/index.dart';
import '../../pages/message/chat/index.dart';
import '../../pages/message/voicecall/index.dart';
import '../../pages/message/videocall/index.dart';


class AppPages {
  static const INITIAL = AppRoutes.INITIAL;
  static final RouteObserver<Route> observer = RouteObservers();
  static List<String> history = [];

  static final List<GetPage> routes = [
    // 免登陆
    GetPage(
      name: AppRoutes.INITIAL,
      page: () => const WelcomePage(),
      binding: WelcomeBinding(),
    ),

    GetPage(
      name: AppRoutes.SIGN_IN,
      page: () => SignInPage(),
      binding: SignInBinding(),
    ),
    /*
    // 需要登录
    // GetPage(
    //   name: AppRoutes.Application,
    //   page: () => ApplicationPage(),
    //   binding: ApplicationBinding(),
    //   middlewares: [
    //     RouteAuthMiddleware(priority: 1),
    //   ],
    // ),

    // 最新路由

    */
    GetPage(name: AppRoutes.Forgot, page: () => ForgotPage(), binding: ForgotBinding()),

    GetPage(name: AppRoutes.Register, page: () => RegisterPage(), binding: RegisterBinding()),

    GetPage(name: AppRoutes.EmailLogin, page: () => EmailLoginPage(), binding: EmailLoginBinding()),
    GetPage(name: AppRoutes.Phone, page: () => PhonePage(), binding: PhoneBinding()),
    GetPage(name: AppRoutes.SendCode, page: () => SendCodePage(), binding: SendCodeBinding()),

    GetPage(name: AppRoutes.Contact, page: () => const ContactPage(), binding: ContactBinding()),

    GetPage(name: AppRoutes.Message, page: () => MessagePage(), binding: MessageBinding(),middlewares: [
       RouteAuthMiddleware(priority: 1),
     ],
    ),

    //我的
    GetPage(name: AppRoutes.Profile, page: () => const ProfilePage(), binding: ProfileBinding()),


    GetPage(name: AppRoutes.Chat, page: () => ChatPage(), binding: ChatBinding()),

    GetPage(name: AppRoutes.Photoimgview, page: () => PhotoImgViewPage(), binding: PhotoImgViewBinding()),

    GetPage(name: AppRoutes.VoiceCall, page: () => VoiceCallPage(), binding: VoiceCallBinding()),
    GetPage(name: AppRoutes.VideoCall, page: () => VideoCallPage(), binding: VideoCallBinding()),
  ];






}
