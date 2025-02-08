import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:my_tflit_app/savedata.dart';
import 'package:my_tflit_app/widget/plant_photo_view.dart';
import 'package:url_launcher/url_launcher.dart';
import '../styles.dart';
import 'HomeAppBar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Constants for model and label file paths
const String _modelFileName = 'assets/model.tflite';
const String _labelsFileName = 'assets/labels.txt';

class Recogniser extends StatefulWidget {
  const Recogniser({Key? key}) : super(key: key);

  @override
  State<Recogniser> createState() => _RecogniserState();
}

enum _ResultStatus {
  notStarted,
  notFound,
  found,
}

class _RecogniserState extends State<Recogniser> {
  // Variables
  bool _isAnalyzing = false;
  final picker = ImagePicker();
  File? _selectedImageFile;
  String _label = '';
  final user= FirebaseAuth.instance.currentUser;
  double _confidence = 0.0;
  _ResultStatus _resultStatus = _ResultStatus.notStarted;
  
  String suggestion='';

  @override
  void initState() {
    super.initState();
    _initializeModel();
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  Future<void> _initializeModel() async {
    await Tflite.loadModel(
      model: _modelFileName,
      labels: _labelsFileName,
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false,
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile == null) return;

    final imageFile = File(pickedFile.path);
    setState(() {
      _selectedImageFile = imageFile;
    });

    _analyzeImage(imageFile);
  }  

  
  Future<void> _analyzeImage(File imageFile) async {
    setState(() {
      _isAnalyzing = true;
    });

    final recognitions = await Tflite.runModelOnImage(
      path: imageFile.path,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 1,
      threshold: 0.2,
      asynch: true,
    );

    if (recognitions == null || recognitions.isEmpty) {
      setState(() {
        _resultStatus = _ResultStatus.notFound;
        _label = '';
        _confidence = 0.0;
        _isAnalyzing = false;
      });
      return;
    }

    setState(() {
      _label = recognitions[0]['label'];
      _confidence = recognitions[0]['confidence'] * 100;
      _resultStatus = _ResultStatus.found;
      _isAnalyzing = false;
     recognitions[0]['label']=='Malignant'? suggestion='you have to go for doctor':suggestion="don't worry we have'nt find skin cancer"; 
    });
    
                      try {
                            // Upload image
                            File imageFile = _selectedImageFile!;
                            // String imageUrl = await uploadImage(imageFile);
                            saveImageToGallery(imageFile.path);
                     
                            // Store data in Firestore
                            await storeData(imageFile.path, user?.displayName??'user', user!.email!,      _label = recognitions[0]['label'], suggestion);

                          } catch (e) {
                            print("Error: $e");
                          }
                    }
                    

  Widget _buildPhotoView() {
    return Stack(
      alignment: Alignment.center,
      children: [
        PhotoView(file: _selectedImageFile),
        if (_isAnalyzing) const Text('Analyzing...', style: kAnalyzingTextStyle),
      ],
    );
  }

  Widget _buildPickPhotoButton({
    required ImageSource source,
    required String title,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () => _pickImage(source),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: const Color(0xFF4C53A5),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: ListTile(
          leading: Icon(icon, color: Colors.white),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultView() {
    String title = '';
    String accuracyLabel = '';

    if (_resultStatus == _ResultStatus.notFound) {
      title = 'Fail to recognize';
    } else if (_resultStatus == _ResultStatus.found) {
      title = _label;
      accuracyLabel = 'Accuracy: ${_confidence.toStringAsFixed(2)}%';
    }

    return Column(
      children: [
        Text(title, style: kResultTextStyle),
        const SizedBox(height: 10),
        Text(accuracyLabel, style: kResultRatingTextStyle),
        if (_resultStatus == _ResultStatus.found)
       GestureDetector(
  onTap: () async {
    final url = 'https://www.google.com/search?q=$title';
    final uri = Uri.parse(url); // Correctly parse the URL

    if (await canLaunchUrl(uri)) { // Check if the URL can be launched
      await launchUrl(uri); // Launch the URL
    } else {
      print('Could not launch $url'); // Handle the case where the URL can't be launched
    }
  },


            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              color: const Color(0xFF4C53A5),
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              child: ListTile(
                leading: const Icon(Icons.search, color: Colors.white),
                title: Text(
                  AppLocalizations.of(context)!.h1_searchonnet,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10),
            decoration: const BoxDecoration(
              color: Color(0xFFEDECF2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      AppLocalizations.of(context)!.pr_dieasedetection,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Color(0xFF4C53A5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildPhotoView(),
                  const SizedBox(height: 10),
                  _buildResultView(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          Container(color: const Color(0xFFEDECF2), height: 20),
          _buildPickPhotoButton(
            title: AppLocalizations.of(context)!.h1_takepic,
            source: ImageSource.camera,
            icon: Icons.add_a_photo,
          ),
          _buildPickPhotoButton(
            title: AppLocalizations.of(context)!.h1_picgallery,
            source: ImageSource.gallery,
            icon: Icons.photo,
          ),
          Container(
            height: 20,
            decoration: const BoxDecoration(
              color: Color(0xFFEDECF2),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
