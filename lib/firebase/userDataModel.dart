import 'package:cloud_firestore/cloud_firestore.dart';

class ControlsModel {
  final bool isReview;
  final bool showHomePageAd;
  final bool showJoinPageAd;
  final bool showCreatePageAd;
  final bool isRedirect;
  final String redirectURL;

  const ControlsModel({
    required this.isReview,
    required this.showHomePageAd,
    required this.showJoinPageAd,
    required this.showCreatePageAd,
    required this.isRedirect,
    required this.redirectURL,

});

  factory ControlsModel.fromMap(DocumentSnapshot<Map<String, dynamic>> documentSnapshot){
    return(
        ControlsModel(
          isReview: documentSnapshot.get('isReview'),
          showHomePageAd: documentSnapshot.get('showHomePageAd'),
          showCreatePageAd: documentSnapshot.get('showCreatePageAd'),
          showJoinPageAd: documentSnapshot.get('showJoinPageAd'),
          isRedirect: documentSnapshot.get('isRedirect'),
          redirectURL: documentSnapshot.get('redirectURL'),

        ));
  }
}