import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:llm_based_sat_app/models/chapter_interface.dart';

class CoursePageChapter extends StatelessWidget {
  final ChapterInterface chapter;

  const CoursePageChapter({
    super.key,
    required this.chapter,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Heading for the list
        Row(
          children: [
            Text(
              "Chapter ${chapter.chapterNumber} - ",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF062240),
              ),
            ),
            Text(
              chapter.chapterTitle,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1C548C),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Display dynamic list of exercises
        ...chapter.exercises.map((exercise) => GestureDetector(
              onTap: () => exercise.onButtonPress(context),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Display the letter as a badge
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCEDFF2), // Background color
                        borderRadius: BorderRadius.circular(
                            10), // Border radius for rounded corners
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        exercise.letter,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),
                    Text(
                      exercise.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "${exercise.practised} / ${exercise.totalSessions}",
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF293138),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    // Display progress indicator or a check mark
                    if (exercise.practised == exercise.totalSessions)
                      SvgPicture.asset(
                        'assets/icons/tick.svg',
                        width: 36.0,
                      )
                    else
                      Icon(
                        Icons.chevron_right_outlined,
                        color: Color(0xFF1C548C),
                        size: 30,
                      ),
                  ],
                ),
              ),
            )),

        const SizedBox(height: 30),
      ],
    );
  }
}
