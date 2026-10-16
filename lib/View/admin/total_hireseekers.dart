import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:job_project/Constants/app_styles.dart';
import 'package:job_project/Constants/core/color.dart';
import 'package:job_project/Widget/empty_view.dart';

class HireSeekersPage extends StatelessWidget {
  const HireSeekersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white,)),
        title:  Text("All Hire Seekers",
        style: AppStyles.appBarTitleStyle,
        ),
        backgroundColor: Design.buttonColor,
        foregroundColor: Colors.white,
        systemOverlayStyle: AppStyles.appStatusBarStyle,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('job_applications')
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error:\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const EmptyView(
              title: "No Hire Seekers Found",
              icon: Icons.person_search_outlined,
            );
          }

          // Get only hired applications
          final hiredApplications =
              snapshot.data!.docs.where((doc) {
            final data =
                doc.data() as Map<String, dynamic>;

            final status = (data['status'] ?? '')
                .toString()
                .trim()
                .toLowerCase();

            return status == 'hired';
          }).toList();

          if (hiredApplications.isEmpty) {
            return const EmptyView(
              title: "No Hire Seekers Found",
              icon: Icons.person_search_outlined,
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: hiredApplications.length,
            itemBuilder: (context, index) {
              final application =
                  hiredApplications[index];

              final applicationData =
                  application.data()
                      as Map<String, dynamic>;

              // Worker ID from job_applications
              final userId =
                  applicationData['userId'];

              if (userId == null ||
                  userId.toString().isEmpty) {
                return _missingUserCard(
                  'Worker ID not found',
                );
              }

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('job_seekers')
                    .doc(userId.toString())
                    .get(),

                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return _loadingCard();
                  }

                  if (!userSnapshot.hasData ||
                      !userSnapshot.data!.exists) {
                    return _missingUserCard(
                      'Job seeker profile not found',
                    );
                  }

                  final userData =
                      userSnapshot.data!.data()
                          as Map<String, dynamic>;

                  final name =
                      (userData['name'] ??
                              userData['fullName'] ??
                              userData['username'] ??
                              'No Name')
                          .toString();

                  final email =
                      (userData['email'] ?? 'No Email')
                          .toString();

                  final phone =
                      (userData['phone'] ??
                              userData['mobile'] ??
                              userData['contact'] ??
                              'No Phone')
                          .toString();

                  return _hireSeekerCard(
                    name: name,
                    email: email,
                    phone: phone,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _hireSeekerCard({
    required String name,
    required String email,
    required String phone,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),

      padding: const EdgeInsets.all(18),

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

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                height: 52,
                width: 52,

                decoration: BoxDecoration(
                  color:
                      Colors.green.withOpacity(.1),
                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.person,
                  color: Colors.green,
                  size: 28,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172033),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          _infoRow(
            icon: Icons.email_outlined,
            title: 'Email',
            value: email,
          ),

          const SizedBox(height: 10),

          _infoRow(
            icon: Icons.phone_outlined,
            title: 'Phone',
            value: phone,
          ),
        ],
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Icon(
          icon,
          size: 20,
          color: Design.buttonColor,
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF30384A),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _loadingCard() {
    return Container(
      height: 150,
      margin: const EdgeInsets.only(bottom: 14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),

      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _missingUserCard(String message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),

      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}