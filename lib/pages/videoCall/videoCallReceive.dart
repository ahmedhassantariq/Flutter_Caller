import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../controllers/signaling.dart';


class VideoCallReceive extends StatefulWidget {
  final String roomID;
  final bool isScreen;
  const VideoCallReceive({
    required this.roomID,
    required this.isScreen,
    super.key,
  });

  @override
  _VideoCallReceiveState createState() => _VideoCallReceiveState();
}

class _VideoCallReceiveState extends State<VideoCallReceive> {
  WebRtcManager signaling = WebRtcManager();
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  bool frontCamera = false;
  bool isMic = true;
  bool isVideo = true;
  bool isLocalScreen = true;
  @override
  void initState() {
    _localRenderer.initialize();
    _remoteRenderer.initialize();
    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });
      signaling.joinRoom(widget.roomID, _localRenderer, _remoteRenderer, widget.isScreen);
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
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(widget.roomID),
          backgroundColor: Colors.lightGreen,
          leading: IconButton(onPressed: (){Navigator.pop(context);signaling.hangUp(_localRenderer);}, icon: const Icon(Icons.arrow_back, color: Colors.white,)),
          actions: [
            (defaultTargetPlatform == TargetPlatform.android && !widget.isScreen)
                ?
            IconButton(onPressed: (){signaling?.switchCamera(); frontCamera = !frontCamera;}, icon: const Icon(Icons.switch_camera, color: Colors.white,))
                :
            const SizedBox(),
            !widget.isScreen ? IconButton(onPressed: (){isMic = !isMic; setState(() {
              signaling?.muteMic(isMic);
            });}, icon: isMic ? const Icon(Icons.mic, color: Colors.white,): const Icon(Icons.mic_off, color: Colors.red,)) : const SizedBox(),
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
            isLocalScreen ?  Positioned(
              bottom: 0,
              right: 0,
              child: SizedBox(
                  height: 200,
                  width: 150,
                  child: isVideo ? RTCVideoView(
                    _localRenderer,
                    mirror: defaultTargetPlatform == TargetPlatform.android ? !frontCamera : true,
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                  ) : const Icon(Icons.videocam_off, color: Colors.white)),
            ) : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
