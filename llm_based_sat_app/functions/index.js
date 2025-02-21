const { onDocumentUpdated } = require("firebase-functions/v2/firestore");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");
const { getMessaging } = require("firebase-admin/messaging");

initializeApp();
const db = getFirestore();

exports.sendScoreUpdateNotification = onDocumentUpdated("Profile/{userId}", async (event) => {
    const beforeData = event.data.before.data(); // Previous data
    const afterData = event.data.after.data(); // Updated data

    if (!beforeData || !afterData) {
        console.log("Missing data in before or after snapshot");
        return;
    }

    // Get the overall score before and after the update
    const beforeScore = beforeData.overallScore;
    const afterScore = afterData.overallScore;

    // Check if the score has changed
    if (beforeScore === afterScore) {
        console.log("No score change detected");
        return;
    }

    const userId = event.params.userId;

    // Retrieve the user's FCM token from Firestore
    const userRef = db.collection("Profile").doc(userId);
    const userDoc = await userRef.get();
    const userData = userDoc.data();

    if (!userData || !userData.fcmToken) {
        console.log(`No FCM token found for user: ${userId}`);
        return;
    }

    const fcmToken = userData.fcmToken;

    // Define the notification payload
    const payload = {
        notification: {
            title: "Score Updated!",
            body: `There was a change in your score.`,
        },
        token: fcmToken,
    };

    try {
        // Send the notification
        await getMessaging().send(payload);
        console.log(`Notification sent to user ${userId}.`);

        // Store the notification in Firestore under the user's notifications subcollection
        const notificationRef = db.collection("Profile").doc(userId).collection("notifications").doc();

        await notificationRef.set({
            title: "Score Updated!",
            message: `There was a change in your score.`,
            timestamp: new Date(),
            isRead: false,
            type: "score_update",
        });

        console.log(`Notification saved to Firestore for user ${userId}`);
    } catch (error) {
        console.error("Error sending or storing notification:", error);
    }
});
