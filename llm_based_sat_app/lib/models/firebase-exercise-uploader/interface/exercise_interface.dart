import 'package:llm_based_sat_app/models/firebase-exercise-uploader/interface/final_step_interface.dart';
import 'package:llm_based_sat_app/models/firebase-exercise-uploader/interface/step_interface.dart';

class Exercise {
  final String id;
  final String exerciseTitle;
  final String objective;
  final String minimumPracticeTime;
  final int totalSessions;
  final List<String> preExerciseTasks;
  final List<String> requiredLearning;
  final List<String> optionalLearning;
  final List<Step> exerciseSteps;
  final FinalStep? exerciseFinalStep;
  final List<String> afterExerciseTasks;

  Exercise({
    required this.id,
    required this.exerciseTitle,
    required this.objective,
    required this.minimumPracticeTime,
    required this.totalSessions,
    required this.preExerciseTasks,
    required this.requiredLearning,
    required this.optionalLearning,
    this.exerciseSteps = const [],
    this.exerciseFinalStep,
    required this.afterExerciseTasks,
  });

  // Factory method to create an Exercise from Firestore data
  factory Exercise.fromFirestore(String id, Map<String, dynamic> data) {
    return Exercise(
      id: id,
      exerciseTitle: data['Exercise_title'] ?? '',
      objective: data['Objective'] ?? '',
      minimumPracticeTime: data['Minimum practice time'],
      totalSessions: data['Total sessions'] ?? 0,
      preExerciseTasks: List<String>.from(data['Pre-Exercise Tasks'] ?? []),
      requiredLearning: List<String>.from(data['Required learning'] ?? []),
      optionalLearning: List<String>.from(data['Optional learning'] ?? []),
      afterExerciseTasks: List<String>.from(data['After-Exercise Tasks'] ?? []),
    );
  }

  // Method to attach steps and final step to an exercise
  Exercise withStepsAndFinalStep(List<Step> steps, FinalStep finalStep) {
    return Exercise(
      id: id,
      exerciseTitle: exerciseTitle,
      objective: objective,
      minimumPracticeTime: minimumPracticeTime,
      totalSessions: totalSessions,
      preExerciseTasks: preExerciseTasks,
      requiredLearning: requiredLearning,
      optionalLearning: optionalLearning,
      exerciseSteps: steps,
      exerciseFinalStep: finalStep,
      afterExerciseTasks: afterExerciseTasks,
    );
  }
}
