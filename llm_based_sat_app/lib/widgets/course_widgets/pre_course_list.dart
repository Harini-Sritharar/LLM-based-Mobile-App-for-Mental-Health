import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'package:llm_based_sat_app/widgets/course_widgets/course_list_all_prerequisites.dart';
import 'package:llm_based_sat_app/widgets/course_widgets/empty_pre_requisite.dart';
import 'package:llm_based_sat_app/widgets/custom_button.dart';

// If watchedIntroductoryVideo is false or prerequisite is there or childhood photo is not uploaded then user cannot proceed to start exercise
// TODO
// Link up cache to check if watchedIntroductoryVideo is true for given id
class PreCourseList extends StatelessWidget {
  // Accepts three functions for each of the list items
  final void Function(BuildContext) onStartCoursePressed;
  final void Function(BuildContext) onWatchIntroductoryVideoPressed;
  final void Function(BuildContext) onUploadChildhoodPhotosPressed;
  final List<String> prerequisites;
  final bool watchedIntroductoryVideo;
  final bool childhoodPhotosUploaded;

  const PreCourseList({
    Key? key,
    required this.onStartCoursePressed,
    required this.onWatchIntroductoryVideoPressed,
    required this.onUploadChildhoodPhotosPressed,
    required this.prerequisites,
    required this.watchedIntroductoryVideo,
    required this.childhoodPhotosUploaded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Heading for the list
        const Text(
          "Pre-course tasks",
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w500,
            color: AppColours.brandBluePlusThree,
          ),
        ),
        const SizedBox(height: 10),

        // Tasks yet to complete
        GestureDetector(
          child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                children: [
                  if (prerequisites.isEmpty) EmptyPreRequisites(),
                  if (prerequisites.isNotEmpty)
                    ListAllPreRequisites(preRequisitesList: prerequisites),
                ],
              )),
        ),
        const SizedBox(height: 20),

        // Watch Introductory Video
        GestureDetector(
          onTap: () {},
          child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                children: [
                  if (watchedIntroductoryVideo)
                    SvgPicture.asset(
                      'assets/icons/tick.svg',
                      width: 36.0,
                    ),
                  if (!watchedIntroductoryVideo) const SizedBox(width: 5),
                  if (!watchedIntroductoryVideo)
                    Icon(
                      Icons.warning_amber_outlined,
                      color: Colors.amber,
                      size: 26,
                    ),
                  if (!watchedIntroductoryVideo) const SizedBox(width: 6),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.ondemand_video,
                    color: AppColours.neutralGreyMinusOne,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Watch Introductory Video",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              )),
        ),

        const SizedBox(height: 20),

        // Upload childhood photos
        GestureDetector(
          onTap: () {},
          child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                children: [
                  if (childhoodPhotosUploaded)
                    SvgPicture.asset(
                      'assets/icons/tick.svg',
                      width: 36.0,
                    ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.image_rounded,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Upload childhood photos",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              )),
        ),

        const SizedBox(height: 30),

        // Start Course Button
        if (childhoodPhotosUploaded &&
            prerequisites.isEmpty &&
            watchedIntroductoryVideo)
          CustomButton(
              buttonText: "Start Course",
              onPress: () {
                onStartCoursePressed(context);
              },
              rightArrowPresent: true),
      ],
    );
  }
}
