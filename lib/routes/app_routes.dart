import 'package:flutter/material.dart';
import '../presentation/views/home/home_screen.dart';
import '../presentation/views/contact_detail/contact_detail_screen.dart';
import '../presentation/views/add_edit_contact/add_edit_contact_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String contactDetail = '/contact-detail';
  static const String addContact = '/add-contact';
  static const String editContact = '/edit-contact';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case contactDetail:
        final args = settings.arguments as Map<String, dynamic>;
        final contactId = args['contactId'] as String;
        final heroTagPrefix = args['heroTagPrefix'] as String? ?? 'contacts_list_avatar_';
        return MaterialPageRoute(
          builder: (_) => ContactDetailScreen(
            contactId: contactId,
            heroTagPrefix: heroTagPrefix,
          ),
        );
      case addContact:
        return MaterialPageRoute(
          builder: (_) => const AddEditContactScreen(),
        );
      case editContact:
        final contactId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => AddEditContactScreen(contactId: contactId),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
} 