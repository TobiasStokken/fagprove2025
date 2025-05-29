import 'package:faq_app/models/FAQ_models.dart';
import 'package:faq_app/screens/faq_question_screen.dart';
import 'package:flutter/material.dart';

class FaqThemeCard extends StatelessWidget {
  final FAQ faqData;
  const FaqThemeCard({super.key, required this.faqData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: Card(
          margin: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FaqQuestionScreen(faqData: faqData),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(faqData.theme.title),
                      SizedBox(height: 8.0),
                      Text(faqData.theme.description),
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
