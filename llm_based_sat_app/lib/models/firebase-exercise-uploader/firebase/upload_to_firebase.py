#!/usr/bin/env python3.12

import json
import firebase_admin
from firebase_admin import credentials, firestore

# Initialize Firebase Admin SDK with Firestore
cred = credentials.Certificate("./llm-based-sat-app-firebase-adminsdk-d18wo-071df6539f.json")
firebase_admin.initialize_app(cred)

# Get Firestore client
db = firestore.client()

def upload_exercise_data_to_firestore(file_path):
    # Load JSON data
    with open(file_path, "r") as file:
        exercise_data = json.load(file)

    # Upload data to Firestore
    for exercise_name, exercise_content in exercise_data.items():
        exercise_ref = db.collection("Exercises").document(exercise_name)
        exercise_ref.set(exercise_content)
        print(f"Uploaded: {exercise_name}")

# Call the function to upload data
upload_exercise_data_to_firestore("../data/exercise_data.json")
