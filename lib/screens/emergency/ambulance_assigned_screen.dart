import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/emergency_provider.dart';
import '../../providers/view_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/mock_map_background.dart';
import '../../widgets/state_views.dart';

class AmbulanceAssignedScreen extends StatefulWidget {
  const AmbulanceAssignedScreen({super.key});

  @override
  State<AmbulanceAssignedScreen> createState() => _AmbulanceAssignedScreenState();
}

class _AmbulanceAssignedScreenState extends State<AmbulanceAssignedScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmergencyProvider>().requestAmbulance();
    });
  }

  Future<void> _call(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final emergency = context.watch<EmergencyProvider>();
    final state = emergency.ambulanceState;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome back', style: Theme.of(context).textTheme.bodyMedium),
                      Text('Ambulance assigned', style: Theme.of(context).textTheme.headlineMedium),
                    ],
                  ),
                  const CircleAvatar(
                    backgroundColor: Color(0xFFE7E1FB),
                    child: Icon(Icons.person, color: AppColors.primaryStart),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Builder(builder: (_) {
                  if (state.status == ViewStatus.loading) {
                    return const LoadingView(message: 'Dispatching the nearest ambulance…');
                  }
                  if (state.isError) {
                    return ErrorView(
                      message: state.errorMessage ?? 'Could not reach dispatch.',
                      onRetry: () => emergency.requestAmbulance(),
                    );
                  }
                  final ambulance = state.data;
                  if (ambulance == null) {
                    return const EmptyView(message: 'No ambulance request in progress.');
                  }

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(AppRadii.lg),
                            boxShadow: const [
                              BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 4)),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const CircleAvatar(radius: 28, backgroundColor: Color(0xFFE5E7EB), child: Icon(Icons.person, color: AppColors.textSecondary)),
                                  const SizedBox(width: 14),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Ambulance details', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                                      Text(ambulance.driverName, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
                                      Text('Vehicle # ${ambulance.vehicleNumber}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                                    ],
                                  ),
                                ],
                              ),
                              const Divider(height: 28),
                              ...ambulance.equipment.map(
                                (e) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.check_circle, size: 18, color: AppColors.success),
                                      const SizedBox(width: 10),
                                      Text(e),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            borderRadius: BorderRadius.circular(AppRadii.md),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.access_time, color: Colors.white, size: 18),
                              const SizedBox(width: 8),
                              Text('ETA: ${ambulance.etaMinutes} mins',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 260,
                          child: MockMapBackground(
                            child: Stack(
                              children: const [
                                Positioned(
                                  left: 40,
                                  bottom: 60,
                                  child: Icon(Icons.location_on, color: AppColors.emergencyStart, size: 34),
                                ),
                                Positioned(
                                  right: 50,
                                  top: 40,
                                  child: Icon(Icons.local_shipping, color: AppColors.hospitalStart, size: 30),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _call(ambulance.driverPhone),
                                child: const Text('Call Driver'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF14224D)),
                                onPressed: () => _call(ambulance.medicalTeamPhone),
                                child: const Text('Call Medical Team'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              emergency.cancelRequest();
                              Navigator.of(context).popUntil((r) => r.settings.name == '/home');
                            },
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              side: const BorderSide(color: AppColors.border),
                            ),
                            child: const Text('Cancel Request'),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
