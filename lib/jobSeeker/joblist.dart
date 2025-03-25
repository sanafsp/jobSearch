import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:job_project/jobSeeker/jobdetails.dart';
import 'package:job_project/jobSeeker/saveJob.dart';

class JobListScreen extends StatefulWidget {
  @override
  _JobListScreenState createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _jobs = [];
  bool _isLoading = false;
  DocumentSnapshot? _lastDocument;
  final int _perPage = 10;
  bool _hasMore = true;
  String _searchQuery = "";
  String? _selectedCategory;
  String? _selectedLocation;

  // ✅ Set to store saved job IDs
  Set<String> _savedJobs = {};

  @override
  void initState() {
    super.initState();
    _fetchJobs(isRefresh: true);
    _loadSavedJobs(); // ✅ Load saved jobs on start
  }

  // ✅ Load saved jobs from Firestore
  Future<void> _loadSavedJobs() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    if (userId.isEmpty) return;

    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('saved_jobs')
        .get();

    setState(() {
      _savedJobs = snapshot.docs.map((doc) => doc.id).toSet();
    });
  }

  // ✅ Toggle job save state and update UI
  Future<void> _toggleSaveJob(String jobId, String title, String company) async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    if (userId.isEmpty) return;

    if (_savedJobs.contains(jobId)) {
      // Remove saved job
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('saved_jobs')
          .doc(jobId)
          .delete();

      setState(() {
        _savedJobs.remove(jobId); // ✅ Update the UI immediately
      });
    } else {
      // Save job
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('saved_jobs')
          .doc(jobId)
          .set({'title': title, 'company': company});

      setState(() {
        _savedJobs.add(jobId); // ✅ Update the UI immediately
      });
    }
  }

  Future<void> _fetchJobs({bool isRefresh = false}) async {
    if (_isLoading || (!_hasMore && !isRefresh)) return;
    setState(() => _isLoading = true);

    try {
      Query query = _firestore.collection('jobs').orderBy('title').limit(_perPage);

      if (_searchQuery.isNotEmpty) {
        query = query.where('title', isGreaterThanOrEqualTo: _searchQuery)
                     .where('title', isLessThanOrEqualTo: _searchQuery + '\uf8ff');
      }
      if (_selectedCategory != null) {
        query = query.where('category', isEqualTo: _selectedCategory);
      }
      if (_selectedLocation != null) {
        query = query.where('location', isEqualTo: _selectedLocation);
      }
      if (_lastDocument != null && !isRefresh) {
        query = query.startAfterDocument(_lastDocument!);
      }

      QuerySnapshot snapshot = await query.get();

      if (isRefresh) {
        _jobs.clear();
        _lastDocument = null;
        _hasMore = true;
      }

      if (snapshot.docs.isEmpty) {
        setState(() {
          _hasMore = false;
          _isLoading = false;
        });
        return;
      }

      _lastDocument = snapshot.docs.last;
      setState(() {
        _jobs.addAll(snapshot.docs);
        _isLoading = false;
      });
    } catch (e) {
      print("Firestore Query Error: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Job Listings"),
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SavedJobsScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _jobs.length + (_hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _jobs.length) {
                  _fetchJobs();
                  return Center(child: CircularProgressIndicator());
                }

                DocumentSnapshot job = _jobs[index];
                Map<String, dynamic> jobData = job.data() as Map<String, dynamic>? ?? {};
                String jobId = job.id;
                String title = jobData['title'] ?? "No Title";
                String company = jobData['company'] ?? "Unknown Company";
                String location = jobData['location'] ?? "Unknown Location";

                return Card(
                  child: ListTile(
                    title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("$company • $location"),
                    trailing: IconButton(
                      icon: Icon(
                        _savedJobs.contains(jobId) ? Icons.bookmark : Icons.bookmark_border,
                        color: _savedJobs.contains(jobId) ? Colors.blue : null, // ✅ Fix icon color change
                      ),
                      onPressed: () => _toggleSaveJob(jobId, title, company),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => JobDetailScreen(jobId: jobId)),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

