
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:job_project/Constants/app_styles.dart';
import 'package:job_project/Constants/core/color.dart';
import 'package:job_project/Widget/empty_view.dart';
import 'package:job_project/Widget/user_list_ui.dart';

class PremiumUsersPage extends StatelessWidget {
  const PremiumUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white,)),
        title:  Text("Premium Users",
        style: AppStyles.appBarTitleStyle
        ),
        backgroundColor: Design.buttonColor,
        foregroundColor: Colors.white,
        systemOverlayStyle: AppStyles.appStatusBarStyle,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('isPremium', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const EmptyView(
              title: "No Premium Users",
              icon: Icons.workspace_premium_outlined,
            );
          }

          return buildPremiumList(snapshot.data!.docs);
        },
      ),
    );
  }
}
