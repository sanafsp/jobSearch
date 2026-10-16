import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_project/Constants/core/color.dart';
import 'package:pdf/pdf.dart';
 import 'package:pdf/widgets.dart' as pw;
 import 'package:printing/printing.dart';

class ResumeViewScreen extends StatefulWidget {
  final String userId;
  const ResumeViewScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<ResumeViewScreen> createState() => _ResumeViewScreenState();
}

class _ResumeViewScreenState extends State<ResumeViewScreen> {
  Map<String, dynamic>? userData;
  String generatedObjective = "";

  @override
  void initState() {
    super.initState();
    fetchResumeData();
  }

  // Function to fetch user data from Firestore
  Future<void> fetchResumeData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('job_seekers')
        .doc(widget.userId)
        .get();

    if (snapshot.exists) {
      setState(() {
        userData = snapshot.data() as Map<String, dynamic>;
        // Automatically generate the objective
        generatedObjective = generateObjective();
      });

      // Save the generated objective to Firestore if it's not already set
      if (userData?['objective'] == null || userData?['objective'].isEmpty) {
        updateObjective(generatedObjective);
      }
    }
  }


  // here comes generate pdf funciton
    Future<void> generatePdf() async {
    if (userData == null) return;

    final pdf = pw.Document();

    final String name = userData!['name']?.toString() ?? '';
    final String email = userData!['email']?.toString() ?? '';
    final String phone = userData!['phone']?.toString() ?? '';
    final String location = userData!['location']?.toString() ?? '';
    final String education = userData!['education']?.toString() ?? '';
    final String skills = userData!['skills']?.toString() ?? '';
    final String certifications =
        userData!['certifications']?.toString() ?? '';
    final String links = userData!['links']?.toString() ?? '';
    final String resume = userData!['resume']?.toString() ?? '';

    final String firstLetter =
        name.isNotEmpty ? name[0].toUpperCase() : '?';

    // Experience
    List experienceList = [];

    if (userData!['experience'] != null &&
        userData!['experience'] is List) {
      experienceList = userData!['experience'];
    }

    // PDF PAGE
    

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),

        build: (pw.Context context) {
          return [
         

            pw.Container(
              padding: const pw.EdgeInsets.all(20),
              decoration: pw.BoxDecoration(
                color: PdfColors.blue,
                borderRadius: pw.BorderRadius.circular(12),
              ),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  // Avatar
                  pw.Container(
                    width: 70,
                    height: 70,
                    alignment: pw.Alignment.center,
                    decoration: pw.BoxDecoration(
                      color: PdfColors.white,
                      shape: pw.BoxShape.circle,
                    ),
                    child: pw.Text(
                      firstLetter,
                      style: pw.TextStyle(
                        fontSize: 30,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue,
                      ),
                    ),
                  ),

                  pw.SizedBox(width: 18),

                  // User details
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          name,
                          style: pw.TextStyle(
                            fontSize: 22,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),

                        pw.SizedBox(height: 5),

                        if (email.isNotEmpty)
                          pw.Text(
                            email,
                            style: const pw.TextStyle(
                              fontSize: 11,
                              color: PdfColors.white,
                            ),
                          ),

                        if (phone.isNotEmpty)
                          pw.Text(
                            phone,
                            style: const pw.TextStyle(
                              fontSize: 11,
                              color: PdfColors.white,
                            ),
                          ),

                        if (location.isNotEmpty)
                          pw.Text(
                            location,
                            style: const pw.TextStyle(
                              fontSize: 11,
                              color: PdfColors.white,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 20),

          

            buildPdfSectionTitle('Resume Objective'),

            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Text(
                generatedObjective,
                style: pw.TextStyle(
                  fontSize: 11,
                  fontStyle: pw.FontStyle.italic,
                  lineSpacing: 3,
                ),
              ),
            ),

            pw.SizedBox(height: 18),


            if (location.isNotEmpty) ...[
              buildPdfSectionTitle('Location'),
              pw.Text(
                location,
                style: const pw.TextStyle(fontSize: 11),
              ),
              pw.SizedBox(height: 15),
            ],

            if (education.isNotEmpty) ...[
              buildPdfSectionTitle('Education'),
              pw.Text(
                education,
                style: const pw.TextStyle(fontSize: 11),
              ),
              pw.SizedBox(height: 15),
            ],


            if (skills.isNotEmpty) ...[
              buildPdfSectionTitle('Skills'),
              pw.Text(
                skills,
                style: const pw.TextStyle(fontSize: 11),
              ),
              pw.SizedBox(height: 15),
            ],

        

            if (experienceList.isNotEmpty) ...[
              buildPdfSectionTitle('Experience'),

              pw.SizedBox(height: 5),

              ...experienceList.map((exp) {
                final String position =
                    exp['position']?.toString() ?? 'Position';

                final String company =
                    exp['company']?.toString() ?? 'Company';

                final String year =
                    exp['year']?.toString() ?? 'Year';

                return pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 10),
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      color: PdfColors.grey400,
                    ),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Row(
                    crossAxisAlignment:
                        pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        width: 8,
                        height: 8,
                        margin:
                            const pw.EdgeInsets.only(top: 4),
                        decoration: const pw.BoxDecoration(
                          color: PdfColors.blue,
                          shape: pw.BoxShape.circle,
                        ),
                      ),

                      pw.SizedBox(width: 10),

                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment:
                              pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              position,
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight:
                                    pw.FontWeight.bold,
                              ),
                            ),

                            pw.SizedBox(height: 3),

                            pw.Text(
                              '$company - $year',
                              style: const pw.TextStyle(
                                fontSize: 10,
                                color: PdfColors.grey700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),

              pw.SizedBox(height: 8),
            ],

         
            if (certifications.isNotEmpty) ...[
              buildPdfSectionTitle('Certifications'),
              pw.Text(
                certifications,
                style: const pw.TextStyle(fontSize: 11),
              ),
              pw.SizedBox(height: 15),
            ],

          

            if (links.isNotEmpty) ...[
              buildPdfSectionTitle('Portfolio'),
              pw.Text(
                links,
                style: pw.TextStyle(
                  fontSize: 11,
                  color: PdfColors.blue,
                ),
              ),
              pw.SizedBox(height: 15),
            ],

           

            if (resume.isNotEmpty) ...[
              buildPdfSectionTitle('Resume Link'),

              pw.Text(
                resume,
                style: pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.blue,
                  decoration:
                      pw.TextDecoration.underline,
                ),
              ),

              pw.SizedBox(height: 20),
            ],

            pw.Divider(
              color: PdfColors.grey400,
            ),

            pw.SizedBox(height: 5),

            pw.Center(
              child: pw.Text(
                'Generated Resume',
                style: const pw.TextStyle(
                  fontSize: 9,
                  color: PdfColors.grey600,
                ),
              ),
            ),
          ];
        },
      ),
    );



    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async {
        return pdf.save();
      },
    );
  }

  pw.Widget buildPdfSectionTitle(String title) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue,
          ),
        ),

        pw.SizedBox(height: 4),

        pw.Container(
          height: 2,
          width: 40,
          color: PdfColors.blue,
        ),

        pw.SizedBox(height: 8),
      ],
    );
  }
  // 

  // Function to generate the objective
  String generateObjective() {
    String name = userData?['name'] ?? 'Job Seeker';
    String skills = userData?['skills'] ?? 'various skills';
    String experience = userData?['experience'] != null && userData!['experience'].isNotEmpty
        ? 'extensive experience in ${userData!['experience'][0]['position'] ?? "field"}'
        : 'seeking new opportunities';
    String education = userData?['education'] ?? 'education background';

    return 'A motivated and results-driven professional with ${experience}, expertise in ${skills}, and a solid ${education}. Seeking to leverage skills in a challenging role to contribute to organizational success and personal growth.';
  }

  // Function to update the objective in Firestore
  Future<void> updateObjective(String objective) async {
    await FirebaseFirestore.instance
        .collection('job_seekers')
        .doc(widget.userId)
        .update({'objective': objective});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(
        leading: IconButton(onPressed: (){
        Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,)),
        title: Text("Resume", style: TextStyle(color: Colors.white),),
        backgroundColor: Design.buttonColor,
        centerTitle: true,
      ),
      body: userData == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar Section
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Design.buttonColor,
                        child: Text(
                          userData!['name'] != null
                              ? userData!['name'][0].toUpperCase()
                              : '?',
                          style: TextStyle(fontSize: 30, color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        userData!['name'] ?? '',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(userData!['email'] ?? '', style: TextStyle(fontSize: 16)),
                      Text(userData!['phone'] ?? '', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 20),

                      // Resume Objective Section
                      Text("Resume Objective", style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text(generatedObjective,
                          style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
                      SizedBox(height: 20),

                      // General Info Section
                      Text("Location", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(userData!['location'] ?? ''),
                      SizedBox(height: 10),

                      Text("Education", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(userData!['education'] ?? ''),
                      SizedBox(height: 10),

                      Text("Skills", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(userData!['skills'] ?? ''),
                      SizedBox(height: 10),

                      // Experience Section
                      if (userData!['experience'] != null) ...[
                        Text("Experience", style: TextStyle(fontWeight: FontWeight.bold)),
                        ...userData!['experience'].map<Widget>((exp) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(Icons.work_outline, color: Design.buttonColor),
                              title: Text(exp['position'] ?? "Position"),
                              subtitle: Text(
                                  "${exp['company'] ?? "Company"} - ${exp['year'] ?? "Year"}"),
                            ),
                          );
                        }).toList(),
                        SizedBox(height: 10),
                      ],

                      // Certifications Section
                      Text("Certifications", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(userData!['certifications'] ?? ''),
                      SizedBox(height: 10),

                      // Portfolio Section
                      Text("Portfolio", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(userData!['links'] ?? ''),
                      SizedBox(height: 10),

                      // Resume Link Section
                      if ((userData!['resume'] ?? '').isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Resume Link", style: TextStyle(fontWeight: FontWeight.bold)),
                            SelectableText(
                              userData!['resume'],
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline),
                            ),
                          ],
                        ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              
            ),
            floatingActionButton: FloatingActionButton( backgroundColor: Design.buttonColor,
             onPressed: userData == null ? null : () async {
               await generatePdf(); }, 
               child: const Icon( Icons.picture_as_pdf, color: Colors.white, ), ),
    );
  }
}
