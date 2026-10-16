import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:job_project/Constants/core/color.dart';

 buildUsersList(
    List<QueryDocumentSnapshot> documents) {
  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: documents.length,
    itemBuilder: (context, index) {
      final data =
          documents[index].data() as Map<String, dynamic>;

      final name =
          data['name'] ??
          data['username'] ??
          
          data['companyName'] ??
          'Unknown User';

      final email = data['email'] ?? 'No email';

      final phone = data['phone'] ?? '';

     final premiumPlan = data['premiumPlan'] ??'';

      final photo = data['photo'] ??
          data['image'] ??
          '';

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor:
                  Design.buttonColor.withOpacity(.1),
              backgroundImage:
                  photo.toString().isNotEmpty
                      ? NetworkImage(photo.toString())
                      : null,
              child: photo.toString().isEmpty
                  ? Icon(
                      Icons.person,
                      color: Design.buttonColor,
                      size: 28,
                    )
                  : null,
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    name.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Row(
                    children: [
                      Icon(
                        Icons.email_outlined,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          email.toString(),
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

                  if (phone.toString().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          size: 14,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          phone.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                   const SizedBox(height: 5),
                    if (premiumPlan.toString().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          size: 14,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          premiumPlan.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Icon(
            //   Icons.arrow_forward_ios_rounded,
            //   size: 16,
            //   color: Colors.grey.shade400,
            // ),
          ],
        ),
      );
    },
  );
}


 buildPremiumList(
    List<QueryDocumentSnapshot> documents) {
  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: documents.length,
    itemBuilder: (context, index) {
      final data =
          documents[index].data() as Map<String, dynamic>;

      // final name =
      //     data['name'] ??
      //     data['username'] ??
          
      //     data['companyName'] ??
      //     'Unknown User';

      final email = data['email'] ?? 'No email';

      final phone = data['phone'] ?? '';

     final premiumPlan = data['premiumPlan'] ??'';

      final photo = data['photo'] ??
          data['image'] ??
          '';

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor:
                  Design.buttonColor.withOpacity(.1),
              backgroundImage:
                  photo.toString().isNotEmpty
                      ? NetworkImage(photo.toString())
                      : null,
              child: photo.toString().isEmpty
                  ? Icon(
                      Icons.person,
                      color: Design.buttonColor,
                      size: 28,
                    )
                  : null,
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   name.toString(),
                  //   maxLines: 1,
                  //   overflow: TextOverflow.ellipsis,
                  //   style: const TextStyle(
                  //     fontSize: 16,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),

                  const SizedBox(height: 5),

                  Row(
                    children: [
                      Icon(
                        Icons.email_outlined,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          email.toString(),
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

                  if (phone.toString().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          size: 14,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          phone.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                   const SizedBox(height: 5),
                    if (premiumPlan.toString().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.workspace_premium_outlined,
                          size: 14,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          premiumPlan.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Icon(
            //   Icons.arrow_forward_ios_rounded,
            //   size: 16,
            //   color: Colors.grey.shade400,
            // ),
          ],
        ),
      );
    },
  );
}

