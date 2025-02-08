// import 'dart:io';
// import 'package:flutter_tflite/flutter_tflite.dart';
// import 'package:logger/logger.dart';

// abstract class Classifier {
//   late String modelName; // Path to your TFLite model file
//   late String labelsFileName; // Path to your labels file
//   late int labelsLength;

//   var logger = Logger();
//   List<String>? labels;

//   Classifier({required int numThreads}) {
//     _loadModel();
    
//   }

//   /// Initialize the model using `flutter_tflite`
//   Future<void> _loadModel() async {
//     try {
//       String? result = await Tflite.loadModel(
//         model: "assets/model.tflite",
//         labels: "assets/labels.txt",
//         numThreads: 1,
//         isAsset: true,
//         useGpuDelegate: false,
//       );
//       logger.i('Model loaded: $result');
//     } catch (e) {
//       logger.e('Failed to load model: $e');
//     }
//   }

 
//   /// Predict method using `flutter_tflite`
//   Future<Map<String, dynamic>?> predict(File imageFile) async {
//     try {
//       // Perform inference on the image
//       var recognitions = await Tflite.runModelOnImage(
//         path: imageFile.path,
//         imageMean: 0.0,
//         imageStd: 255.0,
//         numResults: 5,
//         threshold: 0.2,
//         asynch: true,
//       );

//       if (recognitions == null || recognitions.isEmpty) {
//         logger.e("No recognitions found");
//         return null;
//       }

//       // Parse the first recognition result
//       var topRecognition = recognitions.first;
//       logger.i("Recognition: $topRecognition");
//       return {
//         "label": topRecognition['label'],
//         "confidence": topRecognition['confidence'],
//       };
//     } catch (e) {
//       logger.e("Prediction failed: $e");
//       return null;
//     }
//   }

//   /// Dispose of the TFLite resources
//   void dispose() {
//     Tflite.close();
//   }
// }

