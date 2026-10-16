import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:job_project/Controller/payment_controller.dart';
import 'package:job_project/View/jobSeeker/premiumView_plan.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PaymentController>(
      create: (_) {
        final controller = PaymentController();

        controller.checkPremiumStatus();

        return controller;
      },
      child: Consumer<PaymentController>(
        builder: (context, paymentController, child) {
          return PremiumView(
            paymentController: paymentController,
          );
        },
      ),
    );
  }
}
