import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../../controllers/chat/signaling.dart';
import '../../../controllers/chat/userDataModel.dart';
import '../../../controllers/notifications/notification_services.dart';
import '../../../controllers/notifications/notificationsModel.dart';


class VideoCallSend extends StatefulWidget {
  final UserCredentialsModel receiver;
  const VideoCallSend({
    required this.receiver,
    super.key,
  });
  @override
  _VideoCallSendState createState() => _VideoCallSendState();
}

class _VideoCallSendState extends State<VideoCallSend> {
  WebRtcManager signaling = WebRtcManager();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String? roomId;
  bool frontCamera = false;
  bool isMic = true;
  bool isVideo = true;
  bool isLocalScreen = true;


  sendMessage(String roomID) {
    if(roomId!=null) {
      NotificationServices().sendNotification(
          NotificationsModel(
              to: widget.receiver.uid,
              priority: 'high',
              title: 'Call',
              body: "Calling",
              type: 'call',
              id: '1',
              payload: roomID
          )
      );
    }
  }

  sendInvite() async{
    roomId = await signaling.createRoom(_localRenderer,_remoteRenderer);
    sendMessage(roomId!);
    setState(() {
    });
  }
  @override
  void initState() {
    _localRenderer.initialize();
    _remoteRenderer.initialize();
    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });
    sendInvite();

    super.initState();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(roomId.toString()),
          backgroundColor: Colors.lightGreen,
          leading: IconButton(onPressed: (){Navigator.pop(context);signaling.hangUp(_localRenderer);}, icon: const Icon(Icons.arrow_back, color: Colors.white,)),
          actions: [
            (defaultTargetPlatform == TargetPlatform.android)
                ?
            IconButton(onPressed: (){signaling?.switchCamera(); setState(() {
              frontCamera = !frontCamera;
            });}, icon: const Icon(Icons.switch_camera, color: Colors.white,))
                :
            const SizedBox(),
            IconButton(onPressed: (){isMic = !isMic; setState(() {
              signaling?.muteMic(isMic);
            });}, icon: isMic ? const Icon(Icons.mic, color: Colors.white,): const Icon(Icons.mic_off, color: Colors.red,)),
            IconButton(onPressed: (){isVideo = !isVideo; setState(() {
              signaling?.muteVideo(isVideo);
            });}, icon: isVideo ? const Icon(Icons.videocam_outlined, color: Colors.white,): const Icon(Icons.videocam_off_outlined, color: Colors.red,)),
            IconButton(onPressed: (){isLocalScreen = !isLocalScreen; setState(() {});}, icon: isLocalScreen ? const Icon(Icons.video_camera_front_outlined, color: Colors.white,): const Icon(Icons.videocam_off_outlined, color: Colors.red,)),

          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.red,
          child: CupertinoButton(
              onPressed: (){
                signaling.hangUp(_localRenderer);
                Navigator.pop(context);
              }, child: const Text("Hang Up", style: TextStyle(color: Colors.white),)),
        ),
        body: Stack(
          children:<Widget> [
            Container(
              child: RTCVideoView(
                _remoteRenderer,
                objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
              ),
            ),
            isLocalScreen ? Positioned(
              bottom: 0,
              right: 0,
              child: SizedBox(
                  height: 200,
                  width: 150,
                  child: isVideo ?  RTCVideoView(
                    _localRenderer,
                    mirror: defaultTargetPlatform == TargetPlatform.android ? !frontCamera : true,
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                  ) : const Icon(Icons.videocam_off, color: Colors.white,)),
            ) : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
