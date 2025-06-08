import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this dependency to pubspec.yaml
import '../../viewmodels/contact_detail_viewmodel.dart';
import '../../viewmodels/contacts_viewmodel.dart';
import '../../../routes/app_routes.dart';

class ContactDetailScreen extends StatefulWidget {
  final String contactId;
  final String heroTagPrefix;

  const ContactDetailScreen({
    super.key,
    required this.contactId,
    this.heroTagPrefix = 'contacts_list_avatar_',
  });

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  @override
  void initState() {
    super.initState();
    _loadContact();
  }

  void _loadContact() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContactDetailViewModel>().loadContact(widget.contactId);
    });
  }

  // Function to handle phone dialing
  // Future<void> _makePhoneCall(String phoneNumber) async {
  //   final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
  //   try {
  //     if (await canLaunchUrl(phoneUri)) {
  //       await launchUrl(phoneUri);
  //     } else {
  //       if (mounted) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //             content: Text('Could not launch phone dialer'),
  //             behavior: SnackBarBehavior.floating,
  //           ),
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Error: ${e.toString()}'),
  //           behavior: SnackBarBehavior.floating,
  //         ),
  //       );
  //     }
  //   }
  // }

  // Function to handle email
  Future<void> _sendEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not launch email client'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

// Alternative simple approach - replace the _makePhoneCall method with this:
  Future<void> _makePhoneCall(String phoneNumber) async {
    try {
      // Clean the phone number by removing all non-digit characters except '+'
      final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

      // Use flutter_phone_direct_caller package
      bool? res = await FlutterPhoneDirectCaller.callNumber(cleanNumber);

      if (res != true) {
        // If direct call fails, fall back to the launchUrl method
        final Uri phoneUri = Uri(scheme: 'tel', path: cleanNumber);
        if (await canLaunchUrl(phoneUri)) {
          await launchUrl(phoneUri);
        } else {
          _showManualDialOption(phoneNumber, cleanNumber);
        }
      }
    } catch (e) {
      print('e$e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

// Future<void> _makePhoneCall(String phoneNumber) async {
//   // Clean phone number
//   final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

//   try {
//     // Try different approaches in order
//     final approaches = [
//       () async {
//         // Approach 1: Standard tel: with external app mode
//         final uri = Uri.parse('tel:$cleanNumber');
//         await launchUrl(uri, mode: LaunchMode.externalApplication);
//       },
//       () async {
//         // Approach 2: Using Intent action (Android-style)
//         final uri = Uri.parse('intent://dial/$cleanNumber#Intent;scheme=tel;package=com.android.phone;end');
//         await launchUrl(uri, mode: LaunchMode.externalApplication);
//       },
//       () async {
//         // Approach 3: Direct dialer package
//         final uri = Uri.parse('package:com.android.phone');
//         await launchUrl(uri, mode: LaunchMode.externalApplication);
//       },
//     ];

//     // Try each approach
//     for (int i = 0; i < approaches.length; i++) {
//       try {
//         await approaches[i]();
//         return; // Success, exit
//       } catch (e) {
//         print('Approach ${i + 1} failed: $e');
//         if (i == approaches.length - 1) {
//           // Last approach failed, show fallback
//           _showManualDialOption(phoneNumber, cleanNumber);
//         }
//       }
//     }

//   } catch (e) {
//     print('All approaches failed: $e');
//     _showManualDialOption(phoneNumber, cleanNumber);
//   }
// }

  void _showManualDialOption(String originalNumber, String cleanNumber) {
    if (!mounted) return;

    // Copy to clipboard
    Clipboard.setData(ClipboardData(text: cleanNumber));

    // Show snackbar with manual option
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.phone, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text('Call $cleanNumber (copied to clipboard)'),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'OPEN DIALER',
          textColor: Colors.white,
          onPressed: () async {
            // Try to open the default dialer app
            try {
              final dialerUri = Uri.parse('tel:');
              if (await canLaunchUrl(dialerUri)) {
                await launchUrl(dialerUri,
                    mode: LaunchMode.externalApplication);
              }
            } catch (e) {
              // If that fails, just show a message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Please open your dialer manually and paste the number'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          Consumer<ContactDetailViewModel>(
            builder: (context, viewModel, child) {
              final contact = viewModel.contact;
              final contactName = contact?.fullName ?? 'Contact Details';

              return SliverAppBar.medium(
                expandedHeight: 140,
                pinned: true,
                floating: true,
                snap: true,
                backgroundColor: colorScheme.surface,
                surfaceTintColor: colorScheme.surfaceTint,
                // Fixed leading button with proper elevation
                leading: Padding(
                  padding: const EdgeInsets.only(left: 4.0, top: 8.0),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: colorScheme.surface
                          .withOpacity(0.95), // Increased opacity
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color:
                              Colors.black.withOpacity(0.2), // Increased shadow
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      // Added Material wrapper for better touch feedback
                      color: Colors.transparent,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_rounded,
                          color: colorScheme.onSurface,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          context.read<ContactsViewModel>().loadContacts();
                        },
                      ),
                    ),
                  ),
                ),
                // Fixed actions with proper elevation and z-index
                actions: [
                  Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: colorScheme.surface
                          .withOpacity(0.95), // Increased opacity
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color:
                              Colors.black.withOpacity(0.2), // Increased shadow
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    // Ensure this container is above other elements
                    child: Material(
                      // Added Material wrapper for better touch feedback
                      color: Colors.transparent,
                      child: IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.edit_rounded,
                            color: colorScheme.primary,
                            size: 18,
                          ),
                        ),
                        onPressed: () async {
                          await Navigator.pushNamed(
                            context,
                            AppRoutes.editContact,
                            arguments: widget.contactId,
                          );
                          if (mounted) {
                            _loadContact();
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    contactName,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5,
                      fontSize: 18,
                    ),
                  ),
                  titlePadding:
                      const EdgeInsets.only(left: 16, bottom: 16, right: 80),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colorScheme.primaryContainer.withOpacity(0.15),
                          colorScheme.secondaryContainer.withOpacity(0.1),
                          colorScheme.tertiaryContainer.withOpacity(0.08),
                        ],
                        stops: const [0.0, 0.6, 1.0],
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Subtle pattern overlay
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _ContactPatternPainter(
                              color: colorScheme.primary.withOpacity(0.03),
                            ),
                          ),
                        ),
                        // Dynamic floating elements based on contact data
                        // Reduced z-index to ensure buttons are clickable
                        if (contact != null) ...[
                          // Phone icon if contact has phone
                          if (contact.phoneNumber?.isNotEmpty == true)
                            Positioned(
                              top: 50,
                              right: 80, // Moved left to avoid edit button
                              child: Container(
                                width: 50, // Reduced size
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colorScheme.primary.withOpacity(0.08),
                                  border: Border.all(
                                    color:
                                        colorScheme.primary.withOpacity(0.15),
                                    width: 1,
                                  ),
                                ),
                                child: Icon(
                                  Icons.phone_rounded,
                                  size: 20, // Reduced size
                                  color: colorScheme.primary.withOpacity(0.4),
                                ),
                              )
                                  .animate()
                                  .fadeIn(duration: 800.ms)
                                  .scale(begin: const Offset(0.7, 0.7))
                                  .then()
                                  .shimmer(duration: 2000.ms, delay: 1200.ms),
                            ),
                          // Email icon if contact has email
                          if (contact.email?.isNotEmpty == true)
                            Positioned(
                              top: 70,
                              left: 120,
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      colorScheme.secondary.withOpacity(0.12),
                                ),
                                child: Icon(
                                  Icons.email_rounded,
                                  size: 18,
                                  color: colorScheme.secondary.withOpacity(0.5),
                                ),
                              )
                                  .animate()
                                  .fadeIn(duration: 600.ms, delay: 300.ms)
                                  .scale(begin: const Offset(0.4, 0.4)),
                            ),
                          // Favorite star if contact is favorite
                          if (contact.isFavorite)
                            Positioned(
                              bottom: 90,
                              left: 50,
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colorScheme.error.withOpacity(0.15),
                                ),
                                child: Icon(
                                  Icons.favorite_rounded,
                                  size: 16,
                                  color: colorScheme.error.withOpacity(0.6),
                                ),
                              )
                                  .animate()
                                  .fadeIn(duration: 700.ms, delay: 500.ms)
                                  .scale(begin: const Offset(0.3, 0.3))
                                  .then()
                                  .shimmer(duration: 1500.ms, delay: 800.ms),
                            ),
                        ],
                        // Default decorative elements if no contact loaded
                        if (contact == null) ...[
                          Positioned(
                            top: 60,
                            right: 80, // Moved to avoid edit button
                            child: Container(
                              width: 60, // Reduced size
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colorScheme.primary.withOpacity(0.06),
                                border: Border.all(
                                  color: colorScheme.primary.withOpacity(0.12),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                Icons.person_rounded,
                                size: 24, // Reduced size
                                color: colorScheme.primary.withOpacity(0.3),
                              ),
                            )
                                .animate()
                                .fadeIn(duration: 800.ms)
                                .scale(begin: const Offset(0.8, 0.8)),
                          ),
                          Positioned(
                            top: 45,
                            left: 100,
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colorScheme.tertiary.withOpacity(0.1),
                              ),
                            )
                                .animate()
                                .fadeIn(duration: 600.ms, delay: 200.ms)
                                .scale(begin: const Offset(0.5, 0.5)),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Consumer<ContactDetailViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isLoading) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          strokeWidth: 3,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Loading contact...',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (viewModel.errorMessage != null) {
                return SliverFillRemaining(
                  child: Center(
                    child: Card(
                      margin: const EdgeInsets.all(16),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: colorScheme.errorContainer,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.error_outline_rounded,
                                size: 32,
                                color: colorScheme.error,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Something went wrong',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              viewModel.errorMessage!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            FilledButton.icon(
                              onPressed: () =>
                                  viewModel.loadContact(widget.contactId),
                              icon: const Icon(Icons.refresh_rounded),
                              label: const Text('Try again'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }

              final contact = viewModel.contact;
              if (contact == null) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: colorScheme.errorContainer.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person_off_outlined,
                            size: 48,
                            color: colorScheme.error,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Contact not found',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Center(
                      child: Hero(
                        tag: '${widget.heroTagPrefix}${contact.id}',
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.primary.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 64,
                            backgroundColor: colorScheme.primaryContainer,
                            child: Text(
                              contact.initials,
                              style: TextStyle(
                                fontSize: 32,
                                color: colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                        .animate()
                        .scale(duration: 600.ms, curve: Curves.elasticOut)
                        .then()
                        .shimmer(duration: 1800.ms),
                    const SizedBox(height: 32),
                    Card(
                      elevation: 0,
                      color: colorScheme.surfaceVariant.withOpacity(0.3),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.person_outline_rounded,
                                color: colorScheme.primary,
                                size: 20,
                              ),
                            ),
                            title: const Text('Name'),
                            subtitle: Text(
                              contact.fullName,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                          if (contact.phoneNumber?.isNotEmpty == true)
                            ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: colorScheme.secondary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.phone_outlined,
                                  color: colorScheme.secondary,
                                  size: 20,
                                ),
                              ),
                              title: const Text('Phone'),
                              subtitle: Text(
                                contact.phoneNumber!,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              trailing: Container(
                                decoration: BoxDecoration(
                                  color: colorScheme.secondary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.phone_rounded,
                                    color: colorScheme.secondary,
                                  ),
                                  onPressed: () =>
                                      _makePhoneCall(contact.phoneNumber!),
                                  tooltip: 'Call ${contact.phoneNumber}',
                                ),
                              ),
                            ),
                          if (contact.email?.isNotEmpty == true)
                            ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: colorScheme.tertiary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.email_outlined,
                                  color: colorScheme.tertiary,
                                  size: 20,
                                ),
                              ),
                              title: const Text('Email'),
                              subtitle: Text(
                                contact.email!,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              trailing: Container(
                                decoration: BoxDecoration(
                                  color: colorScheme.tertiary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.email_rounded,
                                    color: colorScheme.tertiary,
                                  ),
                                  onPressed: () => _sendEmail(contact.email!),
                                  tooltip: 'Email ${contact.email}',
                                ),
                              ),
                            ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 300.ms)
                        .slideY(begin: 0.2, end: 0),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 0,
                      color: colorScheme.surfaceVariant.withOpacity(0.3),
                      child: SwitchListTile(
                        secondary: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colorScheme.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            contact.isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_outline_rounded,
                            color: colorScheme.error,
                            size: 20,
                          ),
                        ),
                        title: const Text('Favorite'),
                        subtitle: Text(
                          contact.isFavorite
                              ? 'This contact is marked as favorite'
                              : 'Mark as favorite',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                        ),
                        value: contact.isFavorite,
                        onChanged: (_) => viewModel.toggleFavorite(),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 300.ms, delay: 100.ms)
                        .slideY(begin: 0.2, end: 0),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.errorContainer.withOpacity(0.3),
                            colorScheme.error.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FilledButton.tonal(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: colorScheme.error,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Contact'),
                              content: Text(
                                'Are you sure you want to delete "${contact.fullName}"? This action cannot be undone.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                FilledButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: colorScheme.error,
                                    foregroundColor: colorScheme.onError,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    viewModel.deleteContact();
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      context
                                          .read<ContactsViewModel>()
                                          .loadContacts();
                                    });

                                    Navigator.pop(context);
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete_outline_rounded,
                              color: colorScheme.error,
                            ),
                            const SizedBox(width: 8),
                            const Text('Delete Contact'),
                          ],
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 300.ms, delay: 200.ms)
                        .slideY(begin: 0.2, end: 0),
                  ]),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ContactPatternPainter extends CustomPainter {
  final Color color;

  _ContactPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    const spacing = 25.0;

    // Draw subtle dotted pattern
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
