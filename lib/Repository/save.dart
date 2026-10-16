import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveJob(String jobId, String title, String company) async {
    if (jobId.isEmpty) {
      print("Skipping save due to invalid job ID.");
      return;
    }

    try {
      await _firestore.collection('saved_jobs').doc(jobId).set({
        'jobId': jobId,
        'title': title,
        'company': company,
        'savedAt': FieldValue.serverTimestamp(),
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> savedJobs = prefs.getStringList('saved_jobs') ?? [];
      savedJobs.add(jobId);
      await prefs.setStringList('saved_jobs', savedJobs);

      print(" Job Saved: $jobId");
    } catch (e) {
      print(" Error saving job: $e");
    }
  }
}
