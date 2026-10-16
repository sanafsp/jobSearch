import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:job_project/Constants/core/color.dart';

class InterviewQuestionsAnswersScreen extends StatefulWidget {
  const InterviewQuestionsAnswersScreen({super.key});

  @override
  State<InterviewQuestionsAnswersScreen> createState() =>
      _InterviewQuestionsAnswersScreenState();
}

class _InterviewQuestionsAnswersScreenState
    extends State<InterviewQuestionsAnswersScreen> {

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  String selectedCategory = 'All';
  String searchText = '';

  final TextEditingController searchController =
      TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // FIREBASE 


  Stream<QuerySnapshot<Map<String, dynamic>>>
      _questionsStream() {

    return _firestore
        .collection('interview_questions_answers')
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  // FILTER QUESTIONS
 

  List<QueryDocumentSnapshot<Map<String, dynamic>>>
      _filterQuestions(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> questions,
  ) {

    return questions.where((document) {

      final data = document.data();

      final category =
          data['category']?.toString() ?? '';

      final question =
          data['question']?.toString().toLowerCase() ?? '';

      final answer =
          data['answer']?.toString().toLowerCase() ?? '';

      final search =
          searchText.toLowerCase().trim();

      final categoryMatch =
          selectedCategory == 'All' ||
          category == selectedCategory;

      final searchMatch =
          search.isEmpty ||
          question.contains(search) ||
          answer.contains(search) ||
          category.toLowerCase().contains(search);

      return categoryMatch && searchMatch;

    }).toList();
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey.shade50,

      appBar: AppBar(
         leading:IconButton(onPressed: (){Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios)) ,
        backgroundColor: Design.buttonColor,
        foregroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          'Interview Questions & Answers',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),

      body: StreamBuilder<
          QuerySnapshot<Map<String, dynamic>>>(
        stream: _questionsStream(),

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child: CircularProgressIndicator(),
            );
          }


          if (snapshot.hasError) {

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(30),

                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [

                    Icon(
                      Icons.error_outline,
                      size: 65,
                      color: Colors.red.shade300,
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      'Something went wrong',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Unable to load interview questions.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

         
          // FIREBASE 
          final allQuestions =
              snapshot.data?.docs ?? [];

      
          // CATEGORIES FROM FIREBASE
     

          final categories = <String>{
            'All',

            ...allQuestions.map(
              (document) =>
                  document.data()['category']?.toString() ?? '',
            ),
          }
              .where((category) => category.isNotEmpty)
              .toList();

          // If selected category was deleted from Firebase
          if (!categories.contains(selectedCategory)) {
            selectedCategory = 'All';
          }
          // FILTERED QUESTIONS
        
          final filteredQuestions =
              _filterQuestions(allQuestions);

          return Column(
            children: [

            
              // SEARCH
             

              _searchSection(),

              
              // CATEGORY FILTER
              

              SizedBox(
                height: 55,

                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),

                  scrollDirection: Axis.horizontal,

                  itemCount: categories.length,

                  separatorBuilder: (_, __) =>
                      const SizedBox(width: 8),

                  itemBuilder: (context, index) {

                    final category =
                        categories[index];

                    final selected =
                        selectedCategory == category;

                    return ChoiceChip(
                      label: Text(category),

                      selected: selected,

                      onSelected: (_) {

                        setState(() {
                          selectedCategory = category;
                        });
                      },

                      selectedColor:
                          Design.buttonColor,

                      backgroundColor:
                          Colors.white,

                      labelStyle: TextStyle(
                        color: selected
                            ? Colors.white
                            : Colors.black87,

                        fontWeight: selected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),

                      side: BorderSide(
                        color: selected
                            ? Design.buttonColor
                            : Colors.grey.shade300,
                      ),
                    );
                  },
                ),
              ),

             
              // QUESTIONS
          

              Expanded(
                child: filteredQuestions.isEmpty
                    ? _emptyState()
                    : ListView.builder(

                        padding:
                            const EdgeInsets.fromLTRB(
                          16,
                          8,
                          16,
                          20,
                        ),

                        itemCount:
                            filteredQuestions.length,

                        itemBuilder:
                            (context, index) {

                          final data =
                              filteredQuestions[index]
                                  .data();

                          return _questionCard(
                            data,
                            index + 1,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  // SEARCH SECTION


  Widget _searchSection() {

    return Container(
      color: Design.buttonColor,

      padding: const EdgeInsets.fromLTRB(
        16,
        5,
        16,
        18,
      ),

      child: TextField(
        controller: searchController,

        onChanged: (value) {

          setState(() {
            searchText = value;
          });
        },

        decoration: InputDecoration(

          hintText:
              'Search interview questions...',

          prefixIcon:
              const Icon(Icons.search),

          suffixIcon:
              searchText.isNotEmpty
                  ? IconButton(
                      onPressed: () {

                        searchController.clear();

                        setState(() {
                          searchText = '';
                        });
                      },

                      icon:
                          const Icon(Icons.clear),
                    )
                  : null,

          filled: true,

          fillColor: Colors.white,

          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(14),

            borderSide:
                BorderSide.none,
          ),
        ),
      ),
    );
  }

 
  // QUESTION CARD

  Widget _questionCard(
    Map<String, dynamic> item,
    int number,
  ) {

    final category =
        item['category']?.toString() ?? '';

    final question =
        item['question']?.toString() ?? '';

    final answer =
        item['answer']?.toString() ?? '';

    final tip =
        item['tip']?.toString() ?? '';

    return Container(

      margin:
          const EdgeInsets.only(bottom: 12),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.04),

            blurRadius: 8,

            offset:
                const Offset(0, 2),
          ),
        ],
      ),

      child: ExpansionTile(

        tilePadding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 5,
        ),

        childrenPadding:
            const EdgeInsets.fromLTRB(
          16,
          0,
          16,
          18,
        ),

        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(16),
        ),

        collapsedShape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(16),
        ),


        leading: Container(

          width: 42,
          height: 42,

          alignment:
              Alignment.center,

          decoration: BoxDecoration(
            color:
                Design.buttonColor
                    .withOpacity(0.10),

            borderRadius:
                BorderRadius.circular(12),
          ),

          child: Text(
            '$number',

            style: TextStyle(
              color:
                  Design.buttonColor,

              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ),

   

        title: Text(
          question,

          style: const TextStyle(
            fontWeight:
                FontWeight.w600,

            fontSize: 15,
          ),
        ),

      

        subtitle: category.isNotEmpty
            ? Padding(
                padding:
                    const EdgeInsets.only(
                  top: 5,
                ),

                child: Text(
                  category,

                  style: TextStyle(
                    color:
                        Design.buttonColor,

                    fontSize: 12,

                    fontWeight:
                        FontWeight.w500,
                  ),
                ),
              )
            : null,


        children: [

          const Divider(),

          const SizedBox(height: 8),

          _answerSection(
            icon:
                Icons.lightbulb_outline,

            title:
                'Suggested Answer',

            content:
                answer,
          ),

       
          if (tip.isNotEmpty) ...[

            const SizedBox(height: 15),

            _answerSection(
              icon:
                  Icons.tips_and_updates_outlined,

              title:
                  'Interview Tip',

              content:
                  tip,
            ),
          ],
        ],
      ),
    );
  }


  Widget _answerSection({
    required IconData icon,
    required String title,
    required String content,
  }) {

    return Container(

      width: double.infinity,

      padding:
          const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color:
            Design.buttonColor
                .withOpacity(0.05),

        borderRadius:
            BorderRadius.circular(12),
      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Row(
            children: [

              Icon(
                icon,

                color:
                    Design.buttonColor,

                size: 21,
              ),

              const SizedBox(width: 8),

              Text(
                title,

                style: TextStyle(
                  color:
                      Design.buttonColor,

                  fontWeight:
                      FontWeight.bold,

                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: 9),

          Text(
            content,

            style: TextStyle(
              color:
                  Colors.grey.shade800,

              fontSize: 13,

              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }

 
  Widget _emptyState() {

    return Center(

      child: Padding(
        padding:
            const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            Icon(
              Icons.search_off_rounded,

              size: 65,

              color:
                  Colors.grey.shade400,
            ),

            const SizedBox(height: 15),

            const Text(
              'No Questions Found',

              style: TextStyle(
                fontSize: 19,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Try another search or select a different category.',

              textAlign:
                  TextAlign.center,

              style: TextStyle(
                color:
                    Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}