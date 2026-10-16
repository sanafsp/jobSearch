import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:job_project/Model/api_responce_model.dart';
import 'package:job_project/Model/logged_user_model.dart';
import 'package:job_project/Model/password_change_mdl.dart';
import 'package:job_project/Repository/local_storage.dart';
import 'package:job_project/Utils/validations_utils.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';


class HomeController extends ChangeNotifier {

Future<void> generatePdfFromText(String text) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(24),
          child: pw.Text(
            text,
            style: pw.TextStyle(
              fontSize: 14,
            ),
          ),
        );
      },
    ),
  );

  await Printing.layoutPdf(
    onLayout: (format) async => pdf.save(),
  );
}
  
  
}