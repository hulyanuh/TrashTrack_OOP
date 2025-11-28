import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart'; // ADD THIS IMPORT
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import '../models/disposal_service.dart';
import '../providers/disposal_service_provider.dart';
import 'disposal_shop_details_screen.dart';

// MODIFICATION: Changed to ConsumerStatefulWidget to access Riverpod providers
class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

// MODIFICATION: Changed to ConsumerState
class _ScanScreenState extends ConsumerState<ScanScreen> {
  // ─────────────────────── UI constants ──────────────────────
  static const _bg = Color(0xFFDCE2E5);
  static const _text = Color(0xFF2A2A2A);

  // ─────────────────────── image picking ─────────────────────
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  // ─────────────────── Face Detection Model ──────────────────
  // Create an instance of the face detector
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      performanceMode: FaceDetectorMode.fast, // Use fast mode for quick checks
    ),
  );
  bool _isDetectingFaces = false;

  // ─────────────────────── tflite model ──────────────────────
  static const _modelPath = 'assets/models/GarbageClassification.tflite';
  static const _labelsPath = 'assets/models/labels.txt';
  Interpreter? _interpreter;
  List<String> _labels = [];
  bool _modelReady = false;

  // ───────────────── classification state ────────────────────
  String? _prediction;
  String? _wasteType;
  String? _wasteDescription;
  bool _running = false;

  // Data structure for waste details
  static final Map<String, Map<String, String>> _wasteDetails = {
    'cardboard': {
      'type': 'Biodegradable',
      'description':
          'Cardboard is a paper-based material that is both recyclable and biodegradable. It is commonly used for packaging and shipping. Proper recycling of cardboard helps conserve resources and reduce landfill waste.',
    },
    'glass': {
      'type': 'Non-Biodegradable',
      'description':
          'Glass is made from natural and stable materials, making it infinitely recyclable without loss of quality. However, it is not biodegradable and can persist in the environment for a very long time if not disposed of correctly. Please recycle glass to save energy and reduce pollution.',
    },
    'metal': {
      'type': 'Non-Biodegradable',
      'description':
          'Metal objects are typically non-biodegradable but are highly valuable for recycling. Recycling metal conserves natural resources, saves energy, and reduces greenhouse gas emissions. Common recyclable metals include aluminum and steel cans.',
    },
    'paper': {
      'type': 'Biodegradable',
      'description':
          'Paper is produced from wood pulp and is readily biodegradable and recyclable. Recycling paper saves trees, water, and energy compared to making it from raw materials. Please ensure it is clean and dry before recycling.',
    },
    'plastic': {
      'type': 'Non-Biodegradable',
      'description':
          'Plastic is a synthetic material that is not biodegradable and can take hundreds of years to break down. It poses a significant threat to wildlife and ecosystems when it pollutes the environment. Recycling plastic helps reduce waste and consumption of raw materials.',
    },
    'trash': {
      'type': 'Non-Biodegradable',
      'description':
          'This category typically includes mixed waste or items that are not easily recyclable. These materials are generally non-biodegradable and are destined for the landfill. Proper sorting is crucial to minimize the amount of waste sent to landfills.',
    }
  };

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  @override
  void dispose() {
    // It's important to release the resources used by the detectors
    _interpreter?.close();
    _faceDetector.close();
    super.dispose();
  }

  Future<void> _loadModel() async {
    try {
      final options = InterpreterOptions();
      _interpreter = await Interpreter.fromAsset(_modelPath, options: options);
      final labelsRaw = await rootBundle.loadString(_labelsPath);
      _labels = labelsRaw.split('\n').where((e) => e.isNotEmpty).toList();
      setState(() => _modelReady = true);
    } catch (e) {
      debugPrint('Model load error: $e');
      setState(() => _modelReady = false);
    }
  }

  // ─────────────────────── ui handlers ───────────────────────

  Future<void> _handleScan() async {
    final bool? continueToCamera = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('For Best Results'),
          content: const Text(
            'Please take a picture of only one item at a time to ensure accurate identification.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (continueToCamera == true) {
      await _processPickedImage(ImageSource.camera);
    }
  }

  Future<void> _pickFromGallery() async {
    await _processPickedImage(ImageSource.gallery);
  }

  /// NEW: A unified method to handle picking, face detection, and classification
  Future<void> _processPickedImage(ImageSource source) async {
    if (_isDetectingFaces) return;

    final XFile? picked = await _picker.pickImage(source: source);
    if (picked == null) return;

    setState(() {
      _isDetectingFaces = true;
      _selectedImage = File(picked.path); // Show image immediately
      _prediction = null; // Clear previous prediction
    });

    // Show a loading indicator while checking for faces
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Analyzing image...", style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
    );

    final imageFile = File(picked.path);
    final hasFace = await _checkForFaces(imageFile);

    if (mounted) Navigator.of(context).pop(); // Dismiss loading dialog

    if (hasFace) {
      if (mounted) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Face Detected'),
            content: const Text(
                'An animal or human face was detected. Please use a picture of the waste item only.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
      _removeImage(); // Clear the invalid image
    } else {
      // No face detected, proceed with garbage classification
      _handleIdentify();
    }

    setState(() {
      _isDetectingFaces = false;
    });
  }

  /// NEW: This method checks an image file for any faces.
  Future<bool> _checkForFaces(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final List<Face> faces = await _faceDetector.processImage(inputImage);
      return faces.isNotEmpty;
    } catch (e) {
      debugPrint("Error detecting faces: $e");
      return false; // Assume no faces if there's an error
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _prediction = null;
      _wasteType = null;
      _wasteDescription = null;
    });
  }

  Future<void> _handleIdentify() async {
    if (_selectedImage == null || !_modelReady) return;
    setState(() {
      _running = true;
      _prediction = null;
    });
    final pred = await _classifyImage(_selectedImage!);
    _updateWasteDetails(pred);
    setState(() {
      _prediction = pred;
      _running = false;
    });
  }

  void _updateWasteDetails(String? prediction) {
    if (prediction == null) {
      _wasteType = null;
      _wasteDescription = null;
      return;
    }
    final details = _wasteDetails[prediction.toLowerCase()];
    if (details != null) {
      setState(() {
        _wasteType = details['type'];
        _wasteDescription = details['description'];
      });
    }
  }

  // This function fetches services, finds a match, and navigates.
  Future<void> _findShopAndNavigate() async {
    if (_prediction == null) return;

    // Show a loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Use the provider to fetch all services
      final allServices = await ref.read(allServicesProvider.future);

      DisposalService? matchingService;
      // Find the first service that accepts the predicted material type
      for (final service in allServices) {
        final acceptsMaterial = service.serviceMaterials.any((material) =>
            material.materialPoints.materialType.toLowerCase() ==
            _prediction!.toLowerCase());
        if (acceptsMaterial) {
          matchingService = service;
          break; // Stop after finding the first match
        }
      }

      if (mounted) Navigator.of(context).pop();

      if (matchingService != null) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DisposalShopDetailsScreen(service: matchingService!),
            ),
          );
        }
      } else {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('No Shop Found'),
              content: Text(
                  'Sorry, we couldn\'t find a shop that accepts "$_prediction".'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) Navigator.of(context).pop();
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('An error occurred while finding a shop: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<String?> _classifyImage(File imgFile) async {
    if (_interpreter == null) return null;

    final Uint8List bytes = await imgFile.readAsBytes();
    final img.Image? original = img.decodeImage(bytes);
    if (original == null) return null;

    final img.Image resized = img.copyResize(original, width: 224, height: 224);
    final Float32List input = Float32List(224 * 224 * 3);
    int i = 0;
    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        final px = resized.getPixel(x, y);
        input[i++] = px.rNormalized.toDouble();
        input[i++] = px.gNormalized.toDouble();
        input[i++] = px.bNormalized.toDouble();
      }
    }
    final reshaped = input.reshape([1, 224, 224, 3]);
    final output = List.filled(6, 0.0).reshape([1, 6]);
    _interpreter!.run(reshaped, output);

    var bestIdx = 0;
    var bestProb = 0.0;
    for (var j = 0; j < output[0].length; j++) {
      if (output[0][j] > bestProb) {
        bestProb = output[0][j];
        bestIdx = j;
      }
    }
    return bestIdx < _labels.length ? _labels[bestIdx] : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: _text),
          onPressed: () => Navigator.maybePop(context),
        ),
        actions: [
          if (_prediction != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TextButton(
                onPressed: _findShopAndNavigate,
                child: const Text(
                  'Find Shop',
                  style: TextStyle(
                    color: _text,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
              left: 24.0,
              right: 24.0,
              bottom: 24.0,
            ),
            child: Column(
              children: [
                if (_selectedImage != null) ...[
                  imagePreview(),
                  const SizedBox(height: 24),
                  if (_running || _isDetectingFaces)
                    const CircularProgressIndicator()
                  else if (_prediction != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Identified As:',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _prediction!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_wasteType != null) ...[
                            const SizedBox(height: 16),
                            Text(
                              _wasteType!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: _wasteType == 'Biodegradable'
                                    ? Colors.green.shade700
                                    : Colors.red.shade700,
                              ),
                            ),
                          ],
                          if (_wasteDescription != null) ...[
                            const SizedBox(height: 16),
                            Text(
                              _wasteDescription!,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                ] else
                  optionsCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget imagePreview() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.file(_selectedImage!, height: 300, fit: BoxFit.cover),
          ),
        ),
        Positioned(
          right: 8,
          top: -10,
          child: GestureDetector(
            onTap: _removeImage,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.65),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget optionsCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.center_focus_weak_rounded, size: 80, color: _text),
          const SizedBox(height: 24),
          const Text(
            'Not sure what kind of trash you have?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _text,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Choose one of the options below to help us identify it.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  // MODIFIED: Use the new unified handler
                  onPressed: _handleScan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5D6B4C),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Scan',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  // MODIFIED: Use the new unified handler
                  onPressed: _pickFromGallery,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD9D9D9),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Upload',
                    style: TextStyle(color: _text, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
