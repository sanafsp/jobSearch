
import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  final String title;
  final IconData icon;

  const EmptyView({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 70,
            color: Colors.grey.shade300,
          ),

          const SizedBox(height: 15),

          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
