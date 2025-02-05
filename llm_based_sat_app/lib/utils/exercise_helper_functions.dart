String getExerciseLetter(String input) {
    // Use split to find the last letter between underscores
    List<String> parts = input.split('_');

    // Check if the string is valid and has enough parts
    if (parts.length > 2) {
      String secondLast = parts[parts.length - 2];

      // Ensure it's a single letter (in case of invalid input)
      if (RegExp(r'^[A-Za-z]$').hasMatch(secondLast)) {
        return secondLast;
      }
    }
    throw ArgumentError("No valid letter found between underscores.");
  }