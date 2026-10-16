
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:job_project/Controller/payment_controller.dart';


class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _dialogIsShowing = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentController>(
      builder: (context, paymentController, child) {
        // Listen for dialog request
        if (paymentController.dialogTitle != null &&
            paymentController.dialogMessage != null &&
            !_dialogIsShowing) {
          _dialogIsShowing = true;

          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (!mounted) return;

            await showDialog(
              context: context,
              builder: (dialogContext) {
                return AlertDialog(
                  title: Text(paymentController.dialogTitle!),
                  content: SingleChildScrollView(
                    child: Text(paymentController.dialogMessage!),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );

            if (!mounted) return;

            _dialogIsShowing = false;
            paymentController.clearDialog();
          });
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Payment'),
          ),
          body: Center(
            child: ElevatedButton(
              onPressed: paymentController.isLoading
                  ? null
                  : paymentController.openCheckout,
              child: paymentController.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Pay Now'),
            ),
          ),
        );
      },
    );
  }
}