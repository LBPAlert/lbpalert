const functions = require("firebase-functions");

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

// Listens for new messages added to /messages/:pushId/original and creates an
// uppercase version of the message to /messages/:pushId/uppercase
exports.makePrediction = functions.database.ref('/Sensor_Data/{deviceID}')
    .onUpdate((snapshot, context) => {
      // Grab the current value of what was written to the Realtime Database.
      const values = snapshot.val();
      functions.logger.log('Values', context.params.deviceID, values);
      return "Done";
    });
