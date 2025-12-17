import 'package:flutter/material.dart';

class LaporanFormPage extends StatefulWidget {
  const LaporanFormPage({super.key});

  @override
  State<LaporanFormPage> createState() => _LaporanFormPageState();
}

class _LaporanFormPageState extends State<LaporanFormPage> {
  final _formKey = GlobalKey<FormState>();

  String? tipeProblem;
  String? priority;
  String? teknisi;

  final TextEditingController problemController = TextEditingController();

  final List<String> tipeProblemList = [
    "Modem Problem",
    "Jaringan Lambat",
    "Tidak Ada Koneksi",
    "Tagihan / Billing",
  ];

  final List<String> priorityList = [
    "Low",
    "Medium",
    "High",
    "Critical",
  ];

  final List<String> teknisiList = [
    "Semua Teknisi",
    "Teknisi A",
    "Teknisi B",
    "Teknisi C",
  ];

  // ============================================================
  // SUBMIT FUNCTION
  // ============================================================
  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    final payload = {
      "type_problem": tipeProblem,
      "priority": priority,
      "teknisi": teknisi,
      "problem_desc": problemController.text,
    };

    print("Submit Payload : $payload");

    // TODO: Call API here
    // await Api.post("/laporan/create", payload);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Laporan berhasil dibuat")),
    );

    Navigator.pop(context); // kembali ke list page
  }

  // WIDGET DROPDOWN
  Widget buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
        ),
        icon: const Icon(Icons.arrow_drop_down, size: 30),
        items: items
            .map((e) => DropdownMenuItem(
          value: e,
          child: Text(e),
        ))
            .toList(),
        onChanged: onChanged,
        validator: (val) => val == null ? "$label wajib dipilih" : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buat Laporan"),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Tipe Problem
              buildDropdown(
                label: "Tipe Problem",
                value: tipeProblem,
                items: tipeProblemList,
                onChanged: (v) => setState(() => tipeProblem = v),
              ),

              // Priority
              buildDropdown(
                label: "Priority",
                value: priority,
                items: priorityList,
                onChanged: (v) => setState(() => priority = v),
              ),

              // Pilih Teknisi
              buildDropdown(
                label: "Pilih Teknisi",
                value: teknisi,
                items: teknisiList,
                onChanged: (v) => setState(() => teknisi = v),
              ),

              // TextArea Problem
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: TextFormField(
                  controller: problemController,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    hintText: "Masukkan Problem Disini",
                    border: InputBorder.none,
                  ),
                  validator: (val) =>
                  val == null || val.isEmpty ? "Deskripsi problem wajib diisi" : null,
                ),
              ),

              // Button di kanan bawah
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    child: const Text(
                      "Buat Laporan",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}