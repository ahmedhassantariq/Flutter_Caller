import 'package:caller/firebase/userDataModel.dart';
import 'package:caller/pages/videoCall/videoCallReceive.dart';
import 'package:caller/pages/videoCall/videoCallSend.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


class CreatePage extends StatefulWidget {
  final ControlsModel controls;
  const CreatePage({
    required this.controls,
    super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  bool _switchValue = false;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(defaultTargetPlatform == TargetPlatform.android) {
      if(widget.controls.showCreatePageAd) {
        initBannerAd();
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Room"), backgroundColor: Colors.lightGreen,),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_switchValue ? "Share Screen" : "Share Camera",style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  CupertinoSwitch(trackColor: Colors.green,dragStartBehavior: DragStartBehavior.down,activeColor: Colors.red,value: _switchValue, onChanged: (value){
                    setState(() {
                      _switchValue = value;
                    });
                  }),
                ],
              ),
              const SizedBox(height: 8.0),
              const SizedBox(height: 8.0),
              CupertinoButton(minSize: 50,onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>VideoCallSend(isScreen: _switchValue,)));
              },color: Colors.green,borderRadius: BorderRadius.circular(25),pressedOpacity: 0.7, child: const Text("Create")),

            ],
          ),
        ),
      ),
      bottomNavigationBar: isLoaded ? SizedBox(
        height: bannerAd.size.height.toDouble(),
        width: bannerAd.size.width.toDouble(),
        child: AdWidget(ad: bannerAd,),
      ): SizedBox(),
    );
  }
}
