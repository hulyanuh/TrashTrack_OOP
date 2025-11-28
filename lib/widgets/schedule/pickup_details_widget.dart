import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/available_schedule.dart';
import '../../models/disposal_service.dart';
import '../../providers/available_schedule_provider.dart';

class PickupDetailsSection extends ConsumerStatefulWidget {
  final DisposalService service;
  final AvailableSchedule? selectedSchedule;
  final Function(AvailableSchedule) onScheduleSelected;
  final String? userLocation;
  final Function(String) onLocationChanged;

  const PickupDetailsSection({
    super.key,
    required this.service,
    required this.selectedSchedule,
    required this.onScheduleSelected,
    required this.userLocation,
    required this.onLocationChanged,
  });

  @override
  ConsumerState<PickupDetailsSection> createState() => _PickupDetailsSectionState();
}

class _PickupDetailsSectionState extends ConsumerState<PickupDetailsSection> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<DateTime> _dates = [];

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    if (date == today) return 'Today';
    if (date == tomorrow) return 'Tomorrow';

    final weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }

  String _formatTime(String time24) {
    final parts = time24.split(":").map(int.parse).toList();
    final hour = parts[0];
    final minute = parts[1];
    final period = hour >= 12 ? "PM" : "AM";
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    final minuteStr = minute.toString().padLeft(2, '0');
    return "$hour12:$minuteStr $period";
  }

  void _initializeTabController(List<DateTime> dates) {
    final currentIndex = _tabController?.index ?? 0;

    // Only recreate controller if necessary
    if (_tabController == null || _tabController!.length != dates.length) {
      _tabController?.dispose();
      _tabController = TabController(
        length: dates.length,
        vsync: this,
        initialIndex: currentIndex.clamp(0, dates.length - 1),
      );
    }
  }


  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Pick up Details",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ref.watch(availableSchedulesProvider(widget.service.serviceId)).when(
          data: (schedules) {
            final now = DateTime.now();
            schedules = schedules.where((s) {
              final dateTime = DateTime(
                s.availDate.year,
                s.availDate.month,
                s.availDate.day,
                int.parse(s.availStartTime.split(':')[0]),
                int.parse(s.availStartTime.split(':')[1]),
              );
              return dateTime.isAfter(now);
            }).toList();

            final grouped = <DateTime, List<AvailableSchedule>>{};
            for (var s in schedules) {
              final key = DateTime(s.availDate.year, s.availDate.month, s.availDate.day);
              grouped.putIfAbsent(key, () => []).add(s);
            }

            _dates = grouped.keys.toList()..sort();
            _initializeTabController(_dates);

            if (_dates.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'No available pickup schedules for this service',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Mallanna', color: Colors.grey, fontSize: 16),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Available Pick-Up Schedules", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Column(
                    children: [
                      TabBar(
                        isScrollable: true,
                        labelColor: const Color(0xFF4B5320),
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: const Color(0xFF4B5320),
                        controller: _tabController,
                        tabs: _dates.map((d) => Tab(text: _formatDate(d))).toList(),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: _dates.map((date) {
                            return GridView.count(
                              crossAxisCount: 2,
                              padding: const EdgeInsets.all(8),
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 2.5,
                              children: grouped[date]!.map((s) {
                                final isSelected = widget.selectedSchedule?.availScheduleId == s.availScheduleId;
                                return InkWell(
                                  onTap: () => widget.onScheduleSelected(s),
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: isSelected ? const Color(0xFF4B5320) : const Color(0xFFF0F0F0),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${_formatTime(s.availStartTime)} - ${_formatTime(s.availEndTime)}',
                                      style: TextStyle(
                                        fontFamily: 'Mallanna',
                                        color: isSelected ? Colors.white : Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const Center(child: Text('Failed to load schedules')),
        ),
        const SizedBox(height: 15),
        const Text("Location", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            onChanged: widget.onLocationChanged,
            decoration: const InputDecoration(
              icon: Icon(Icons.location_on),
              hintText: 'Enter pickup address',
              border: InputBorder.none,
            ),
            maxLines: null,
          ),
        ),
        const SizedBox(height: 10),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Pick up Fee", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("₱50.00"),
          ],
        ),
      ],
    );
  }
}
