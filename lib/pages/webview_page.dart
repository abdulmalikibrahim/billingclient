import 'package:billing_client/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class WebviewPage extends StatefulWidget {
  const WebviewPage({super.key});

  @override
  State<WebviewPage> createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  bool isLoading = true;

  late String url;
  late String title;
  final helper = Helper();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    url = args?['url'] ?? '';
    title = args?['title'] ?? 'Webview';
  }

  void showToast(String message, {bool success = true}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: success ? Colors.green : Colors.red,
      textColor: Colors.white,
      fontSize: 14,
    );
  }

  @override
  Widget build(BuildContext context) {
    // safety: jika url kosong
    if (url.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: const Center(
          child: Text('URL tidak tersedia'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri(url),
            ),
            onLoadStop: (controller, _) {
              if (mounted) {
                setState(() => isLoading = false);
              }
            },
            onDownloadStartRequest: (controller, request) async {
              final url = request.url.toString();

              try {
                if (url.startsWith('data:')) {
                  final isPdf = url.contains('application/pdf');

                  // pakai nama dari export jika ada
                  final filename = (request.suggestedFilename != null &&
                      request.suggestedFilename!.isNotEmpty)
                      ? request.suggestedFilename!
                      : isPdf
                      ? 'invoice_${DateTime.now().millisecondsSinceEpoch}.pdf'
                      : 'invoice_${DateTime.now().millisecondsSinceEpoch}.jpg';

                  final success = await helper.saveScanAndOpenBase64File(
                    base64Url: url,
                    filename: filename,
                  );

                  if (success) {
                    showToast('File "$filename" berhasil disimpan');
                  } else {
                    showToast('Gagal menyimpan file', success: false);
                  }
                  return;
                }

                // fallback untuk URL biasa
                await launchUrl(
                  Uri.parse(url),
                  mode: LaunchMode.externalApplication,
                );
                showToast('Download dimulai');
              } catch (e) {
                showToast('Terjadi kesalahan saat download', success: false);
              }
            },
          ),

          if (isLoading)
            Container(
              color: Colors.white, // ✅ background putih
              width: double.infinity,
              height: double.infinity,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          ,
        ],
      ),
    );
  }
}
