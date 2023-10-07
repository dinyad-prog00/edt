import 'package:flutter/material.dart';
import 'package:qrcode_flutter/qrcode_flutter.dart';

class QrScanner extends StatefulWidget {
  @override
  _QrScannerState createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> with TickerProviderStateMixin {
  QRCaptureController _controller = QRCaptureController();

  bool _isTorchOn = false;

  String _captureText = '';

  @override
  void initState() {
    super.initState();

    _controller.onCapture((data) {
      //Navigator.pop<String>(context, data);
      // print('$data');
      setState(() {
        _captureText = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scanner'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 300,
                height: 300,
                child: QRCaptureView(
                  controller: _controller,
                ),
              ),
            ),
            if (_captureText != "")
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _captureText,
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            if (_captureText != "")
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 45),
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {
                    Navigator.pop<String>(context, _captureText);
                  },
                  child: Text('OK'),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildToolBar() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextButton(
          onPressed: () {
            _controller.pause();
          },
          child: Text('pause'),
        ),
        TextButton(
          onPressed: () {
            if (_isTorchOn) {
              _controller.torchMode = CaptureTorchMode.off;
            } else {
              _controller.torchMode = CaptureTorchMode.on;
            }
            _isTorchOn = !_isTorchOn;
          },
          child: Text('torch'),
        ),
        TextButton(
          onPressed: () {
            _controller.resume();
          },
          child: Text(
            'resume=$_captureText',
          ),
        ),
      ],
    );
  }
}
