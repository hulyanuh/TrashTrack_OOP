import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/admin_disposal_provider.dart';
import '../widgets/admin_nav_bar.dart';

class AdminSettingsScreen extends ConsumerStatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  ConsumerState<AdminSettingsScreen> createState() =>
      _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends ConsumerState<AdminSettingsScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.invalidate(adminServiceProvider));
  }

  @override
  Widget build(BuildContext context) {
    final shopAsync = ref.watch(adminServiceProvider);

    return shopAsync.when(
      data: (shop) {
        return Scaffold(
          bottomNavigationBar: const AdminNavBar(currentIndex: 4),
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
                      const CircleAvatar(
                        radius: 36,
                        backgroundImage: AssetImage(
                          'assets/images/default_profile.png',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          shop.serviceName, // Dynamic shop name
                          style: const TextStyle(
                            fontFamily: 'Mallanna',
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                          softWrap: true,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),

                  ListTile(
                    title: const Text(
                      'Privacy Policy',
                      style: TextStyle(fontFamily: 'Mallanna', fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminPrivacyPolicyScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(thickness: 1, height: 1),
                  ListTile(
                    title: const Text(
                      'Log Out',
                      style: TextStyle(
                        fontFamily: 'Mallanna',
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                    onTap: () async {
                      await Supabase.instance.client.auth.signOut();
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/welcome',
                          (route) => false,
                        );
                      }
                    },
                  ),
                  const Divider(thickness: 1, height: 1),
                ],
              ),
            ),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
    );
  }
}

class AdminPrivacyPolicyScreen extends StatelessWidget {
  const AdminPrivacyPolicyScreen({super.key});

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
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 24,
                        ),
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
                        'As an admin of TrashTrack, your information is vital to maintaining the integrity and operations of the platform. This Privacy Policy explains how we handle your data securely and responsibly.',
                        style: TextStyle(fontFamily: 'Mallanna'),
                      ),
                      SizedBox(height: 24),
                      Text(
                        '1. Data We Collect',
                        style: TextStyle(
                          fontFamily: 'Mallanna',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '- Name, contact number, and role for identity verification. Activity logs related to disposal management and validation. Location data for admin assignments',
                        style: TextStyle(fontFamily: 'Mallanna'),
                      ),
                      SizedBox(height: 24),
                      Text(
                        '2. Usage of Data',
                        style: TextStyle(
                          fontFamily: 'Mallanna',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '- To authorize access and privileges on the platform. To monitor eco hub activity and validate disposal requests. For platform analytics and improvement',
                        style: TextStyle(fontFamily: 'Mallanna'),
                      ),
                      SizedBox(height: 24),
                      Text(
                        '3. Security Measures',
                        style: TextStyle(
                          fontFamily: 'Mallanna',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'We employ administrative and technical safeguards to ensure your data remains secure and inaccessible to unauthorized users.',
                        style: TextStyle(fontFamily: 'Mallanna'),
                      ),
                      SizedBox(height: 24),
                      Text(
                        '4. Confidentiality',
                        style: TextStyle(
                          fontFamily: 'Mallanna',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Admin data will not be sold, shared, or disclosed without consent, except as required by law or for internal investigations.',
                        style: TextStyle(fontFamily: 'Mallanna'),
                      ),
                      SizedBox(height: 24),
                      Text(
                        '5. Updates to This Policy',
                        style: TextStyle(
                          fontFamily: 'Mallanna',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'We reserve the right to revise this policy when necessary. Admins will be notified of any major changes.',
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
                        'For concerns regarding admin data privacy, contact us at admin-support@trashtrack.eco.',
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
