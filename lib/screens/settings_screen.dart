import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../providers/manage_profile_provider.dart';
import '../providers/points_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/appointment/appointment_card.dart';
import '../providers/appointment_provider.dart';
import '../models/appointment_model.dart';

import '../providers/delete_account_provider.dart';
import '../providers/settings_provider.dart';


class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final int _selectedIndex = 4;
  bool _showPrivacyOptions = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(settingsViewModelProvider.notifier).fetchUserInfo();
    });
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    // Navigate to different screens based on the index
    // You can implement this part to suit your nav setup
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(settingsViewModelProvider);
    final user = viewModel.userInfo;

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Mallanna',
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundImage: user?.profileImg != null
                        ? NetworkImage(user!.profileImg!)
                        : const AssetImage('assets/images/default_profile.png')
                            as ImageProvider,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user != null
                            ? '${user.fname} ${user.lname}'
                            : 'Loading...',
                        style: const TextStyle(
                          fontFamily: 'Mallanna',
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ManageProfileScreen()),
                          );
                        },
                        child: const Text(
                          'Manage Profile',
                          style: TextStyle(
                            fontFamily: 'Mallanna',
                            fontSize: 14,
                            color: Color(0xFF4A5F44),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 32),
              _buildSettingsTile('History', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HistoryScreen()),
                );
              }),
              const Divider(thickness: 1, height: 1),
              _buildSettingsTile('Points', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PointsScreen()),
                );
              }),
              const Divider(thickness: 1, height: 1),
              ListTile(
                title: const Text(
                  'Privacy and Security',
                  style: TextStyle(
                    fontFamily: 'Mallanna',
                    fontSize: 16,
                  ),
                ),
                trailing: Icon(
                  _showPrivacyOptions
                      ? Icons.expand_less
                      : Icons.expand_more,
                  color: Colors.black,
                ),
                onTap: () {
                  setState(() {
                    _showPrivacyOptions = !_showPrivacyOptions;
                  });
                },
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.lock_outline),
                      title: const Text(
                        'Change Password',
                        style: TextStyle(fontFamily: 'Mallanna'),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ChangePasswordScreen()),
                        );
                      },
                    ),
                    const Divider(thickness: 1, height: 1),
                    ListTile(
                      leading: const Icon(Icons.delete_outline),
                      title: const Text(
                        'Delete My Account',
                        style: TextStyle(fontFamily: 'Mallanna'),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const DeleteAccountScreen()),
                        );
                      },
                    ),
                    const Divider(thickness: 1, height: 1),
                    ListTile(
                      leading: const Icon(Icons.privacy_tip_outlined),
                      title: const Text(
                        'Privacy Policy',
                        style: TextStyle(fontFamily: 'Mallanna'),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const PrivacyPolicyScreen()),
                        );
                      },
                    ),
                    const Divider(thickness: 1, height: 1),
                  ],
                ),
                crossFadeState: _showPrivacyOptions
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
              const Divider(thickness: 2, height: 1),
              _buildSettingsTile(
                'Log Out',
                () async {
                  await Supabase.instance.client.auth.signOut();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/welcome', (route) => false);
                  }
                },
                textColor: Colors.red,
              ),
              const Divider(thickness: 1, height: 1),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile(String title, VoidCallback onTap,
      {Color? textColor}) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: TextStyle(
              fontFamily: 'Mallanna',
              fontSize: 16,
              color: textColor ?? Colors.black,
            ),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
        const Divider(thickness: 1, height: 1),
      ],
    );
  }
}

class ManageProfileScreen extends ConsumerStatefulWidget {
  const ManageProfileScreen({super.key});

  @override
  ConsumerState<ManageProfileScreen> createState() => _ManageProfileScreenState();
}

class _ManageProfileScreenState extends ConsumerState<ManageProfileScreen> {
  bool isEditing = false;
  
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(profileViewModelProvider.notifier).fetchUserInfo());
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(profileViewModelProvider);
    final controller = ref.read(profileViewModelProvider.notifier);
 
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.arrow_back, size: 24),
                      ),
                    ),
                  ),
              // Top Bar
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundImage: controller.pickedImage != null
                        ? FileImage(controller.pickedImage!) // show new image before saving
                        : (controller.uploadedImageUrl != null
                            ? NetworkImage(controller.uploadedImageUrl!)
                            : const AssetImage('assets/images/default_profile.png')) as ImageProvider,
                  ),
                  if (isEditing)
                    Positioned(
                      right: 4,
                      bottom: 4,
                      child: GestureDetector(
                        onTap: () async {
                          await controller.pickImage(); // just picks image then...
                          setState(() {}); // trigger UI update to show new image
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(Icons.add, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 24),
              Text(
                '${controller.fnameController.text} ${controller.lnameController.text}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Mallanna',
                ),
              ),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.center,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(const Color(0xFF4A5F44)),
                    ),
                    onPressed: () async {
                      if (isEditing) {
                        await controller.updateUserInfo(context);
                      }

                      setState(() => isEditing = !isEditing);
                    },
                    child: Text(
                      isEditing ? 'Save' : 'Edit',
                      style: const TextStyle(
                        fontFamily: 'Mallanna',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                ),
              ),

              // Editable Fields
              _buildInputField('First Name', controller.fnameController, isEditing),
              const SizedBox(height: 16),
              _buildInputField('Last Name', controller.lnameController, isEditing),
              const SizedBox(height: 16),
              _buildInputField('Contact Number', controller.contactController, isEditing),
              const SizedBox(height: 16),
              _buildInputField('Location', controller.locationController, isEditing),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, bool enabled) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Mallanna',
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          enabled: enabled,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(fontFamily: 'Mallanna'),
        ),
      ],
    );
  }
}



class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsAsync = ref.watch(userAppointmentsProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'History',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Mallanna',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
              const SizedBox(height: 24),

              Expanded(
                child: appointmentsAsync.when(
                  data: (appointments) {
                    final historyAppointments = ref.watch(userAppointmentsProvider).maybeWhen(
                      data: (appointments) => appointments
                          .where((a) =>  a.appointmentStatus == AppointmentStatus.completed ||
                            a.appointmentStatus == AppointmentStatus.cancelled)
                          .toList(),
                      orElse: () => [],
                    );

                    if (historyAppointments.isEmpty) {
                      return const Center(
                        child: Text(
                          'No appointment history yet.',
                          style: TextStyle(
                            fontFamily: 'Mallanna',
                            fontSize: 16,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                          itemCount: historyAppointments.length,
                          itemBuilder: (context, index) {
                            return AppointmentCard(appointment: historyAppointments[index]);
                          },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(
                    child: Text(
                      'Error: $e',
                      style: const TextStyle(fontFamily: 'Mallanna', color: Colors.red),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PointsScreen extends ConsumerStatefulWidget {
  const PointsScreen({super.key});

  @override
  ConsumerState<PointsScreen> createState() => _PointsScreenState();
}

class _PointsScreenState extends ConsumerState<PointsScreen> {
  final List<Map<String, dynamic>> rewards = [
    {
      'title': 'P10 Voucher',
      'points': 1000,
      'rewardValue': 'P10',
      'icon': Icons.local_cafe,
    },
    {
      'title': 'P30 Discount',
      'points': 3000,
      'rewardValue': 'P30',
      'icon': Icons.shopping_bag,
    },
    {
      'title': 'TrashTrack Elite',
      'points': 10000,
      'rewardValue': 'P120',
      'icon': Icons.verified,
    },
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        ref.read(pointsViewModelProvider).fetchPoints());
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(pointsViewModelProvider);
    final points = viewModel.userPoints.points;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back),
                  ),
                  const Spacer(),
                  const Text(
                    'Points',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Mallanna',
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 32),

              // Points Balance
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF4A5F44),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Balance',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Mallanna',
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$points EcoBits',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Mallanna',
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              const Text(
                'Redeem Rewards',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Mallanna',
                ),
              ),
              const SizedBox(height: 16),

              // Rewards List
              Expanded(
                child: ListView.builder(
                  itemCount: rewards.length,
                  itemBuilder: (context, index) {
                    final reward = rewards[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF4A5F44).withValues(alpha: 0.1),
                          child: Icon(reward['icon'], color: const Color(0xFF4A5F44)),
                        ),
                        title: Text(
                          reward['title'],
                          style: const TextStyle(
                            fontFamily: 'Mallanna',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'Redeem with ${reward['points']} EcoBits',
                          style: const TextStyle(fontFamily: 'Mallanna'),
                        ),
                        trailing: ElevatedButton(
                          onPressed: points >= reward['points']
                              ? () => _showRedeemDialog(context, reward)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A5F44),
                          ),
                          child: Text(
                            'Redeem',
                            style: const TextStyle(
                              fontFamily: 'Mallanna',
                              color: Colors.white, // Set text color here
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRedeemDialog(BuildContext context, Map<String, dynamic> reward) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text("Are you sure you want to redeem this reward?"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "📦 Voucher: ${reward['title']}",
              style: const TextStyle(
                fontFamily: 'Mallanna',
                color: Colors.black, // Set text color here
              ),
            ),
            Text(
              "💸 Cost: ${reward['points']} EcoBits",
              style: const TextStyle(
                fontFamily: 'Mallanna',
                color: Colors.black, // Set text color here
              ),
            ),
            Text(
              "🏷️ Reward Value: ${reward['rewardValue']}",
              style: const TextStyle(
                fontFamily: 'Mallanna',
                color: Colors.black, // Set text color here
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              "Cancel",
              style: const TextStyle(
                fontFamily: 'Mallanna',
                color: Colors.black, // Set text color here
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A5F44),
            ),
            onPressed: () async {
              final success = await ref
                  .read(pointsViewModelProvider)
                  .redeem(reward['points']);

              Navigator.pop(dialogContext); // Close dialog

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'You redeemed: ${reward['title']}'
                          : 'Not enough EcoBits.',
                    ),
                  ),
                );
              }
            },
            child: const Text(
              "Confirm",
              style: const TextStyle(
                  fontFamily: 'Mallanna',
                  color: Colors.white, // Set text color here
                ),
              ),
          ),
        ],
      );
    },
  );
}

}


class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Uniform back button and title
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
                      ),
                    ),
                  ),
                  const Text(
                    'Privacy Policy',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Mallanna',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Scrollable policy body
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Our Commitment to Your Privacy',
                        style: TextStyle(
                          fontFamily: 'Mallanna',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'TrashTrack is committed to protecting your personal information. This Privacy Policy outlines how we collect, use, and safeguard your data while using our application.',
                        style: TextStyle(fontFamily: 'Mallanna'),
                      ),
                      SizedBox(height: 24),
                      Text(
                        '1. Information We Collect',
                        style: TextStyle(
                          fontFamily: 'Mallanna',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '- Full name and email address (for account registration)\n'
                            '- Location data (to suggest nearby disposal sites)\n'
                            '- Disposal history and earned points (to maintain account activity)',
                        style: TextStyle(fontFamily: 'Mallanna'),
                      ),
                      SizedBox(height: 24),
                      Text(
                        '2. How We Use Your Information',
                        style: TextStyle(
                          fontFamily: 'Mallanna',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '- To personalize your experience and provide accurate disposal data\n'
                            '- To monitor and reward your sustainable actions\n'
                            '- To notify you of upcoming events, rewards, and nearby eco hubs',
                        style: TextStyle(fontFamily: 'Mallanna'),
                      ),
                      SizedBox(height: 24),
                      Text(
                        '3. Data Sharing',
                        style: TextStyle(
                          fontFamily: 'Mallanna',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'We do not sell, trade, or rent your personal information to third parties. We may share limited data with government or partnered recycling organizations, only when necessary for environmental reporting and verification.',
                        style: TextStyle(fontFamily: 'Mallanna'),
                      ),
                      SizedBox(height: 24),
                      Text(
                        '4. Data Security',
                        style: TextStyle(
                          fontFamily: 'Mallanna',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'We implement appropriate technical and organizational measures to protect your personal data from unauthorized access, alteration, disclosure, or destruction.',
                        style: TextStyle(fontFamily: 'Mallanna'),
                      ),
                      SizedBox(height: 24),
                      Text(
                        '5. User Responsibilities',
                        style: TextStyle(
                          fontFamily: 'Mallanna',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '- Do not share your login credentials with others\n'
                            '- Report any suspicious or unauthorized activity on your account\n'
                            '- Use the app responsibly and truthfully when logging disposals',
                        style: TextStyle(fontFamily: 'Mallanna'),
                      ),
                      SizedBox(height: 24),
                      Text(
                        '6. Updates to the Policy',
                        style: TextStyle(
                          fontFamily: 'Mallanna',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'This policy may be updated occasionally. Users will be notified of major changes through in-app alerts.',
                        style: TextStyle(fontFamily: 'Mallanna'),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Contact Us',
                        style: TextStyle(
                          fontFamily: 'Mallanna',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'For questions regarding our Privacy Policy, please email us at support@trashtrack.eco',
                        style: TextStyle(fontFamily: 'Mallanna'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeleteAccountScreen extends ConsumerWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(deleteAccountViewModelProvider);
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
                      ),
                    ),
                  ),
                  const Text(
                    'Delete Account',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Mallanna',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                'Are you sure you want to delete your TrashTrack account?',
                style: TextStyle(
                  fontFamily: 'Mallanna',
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'This action is irreversible and will permanently remove all your data including EcoBits, history, and personal information.',
                style: TextStyle(
                  fontFamily: 'Mallanna',
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  // TODO: Add delete logic
                  try {
                    await viewModel.updateUserStatus();
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Account Deleted'),
                        content: const Text('Your account has been deleted successfully.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.popUntil(context, (route) => route.isFirst);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Delete My Account',
                  style: TextStyle(
                    fontFamily: 'Mallanna',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}
class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleChangePassword() async {
    if (!_formKey.currentState!.validate()) return;

    final viewModel = ref.read(changePasswordViewModelProvider);
    final success = await viewModel.changePassword(
      _currentPasswordController.text.trim(),
      _newPasswordController.text.trim(),
    );

    if (success && mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Success'),
          content: Text(viewModel.successMessage ?? 'Password updated.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(viewModel.errorMessage ?? 'Failed to update password.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(changePasswordViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back and title
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
                      ),
                    ),
                  ),
                  const Text(
                    'Change Password',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Mallanna',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Current password
                    TextFormField(
                      controller: _currentPasswordController,
                      obscureText: _obscureCurrent,
                      decoration: InputDecoration(
                        labelText: 'Current Password',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureCurrent ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureCurrent = !_obscureCurrent;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your current password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // New password
                    TextFormField(
                      controller: _newPasswordController,
                      obscureText: _obscureNew,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureNew ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureNew = !_obscureNew;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Confirm new password
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirm,
                      decoration: InputDecoration(
                        labelText: 'Confirm New Password',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirm = !_obscureConfirm;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value != _newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Save button
              ElevatedButton(
                onPressed: viewModel.isLoading ? null : _handleChangePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A5F44),
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: viewModel.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontFamily: 'Mallanna',
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
