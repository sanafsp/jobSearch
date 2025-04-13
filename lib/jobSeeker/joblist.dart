// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:job_project/const/core/color.dart';
import 'package:job_project/jobSeeker/jobdetails.dart';
import 'package:job_project/jobSeeker/notification.dart';
import 'package:job_project/jobSeeker/saveJob.dart';

class JobListScreen extends StatefulWidget {
  @override
  _JobListScreenState createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<DocumentSnapshot> _jobs = [];
  bool _isLoading = false;
  DocumentSnapshot? _lastDocument;
  final int _perPage = 10;
  bool _hasMore = true;
  String _searchQuery = "";
  String? _selectedLocation;
  Set<String> _savedJobs = {};

  @override
  void initState() {
    super.initState();
    _fetchJobs(isRefresh: true);
    _loadSavedJobs();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
        _fetchJobs();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

//job save
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

  Future<void> _toggleSaveJob(String jobId, String title, String company,String location) async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    if (userId.isEmpty) return;

    if (_savedJobs.contains(jobId)) {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('saved_jobs')
          .doc(jobId)
          .delete();

      setState(() {
        _savedJobs.remove(jobId);
      });
    } else {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('saved_jobs')
          .doc(jobId)
          .set({'title': title, 'company': company, 'location': location});

      setState(() {
        _savedJobs.add(jobId);
      });
    }
  }

  Future<void> _fetchJobs({bool isRefresh = false}) async {
    if (_isLoading || (!_hasMore && !isRefresh)) return;
    setState(() => _isLoading = true);

    try {
      Query query = _firestore.collection('jobs').orderBy('title').limit(_perPage);

      if (_searchQuery.isNotEmpty && _selectedLocation != null && _selectedLocation!.isNotEmpty) {
        query = query
            .where('title', isGreaterThanOrEqualTo: _searchQuery)
            .where('title', isLessThanOrEqualTo: _searchQuery + '\uf8ff')
            .where('location', isEqualTo: _selectedLocation);
      } else if (_searchQuery.isNotEmpty) {
        query = query
            .where('title', isGreaterThanOrEqualTo: _searchQuery)
            .where('title', isLessThanOrEqualTo: _searchQuery + '\uf8ff');
      } else if (_selectedLocation != null && _selectedLocation!.isNotEmpty) {
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

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.trim();
    });
    _fetchJobs(isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Design.baseColor,
      body: Column(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                     height: 200,
                     width: 500,
                     decoration: BoxDecoration(
               color: Design.buttonColor, 
               borderRadius: BorderRadius.only(
                 // bottomLeft: Radius.circular(50),
                 bottomRight: Radius.circular(50),
               ),
             ),
                     child: Column(
                       children: [
                         Row(mainAxisAlignment: MainAxisAlignment.end,
                           children: [
                            
                                         SizedBox(
                                          // width: 500,
                                          height: 100,
                                           child: IconButton(
                                           icon: Icon(Icons.notifications, color: Design.bottom),
                                           onPressed: () {
                                             Navigator.push(
                                               context,
                                               MaterialPageRoute(builder: (context) => NotificationScreen()),
                                             );
                                           },
                                                                              ),
                                         ),
                                          ],
                         ),
                             Center(
                               child: 
                                   Row(mainAxisAlignment: MainAxisAlignment.center,
                                     children: [
                                       Text(
                                                          "Job Listings",
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(fontSize: 25, 
                                                          fontWeight: FontWeight.bold,
                                                          color: Design.bottom),
                                                        ),
                                     
                         
                                 ],
                               ),
                             ),
                          
                       ],
                     ),
                   ),
                   SizedBox(height: 20,),
                   TextFormField(
                    
                    controller: _searchController,
                  onChanged: (value) => _onSearchChanged(),
                  decoration: InputDecoration(
                     filled: true,
                     fillColor: Design.bottom,
                    hintText: 'Search Job title...',
                    hintStyle: TextStyle(color: Design.searchbar),
                    prefixIcon: Icon(
                      Icons.search_outlined,
                      color: Design.searchbar,
                    ),
                    border: InputBorder.none,
                     enabledBorder: UnderlineInputBorder(
                                  borderSide:  BorderSide(color: Colors.white),
                                  borderRadius:  BorderRadius.circular(30),
                                ),
                                 focusedBorder: OutlineInputBorder(
                                  borderSide:  BorderSide(color: Design.baseColor),
                                  borderRadius:  BorderRadius.circular(30),
                                ),
                  ),
                ),
               
              ],
            ),
          ),
          Expanded(
            child: _jobs.isEmpty && !_isLoading
                ? Center(child: Text("No jobs found"))
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: _jobs.length + (_hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _jobs.length) {
                        return Center(child: CircularProgressIndicator());
                      }

                      DocumentSnapshot job = _jobs[index];
                      Map<String, dynamic> jobData = job.data() as Map<String, dynamic>? ?? {};
                      String jobId = job.id;
                      String title = jobData['title'] ?? "No Title";
                      String company = jobData['company'] ?? "Unknown Company";
                      String location = jobData['location'] ?? "Unknown Location";
                      String salary = jobData['salary']??"Unknown Salary";

                      return GestureDetector(
                        onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => JobDetailScreen(jobId: jobId)),
                              );
                            }, 
                        child: Card(
                          color: Design.bottom,
                          elevation: 10,
                        
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              Text(title, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                              // SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("🏢 $company    📍$location",style: TextStyle(fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                  color:  Color.fromARGB(255, 112, 111, 111))),
                                  IconButton(
                              icon: Icon(
                                _savedJobs.contains(jobId) ? Icons.bookmark : Icons.bookmark_border,
                                color: _savedJobs.contains(jobId) ? Colors.blue : null,
                              ),
                              onPressed: () => _toggleSaveJob(jobId, title, company,location),
                            ),
                                ],
                              ),
                              // SizedBox(height: 10,),
                               Text("💰$salary", style: TextStyle(fontWeight: FontWeight.normal,fontSize: 15,color:  Color.fromARGB(255, 112, 111, 111))),
                            ],),
                          ),
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
