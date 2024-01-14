import 'package:caller/firebase/userDataModel.dart';
import 'package:caller/pages/home/redirectScreen.dart';
import 'package:caller/pages/videoCall/joinPage.dart';
import 'package:caller/pages/videoCall/videoCallReceive.dart';
import 'package:caller/pages/videoCall/videoCallSend.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../authentication/auth/auth_service.dart';
import '../../controllers/notification_services.dart';
import '../videoCall/createPage.dart';



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
            IconButton(onPressed: (){_authService.signOut();}, icon: const Icon(Icons.logout, color: Colors.white,))
          ],),
        body: Center(
          child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CupertinoButton(minSize: 50,onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>JoinPage(controls: widget.controls,)));},color: Colors.green,borderRadius: BorderRadius.circular(25),pressedOpacity: 0.7, child: Text("Join")),
                  const SizedBox(height: 8.0),
                  CupertinoButton(minSize: 50,onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>CreatePage(controls:  widget.controls,)));},color: Colors.green,borderRadius: BorderRadius.circular(25),pressedOpacity: 0.7, child: Text("Create")),
                ],
              )),
        ),
      bottomNavigationBar: isLoaded ? SizedBox(
        height: bannerAd.size.height.toDouble(),
        width: bannerAd.size.width.toDouble(),
        child: AdWidget(ad: bannerAd,),
      ): SizedBox(),
    );
  }
}
