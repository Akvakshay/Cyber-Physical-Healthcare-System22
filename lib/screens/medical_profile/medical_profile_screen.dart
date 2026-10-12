import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../models/emergency_type_model.dart';
import '../../models/medical_profile_model.dart';
import '../../providers/medical_profile_provider.dart';
import '../../providers/view_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/emergency_type_card.dart';
import '../../widgets/medical_profile_floating_actions.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/state_views.dart';
import '../../widgets/voice_recording_sheet.dart';

class MedicalProfileScreen extends StatefulWidget {
  const MedicalProfileScreen({super.key});

  @override
  State<MedicalProfileScreen> createState() => _MedicalProfileScreenState();
}

class _MedicalProfileScreenState extends State<MedicalProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _diseasesController = TextEditingController();
  final _allergiesController = TextEditingController();

  final _ageFocus = FocusNode();
  final _weightFocus = FocusNode();
  final _diseasesFocus = FocusNode();
  final _allergiesFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<MedicalProfileProvider>();
      await provider.loadProfile();
      _syncControllersFromDraft(provider.draft);
    });
  }

  void _syncControllersFromDraft(MedicalProfileModel profile) {
    _ageController.text = profile.age?.toString() ?? '';
    _weightController.text = profile.weightKg?.toString() ?? '';
    _diseasesController.text = profile.knownDiseases;
    _allergiesController.text = profile.allergies;
  }

  Future<void> _openVoiceRecorder(MedicalProfileProvider provider) async {
    final note = await VoiceRecordingSheet.show(context);
    if (!mounted || note == null) return;
    await provider.addVoiceNote(note);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Voice note recorded (${note.formattedDuration})'),
        backgroundColor: const Color(0xFF6B4EE6),
      ),
    );
  }

  @override
  void dispose() {
    for (final c in [_ageController, _weightController, _diseasesController, _allergiesController]) {
      c.dispose();
    }
    for (final f in [_ageFocus, _weightFocus, _diseasesFocus, _allergiesFocus]) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MedicalProfileProvider>();
    final status = provider.state.status;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Profile'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Builder(
          builder: (_) {
            if (status == ViewStatus.loading && provider.state.data == null) {
              return const LoadingView(message: 'Loading your profile…');
            }
            if (status == ViewStatus.error) {
              return ErrorView(
                message: provider.state.errorMessage ?? 'Something went wrong.',
                onRetry: () => provider.loadProfile(),
              );
            }
            return _buildForm(context, provider);
          },
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, MedicalProfileProvider provider) {
    final draft = provider.draft;

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Centered Heart Badge matching Image 2
                Center(
                  child: Container(
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
                ),
                const SizedBox(height: 14),
                const Center(
                  child: Text(
                    'A. Demographics',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF14161F),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Center(
                  child: Text(
                    'Update your personal details for a complete profile.',
                    style: TextStyle(
                      color: Color(0xFF4B5563),
                      fontSize: 13.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    label: 'Age',
                    hint: 'Age',
                    controller: _ageController,
                    focusNode: _ageFocus,
                    nextFocusNode: _weightFocus,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                    onChanged: (v) => provider.updateDraft(
                      (p) => p.copyWith(age: int.tryParse(v)),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: CustomTextField(
                    label: 'Weights',
                    hint: 'Weight in kg',
                    controller: _weightController,
                    focusNode: _weightFocus,
                    nextFocusNode: _diseasesFocus,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                    onChanged: (v) => provider.updateDraft(
                      (p) => p.copyWith(weightKg: double.tryParse(v)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('BMI', style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      Container(
                        height: 54,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(AppRadii.md),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          draft.bmi?.toString() ?? 'BMI (Calculated)',
                          style: TextStyle(
                            color: draft.bmi == null ? const Color(0xFF9AA1AC) : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Gender', style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<Gender>(
                        initialValue: draft.gender,
                        decoration: const InputDecoration(),
                        hint: const Text('Select Gender'),
                        items: Gender.values
                            .map((g) => DropdownMenuItem(value: g, child: Text(g.label)))
                            .toList(),
                        onChanged: (g) => provider.updateDraft((p) => p.copyWith(gender: g)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Know Disease',
              hint: 'Known Diseases (e.g., Diabetes, Hypertension)',
              controller: _diseasesController,
              focusNode: _diseasesFocus,
              nextFocusNode: _allergiesFocus,
              onChanged: (v) => provider.updateDraft((p) => p.copyWith(knownDiseases: v)),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Allergies',
              hint: 'Allergies (e.g., Peanuts, Penicillin)',
              controller: _allergiesController,
              focusNode: _allergiesFocus,
              textInputAction: TextInputAction.done,
              onChanged: (v) => provider.updateDraft((p) => p.copyWith(allergies: v)),
            ),
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'B. Emergency Type',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF14161F),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: EmergencyTypes.all.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.6,
              ),
              itemBuilder: (context, index) {
                final type = EmergencyTypes.all[index];
                return EmergencyTypeCard(
                  type: type,
                  selected: draft.selectedEmergencyTypeId == type.id,
                  onTap: () => provider.updateDraft(
                    (p) => p.copyWith(selectedEmergencyTypeId: type.id),
                  ),
                );
              },
            ),
            const SizedBox(height: 28),
            PrimaryButton(
              label: 'SAVE PROFILE',
              isLoading: provider.state.status == ViewStatus.loading,
              gradientColors: const [Color(0xFF6B4EE6), Color(0xFF5B30DE)],
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;
                final ok = await provider.saveProfile();
                if (ok && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile saved successfully.')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    ),
    // Floating actions in the bottom-left area, exactly matching Image 2
    Positioned(
      left: 18,
      bottom: 96,
      child: MedicalProfileFloatingActions(
        onAddPrescription: () =>
            Navigator.of(context).pushNamed('/add-prescription'),
        onVoiceRecord: () => _openVoiceRecorder(provider),
      ),
    ),
  ],
);
  }
}
