
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:convert';
import 'dart:io';

class Helper {
  String formatNumber(dynamic value) {
    if (value == null) return '0';

    final number = int.tryParse(value.toString()) ?? 0;
    return NumberFormat('#,###', 'id_ID').format(number);
  }

  String formatRupiah(dynamic value) {
    final number = int.tryParse(value.toString()) ?? 0;
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    ).format(number);
  }

  String formatTanggalIndo(String? value) {
    if (value == null || value.toString().isEmpty) {
      return '-';
    }

    // "2027-01-01 00:00:00" → ISO
    final date = DateTime.parse(value.replaceAll(' ', 'T'));

    return DateFormat(
      'dd MMMM yyyy • HH:mm',
      'id_ID',
    ).format(date);
  }

  Future<bool> saveScanAndOpenBase64File({
    required String base64Url,
    required String filename,
  }) async {
    try {
      final base64Data = base64Url.split(',').last;
      final bytes = base64Decode(base64Data);

      final dir = Directory('/storage/emulated/0/Download');
      if (!dir.existsSync()) {
        dir.createSync(recursive: true);
      }

      final file = File('${dir.path}/$filename');
      await file.writeAsBytes(bytes);

      // 🔥 PAKSA GALLERY SCAN
      await MediaScanner.loadMedia(path: file.path);

      // 🔥 OPEN pakai app bawaan
      final result = await OpenFilex.open(file.path);

      return result.type == ResultType.done;
    } catch (e) {
      debugPrint('Save/Scan/Open error: $e');
      return false;
    }
  }
}