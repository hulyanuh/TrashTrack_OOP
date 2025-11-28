import 'package:flutter/material.dart';

class InfoSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const InfoSection({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4B5320),
            fontFamily: 'Mallanna',
          ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String content;

  const InfoRow({super.key, required this.label, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Mallanna',
              ),
            ),
          ),
          Expanded(
            child: Text(
              content,
              style: const TextStyle(fontSize: 14, fontFamily: 'Mallanna', fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
