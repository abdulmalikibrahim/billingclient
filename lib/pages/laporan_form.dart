import 'package:billing_client/models/technisian.dart';
import 'package:billing_client/services/ticket_service.dart';
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
  String? teknisiId;

  final TextEditingController problemController = TextEditingController();

  bool isLoadingTechnisian = false;
  bool isSubmitting = false;

  List<TechnisianModel> technisianList = [];

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

  @override
  void initState() {
    super.initState();
    fetchTechnisian();
  }

  @override
  void dispose() {
    problemController.dispose();
    super.dispose();
  }

  // ============================================================
  // FETCH TEKNISI
  // ============================================================
  Future<void> fetchTechnisian() async {
    setState(() => isLoadingTechnisian = true);

    try {
      final res = await TicketService().getTechnisian(idMitra: 750);

      final list = res.data;

      technisianList = [
        TechnisianModel(idTeknisi: null, name: 'Semua Teknisi'),
        ...list,
      ];
    } catch (e) {
      showToast(e.toString());
    } finally {
      if (mounted) {
        setState(() => isLoadingTechnisian = false);
      }
    }
  }

  // ============================================================
  // SUBMIT
  // ============================================================
  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (isSubmitting) return;

    setState(() => isSubmitting = true);

    try {
      await TicketService().store(
        idClient: 35557, // sesuaikan dari auth / session
        idMitra: 750,
        tipeProblem: tipeProblem!,
        idTeknisi: teknisiId ?? '',
        difficulty: priority!,
        problem: problemController.text,
      );

      // callback ke page sebelumnya
      Navigator.pop(context, true);
    } catch (e) {
      showToast(e.toString());
    } finally {
      if (mounted) {
        setState(() => isSubmitting = false);
      }
    }
  }

  // ============================================================
  // TOAST
  // ============================================================
  void showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade600,
      ),
    );
  }

  // ============================================================
  // DROPDOWN STRING
  // ============================================================
  Widget buildDropdownString({
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
        border: Border.all(color: Colors.black),
      ),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
        validator: (val) => val == null ? "$label wajib dipilih" : null,
      ),
    );
  }

  // ============================================================
  // DROPDOWN TEKNISI
  // ============================================================
  Widget buildDropdownTechnisian() {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black),
      ),
      child: DropdownButtonFormField<String?>(
        initialValue: teknisiId,
        decoration: const InputDecoration(
          labelText: "Pilih Teknisi",
          border: InputBorder.none,
        ),
        items: technisianList
            .map(
              (e) => DropdownMenuItem<String?>(
            value: e.idTeknisi,
            child: Text(e.name),
          ),
        )
            .toList(),
        onChanged: (v) => setState(() => teknisiId = v),
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
              buildDropdownString(
                label: "Tipe Problem",
                value: tipeProblem,
                items: tipeProblemList,
                onChanged: (v) => setState(() => tipeProblem = v),
              ),

              buildDropdownString(
                label: "Priority",
                value: priority,
                items: priorityList,
                onChanged: (v) => setState(() => priority = v),
              ),

              isLoadingTechnisian
                  ? const Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              )
                  : buildDropdownTechnisian(),

              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black),
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

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: isSubmitting ? null : submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    child: isSubmitting
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Text(
                      "Buat Laporan",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
