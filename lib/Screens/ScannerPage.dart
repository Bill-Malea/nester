import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../providers/AttendenceProvider.dart';

class ScannerPage extends StatefulWidget {
  final bool ischeckin;
  const ScannerPage({super.key, required this.ischeckin});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
QRViewController? _controller;
String _qrText = '';

class _ScannerPageState extends State<ScannerPage> {
  @override
  void dispose() {
    _controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String date() {
      final now = DateTime.now();
      final year = now.year.toString();
      final month = now.month.toString();
      final day = now.day.toString();
      return year + month + day;
    }

    void onQRViewCreated(QRViewController controller) {
      setState(() {
        _controller = controller;
      });
      _controller!.scannedDataStream.listen((scanData) async {
        final scannedText = scanData.code!;
        final currentDate = date();
        if (scannedText == currentDate) {
          if (widget.ischeckin) {
            Provider.of<AttendanceService>(context, listen: false).checkIn();
            Navigator.pop(context);
            if (mounted) {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Check In'),
                  content: const Text('Checked in Successfully.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            }
          } else {
            Provider.of<AttendanceService>(context, listen: false).checkOut();
            Navigator.pop(context);
            if (mounted) {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('CheckOut'),
                  content: const Text('Checked Out Successfully.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            }
          }
        } else {
          Navigator.pop(context);
          if (mounted) {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Invalid QR code'),
                content: const Text('Invalid Qr Code.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        }
        setState(() {
          _qrText = scannedText;
        });
      });
    }

    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 350.0;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: QRView(
              overlay: QrScannerOverlayShape(
                  borderColor: Colors.red,
                  borderRadius: 10,
                  borderLength: 40,
                  borderWidth: 5,
                  cutOutSize: scanArea),
              key: _qrKey,
              onQRViewCreated: onQRViewCreated,
            ),
          ),
        ],
      ),
    );
  }
}
