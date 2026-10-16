
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_project/Constants/config.dart';
import 'package:job_project/Model/premium_model.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentController extends ChangeNotifier {
  late Razorpay _razorpay;

  bool _isInitialized = false;
  bool _isLoading = false;

  bool isProcessing = false;
  bool isPremium = false;

  String? _dialogTitle;
  String? _dialogMessage;

  String selectedPlan = "monthly";

  PremiumPlan selectedPlanModel = PremiumPlan();

  String? paymentId;

  bool isCheckingPremium = false;

  bool get isInitialized => _isInitialized;

  bool get isLoading => _isLoading;

  String? get dialogTitle => _dialogTitle;

  String? get dialogMessage => _dialogMessage;

  //razorpay
DateTime? premiumExpiryDate;

String get premiumExpiryDateText {
  if (premiumExpiryDate == null) {
    return "Not available";
  }

  final date = premiumExpiryDate!;

  return "${date.day.toString().padLeft(2, '0')}/"
      "${date.month.toString().padLeft(2, '0')}/"
      "${date.year}";
}
  void initialize() {
    if (_isInitialized) return;

    _razorpay = Razorpay();

    _razorpay.on(
      Razorpay.EVENT_PAYMENT_SUCCESS,
      _handleSuccess,
    );

    _razorpay.on(
      Razorpay.EVENT_PAYMENT_ERROR,
      _handleError,
    );

    _razorpay.on(
      Razorpay.EVENT_EXTERNAL_WALLET,
      _handleExternalWallet,
    );

    _isInitialized = true;
  }

  // select plan

  void selectPlan(
    String plan,
    PremiumPlan planModel,
  ) {
    selectedPlan = plan;
    selectedPlanModel = planModel;

    print(
      'Selected Plan: $selectedPlan',
    );

    print(
      'Selected Amount: ${selectedPlanModel.amountAsInt}',
    );

    notifyListeners();
  }

  //purchase premium

  Future<void> purchasePremium(BuildContext context) async {
    if (isProcessing) return;

    final int amount =
        selectedPlanModel.amountAsInt ?? 0;

    if (amount <= 0) {
      _setDialog(
        'Invalid Amount',
        'Please select a valid premium plan.',
      );

      notifyListeners();
      return;
    }

    isProcessing = true;
    notifyListeners();

    try {
      initialize();

      print('==============================');
      print('PREMIUM PAYMENT');
      print('Plan: $selectedPlan');
      print('Title: ${selectedPlanModel.title}');
      print('Amount: ₹$amount');
      print('Paise: ${amount * 100}');
      print('==============================');

      openCheckout();
    } catch (e) {
      isProcessing = false;

      _setDialog(
        'Payment Error',
        e.toString(),
      );

      notifyListeners();
    }
  }

  void openCheckout() {
  if (!_isInitialized) {
    initialize();
  }

  final int amount = selectedPlanModel.amountAsInt ?? 0;

  if (amount <= 0) {
    _setDialog(
      'Invalid Amount',
      'Please select a valid premium plan.',
    );
    notifyListeners();
    return;
  }

  final int amountInPaise = amount * 100;

  _isLoading = true;
  notifyListeners();

  debugPrint('==============================');
  debugPrint('OPENING RAZORPAY');
  debugPrint('Plan: $selectedPlan');
  debugPrint('Amount: ₹$amount');
  debugPrint('Amount in paise: $amountInPaise');
  debugPrint('Key: ${Config.rzrpayTestKey}');
  debugPrint('==============================');

  final Map<String, dynamic> options = {
    'key': Config.rzrpayTestKey,
    'amount': amountInPaise,
    'currency': 'INR',
    'name': 'Job Search',
    'description': '${selectedPlanModel.title} Premium Plan',
  };

  try {
    _razorpay.open(options);
  } catch (e) {
    debugPrint('Razorpay open error: $e');

    _isLoading = false;
    isProcessing = false;

    _setDialog(
      'Unable to Open Payment',
      e.toString(),
    );

    notifyListeners();
  }
}

//payment
Future<void> _handleSuccess(
  PaymentSuccessResponse response,
) async {
  _isLoading = false;

  paymentId = response.paymentId;

  debugPrint('==============================');
  debugPrint('PAYMENT SUCCESS');
  debugPrint('Payment ID: ${response.paymentId}');
  debugPrint('Plan: $selectedPlan');
  debugPrint(
    'Amount: ${selectedPlanModel.amountAsInt}',
  );
  debugPrint('==============================');

  try {
    await savePremiumToFirebase(response);

    isPremium = true;

    _setDialog(
      'Payment Successful',
      'Your ${selectedPlanModel.title} Premium plan is now active.',
    );
  } catch (e) {
    debugPrint(
      'Error saving premium: $e',
    );

    _setDialog(
      'Payment Successful',
      'Payment was successful, but premium information could not be saved.\n\n$e',
    );
  }

  isProcessing = false;

  notifyListeners();
}

  Future<void> savePremiumToFirebase(
    PaymentSuccessResponse response,
  ) async {
    final User? user =
        FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception(
        'User is not logged in.',
      );
    }

    final DateTime startDate =
        DateTime.now();

    DateTime expiryDate;

    // Monthly
    if (selectedPlan == 'monthly') {
      expiryDate = DateTime(
        startDate.year,
        startDate.month + 1,
        startDate.day,
        startDate.hour,
        startDate.minute,
        startDate.second,
      );
    }

    // 3 Months
    else if (selectedPlan == 'three_months') {
      expiryDate = DateTime(
        startDate.year,
        startDate.month + 3,
        startDate.day,
        startDate.hour,
        startDate.minute,
        startDate.second,
      );
    }

    // Default
    else {
      expiryDate = DateTime(
        startDate.year,
        startDate.month + 1,
        startDate.day,
      );
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set(
      {
        'isPremium': true,

        'premiumPlan': selectedPlan,

        'premiumTitle':
            selectedPlanModel.title,

        'premiumAmount':
            selectedPlanModel.amountAsInt,

        'premiumStartDate':
            Timestamp.fromDate(startDate),

        'premiumExpiryDate':
            Timestamp.fromDate(expiryDate),

        'razorpayPaymentId':
            response.paymentId,

        'razorpayOrderId':
            response.orderId,

        'razorpaySignature':
            response.signature,

        'updatedAt':
            FieldValue.serverTimestamp(),
      },
      SetOptions(
        merge: true,
      ),
    );

    print(
      'Premium information saved to Firebase',
    );

    print(
      'Premium expiry: $expiryDate',
    );
  }


Future<void> checkPremiumStatus() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    isPremium = false;
    premiumExpiryDate = null;
    isCheckingPremium = false;
    notifyListeners();
    return;
  }

  isCheckingPremium = true;
  notifyListeners();

  try {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!doc.exists || doc.data() == null) {
      isPremium = false;
      premiumExpiryDate = null;
      return;
    }

    final data = doc.data()!;

    final bool firebasePremium =
        data['isPremium'] == true;

    final dynamic expiryValue =
        data['premiumExpiryDate'];

    
    // No premium
    

    //expiry
    if (!firebasePremium) {
      isPremium = false;
      premiumExpiryDate = null;
      return;
    }

    if (expiryValue is! Timestamp) {
      isPremium = false;
      premiumExpiryDate = null;

      debugPrint(
        'Premium expiry date is missing or invalid',
      );

      return;
    }

    final DateTime expiryDate =
        expiryValue.toDate();
    premiumExpiryDate = expiryDate;

    debugPrint(
      'Premium expiry loaded: $premiumExpiryDate',
    );

   //expiry checking

    final DateTime now = DateTime.now();

    if (now.isBefore(expiryDate)) {
      isPremium = true;

      debugPrint(
        'Premium ACTIVE until: $expiryDate',
      );
    } else {
      isPremium = false;

      debugPrint(
        'Premium EXPIRED on: $expiryDate',
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'isPremium': false,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  } catch (e) {
    debugPrint(
      'CHECK PREMIUM ERROR: $e',
    );
  } finally {
    isCheckingPremium = false;
    notifyListeners();
  }
}


void _handleError(PaymentFailureResponse response) {
  _isLoading = false;
  isProcessing = false;


  _dialogTitle = "Payment Failed";
  _dialogMessage =
      response.message ?? "Payment was cancelled or failed.";

  notifyListeners();

  debugPrint(
    'PAYMENT FAILED: ${response.code} - ${response.message}',
  );
}

  //external wallet

  void _handleExternalWallet(
    ExternalWalletResponse response,
  ) {
    _isLoading = false;
    isProcessing = false;

    _setDialog(
      'External Wallet',
      'Wallet: ${response.walletName}',
    );

    notifyListeners();
  }

//dialog

  void _setDialog(
    String title,
    String message,
  ) {
    _dialogTitle = title;
    _dialogMessage = message;
  }

  void clearDialog() {
    _dialogTitle = null;
    _dialogMessage = null;

    notifyListeners();
  }

//dispose

  @override
  void dispose() {
    if (_isInitialized) {
      _razorpay.clear();
    }

    super.dispose();
  }
}