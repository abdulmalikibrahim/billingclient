import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:billing_client/models/banner.dart';
import 'package:billing_client/services/banner_service.dart';

class BannerDetailPage extends StatefulWidget {
  const BannerDetailPage({super.key});

  @override
  State<BannerDetailPage> createState() => _BannerDetailPageState();
}

class _BannerDetailPageState extends State<BannerDetailPage> {
  final BannerService bannerService = BannerService();

  bool isLoading = true;
  BannerModel? banner;
  String? bannerId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    bannerId = args?['id']?.toString();

    if (bannerId != null) {
      _loadBannerDetail();
    }
  }

  Future<void> _loadBannerDetail() async {
    try {
      final result = await bannerService.show(id: bannerId!);

      if (!mounted) return;

      setState(() {
        banner = result.data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(
        msg: e.toString().replaceAll('Exception: ', ''),
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(
          banner?.name ?? 'Detail Banner',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : banner == null
          ? const Center(
        child: Text(
          'Data banner tidak ditemukan',
          style: TextStyle(color: Colors.black54),
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Html(
            data: banner!.bodyBanner,
            style: {
              "body": Style(
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
                fontSize: FontSize(14),
                color: Colors.black87,
                lineHeight: LineHeight.number(1.6),
              ),
            },
            extensions: [
              TagExtension(
                tagsToExtend: {"img"},
                builder: (context) {
                  final src = context.attributes['src'];
                  if (src == null) return const SizedBox();

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8), // ✅ BENAR
                      child: Image.network(
                        src,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
