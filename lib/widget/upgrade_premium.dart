import 'package:flutter/material.dart';
import 'package:job_project/Constants/core/color.dart';
import 'package:job_project/Controller/payment_controller.dart';
import 'package:job_project/Model/premium_model.dart';

class UpgradePremiumPage extends StatelessWidget {
   UpgradePremiumPage({super.key,required this.paymentController});
   PaymentController paymentController;
  List<PremiumPlan> liPremiumPlans=[
    PremiumPlan(id: '1', 
                  title: "Monthly",
                  price: "₹99",
                  amountAsInt: 99,
                  duration: "per month",
                  isPopular: false,),
    PremiumPlan(id: '2',
                  title: "3 Months",
                  price: "₹249",
                  amountAsInt: 249,
                  duration: "for 3 months",isPopular: true),
   ];
  @override
 
Widget build(BuildContext context)
 {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Design.buttonColor,
                Design.buttonColor.withOpacity(0.75),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Column(
            children: [
              Icon(
                Icons.workspace_premium,
                color: Colors.white,
                size: 45,
              ),

              SizedBox(height: 16),

              Text(
                "Upgrade to Premium",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 8),

              Text(
                "Get more opportunities and unlock\npremium job seeker features.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        //plan card

        _planCard(
          context: context,
          controller: paymentController,
          plan: "monthly",
          title: "Monthly",
          price: "₹99",
          duration: "per month",
          planModel: liPremiumPlans[0],
        ),

        const SizedBox(height: 12),

        _planCard(
          context: context,
          controller: paymentController,
          plan: "three_months",
          title: "3 Months",
          price: "₹249",
          duration: "for 3 months",
          planModel: liPremiumPlans[1],
          popular: true,
        ),

        const SizedBox(height: 25),

        // upgrade

        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: paymentController.isProcessing
                ? null
                : () {
                    paymentController.initialize();

                    paymentController.purchasePremium(
                      context,
                    );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Design.buttonColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: paymentController.isProcessing
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : const Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.workspace_premium,
                        size: 22,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Upgrade to Premium",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
          ),
        ),

        const SizedBox(height: 15),

        const Center(
          child: Text(
            "Cancel anytime • Secure payment",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ),
      ],
    ),
  );
}

  static Widget _benefitItem({
  required IconData icon,
  required String title,
  required String subtitle,
  required VoidCallback onTap,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(
        color: Colors.grey.shade200,
      ),
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color:
                    Design.buttonColor.withOpacity(0.1),
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Design.buttonColor,
                size: 23,
              ),
            ),

            const SizedBox(width: 13),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              color: Design.buttonColor,
              size: 16,
            ),
          ],
        ),
      ),
    ),
  );
}


  static Widget _planCard({
    required BuildContext context,
    required PaymentController controller,
    required String plan,
    required String title,
    required String price,
    required String duration,
    bool popular = false,required PremiumPlan planModel
  }) {
    final bool selected = controller.selectedPlan == plan;

    return GestureDetector(
      onTap: () {
        controller.selectPlan(plan,planModel);
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.all(17),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),

          border: Border.all(
            color: selected
                ? Design.buttonColor
                : Colors.grey.shade200,
            width: selected ? 2 : 1,
          ),

          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Design.buttonColor.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),

        child: Row(
          children: [

            // Radio button
            Container(
              height: 22,
              width: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? Design.buttonColor
                      : Colors.grey,
                  width: 2,
                ),
              ),

              child: selected
                  ? Center(
                      child: Container(
                        height: 10,
                        width: 10,
                        decoration: const BoxDecoration(
                          color: Design.buttonColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      if (popular) ...[
                        const SizedBox(width: 8),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Design.buttonColor
                                .withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(5),
                          ),
                          child: const Text(
                            "POPULAR",
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Design.buttonColor,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    duration,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            Text(
              price,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}