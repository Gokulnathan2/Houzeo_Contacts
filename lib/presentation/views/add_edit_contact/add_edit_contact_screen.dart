import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/add_edit_contact_viewmodel.dart';
import '../../viewmodels/contacts_viewmodel.dart';

class AddEditContactScreen extends StatefulWidget {
  final String? contactId;

  const AddEditContactScreen({super.key, this.contactId});

  @override
  State<AddEditContactScreen> createState() => _AddEditContactScreenState();
}

class _AddEditContactScreenState extends State<AddEditContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.contactId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final viewModel = context.read<AddEditContactViewModel>();
        viewModel.loadContact(widget.contactId!).then((_) {
          if (viewModel.contact != null) {
            _firstNameController.text = viewModel.firstName;
            _lastNameController.text = viewModel.lastName;
            _phoneController.text = viewModel.phoneNumber ?? '';
            _emailController.text = viewModel.email ?? '';
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.contactId != null;
    final colorScheme = Theme.of(context).colorScheme;

    return WillPopScope(
      onWillPop: () async {
        context.read<ContactsViewModel>().loadContacts();
        return true;
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            // Enhanced SliverAppBar matching ContactDetailScreen
            SliverAppBar.large(
              expandedHeight: 130,
              pinned: true,
              floating: true,
              snap: true,
              backgroundColor: colorScheme.surface,
              surfaceTintColor: colorScheme.surfaceTint,

              // actionsPadding: const EdgeInsets.all(9),
              leading: Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  width: 150,
                  height: 150,
                  //  margin: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withOpacity(0.95),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: colorScheme.onSurface,
                      ),
                      onPressed: () {
                        context.read<ContactsViewModel>().loadContacts();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  isEdit ? 'Edit Contact' : 'Add Contact',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.5,
                    fontSize: 18,
                  ),
                ),
                titlePadding:
                    const EdgeInsets.only(left: 16, bottom: 16, right: 16),
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
                      // Decorative floating elements
                      Positioned(
                        top: 60,
                        right: 80,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorScheme.primary.withOpacity(0.08),
                            border: Border.all(
                              color: colorScheme.primary.withOpacity(0.15),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            isEdit
                                ? Icons.edit_rounded
                                : Icons.person_add_rounded,
                            size: 24,
                            color: colorScheme.primary.withOpacity(0.4),
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 800.ms)
                            .scale(begin: const Offset(0.7, 0.7))
                            .then()
                            .shimmer(duration: 2000.ms, delay: 1200.ms),
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
                      Positioned(
                        bottom: 100,
                        left: 60,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorScheme.secondary.withOpacity(0.12),
                          ),
                          child: Icon(
                            Icons.save_rounded,
                            size: 16,
                            color: colorScheme.secondary.withOpacity(0.5),
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 700.ms, delay: 500.ms)
                            .scale(begin: const Offset(0.3, 0.3)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Content
            Consumer<AddEditContactViewModel>(
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
                        elevation: 0,
                        color: colorScheme.surfaceVariant.withOpacity(0.3),
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
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
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
                                    viewModel.loadContact(widget.contactId!),
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

                return SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Avatar placeholder for visual consistency

                      // Form content
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Basic Information Card
                            Card(
                              elevation: 0,
                              color:
                                  colorScheme.surfaceVariant.withOpacity(0.3),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: colorScheme.primary
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Icon(
                                            Icons.person_outline_rounded,
                                            color: colorScheme.primary,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'Basic Information',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                color: colorScheme.primary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    _buildEnhancedInputField(
                                      controller: _firstNameController,
                                      label: 'First Name',
                                      icon: Icons.person_outline_rounded,
                                      onChanged: viewModel.setFirstName,
                                      validator: (value) => value!.isEmpty
                                          ? 'First name required'
                                          : null,
                                      colorScheme: colorScheme,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildEnhancedInputField(
                                      controller: _lastNameController,
                                      label: 'Last Name',
                                      icon: Icons.person_2_outlined,
                                      onChanged: viewModel.setLastName,
                                      validator: (value) => value!.isEmpty
                                          ? 'Last name required'
                                          : null,
                                      colorScheme: colorScheme,
                                    ),
                                  ],
                                ),
                              ),
                            )
                                .animate()
                                .fadeIn(duration: 300.ms)
                                .slideY(begin: 0.2, end: 0),
                            const SizedBox(height: 16),

                            // Contact Information Card
                            Card(
                              elevation: 0,
                              color:
                                  colorScheme.surfaceVariant.withOpacity(0.3),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: colorScheme.secondary
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Icon(
                                            Icons.contact_phone_rounded,
                                            color: colorScheme.secondary,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'Contact Information',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                color: colorScheme.secondary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    _buildEnhancedInputField(
                                      controller: _phoneController,
                                      label: 'Phone Number',
                                      icon: Icons.phone_outlined,
                                      inputType: TextInputType.phone,
                                      onChanged: viewModel.setPhoneNumber,
                                      colorScheme: colorScheme,
                                      isOptional: true,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildEnhancedInputField(
                                      controller: _emailController,
                                      label: 'Email Address',
                                      icon: Icons.email_outlined,
                                      inputType: TextInputType.emailAddress,
                                      onChanged: viewModel.setEmail,
                                      colorScheme: colorScheme,
                                      isOptional: true,
                                      validator: (value) {
                                        if (value == null || value.isEmpty)
                                          return null;
                                        if (!value.contains('@'))
                                          return 'Invalid email address';
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            )
                                .animate()
                                .fadeIn(duration: 300.ms, delay: 100.ms)
                                .slideY(begin: 0.2, end: 0),
                            const SizedBox(height: 32),

                            // Save Button
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    colorScheme.primaryContainer
                                        .withOpacity(0.3),
                                    colorScheme.primary.withOpacity(0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: FilledButton.icon(
                                style: FilledButton.styleFrom(
                                  backgroundColor: colorScheme.primary,
                                  foregroundColor: colorScheme.onPrimary,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                icon: Icon(
                                  isEdit
                                      ? Icons.save_rounded
                                      : Icons.person_add_rounded,
                                  size: 20,
                                ),
                                label: Text(
                                  isEdit ? 'Update Contact' : 'Save Contact',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    final success =
                                        await viewModel.saveContact();
                                    if (success && mounted) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        context
                                            .read<ContactsViewModel>()
                                            .loadContacts();
                                      });

                                      // context.read<ContactsViewModel>().loadContacts();
                                      Navigator.pop(context);
                                    }
                                  }
                                },
                              ),
                            )
                                .animate()
                                .fadeIn(duration: 300.ms, delay: 200.ms)
                                .slideY(begin: 0.2, end: 0)
                                .then()
                                .shimmer(duration: 2000.ms, delay: 1000.ms),
                          ],
                        ),
                      ),
                    ]),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required ValueChanged<String> onChanged,
    required ColorScheme colorScheme,
    TextInputType inputType = TextInputType.text,
    String? Function(String?)? validator,
    bool isOptional = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        validator: validator,
        onChanged: onChanged,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
          helperText: isOptional ? 'Optional' : null,
          helperStyle: TextStyle(
            color: colorScheme.onSurfaceVariant.withOpacity(0.7),
            fontSize: 12,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: colorScheme.primary,
              size: 20,
            ),
          ),
          filled: true,
          fillColor: colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: colorScheme.outline.withOpacity(0.3),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: colorScheme.outline.withOpacity(0.3),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: colorScheme.primary,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: colorScheme.error,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: colorScheme.error,
              width: 2,
            ),
          ),
        ),
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
