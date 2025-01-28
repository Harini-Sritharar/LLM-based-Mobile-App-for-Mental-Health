#!/usr/bin/env python3.12

import json
import firebase_admin
from firebase_admin import credentials, firestore

# Initialize Firebase Admin SDK with Firestore
cred = credentials.Certificate("./llm-based-sat-app-firebase-adminsdk-d18wo-071df6539f.json")
firebase_admin.initialize_app(cred)

# Get Firestore client
db = firestore.client()

def upload_course_structure_to_firestore(course_path, exercise_data_path, steps_data_path):
    """
    Uploads the hierarchical course structure into Firestore.
    Includes exercises as subdocuments inside the Exercises folder.
    """
    # Load exercise data from the exercise data file
    with open(exercise_data_path, "r") as exercise_file:
        exercise_data = json.load(exercise_file)

    # Load steps data from the steps data file
    with open(steps_data_path, "r") as steps_file:
        steps_data = json.load(steps_file)
    
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
            "Course_title": course_content.get("Course_title", ""),
            "Rating": course_content.get("Rating", ""),
            "Rating_Count": course_content.get("Rating_Count", ""),
            "Duration": course_content.get("Duration", ""),
            "Image_URL": course_content.get("Image_URL", ""),
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
                "Chapter_title": chapter_content.get("Chapter_title", ""),
            })

            # Add exercises and their steps as subdocuments
            exercises = chapter_content.get("Exercises", {})
            for exercise_name in exercises:
                if exercise_name in exercise_data:
                    print(f"    Adding exercise: {exercise_name}")
                    exercise_ref = chapter_ref.collection("Exercises").document(exercise_name)

                    # Set exercise data
                    exercise_ref.set(exercise_data[exercise_name])

                    # Add steps for the exercise
                    step_ids = exercise_data[exercise_name].get("Exercise Steps", [])
                    for step_id in step_ids:
                        if step_id in steps_data:
                            print(f"      Adding step: {step_id}")
                            step_ref = exercise_ref.collection("Steps").document(step_id)
                            step_ref.set(steps_data[step_id])
                        else:
                            print(f"      Warning: Step {step_id} not found in steps data.")
                else:
                    print(f"    Warning: Exercise {exercise_name} not found in exercise data.")

# Call the function with paths to the JSON files
upload_course_structure_to_firestore(
    "../data/courses_data.json",
    "../data/exercise_data.json",
    "../data/steps_data.json"
)
