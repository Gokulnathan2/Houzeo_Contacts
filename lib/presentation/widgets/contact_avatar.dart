import 'package:flutter/material.dart';
import '../../domain/entities/contact.dart';

class ContactAvatar extends StatelessWidget {
  final Contact contact;
  final double radius;

  const ContactAvatar({
    Key? key,
    required this.contact,
    this.radius = 32,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (contact.profileImage != null) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: AssetImage(contact.profileImage!),
        onBackgroundImageError: (_, __) {
          // Handle image loading error
        },
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Text(
        contact.initials,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: radius * 0.8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
} 