
import 'package:dynamic_delivery/src/utils/theme/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'found_screen.dart';
import 'qrscanner_overlay.dart';

class Scanner extends StatefulWidget {
  const Scanner({super.key});

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  MobileScannerController  cameraController = MobileScannerController();
  List<String> storedBarcodes = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.5),
        appBar: AppBar(
          backgroundColor:tThemeMain,
          title: const Text("Scanner", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          elevation: 0.0,
        ),
        body: Stack(
          children: [
            MobileScanner(
              controller: cameraController,
                onDetect: (capture) {
                  if (storedBarcodes.isEmpty) {
                    final List<Barcode> barcodes = capture.barcodes;
                    if (barcodes.isNotEmpty) {
                      final Barcode barcode = barcodes.first;
                      debugPrint('Barcode found! ${barcode.rawValue}');
                      // Split the barcode data by newline characters
                      List<String>? barcodeParts = barcode.rawValue?.split('\n');

                      // Add each part to the storedBarcodes list
                      for (String part in barcodeParts!) {
                        storedBarcodes.add(part);
                      }
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> FoundScreen(value: storedBarcodes,)));
                      // Print the list data
                      debugPrint('List of stored barcodes: $storedBarcodes');
                    }
                  }
                },
            ),
            QRScannerOverlay(overlayColour: Colors.black.withOpacity(0.5))
          ],
        )
    );
  }
  }

