
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'src/features/authentication/screens/notification/notification_services.dart';
import 'src/repository/authentication_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  NotificationServices notificationServices = NotificationServices();

  Future<List<String>> getDeviceTokensFromFirestore() async {
    List<String> tokens = [];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('deviceTokens').get();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      // Assuming 'token' is the field in your Firestore document that stores the device token
      String token = doc.get('token');

      if (token != null && token.isNotEmpty) {
        tokens.add(token);
      }
    }

    return tokens;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.getDeviceToken().then((value){
      if (kDebugMode) {
       // print('device token');
       // print(value);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Notifications'),

      ),
      body: ElevatedButton(
        onPressed: (){
          getDeviceTokensFromFirestore().then((List<String> tokens) async{
            for (var token in tokens) {
              var data = {
                'to': token,
                'priority': 'high',
                'notification': {
                  'title': 'Parcel Request!',
                  'body': 'Parcel is Ready for Pickup!',
                },
                'data':{
                  'type':'msg',
                  'id':'dynamic1990'
                }
              };
            await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            body:jsonEncode(data),
                headers:{
              'Content-Type':'application/json; charset=UTF-8',
            'Authorization':'key=AAAAVv7wqlg:APA91bGty2wYEMEP1Pod2qpGgpZULYzS6SVtgxn4sc3gdkwyhSybGWW-aKR7_kyYfw6oLqteYNpaIpaUGBo_0JtQo2vBnEy4DJnLyWG4qTZrso_uFtRbL05JHhSxFRoFYwyhOUo5O20x',
            },
            );}
          });
          //AuthenticationRepository.instance.logout();
        },
        child: const Text('logout'),
      ),

    );
  }
}