// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:paye_ton_kawa/models/boxes.dart';
import 'package:paye_ton_kawa/products_page.dart';

class QRCodeScanner extends StatefulWidget {
  const QRCodeScanner({super.key});

  @override
  State<QRCodeScanner> createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  MobileScannerController cameraController = MobileScannerController();
  bool canScan = true;

  void _onQRCodeScanned(String? code) async {
    if (code == null || code.isEmpty || !canScan) return;

    canScan = false;

    bool res = await _login(code);
    if (res) {
      box.put("jwt_token", code);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProductsPage()),
      );
    }
  }

  Future<bool> _login(String qrcode) async {
    final url = Uri.parse(
        'https://mspr-payetonkawa-95a92-revendeur-7yeohaluka-uc.a.run.app/revendeur/login');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'key': qrcode,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401 || response.statusCode == 404) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('QR Code invalide'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Error occurred, display an error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(
              'Une erreur est survenue, veuillez réessayer plus tard ${response.statusCode}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                switch (state) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (capture) {
          _onQRCodeScanned(capture.barcodes[0].rawValue);
        },
      ),
    );
  }
}
