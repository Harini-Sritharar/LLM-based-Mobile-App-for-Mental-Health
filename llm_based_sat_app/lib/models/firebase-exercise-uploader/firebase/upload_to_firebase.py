#!/usr/bin/env python3.12

import json
import firebase_admin
from firebase_admin import credentials, firestore

# Initialize Firebase Admin SDK with Firestore
cred = credentials.Certificate("./llm-based-sat-app-firebase-adminsdk-d18wo-071df6539f.json")
firebase_admin.initialize_app(cred)

# Get Firestore client
db = firestore.client()

def upload_course_structure_to_firestore(course_path, exercise_data_path):
    """
    Uploads the hierarchical course structure into Firestore.
    Includes exercises as subdocuments inside the Exercises folder.
    """
    # Load exercise data from the exercise data file
    with open(exercise_data_path, "r") as exercise_file:
        exercise_data = json.load(exercise_file)
    
    # Load course data from the course structure file
    with open(course_path, "r") as course_file:
        course_data = json.load(course_file)
    
    for course_name, course_content in course_data.items():
        print(f"Uploading course: {course_name}")
        
        # Create a Firestore document for the course
        course_ref = db.collection("Courses").document(course_name)
        course_ref.set({
            "Aim": course_content.get("Aim", ""),
            "Course_type": course_content.get("Course_type", ""),
            "Prerequisites": course_content.get("Prerequisites course tasks", [])
        })
        
        # Add chapters
        chapters = course_content.get("Chapters", {})
        for chapter_name, chapter_content in chapters.items():
            print(f"  Uploading chapter: {chapter_name}")
            
            # Create a subcollection for chapters
            chapter_ref = course_ref.collection("Chapters").document(chapter_name)
            chapter_ref.set({
                "Aim": chapter_content.get("Aim", ""),
            })

            # Add exercises as subdocuments
            exercises = chapter_content.get("Exercises", {})
            for exercise_name in exercises:
                if exercise_name in exercise_data:
                    print(f"    Adding exercise: {exercise_name}")
                    exercise_ref = chapter_ref.collection("Exercises").document(exercise_name)
                    exercise_ref.set(exercise_data[exercise_name])
                else:
                    print(f"    Warning: Exercise {exercise_name} not found in exercise data.")

# Call the function with paths to the JSON files
upload_course_structure_to_firestore(
    "../data/courses_data.json",
    "../data/exercise_data.json"
)
