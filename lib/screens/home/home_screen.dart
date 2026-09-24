import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/home_action_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

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
                      Text('Stay Safe.', style: Theme.of(context).textTheme.headlineMedium),
                    ],
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'logout') {
                        auth.logout();
                        Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
                      }
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'name',
                        enabled: false,
                        child: Text(auth.currentUser?.name ?? 'Guest'),
                      ),
                      const PopupMenuItem(value: 'logout', child: Text('Log out')),
                    ],
                    child: const CircleAvatar(
                      backgroundColor: Color(0xFFE7E1FB),
                      child: Icon(Icons.person, color: AppColors.primaryStart),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              HomeActionCard(
                title: 'EMERGENCY',
                subtitle: 'Call an Ambulance',
                icon: Icons.call,
                gradientColors: AppColors.emergencyGradient,
                onTap: () => Navigator.of(context).pushNamed('/confirm-location'),
              ),
              const SizedBox(height: 16),
              HomeActionCard(
                title: 'My Medical Profile',
                subtitle: 'History, allergies & medication',
                icon: Icons.badge,
                gradientColors: AppColors.profileGradient,
                onTap: () => Navigator.of(context).pushNamed('/medical-profile'),
              ),
              const SizedBox(height: 16),
              HomeActionCard(
                title: 'Nearby Hospitals',
                subtitle: 'Find help close to you',
                icon: Icons.local_hospital,
                gradientColors: AppColors.hospitalGradient,
                onTap: () => Navigator.of(context).pushNamed('/hospitals'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
