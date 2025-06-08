import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/contacts_viewmodel.dart';
import '../contacts/widgets/contact_list_item.dart';
import '../../../routes/app_routes.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContactsViewModel>().loadContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Enhanced SliverAppBar with attractive design
          SliverAppBar.medium(
            expandedHeight: 180,
            pinned: true,
            floating: true,
            snap: true,
            backgroundColor: colorScheme.surface,
            surfaceTintColor: colorScheme.surfaceTint,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Favorites',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primaryContainer.withOpacity(0.15),
                      colorScheme.errorContainer.withOpacity(0.1),
                      colorScheme.tertiaryContainer.withOpacity(0.1),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
                child: Stack(
                  children: [
                    // Subtle pattern overlay
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _PatternPainter(
                          color: colorScheme.primary.withOpacity(0.03),
                        ),
                      ),
                    ),
                    // Main favorite heart icon
                    Positioned(
                      top: 50,
                      right: 20,
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme.errorContainer.withOpacity(0.2),
                          border: Border.all(
                            color: colorScheme.error.withOpacity(0.2),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.favorite_rounded,
                          size: 36,
                          color: colorScheme.error.withOpacity(0.6),
                        ),
                      ).animate()
                        .fadeIn(duration: 800.ms)
                        .scale(begin: const Offset(0.7, 0.7))
                        .then()
                        .shimmer(duration: 2500.ms, delay: 1200.ms),
                    ),
                    // Floating decorative elements
                    Positioned(
                      top: 35,
                      left: 80,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme.error.withOpacity(0.3),
                        ),
                        child: Icon(
                          Icons.favorite,
                          size: 10,
                          color: colorScheme.error.withOpacity(0.8),
                        ),
                      ).animate()
                        .fadeIn(duration: 600.ms, delay: 300.ms)
                        .scale(begin: const Offset(0.3, 0.3))
                        .then(delay: 1500.ms)
                        .animate(onPlay: (controller) => controller.repeat())
                        .scaleXY(end: 1.2, duration: 1000.ms)
                        .then()
                        .scaleXY(end: 1.0, duration: 1000.ms),
                    ),
                    Positioned(
                      top: 70,
                      left: 120,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme.error.withOpacity(0.25),
                        ),
                        child: Icon(
                          Icons.favorite,
                          size: 8,
                          color: colorScheme.error.withOpacity(0.7),
                        ),
                      ).animate()
                        .fadeIn(duration: 700.ms, delay: 500.ms)
                        .scale(begin: const Offset(0.2, 0.2)),
                    ),
                    Positioned(
                      bottom: 90,
                      left: 30,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme.primary.withOpacity(0.15),
                          border: Border.all(
                            color: colorScheme.primary.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.star_rounded,
                          size: 12,
                          color: colorScheme.primary.withOpacity(0.6),
                        ),
                      ).animate()
                        .fadeIn(duration: 600.ms, delay: 700.ms)
                        .scale(begin: const Offset(0.4, 0.4)),
                    ),
                    Positioned(
                      bottom: 70,
                      right: 60,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme.tertiary.withOpacity(0.2),
                        ),
                        child: Icon(
                          Icons.circle,
                          size: 8,
                          color: colorScheme.tertiary.withOpacity(0.5),
                        ),
                      ).animate()
                        .fadeIn(duration: 500.ms, delay: 900.ms)
                        .scale(begin: const Offset(0.1, 0.1)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Favorites Statistics Card
          Consumer<ContactsViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isLoading) {
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              }
              
              final favoriteCount = viewModel.favoriteContacts.length;
              
              if (favoriteCount == 0) {
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              }
              
              return SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: colorScheme.error.withOpacity(0.2),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.error.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.errorContainer.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.favorite_rounded,
                          color: colorScheme.error,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$favoriteCount Favorite${favoriteCount == 1 ? '' : 's'}',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: colorScheme.error,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Your most important contacts',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate()
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.2, duration: 600.ms),
              );
            },
          ),

          Consumer<ContactsViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isLoading) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          strokeWidth: 3,
                          color: colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Loading favorites...',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            FilledButton.icon(
                              onPressed: () => viewModel.loadContacts(),
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

              final favoriteContacts = viewModel.favoriteContacts;

              if (favoriteContacts.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: colorScheme.errorContainer.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colorScheme.error.withOpacity(0.2),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.favorite_border_rounded,
                            size: 64,
                            color: colorScheme.error.withOpacity(0.7),
                          ),
                        ).animate()
                          .scale(duration: 600.ms, curve: Curves.elasticOut)
                          .then()
                          .shimmer(duration: 1800.ms),
                        const SizedBox(height: 32),
                        Text(
                          'No favorite contacts yet',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Tap the heart icon on any contact\nto add them to your favorites',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        // const SizedBox(height: 32),
                        // FilledButton.icon(
                        //   onPressed: () {
                        //     Navigator.pop(context); // Go back to contacts
                        //   },
                        //   icon: const Icon(Icons.contacts_rounded),
                        //   label: const Text('Browse Contacts'),
                        //   style: FilledButton.styleFrom(
                        //     backgroundColor: colorScheme.error,
                        //     foregroundColor: colorScheme.onError,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final contact = favoriteContacts[index];
                      return ContactListItem(
                        contact: contact,
                        index: index,
                        heroTagPrefix: 'favorites_list_avatar_',
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.contactDetail,
                            arguments: {
                              'contactId': contact.id,
                              'heroTagPrefix': 'favorites_list_avatar_',
                            },
                          );
                        },
                        onFavoriteToggle: () {
                          viewModel.toggleFavorite(contact.id);
                        },
                        onDelete: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              icon: Icon(
                                Icons.delete_outline_rounded,
                                color: colorScheme.error,
                                size: 32,
                              ),
                              title: const Text('Delete Contact'),
                              content: Text(
                                'Are you sure you want to delete this contact? This action cannot be undone.',
                                style: TextStyle(color: colorScheme.onSurfaceVariant),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                FilledButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    viewModel.deleteContact(contact.id);
                                  },
                                  style: FilledButton.styleFrom(
                                    backgroundColor: colorScheme.error,
                                    foregroundColor: colorScheme.onError,
                                  ),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    childCount: favoriteContacts.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PatternPainter extends CustomPainter {
  final Color color;

  _PatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    const spacing = 35.0;
    
    // Draw diagonal lines pattern
    for (double i = -size.height; i < size.width + size.height; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}