import 'package:caller/firebase/userDataModel.dart';
import 'package:caller/pages/chat/chatPage.dart';
import 'package:caller/pages/home/redirectScreen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../authentication/auth/auth_service.dart';
import '../../controllers/notifications/notification_services.dart';
import '../chat/createNewChat.dart';




class HomePage extends StatefulWidget {
  final ControlsModel controls;

  const HomePage({
    required this.controls,
    super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  final NotificationServices notificationServices = NotificationServices();

  late BannerAd bannerAd;
  bool isLoaded = false;
  var adUnit = "ca-app-pub-3940256099942544/6300978111";
  initBannerAd(){
    bannerAd = BannerAd(
        size: AdSize.largeBanner,
        adUnitId: adUnit,
        listener: BannerAdListener(
          onAdLoaded: (ad){
            setState(() {
              isLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error){
            ad.dispose();
            print(error);
          },
        ),
        request: const AdRequest());
    bannerAd.load();
  }
  checkRedirect(){
    if(widget.controls.isRedirect){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> RedirectScreen(controls: widget.controls,)));
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.getDeviceToken();
    notificationServices.isTokenRefresh();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      checkRedirect();
    });
    if(defaultTargetPlatform == TargetPlatform.android) {
      if(widget.controls.showHomePageAd) {
        initBannerAd();
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Line-Share", style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.lightGreen,
          actions: [
            IconButton(padding: const EdgeInsets.symmetric(horizontal: 18.0),onPressed: (){showNewChatMenu();}, icon: const Icon(Icons.chat)),
            IconButton(onPressed: (){_authService.signOut();}, icon: const Icon(Icons.logout, color: Colors.white,))
          ],),
        body: const SingleChildScrollView(
            child: ChatPage()),
      bottomNavigationBar: isLoaded ? SizedBox(
        height: bannerAd.size.height.toDouble(),
        width: bannerAd.size.width.toDouble(),
        child: AdWidget(ad: bannerAd,),
      ): const SizedBox(),
    );
  }


  showNewChatMenu() {
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: false,
        context: context,
        builder: (BuildContext context) {
          return const SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(),
              child: CreateNewChat());
        });
  }
}
