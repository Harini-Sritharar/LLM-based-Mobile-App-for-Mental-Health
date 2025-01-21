import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'package:llm_based_sat_app/utils/exercise_page_caller.dart';
import 'package:llm_based_sat_app/widgets/custom_app_bar.dart';
import 'package:llm_based_sat_app/widgets/custom_button.dart';
import 'package:llm_based_sat_app/widgets/exercise_widgets/learning_tile.dart';
import 'package:llm_based_sat_app/widgets/exercise_widgets/checkbox_tile.dart';

class ExerciseInfoPage extends StatelessWidget {
  final Function(int) onItemTapped; // Function to update navbar index
  final int selectedIndex; // Current selected index

  const ExerciseInfoPage({
    Key? key,
    required this.onItemTapped,
    required this.selectedIndex
  });

  void showDialogBox(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF062240),
            ),
          ),
          content: Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF293138),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(color: Color(0xFF123659)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Self-attachment',onItemTapped: onItemTapped, selectedIndex: selectedIndex),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Exercise A',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: AppColours.brandBluePlusThree
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Complete the preparation and learn more about the exercise before you can start practising.',
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 16),
            const Text(
              'Preparation',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF293138)
              ),
            ),
            const SizedBox(height: 8),
            Column(
              children: const [
                CheckboxTile(
                  title: 'Go to a quiet place. If not possible, wear headphones.',
                  icon: Icons.headphones,
                ),
                CheckboxTile(
                  title: 'Set your childhood photo as the background on your phone.',
                  icon: Icons.photo,
                ),
                CheckboxTile(
                  title: 'Plan a visit to a natural area (park, river, mountain, sea..).',
                  icon: Icons.calendar_today,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Learning',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF293138)
              ),
            ),
            const SizedBox(height: 8),
            Column(
              children: [
                LearningTile(
                  title: 'Aim',
                  icon: Icons.lightbulb, subject: 'Aim', content: 'The aim of this exercise is to have a warm and compassionate attitude towards our childhood self and their emotional problems. Later this compassion is extended to other people.',
                ),
                LearningTile(
                  title: 'Theory',
                  icon: Icons.article, subject: 'Theory', content: 'Intervention through self-attachment:\n\n(a) Taking control to achieve self-mastery by creating an internal affectional bond to enhance self-love, compassion, cheerfulness, creativity and strong will.\n\n(b) In self-attachment, we create an affectional bond with our childhood self and “re-parent” them to reach their real and potential and heroic dreams.\n\n(c) A person\'s true inner self that determines what they really want in life is different from their persona, created and influenced by the materialistic society.'
,
                ),
                LearningTile(
                  title: 'Steps',
                  icon: Icons.list, subject: 'Steps', content: '(1) Recalling positive childhood memories.\n(2) Recalling negative childhood memories.\n(3) Recalling early relationships in the family.',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Minimum practice time:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFF293138)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFFCEDFF2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Color(0xFF123659)),
                      ),
                      child: const Text(
                        '5 Mins',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF062240)),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Exercise session:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFF293138)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFFCEDFF2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Color(0xFF123659))
                      ),
                      child: const Text(
                        '3',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF062240)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: CustomButton(
                buttonText: 'Start Exercise',
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ExercisePageCaller(id: "A_2"),
                    ),
                  );
                },
                rightArrowPresent: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
