const { onDocumentUpdated } = require("firebase-functions/v2/firestore");
const { onSchedule } = require("firebase-functions/v2/scheduler");
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

    // Check notification preferences
    const notificationPreferences = userData.notificationPreferences || [];
    if (!notificationPreferences[2]) { // Score update notifications
        console.log(`User ${userId} has disabled score update notifications.`);
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


exports.checkDailyPractice = onSchedule("every day 20:00", async (event) => {
    console.log("Running daily practice check...");

    const usersSnapshot = await db.collection("Profile").get();
    const currentDate = new Date().toISOString().split("T")[0]; // Get YYYY-MM-DD format

    for (const userDoc of usersSnapshot.docs) {
        const userId = userDoc.id;
        const userRef = db.collection("Profile").doc(userId);
        const courseProgressRef = userRef.collection("course_progress");

        let totalPracticeTime = 0;

        const coursesSnapshot = await courseProgressRef.get();
        for (const courseDoc of coursesSnapshot.docs) {
            const timestampsRef = courseDoc.ref.collection("TimeStamps");
            const timestampsSnapshot = await timestampsRef.get();

            timestampsSnapshot.forEach((timestampDoc) => {
                const timestampData = timestampDoc.data();
                const startTime = timestampData.startTime;
                const endTime = timestampData.endTime;
            
                // Validate timestamps before conversion
                if (!startTime || !endTime) {
                    console.error(`Missing timestamps for user ${userId} in course ${courseDoc.id}`);
                    return;
                }
            
                try {
                    // Ensure Firestore Timestamp conversion
                    const start = startTime.toDate ? startTime.toDate() : new Date(startTime);
                    const end = endTime.toDate ? endTime.toDate() : new Date(endTime);
            
                    // Check if start and end are valid dates
                    if (isNaN(start.getTime()) || isNaN(end.getTime())) {
                        console.error(`Invalid time values for user ${userId}:`, { startTime, endTime });
                        return;
                    }
            
                    // Ensure the activity happened today
                    if (start.toISOString().split("T")[0] === currentDate) {
                        const duration = (end - start) / (1000 * 60); // Convert ms to minutes
                        totalPracticeTime += duration;
                    }
                } catch (error) {
                    console.error(`Error processing timestamps for user ${userId}:`, error);
                }
            });
            
        }

        console.log(`User ${userId} practiced for ${totalPracticeTime.toFixed(2)} minutes today.`);

        if (totalPracticeTime < 20) {
            console.log(`User ${userId} did not practice enough. Sending notification...`);

            // Retrieve the user's FCM token
            const userDoc = await userRef.get();
            const userData = userDoc.data();

            if (!userData || !userData.fcmToken) {
                console.log(`No FCM token found for user: ${userId}`);
                continue;
            }

            // Check notification preferences
            const notificationPreferences = userData.notificationPreferences || [];
            if (!notificationPreferences[1]) { // Pracice Time notifications
                console.log(`User ${userId} has disabled Daily Practice notifications.`);
                return;
            }

            const fcmToken = userData.fcmToken;

            // Define the notification payload
            const payload = {
                notification: {
                    title: "Practice Time Remaining!",
                    body: "You haven't completed 20 minutes of practice today. Keep learning!",
                },
                token: fcmToken,
            };

            try {
                // Send the notification
                await getMessaging().send(payload);
                console.log(`Practice reminder sent to user ${userId}.`);

                // Store the notification in Firestore
                const notificationRef = userRef.collection("notifications").doc();
                await notificationRef.set({
                    title: "Practice Time Remaining!",
                    message: "You haven't completed 20 minutes of practice today. Keep learning!",
                    timestamp: new Date(),
                    isRead: false,
                    type: "practice_reminder",
                });

                console.log(`Practice reminder saved for user ${userId}`);
            } catch (error) {
                console.error(`Error sending practice reminder for user ${userId}:`, error);
            }
        }
    }

    console.log("Daily practice check completed.");
});


// Function to check if users have completed at least 2 sessions today
exports.checkDailySessions = onSchedule("every day 19:00", async (event) => {
    console.log("Running daily session check...");

    try {
        const usersSnapshot = await db.collection("Profile").get();
        const currentDate = new Date().toISOString().split("T")[0]; // Get YYYY-MM-DD format

        for (const userDoc of usersSnapshot.docs) {
            const userId = userDoc.id;
            const userRef = db.collection("Profile").doc(userId);
            const courseProgressRef = userRef.collection("course_progress");

            let sessionCount = 0;

            try {
                const coursesSnapshot = await courseProgressRef.get();

                for (const courseDoc of coursesSnapshot.docs) {
                    const timestampsRef = courseDoc.ref.collection("TimeStamps");
                    const timestampsSnapshot = await timestampsRef.get();

                    timestampsSnapshot.forEach((timestampDoc) => {
                        const timestampData = timestampDoc.data();
                        const startTime = timestampData.startTime;

                        if (!startTime) {
                            console.error(`Missing startTime for user ${userId} in course ${courseDoc.id}`);
                            return;
                        }

                        try {
                            const start = startTime.toDate ? startTime.toDate() : new Date(startTime);

                            if (isNaN(start.getTime())) {
                                console.error(`Invalid startTime for user ${userId}:`, startTime);
                                return;
                            }

                            if (start.toISOString().split("T")[0] === currentDate) {
                                sessionCount++;
                            }
                        } catch (error) {
                            console.error(`Error processing startTime for user ${userId}:`, error);
                        }
                    });
                }
            } catch (error) {
                console.error(`Error fetching courses for user ${userId}:`, error);
            }

            console.log(`User ${userId} has completed ${sessionCount} sessions today.`);

            if (sessionCount < 2) {
                console.log(`User ${userId} has not completed enough sessions. Sending notification...`);

                try {
                    const userDoc = await userRef.get();
                    const userData = userDoc.data();

                    if (!userData || !userData.fcmToken) {
                        console.log(`No FCM token found for user: ${userId}`);
                        continue;
                    }

                    // Check notification preferences
                    const notificationPreferences = userData.notificationPreferences || [];
                    if (!notificationPreferences[0]) { // Daily Task notifications
                        console.log(`User ${userId} has disabled Daily Tasks notifications.`);
                        return;
                    }

                    const fcmToken = userData.fcmToken;

                    const payload = {
                        notification: {
                            title: "Complete Your Sessions!",
                            body: "You haven't completed 2 practice sessions today. Keep up your progress!",
                        },
                        token: fcmToken,
                    };

                    await getMessaging().send(payload);
                    console.log(`Session reminder sent to user ${userId}.`);

                    // Store the notification in Firestore
                    const notificationRef = userRef.collection("notifications").doc();
                    await notificationRef.set({
                        title: "Complete Your Sessions!",
                        message: "You haven't completed 2 practice sessions today. Keep up your progress!",
                        timestamp: new Date(),
                        isRead: false,
                        type: "session_reminder",
                    });

                    console.log(`Session reminder saved for user ${userId}`);
                } catch (error) {
                    console.error(`Error sending session reminder for user ${userId}:`, error);
                }
            }
        }
    } catch (error) {
        console.error("Error running daily session check:", error);
    }

    console.log("Daily session check completed.");
});