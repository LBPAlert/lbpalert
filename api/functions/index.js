const functions = require("firebase-functions");
const tf = require("@tensorflow/tfjs");


exports.api = functions.https.onRequest((req, res) => {
    res.set("Access-Control-Allow-Origin", "*");
    res.set("Access-Control-Allow-Methods", "GET, POST");

    a = [[14.15096801, 5396.33385026,  90], [14.15059375, 5394.17897378, 90]];
    b = [[10.85063639, 4210.27282935,   95],[10.85196154, 4211.90543729 , 95]];
    c = [[9.247584,   3409.35022757,  129], [10.85196154, 4211.90543729 , 95]];
    d = [[9.1312418,  3494.14757631,  106], [10.85196154, 4211.90543729 , 95]];

    predict(a,b,c,d).then((pred) => {
    res.status(200).send({ prediction: pred });
    })
    .catch((error) => {
    res.status(404).send({ prediction: error });
    });

});


async function predict(a,b,c,d) {
    
  let model = await tf.loadLayersModel(
    config.MODEL_API_TOKEN
  );

  a = tf.tensor2d(a);
  b = tf.tensor2d(b);
  c = tf.tensor2d(c);
  d = tf.tensor2d(d);

  let a_new = tf.reshape(a, [a.shape[0], 1, a.shape[1]]);
  let b_new = tf.reshape(b, [b.shape[0], 1, b.shape[1]]);
  let c_new = tf.reshape(c, [c.shape[0], 1, c.shape[1]]);
  let d_new = tf.reshape(d, [d.shape[0], 1, d.shape[1]]);

  return "Yuh daddy";
//   return model.predict([a_new, b_new, c_new, d_new]).dataSync();
//    console.log(model);
}

