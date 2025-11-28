import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/admin_disposal_provider.dart';
import '../widgets/admin_nav_bar.dart';

class AdminShopScreen extends ConsumerStatefulWidget {
  const AdminShopScreen({super.key});

  @override
  ConsumerState<AdminShopScreen> createState() => _AdminShopScreenState();
}

class _AdminShopScreenState extends ConsumerState<AdminShopScreen> {
  bool isEditing = false;
  final TextEditingController shopNameC = TextEditingController();
  final TextEditingController descriptionC = TextEditingController();
  final TextEditingController locationC = TextEditingController();
  final TextEditingController linkC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final shopAsync = ref.watch(adminServiceProvider);

    return shopAsync.when(
      data: (shop) {
        // Initialize controllers only once when not editing and controllers are empty
        if (!isEditing && shopNameC.text.isEmpty) {
          shopNameC.text = shop.serviceName;
          descriptionC.text = shop.serviceDescription;
          locationC.text = shop.serviceLocation;
          linkC.text = shop.serviceImgUrl;
        }

        return Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Shop Management',
                        style: TextStyle(
                          fontFamily: 'Mallanna',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (isEditing) {
                            await _saveChanges(context);
                          }
                          setState(() => isEditing = !isEditing);
                        },
                        child: Text(
                          isEditing ? 'Save' : 'Edit',
                          style: const TextStyle(
                            fontFamily: 'Mallanna',
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A5F44),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      const Text(
                        'Edit your Shop Details here.',
                        style: TextStyle(
                          fontFamily: 'Mallanna',
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInput('Shop Name', shopNameC),
                      _buildInput('Description', descriptionC, maxLines: 3),
                      _buildInput('Location', locationC),
                      _buildInput('Image URL', linkC),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: AdminNavBar(currentIndex: 3),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        enabled: isEditing,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontFamily: 'Mallanna'),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Future<void> _saveChanges(BuildContext context) async {
    final patch = {
      'service_name': shopNameC.text,
      'service_description': descriptionC.text,
      'service_location': locationC.text,
      'service_img': linkC.text,
    };

    await ref.read(adminUpdateServiceProvider)(patch); // dynamic update

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Shop details updated'), behavior: SnackBarBehavior.floating),
    );
  }
}
