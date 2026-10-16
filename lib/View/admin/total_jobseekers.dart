import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:job_project/Constants/app_styles.dart';

class JobSeekersPage extends StatefulWidget {
  const JobSeekersPage({super.key});

  @override
  State<JobSeekersPage> createState() => _JobSeekersPageState();
}

class _JobSeekersPageState extends State<JobSeekersPage> {
  final TextEditingController _searchController = TextEditingController();

  String _searchText = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getName(Map<String, dynamic> data) {
    return (data['name'] ??
            data['fullName'] ??
            data['username'] ??
            data['displayName'] ??
            'Job Seeker')
        .toString();
  }

  String _getEmail(Map<String, dynamic> data) {
    return (data['email'] ?? 'No email').toString();
  }

  String _getPhone(Map<String, dynamic> data) {
    return (data['phone'] ??
            data['mobile'] ??
            data['contact'] ??
            'No phone')
        .toString();
  }

  String? _getImage(Map<String, dynamic> data) {
    final value = data['photo'] ??
        data['image'] ??
        data['profileImage'] ??
        data['photoUrl'];

    if (value == null || value.toString().trim().isEmpty) {
      return null;
    }

    return value.toString();
  }

  bool _matchesSearch(Map<String, dynamic> data) {
    if (_searchText.trim().isEmpty) {
      return true;
    }

    final search = _searchText.toLowerCase();

    return data.values.any(
      (value) => value.toString().toLowerCase().contains(search),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),

      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white,)),
        title:  Text(
          'All Job Seekers',
          style: AppStyles.appBarTitleStyle,
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: AppStyles.appStatusBarStyle,
      ),

      body: Column(
        children: [

          // SEARCH
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: TextField(
              controller: _searchController,

              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },

              decoration: InputDecoration(
                hintText: 'Search job seekers...',
                prefixIcon: const Icon(Icons.search),

                suffixIcon: _searchText.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();

                          setState(() {
                            _searchText = '';
                          });
                        },
                      )
                    : null,

                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // JOB SEEKERS
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('job_seekers')
                  .snapshots(),

              builder: (context, snapshot) {

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Error loading job seekers:\n${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final documents =
                    snapshot.data?.docs ?? [];

                final filteredDocuments =
                    documents.where((doc) {

                  final data =
                      doc.data() as Map<String, dynamic>;

                  return _matchesSearch(data);

                }).toList();

                if (filteredDocuments.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,

                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 70,
                          color: Colors.grey,
                        ),

                        SizedBox(height: 12),

                        Text(
                          'No job seekers found',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    8,
                    16,
                    20,
                  ),

                  itemCount:
                      filteredDocuments.length,

                  itemBuilder: (context, index) {

                    final doc =
                        filteredDocuments[index];

                    final data =
                        doc.data()
                            as Map<String, dynamic>;

                    return _jobSeekerCard(
                      context,
                      doc.id,
                      data,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _jobSeekerCard(
    BuildContext context,
    String userId,
    Map<String, dynamic> data,
  ) {
    final name = _getName(data);
    final email = _getEmail(data);
    final phone = _getPhone(data);
    final image = _getImage(data);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: InkWell(
        borderRadius: BorderRadius.circular(18),

        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (_) => UserDetailsPage(
          //       userId: userId,
          //       data: data,
          //       title: 'Job Seeker Details',
          //     ),
          //   ),
          // );
        },

        child: Padding(
          padding: const EdgeInsets.all(15),

          child: Row(
            children: [

              _profileImage(image),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(
                      name,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,

                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF172033),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Row(
                      children: [

                        const Icon(
                          Icons.email_outlined,
                          size: 15,
                          color: Colors.grey,
                        ),

                        const SizedBox(width: 5),

                        Expanded(
                          child: Text(
                            email,
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,

                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Row(
                      children: [

                        const Icon(
                          Icons.phone_outlined,
                          size: 15,
                          color: Colors.grey,
                        ),

                        const SizedBox(width: 5),

                        Expanded(
                          child: Text(
                            phone,
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,

                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // const Icon(
              //   Icons.arrow_forward_ios_rounded,
              //   size: 17,
              //   color: Colors.grey,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileImage(String? image) {

    if (image == null) {
      return Container(
        height: 58,
        width: 58,

        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(.1),
          shape: BoxShape.circle,
        ),

        child: const Icon(
          Icons.person,
          color: Colors.blue,
          size: 30,
        ),
      );
    }

    return ClipOval(
      child: Image.network(
        image,

        height: 58,
        width: 58,

        fit: BoxFit.cover,

        errorBuilder: (_, __, ___) {
          return Container(
            height: 58,
            width: 58,

            color: Colors.blue.withOpacity(.1),

            child: const Icon(
              Icons.person,
              color: Colors.blue,
              size: 30,
            ),
          );
        },
      ),
    );
  }
}