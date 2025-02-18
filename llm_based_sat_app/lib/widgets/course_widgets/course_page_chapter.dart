import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:llm_based_sat_app/models/chapter_interface.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';

/* This widget displays a course chapter with its associated exercises.

Parameters:
- `chapter` : Represents the chapter details including its number, title, exercises, whether it is locked.

Behavior:
- When `chapter.isLocked` is `true`:
  - Tapping on an exercise does not invoke any functionality.
  - The UI will show a locked icon and a grayed-out badge for each exercise.
- When `chapter.isLocked` is `false`:
  - Exercises are interactable, and tapping them invokes the buttonPress` function passed in the `exercise` parameter. */

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
                color: AppColours.brandBluePlusThree,
              ),
            ),
            Text(
              chapter.chapterTitle,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColours.brandBlueMain,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Display dynamic list of exercises
        ...chapter.exercises.map((exercise) => GestureDetector(
              onTap: () {
                if (!chapter.isLocked) {
                  exercise.onButtonPress(context);
                }
              },
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
                        color: chapter.isLocked
                            ? AppColours.neutralGreyMinusThree
                            : AppColours
                                .brandBlueMinusThree, // Background color
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        exercise.letter,
                        style: TextStyle(
                          color: chapter.isLocked
                              ? AppColours.neutralGreyMinusOne
                              : Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),
                    Text(
                      exercise.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: chapter.isLocked
                            ? AppColours.neutralGreyMinusOne
                            : AppColours.neutralGreyPlusThree,
                      ),
                    ),
                    Spacer(),
                    if (!chapter.isLocked)
                      Text(
                        "${exercise.practised} / ${exercise.totalSessions}",
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColours.neutralGreyPlusOne,
                        ),
                      ),
                    SizedBox(
                      width: 10,
                    ),
                    // Display progress indicator or a check mark
                    if (exercise.practised == exercise.totalSessions &&
                        !chapter.isLocked)
                      SvgPicture.asset(
                        'assets/icons/tick.svg',
                        width: 36.0,
                      ),
                    if (exercise.practised != exercise.totalSessions &&
                        !chapter.isLocked)
                      Icon(
                        Icons.chevron_right_outlined,
                        color: AppColours.brandBlueMain,
                        size: 30,
                      ),
                    if (chapter.isLocked)
                      Icon(
                        Icons.lock_outline,
                        color: AppColours.neutralGreyMinusOne,
                        size: 24,
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
