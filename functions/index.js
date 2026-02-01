/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// const {setGlobalOptions} = require("firebase-functions");------------------
// const {onRequest} = require("firebase-functions/https");---------------
// const logger = require("firebase-functions/logger"); --------------------

// For cost control, you can set the maximum number of containers that can be
// running at the same time. This helps mitigate the impact of unexpected
// traffic spikes by instead downgrading performance. This limit is a
// per-function limit. You can override the limit for each function using the
// `maxInstances` option in the function's options, e.g.
// `onRequest({ maxInstances: 5 }, (req, res) => { ... })`.
// NOTE: setGlobalOptions does not apply to functions using the v1 API. V1
// functions should each use functions.runWith({ maxInstances: 10 }) instead.
// In the v1 API, each function can only serve one request per container, so
// this will be the maximum concurrent request count.
// setGlobalOptions({ maxInstances: 10 });---------------------------

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });


//-----------------------------------------------------------
        
// const functions = require("firebase-functions");
// const admin = require("firebase-admin");

// admin.initializeApp();

// exports.trashbinFullAlert = functions.database
//   .ref("/trashbin/status")
//   .onUpdate(async (change) => {

//     const before = change.before.val();
//     const after = change.after.val();

//     // Prevent spam
//     if (before === "FULL" || after !== "FULL") return null;

//     const payload = {
//       notification: {
//         title: "🗑️ Trash Bin Alert",
//         body: "The trash bin is full. Please empty it.",
//       },
//     };

//     return admin.messaging().sendToTopic(
//       "trashbin_alerts",
//       payload
//     );
//   });

// ---------------------------------- v2 ning ubos

// const { onValueUpdated } = require("firebase-functions/v2/database");
// const admin = require("firebase-admin");

// admin.initializeApp();

// exports.trashbinFullAlert = onValueUpdated(
//   "/trashbin/status",
//   async (event) => {

//     const before = event.data.before.val();
//     const after = event.data.after.val();

//     // Prevent duplicate notifications
//     if (before === "FULL" || after !== "FULL") {
//       return;
//     }

//     const payload = {
//       notification: {
//         title: "🗑️ Trash Bin Alert",
//         body: "The trash bin is full. Please empty it.",
//       },
//     };

//     await admin.messaging().sendToTopic(
//       "trashbin_alerts",
//       payload
//     );
//   }
// );

// ----- babaw kay di ka dawat notif

const { onValueUpdated } = require("firebase-functions/v2/database");
const admin = require("firebase-admin");

admin.initializeApp();

exports.trashbinFullAlert = onValueUpdated(
  "/trashbin/status",
  async (event) => {
    console.log("🔍 Function triggered!");
    
    const before = event.data.before.val();
    const after = event.data.after.val();
    
    console.log(`Before: ${before}, After: ${after}`);

    if (after === "FULL") {
      console.log("📢 Status is FULL! Sending notification...");
      
      // Use send() instead of sendToTopic()
      const message = {
        notification: {
          title: "🗑️ Trash Bin Alert",
          body: "The trash bin is full. Please empty it.",
        },
        topic: "trashbin_alerts", // Topic is specified HERE
        android: {
          priority: "high",
          notification: {
            channelId: "trashbin_alerts",
            sound: "default",
          },
        },
      };

      try {
        const response = await admin.messaging().send(message); // ✅ Use send()
        console.log("✅ Notification sent successfully! Message ID:", response);
        return response;
      } catch (error) {
        console.error("❌ Error sending notification:", error);
        throw error;
      }
    } else {
      console.log("ℹ️ Status is NOT_FULL, no notification sent.");
      return null;
    }
  }
);