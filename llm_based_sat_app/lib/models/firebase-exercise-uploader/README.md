# Firebase Exercise Uploader

A Python script to automate the upload of structured exercise data to Firebase Cloud Storage.

## Features
- Automates uploading exercise data.
- Organizes data in a folder structure in Firebase Storage.
- Supports scalability for multiple exercises.
- Provides logging for upload status and error handling.

## Prerequisites
1. Python 3.8 or later.
2. Firebase Admin SDK service account key.

## Getting a Firebase Admin SDK Key
To use Firebase services programmatically, you need to generate a Firebase Admin SDK private key:

1. Go to the [Firebase Console](https://console.firebase.google.com/).
2. Select your project.
3. Navigate to **Project settings** (click on the gear icon in the sidebar).
4. Go to the **Service accounts** tab.
5. Click **Generate new private key** under Firebase Admin SDK.
6. A JSON file will be downloaded—this is your service account key.

## Placing the Firebase Admin SDK Key
- Save the downloaded JSON key file in the root directory of your project.
- Update the file path in `upload_to_firebase.py` (line 10) to match your key file name:
  ```
  cred = credentials.Certificate("./your-firebase-key.json")
  ```

## Data Structure and Storage

The exercise data is structured into three main JSON files: `courses_data.json`, `exercise_data.json`, and `steps_data.json`. Below are the guidelines for storing data in each file.

### 1. `course_data.json`
This file defines the structure of courses, including their metadata, chapters, and associated exercises.

#### **Structure:**
Each course is stored as a key-value pair where:
- **Key**: The course name (e.g., `"Self-Attachment"`).
- **Value**: An object containing the course's details.

#### **Required Fields:**
- `Aim`: The purpose of the course.
- `Subscription`: Whether the course is "Free" or "Paid".
- `Course_type`: "Core" or "Advanced".
- `Course_title`: The official title of the course.
- `Rating`: The user rating (float).
- `Rating_Count`: The number of reviews.
- `Duration`: The estimated completion time.
- `Image_URL`: Local path to the course image.
- `Prerequisites course tasks`: A list of required prerequisite courses.
- `Chapters`: A dictionary where each chapter has:
  - `Aim`: The goal of the chapter.
  - `Chapter_title`: The chapter’s title.
  - `Exercises`: A list of exercise IDs linked to this chapter.

#### **Example Entry:**
```json
"Self-Attachment": {
    "Aim": "To build a strong and compassionate connection with one's inner child, fostering emotional growth and self-regulation.",
    "Subscription": "Paid",
    "Course_type": "Core",
    "Course_title": "Self-attachment",
    "Rating": 4.2,
    "Rating_Count": 7830,
    "Duration": "2 weeks",
    "Image_URL": "assets/images/self_attachment.png",
    "Prerequisites course tasks": ["Requirement 1", "Requirement 2"],
    "Chapters": {
        "Chapter 1": {
            "Aim": "Connecting compassionately with our child",
            "Chapter_title": "Companionate connection",
            "Exercises": [
                "Self-Attachment_1_A",
                "Self-Attachment_1_B"
            ]
        }
    }
}
```

---

### 2. `exercise_data.json`
This file contains details about each exercise, including objectives, required learning, and steps.

#### **Structure:**
Each exercise is stored as a key-value pair where:
- **Key**: The exercise ID (e.g., `"Self-Attachment_1_A"`).
- **Value**: An object containing the exercise details.

#### **Required Fields:**
- `Exercise_title`: Name of the exercise.
- `Objective`: The goal of the exercise.
- `Minimum practice time`: Recommended practice duration.
- `Total sessions`: Number of required practice sessions.
- `Pre-exercise tasks`: Steps users should complete before starting.
- `Required learning`: Key learnings before starting.
- `Optional learning`: Additional suggested resources.
- `Exercise Steps`: List of step IDs for this exercise.
- `Exercise Final Step`: The final step ID.
- `After-exercise tasks`: Tasks to complete post-exercise.

#### **Example Entry:**
```json
"Self-Attachment_1_A": {
    "Exercise_title": "Initial Connection",
    "Objective": "Connect with early childhood experiences.",
    "Minimum practice time": "5 minutes",
    "Total sessions": 3,
    "Pre-exercise tasks": ["If this is not possible, wear headphones."],
    "Required learning": ["Practise connecting with the child in both positive and negative emotions."],
    "Optional learning": [],
    "Exercise Steps": [
        "Self-Attachment_1_A_1",
        "Self-Attachment_1_A_2"
    ],
    "Exercise Final Step": "Self-Attachment_1_A_Final",
    "After-exercise tasks": [
        "Answer some questions about the exercise.",
        "Write your comments about the exercise in the app."
    ]
}
```

---

### 3. `step_data.json`
This file contains details about individual steps within an exercise.

#### **Structure:**
Each step is stored as a key-value pair where:
- **Key**: The step ID (e.g., `"Self-Attachment_1_A_1"`).
- **Value**: An object containing step details.

#### **Required Fields:**
- `Step_title`: Name of the step.
- `Image_Url`: Previously used for image references, but now deprecated—keep the entry as an empty string ("").
- `Description`: Explanation of the step.
- `Additional Details`: Any extra content.
- `Footer_text`: A footer note for the UI.
- `Image_Type`: The classification of the image, either "Happy" (a favorite childhood photo) or "Sad" (a non-favorite childhood photo).
- `Assessment_questions` (optional, for final steps): Questions to evaluate the user's progress.

#### **Example Entry:**
```json
"Self-Attachment_1_A_1": {
    "Step_title": "Step 1",
    "Image_Url": "assets/icons/exercise_images/exercise_page_A_1.png",
    "Description": "Look at your happy photo below. Recall positive childhood memories.",
    "Additional Details": "",
    "Footer_text": "Leave and lose your progress. X",
    "Image_Type": "Happy"
}
```

For final steps, `Assessment_questions` can be added:
```json
"Self-Attachment_1_A_Final": {
    "Step_title": "Congratulations",
    "Image_Url": "",
    "Description": "You successfully completed Exercise A. You can now move on to the next exercise or back to the course page.",
    "Assessment_questions": [
        "(A) Are you feeling better than before practising the exercise?",
        "(B) How helpful was this exercise?",
        "(C) Rate this exercise."
    ]
}
```

---

## Upload Process
1. Add the updated JSON data to:
   - `llm_based_sat_app/lib/models/firebase-exercise-uploader/data/courses_data.json`
   - `llm_based_sat_app/lib/models/firebase-exercise-uploader/data/exercise_data.json`
   - `llm_based_sat_app/lib/models/firebase-exercise-uploader/data/steps_data.json`
2. Run the script:
   ```
   python llm_based_sat_app/lib/models/firebase-exercise-uploader/firebase/upload_to_firebase.py
   ```
3. Check the logs for any errors or successful uploads.

---

## Contact
For any queries, contact the development team.
