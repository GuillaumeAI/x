//First load the lib in your head
//<script src="../node_modules/@tensorflow/tfjs/dist/tf.min.js"></script>
//<script src="../lib/speech-commands/dist/speech-commands.min.js"></script> 
//
//Use this after you loaded TF+speech command libs
//giatmam210428("Douche proto");


const confidenceRecoThreshHold = 0.65; // used to define a value of the prediction confidence that determine if a class is officially recognized.  The higher the value is, the more precise it gets and maybe harder to recognize.

var labelLast =null;


function giatmam210428(info)
{
   labelLast = document.getElementById("label-last");
   labelLast.innerText = "PRESS START to launch recognizing and see what you can speek up";
   console.log("Model info: " + info);
   //do more stuff if required on loading
   document.getElementById("titlehead").innerText = info + " Teachable Machine Audio Model";
   document.title = info;
}


//conf
var giaconf = new Object();
giaconf = { 
   includeSpectrogram: true, // in case listen should return result.spectrogram
   probabilityThreshold: 0.75,
   invokeCallbackOnNoiseAndUnknown: true,
   overlapFactor: 0.50 // probably want between 0.5 and 0.75. More info in README
};


// more documentation available at
// https://github.com/tensorflow/tfjs-models/tree/master/speech-commands

// the link to your model provided by Teachable Machine export panel
var loc = window.location.href;

//   const URL = "http://127.0.0.1:8080/model/";
var cururlpath= loc.substring(0, loc.lastIndexOf('/'));
var URL = cururlpath +"/model/";
console.log("giatmam URL: " + URL);
   

var recognizer = null;
var classLabels = null;

function stopRecognition()
{
   try {
      recognizer.stopListening();
      labelLast.innerText = "Recognizer Stopped";
      
   } catch (error) {
      console.log("Did you started regognizing or it is already stopped.");
   }
 
   
}

async function init() {

   if (recognizer == null)
    recognizer = await createModel();

    if (classLabels == null)
    classLabels = recognizer.wordLabels(); // get class labels
   const labelContainer = document.getElementById("label-container");

   labelLast.innerText = "Speek up command word on the left such as \"Picasso\"";

   for (let i = 0; i < classLabels.length; i++) {
      labelContainer.appendChild(document.createElement("div"));
      }
      
      // listen() takes two arguments:
      // 1. A callback function that is invoked anytime a word is recognized.
      // 2. A configuration object with adjustable fields
      recognizer.listen(result => {
         const scores = result.scores; // probability of prediction for each class
         // render the probability scores per class
         for (let i = 0; i < classLabels.length; i++) {
            var score = result.scores[i].toFixed(2);
            var label = classLabels[i];
            const classPrediction = label + ": " + score;
            labelContainer.childNodes[i].innerHTML = classPrediction;
            /*
            Archaique: Background Noise: Calme stimulante */
            if (score > confidenceRecoThreshHold && label != "Background Noise") {
               labelLast.innerText = classPrediction;
               console.log(`classPrediction:${classPrediction}`);
            }
         }
      }, giaconf    );
      
      // Stop the recognition in 5 seconds.
      // setTimeout(() => recognizer.stopListening(), 5000);
}

async function createModel() {
   const checkpointURL = URL + "model.json"; // model topology
   const metadataURL = URL + "metadata.json"; // model metadata
   
   const recognizer = speechCommands.create(
      "BROWSER_FFT", // fourier transform type, not useful to change
      undefined, // speech commands vocabulary feature, not useful for your models
      checkpointURL,
      metadataURL);
      
      // check that model and metadata are loaded via HTTPS requests.
      await recognizer.ensureModelLoaded();
      
      return recognizer;
   }