
import 'package:dynamic_delivery/bottom_navigationbar.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

import 'package:dynamic_delivery/src/features/authentication/screens/spalsh_screen/splash_screen.dart';
import 'package:dynamic_delivery/src/utils/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';
import 'home_screen.dart';
import 'src/features/authentication/screens/notification/notification_services.dart';
import 'src/repository/authentication_repository.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).
 then((value) => Get.put(AuthenticationRepository()));
 await FirebaseMessaging.instance.getInitialMessage();
 FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  void main() {
    // Require Hybrid Composition mode on Android.
    final GoogleMapsFlutterPlatform mapsImplementation =
        GoogleMapsFlutterPlatform.instance;
    if (mapsImplementation is GoogleMapsFlutterAndroid) {
      // Force Hybrid Composition mode.
      mapsImplementation.useAndroidViewSurface = true;
    }
    // ···
  }


  runApp(const MyApp());
}
NotificationServices notificationServices=NotificationServices();

@pragma('vm:entry-point')
Future<void>_firebaseMessagingBackgroundHandler(RemoteMessage message)async{
  await Firebase.initializeApp();


}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme:CAppTheme.lightTheme,
      darkTheme:CAppTheme.darktheme,
      themeMode: ThemeMode.system,
      home:const BottomNavBar(),

    );
  }
}

