import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp()); // Entry point
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Simplified with super parameter

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Scanner App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const QRScannerScreen(), // Main screen
    );
  }
}

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key}); // Simplified with super parameter

  @override
  QRScannerScreenState createState() => QRScannerScreenState(); // Changed to public class
}

class QRScannerScreenState extends State<QRScannerScreen> { // Renamed to public class
  final GlobalKey _qrKey = GlobalKey();
  String _qrData = '';

  void _onQRScanned(String? data) {
    if (data != null) {
      setState(() {
        _qrData = data;
      });
      _openFile(data);
    }
  }

  Future<void> _openFile(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
      ),
      body: Column(
        children: [
          Expanded(
            child: QRView(
              key: _qrKey,
              onQRViewCreated: (QRViewController controller) {
                controller.scannedDataStream.listen((scanData) {
                  _onQRScanned(scanData.code);
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Scanned Data: $_qrData',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
