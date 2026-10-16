import 'package:flutter/material.dart';
import 'package:job_project/Controller/payment_controller.dart';
import 'package:job_project/Widget/premium_benefits.dart';
import 'package:provider/provider.dart';

import '../../Widget/upgrade_premium.dart';
class PremiumView extends StatelessWidget {
   PremiumView({super.key,required this.paymentController});
PaymentController paymentController;
  @override
  Widget build(BuildContext context) {
     final paymentController =
        context.watch<PaymentController>();
    return Scaffold(
      body: Consumer<PaymentController>(
        builder: (context, paymentController, child) {
          if (paymentController.isPremium) {
            return PremiumBenefitsPage(
             
               paymentController: paymentController,
            );
          }

          return UpgradePremiumPage(
           paymentController: 
            paymentController,
          );
        },
      ),
    );
  }
}
