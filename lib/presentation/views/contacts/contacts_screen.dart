import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/contacts_viewmodel.dart';
import 'widgets/contact_list_item.dart';
import '../../../routes/app_routes.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final _searchController = SearchController();
  final _scrollController = ScrollController();
  bool _isSearchVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContactsViewModel>().loadContacts();
    });
    
    _scrollController.addListener(() {
      // Hide search bar when scrolling down, show when scrolling up
      if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if (_isSearchVisible) {
          setState(() => _isSearchVisible = false);
        }
      } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
        if (!_isSearchVisible) {
          setState(() => _isSearchVisible = true);
        }
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Enhanced SliverAppBar with attractive design
          //           SliverPersistentHeader(
          //   pinned: true,
            
          //   delegate: _SearchBarDelegate(
          //     searchController: _searchController,
          //     onChanged: (query) {
          //       context.read<ContactsViewModel>().setSearchQuery(query);
          //     },
          //   ),
          // ),
          SliverAppBar.medium(
            expandedHeight: 150,
            pinned: true,
            floating: true,
            snap: true,
            backgroundColor: colorScheme.surface,
            surfaceTintColor: colorScheme.surfaceTint,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Contacts',
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
                      colorScheme.primaryContainer.withOpacity(0.1),
                      colorScheme.secondaryContainer.withOpacity(0.1),
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
                          color: colorScheme.primary.withOpacity(0.02),
                        ),
                      ),
                    ),
                    // Floating elements for visual interest
                    Positioned(
                      top: 60,
                      right: 20,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme.primary.withOpacity(0.05),
                          border: Border.all(
                            color: colorScheme.primary.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.contacts_rounded,
                          size: 32,
                          color: colorScheme.primary.withOpacity(0.3),
                        ),
                      ).animate()
                        .fadeIn(duration: 800.ms)
                        .scale(begin: const Offset(0.8, 0.8))
                        .then()
                        .shimmer(duration: 2000.ms, delay: 1000.ms),
                    ),
                    Positioned(
                      top: 40,
                      left: 100,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme.tertiary.withOpacity(0.1),
                        ),
                      ).animate()
                        .fadeIn(duration: 600.ms, delay: 200.ms)
                        .scale(begin: const Offset(0.5, 0.5)),
                    ),
                    Positioned(
                      bottom: 80,
                      left: 40,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme.secondary.withOpacity(0.15),
                        ),
                      ).animate()
                        .fadeIn(duration: 700.ms, delay: 400.ms)
                        .scale(begin: const Offset(0.3, 0.3)),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              // Consumer<ContactsViewModel>(
              //   builder: (context, viewModel, child) {
              //     return Badge(
              //       label: Text('${viewModel.contacts.length}'),
              //       isLabelVisible: viewModel.contacts.isNotEmpty,
              //       child: IconButton(
              //         icon: const Icon(Icons.search_rounded),
              //         onPressed: () {
              //           _searchController.openView();
              //         },
              //         tooltip: 'Search contacts',
              //       ),
              //     );
              //   },
              // ),
              // PopupMenuButton<String>(
              //   icon: const Icon(Icons.more_vert_rounded),
              //   tooltip: 'More options',
              //   onSelected: (value) {
              //     // Handle menu selections
              //     switch (value) {
              //       case 'sort':
              //         _showSortOptions(context);
              //         break;
              //       case 'import':
              //         // Handle import
              //         break;
              //       case 'export':
              //         // Handle export
              //         break;
              //     }
              //   },
              //   itemBuilder: (context) => [
              //     const PopupMenuItem(
              //       value: 'sort',
              //       child: Row(
              //         children: [
              //           Icon(Icons.sort_rounded),
              //           SizedBox(width: 8),
              //           Text('Sort contacts'),
              //         ],
              //       ),
              //     ),
              //     const PopupMenuItem(
              //       value: 'import',
              //       child: Row(
              //         children: [
              //           Icon(Icons.file_upload_rounded),
              //           SizedBox(width: 8),
              //           Text('Import contacts'),
              //         ],
              //       ),
              //     ),
              //     const PopupMenuItem(
              //       value: 'export',
              //       child: Row(
              //         children: [
              //           Icon(Icons.file_download_rounded),
              //           SizedBox(width: 8),
              //           Text('Export contacts'),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(width: 8),
            ],
          ),
          
          // Enhanced Search Bar with smooth animations
          // SliverPersistentHeader(
          //   pinned: true,
          //   delegate: _SearchBarDelegate(
          //     searchController: _searchController,
          //     onChanged: (query) {
          //       context.read<ContactsViewModel>().setSearchQuery(query);
          //     },
          //     isVisible: true,
          //   ),
          // ),
          SliverPersistentHeader(
  pinned: true,
  delegate: _SearchBarDelegate(
    //  key: ValueKey(Theme.of(context).brightness), // <– triggers rebuild on theme change
    searchController: _searchController,
    onChanged: (query) {
      context.read<ContactsViewModel>().setSearchQuery(query);
    },
    isVisible: true,
    theme: Theme.of(context),
  ),
),

          // Contact Statistics Card
          Consumer<ContactsViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.contacts.isEmpty || viewModel.isLoading) {
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              }
              
              final favoriteCount = viewModel.favoriteContacts.length;
              final totalCount = viewModel.contacts.length;
              
              return SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _StatItem(
                          icon: Icons.contacts_rounded,
                          label: 'Total',
                          value: totalCount.toString(),
                          color: colorScheme.primary,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: colorScheme.outline.withOpacity(0.2),
                      ),
                      Expanded(
                        child: _StatItem(
                          icon: Icons.favorite_rounded,
                          label: 'Favorites',
                          value: favoriteCount.toString(),
                          color: colorScheme.error,
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
          
          // Main Content
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
                          color: colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Loading contacts...',
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

              if (viewModel.contacts.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.contacts_outlined,
                            size: 64,
                            color: colorScheme.primary,
                          ),
                        ).animate()
                          .scale(duration: 600.ms, curve: Curves.elasticOut)
                          .then()
                          .shimmer(duration: 1800.ms),
                        const SizedBox(height: 24),
                        Text(
                          'No contacts yet',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap the + button to add your first contact',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        FilledButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.addContact);
                          },
                          icon: const Icon(Icons.add_rounded),
                          label: const Text('Add Contact'),
                        ),
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
                      final contact = viewModel.contacts[index];
                      return ContactListItem(
                        contact: contact,
                        index: index,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.contactDetail,
                            arguments: {
                              'contactId': contact.id,
                              'heroTagPrefix': 'contacts_list_avatar_',
                            },
                          );
                        },
                        onFavoriteToggle: () {
                          viewModel.toggleFavorite(contact.id);
                        },
                        onDelete: () {
                          viewModel.deleteContact(contact.id);
                        },
                      );
                    },
                    childCount: viewModel.contacts.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Sort contacts by',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.sort_by_alpha_rounded),
              title: const Text('Name (A-Z)'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.access_time_rounded),
              title: const Text('Recently added'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.favorite_rounded),
              title: const Text('Favorites first'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final SearchController searchController;
  final ValueChanged<String> onChanged;
  final bool isVisible;
  final ThemeData theme;

  _SearchBarDelegate({
    required this.searchController,
    required this.onChanged,
    required this.isVisible,
    required this.theme,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final colorScheme = theme.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      transform: Matrix4.translationValues(0, isVisible ? 0 : -56, 0),
      child: Container(
        height: 56,
        color: colorScheme.surface,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: SearchBar(
          controller: searchController,
          hintText: 'Search contacts...',
          hintStyle: MaterialStatePropertyAll(
            TextStyle(color: colorScheme.onSurfaceVariant),
          ),
          leading: Icon(
            Icons.search_rounded,
            color: colorScheme.onSurfaceVariant,
          ),
          trailing: [
            if (searchController.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear_rounded),
                onPressed: () {
                  searchController.clear();
                  onChanged('');
                },
              ),
          ],
          onChanged: onChanged,
          backgroundColor: MaterialStatePropertyAll(
            colorScheme.surfaceVariant.withOpacity(0.5),
          ),
          elevation: const MaterialStatePropertyAll(0),
          side: MaterialStatePropertyAll(
            BorderSide(
              color: colorScheme.outline.withOpacity(0.2),
            ),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 56;

  @override
  double get minExtent => 56;

  @override
  bool shouldRebuild(covariant _SearchBarDelegate oldDelegate) {
    return searchController != oldDelegate.searchController ||
           isVisible != oldDelegate.isVisible ||
           theme.brightness != oldDelegate.theme.brightness;
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

    const spacing = 30.0;
    
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