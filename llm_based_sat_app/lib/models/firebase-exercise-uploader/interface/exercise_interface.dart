import 'package:llm_based_sat_app/models/firebase-exercise-uploader/interface/final_step_interface.dart';
import 'package:llm_based_sat_app/models/firebase-exercise-uploader/interface/step_interface.dart';

/// Represents an exercise within a chapter, containing multiple steps,
/// learning objectives, and final assessment tasks.
class Exercise {
  final String id;

  /// Unique identifier for the exercise.
  final String exerciseTitle;

  /// Title of the exercise.
  final String objective;

  /// Objective of the exercise, explaining its purpose and learning outcomes.
  final String minimumPracticeTime;

  /// Minimum recommended practice time for the exercise.
  final int totalSessions;

  /// Total number of sessions required to complete the exercise.
  final List<String> preExerciseTasks;

  /// List of preparatory tasks to be completed before starting the exercise.
  final List<String> requiredLearning;
  final List<String> optionalLearning;

  /// List of optional topics or skills that may enhance the learning experience.
  final List<Step> exerciseSteps;

  /// List of steps involved in completing the exercise.
  final FinalStep? exerciseFinalStep;

  /// The final step of the exercise, which may contain assessments or a summary.
  final List<String> afterExerciseTasks;

  /// List of tasks or reflections to be completed after finishing the exercise.

  /// Constructor to initialize an `Exercise` instance with required attributes.
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

  /// Factory method to create an `Exercise` instance from Firestore data.
  ///
  /// - `id`: The Firestore document ID.
  /// - `data`: The Firestore document data as a `Map<String, dynamic>`.
  ///
  /// Returns an instance of `Exercise` populated with Firestore data.
  factory Exercise.fromFirestore(String id, Map<String, dynamic> data) {
    return Exercise(
      id: id,
      exerciseTitle: data['Exercise_title'] ?? '',
      objective: data['Objective'] ?? '',
      minimumPracticeTime: data['Minimum practice time'],
      totalSessions: data['Total sessions'] ?? 0,
      preExerciseTasks: List<String>.from(data['Pre-exercise tasks'] ?? []),
      requiredLearning: List<String>.from(data['Required learning'] ?? []),
      optionalLearning: List<String>.from(data['Optional learning'] ?? []),
      afterExerciseTasks: List<String>.from(data['After-exercise tasks'] ?? []),
    );
  }

  /// Creates a new `Exercise` instance with updated steps and a final step.
  ///
  /// - `steps`: A list of `Step` objects representing the sequence of actions in the exercise.
  /// - `finalStep`: The concluding step of the exercise, typically used for assessment.
  ///
  /// Returns a new `Exercise` instance with the updated `exerciseSteps` and `exerciseFinalStep`.
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
