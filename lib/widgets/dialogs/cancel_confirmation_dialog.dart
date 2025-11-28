import 'package:flutter/material.dart';

class CancelConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const CancelConfirmationDialog({Key? key, required this.onConfirm})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text(
        'Cancel Appointment',
        style: TextStyle(
          color: Color(0xFF4B5320),
          fontFamily: 'Mallanna',
          fontWeight: FontWeight.bold,
        ),
      ),
      content: const Text(
        'Are you sure you want to cancel this appointment?',
        style: TextStyle(fontFamily: 'Mallanna'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'No',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
            onConfirm();
          },
          child: const Text(
            'Yes, Cancel',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
