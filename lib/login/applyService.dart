import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApplyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> applyForJob(String jobID) async {
    String userID = _auth.currentUser!.uid;
    await _firestore.collection('applications').add({
      'jobID': jobID,
      'userID': userID,
      'status': 'Applied',
    });
  }
}
