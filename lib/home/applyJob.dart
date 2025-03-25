import 'package:cloud_firestore/cloud_firestore.dart';

class JobApplicationService {
  Future<void> applyForJob(String jobId, String company, String title) async {
    try {
      String userId = "12345"; // Replace with actual user ID from authentication

      await FirebaseFirestore.instance
          .collection("jobApplications")
          .add({
            'userId': userId,
            'jobId': jobId,
            'company': company,
            'title': title,
            'appliedAt': FieldValue.serverTimestamp(),
          });

      print(" Job application submitted successfully!");
    } catch (e) {
      print(" Error applying for job: $e");
      throw e;
    }
  }
}
