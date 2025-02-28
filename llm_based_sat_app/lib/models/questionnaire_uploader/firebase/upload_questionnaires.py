import json
import firebase_admin
from firebase_admin import credentials, firestore

# Initialize Firebase Admin SDK with Firestore
cred = credentials.Certificate("./llm-based-sat-app-firebase-adminsdk-d18wo-071df6539f.json")
firebase_admin.initialize_app(cred)

db = firestore.client()

def upload_questionnaire_data_to_firebase(questionnaires_path):
    # Load exercise data from the exercise data file
    with open(questionnaires_path, "r") as questionnaire_file:
        questionnaire_data = json.load(questionnaire_file)

    for name, content in questionnaire_data.items():
        print(f"Uploading questionnaire: {name}")
        
        # Create a Firestore document for the questionnaire
        questionnaire_ref = db.collection("Questionnaires").document(name)
        questionnaire_ref.set({
            "description": content.get("Description", ""),
            "questions": content.get("Questions", [])
        })


upload_questionnaire_data_to_firebase("../data/questionnaire_data.json")