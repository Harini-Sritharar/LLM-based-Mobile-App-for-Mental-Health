#!/usr/bin/env python3.12

import json
import firebase_admin
from firebase_admin import credentials, storage

# Initialize Firebase Admin SDK
cred = credentials.Certificate("../firebase/llm-based-sat-app-firebase-adminsdk-d18wo-071df6539f.json")
firebase_admin.initialize_app(cred, {
    "storageBucket": "llm-based-sat-app.firebasestorage.app"
})

# Reference to the Firebase Storage bucket
bucket = storage.bucket()

def upload_exercise_data(file_path, bucket):
    # Load JSON data
    with open(file_path, "r") as file:
        exercise_data = json.load(file)
    
    # Loop through each exercise and upload its structure
    for exercise_name, exercise_content in exercise_data.items():
        for section_name, section_content in exercise_content.items():
            # Create a file path in Cloud Storage
            cloud_path = f"Exercises/{exercise_name}/{section_name}.json"
            
            # Convert section content to JSON string
            section_json = json.dumps(section_content, indent=4)
            
            # Upload the content to Cloud Storage
            blob = bucket.blob(cloud_path)
            blob.upload_from_string(section_json, content_type="application/json")
            print(f"Uploaded: {cloud_path}")

# Call the function to upload data
upload_exercise_data("exercise_data.json", bucket)
