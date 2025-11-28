import 'package:flutter/material.dart';

class AppointmentHeaderSection extends StatelessWidget {
  final String serviceName;
  final String serviceType;
  final String appointmentDate;
  final String status;

  const AppointmentHeaderSection({
    Key? key,
    required this.serviceName,
    required this.serviceType,
    required this.appointmentDate,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.6,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  serviceName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B5320),
                    fontFamily: 'Mallanna',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              serviceType,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'Mallanna',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              appointmentDate,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'Mallanna',
              ),
            ),
          ],
        ),
        _buildStatusChip(status),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    switch (status.toLowerCase()) {
      case "pending":
        backgroundColor = Colors.orange;
        break;
      case "confirmed":
        backgroundColor = Colors.green;
        break;
      case "completed":
        backgroundColor = Colors.blue;
        break;
      case "cancelled":
        backgroundColor = Colors.red;
        break;
      default:
        backgroundColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontFamily: 'Mallanna',
        ),
      ),
    );
  }
}
