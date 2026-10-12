import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/prescription_model.dart';
import '../../providers/medical_profile_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/dashed_border_card.dart';
import '../../widgets/primary_button.dart';

class AddPrescriptionScreen extends StatefulWidget {
  const AddPrescriptionScreen({super.key});

  @override
  State<AddPrescriptionScreen> createState() => _AddPrescriptionScreenState();
}

class _AddPrescriptionScreenState extends State<AddPrescriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _doctorController = TextEditingController();
  final _dateController = TextEditingController();
  final _medicinesController = TextEditingController();

  final _doctorFocus = FocusNode();
  final _dateFocus = FocusNode();
  final _medicinesFocus = FocusNode();

  String? _uploadedFileName = 'prescription_01.jpg';
  int _uploadedFileSize = 1258291; // 1.2 MB
  bool _isUploading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('dd / MM / yyyy').format(DateTime.now());
  }

  @override
  void dispose() {
    _doctorController.dispose();
    _dateController.dispose();
    _medicinesController.dispose();
    _doctorFocus.dispose();
    _dateFocus.dispose();
    _medicinesFocus.dispose();
    super.dispose();
  }

  void _simulateUpload(String fileName, int bytes) {
    setState(() {
      _isUploading = true;
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _uploadedFileName = fileName;
          _uploadedFileSize = bytes;
          _isUploading = false;
        });
      }
    });
  }

  void _removeUploadedFile() {
    setState(() {
      _uploadedFileName = null;
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6B4EE6),
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      _dateController.text = DateFormat('dd / MM / yyyy').format(picked);
    }
  }

  Future<void> _savePrescription() async {
    if (!_formKey.currentState!.validate()) return;
    if (_uploadedFileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a prescription image or document.')),
      );
      return;
    }

    setState(() => _isSaving = true);
    final prescription = PrescriptionModel(
      id: 'pres_${DateTime.now().millisecondsSinceEpoch}',
      fileName: _uploadedFileName!,
      fileSizeBytes: _uploadedFileSize,
      doctorName: _doctorController.text.trim(),
      prescriptionDate: _dateController.text.trim(),
      medicinesNotes: _medicinesController.text.trim(),
      uploadedAt: DateTime.now(),
    );

    final provider = context.read<MedicalProfileProvider>();
    final success = await provider.addPrescription(prescription);

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Prescription saved successfully!')),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save prescription.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Heart Badge
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6B4EE6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Icon(Icons.favorite, color: Colors.white, size: 26),
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                const Text(
                  'C. Add Prescription',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF14161F),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),

                // Subtitle
                const Text(
                  'Upload your prescription so responders can see your medicines.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4B5563),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 24),

                // Dashed Upload Card
                DashedBorderCard(
                  color: const Color(0xFF8B5CF6),
                  strokeWidth: 1.5,
                  dashLength: 7,
                  gap: 5,
                  borderRadius: 18,
                  onTap: () => _simulateUpload('prescription_${DateTime.now().second}.jpg', 1258291),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFF),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.file_upload_outlined,
                            color: Color(0xFF7C3AED),
                            size: 26,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Tap to upload prescription',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'JPG, PNG or PDF · up to 10 MB',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Dual Buttons: Take Photo & Gallery
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _simulateUpload('camera_photo_${DateTime.now().millisecond}.jpg', 2097152),
                        borderRadius: BorderRadius.circular(14),
                        child: Ink(
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD1F2ED),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt_outlined, color: Color(0xFF0F766E), size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Take Photo',
                                style: TextStyle(
                                  color: Color(0xFF0F766E),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () => _simulateUpload('gallery_image_${DateTime.now().millisecond}.jpg', 1572864),
                        borderRadius: BorderRadius.circular(14),
                        child: Ink(
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD6E3F8),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image_outlined, color: Color(0xFF1D4ED8), size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Gallery',
                                style: TextStyle(
                                  color: Color(0xFF1D4ED8),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Uploaded File Preview Card
                if (_isUploading)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF7C3AED)),
                        ),
                        SizedBox(width: 12),
                        Text('Uploading prescription…', style: TextStyle(color: Color(0xFF6B7280))),
                      ],
                    ),
                  )
                else if (_uploadedFileName != null)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDE9FE),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.insert_drive_file_outlined,
                              color: Color(0xFF7C3AED),
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _uploadedFileName!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.5,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${(_uploadedFileSize / (1024 * 1024)).toStringAsFixed(1)} MB · Uploaded',
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: const LinearProgressIndicator(
                                  value: 1.0,
                                  minHeight: 4,
                                  backgroundColor: Color(0xFFE5E7EB),
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7C3AED)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: _removeUploadedFile,
                          icon: const Icon(Icons.close, color: Color(0xFF64748B), size: 20),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),

                // Form Fields
                CustomTextField(
                  label: "Doctor's Name",
                  hint: "Doctor's name (e.g., Dr. Sharma)",
                  controller: _doctorController,
                  focusNode: _doctorFocus,
                  nextFocusNode: _dateFocus,
                  prefixIcon: Icons.person_outline,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                InkWell(
                  onTap: _pickDate,
                  child: IgnorePointer(
                    child: CustomTextField(
                      label: 'Prescription Date',
                      hint: 'DD / MM / YYYY',
                      controller: _dateController,
                      focusNode: _dateFocus,
                      nextFocusNode: _medicinesFocus,
                      prefixIcon: Icons.calendar_today_outlined,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                CustomTextField(
                  label: 'Medicines / Notes',
                  hint: 'Medicines or notes (e.g., Metformin 500 mg, twice daily)',
                  controller: _medicinesController,
                  focusNode: _medicinesFocus,
                  textInputAction: TextInputAction.done,
                  maxLines: 3,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 28),

                // Save Prescription Button
                PrimaryButton(
                  label: 'SAVE PRESCRIPTION',
                  isLoading: _isSaving,
                  gradientColors: const [Color(0xFF6B4EE6), Color(0xFF5B30DE)],
                  onPressed: _savePrescription,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
