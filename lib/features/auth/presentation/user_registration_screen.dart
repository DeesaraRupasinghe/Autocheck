import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/providers/auth_provider.dart';

/// Normal user registration screen
class UserRegistrationScreen extends ConsumerStatefulWidget {
  final User? firebaseUser;

  const UserRegistrationScreen({super.key, this.firebaseUser});

  @override
  ConsumerState<UserRegistrationScreen> createState() =>
      _UserRegistrationScreenState();
}

class _UserRegistrationScreenState
    extends ConsumerState<UserRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedLanguage = 'en';
  bool _isLoading = false;
  String? _errorMessage;

  final List<Map<String, String>> _languages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'si', 'name': 'සිංහල (Sinhala)'},
    {'code': 'ta', 'name': 'தமிழ் (Tamil)'},
  ];

  @override
  void initState() {
    super.initState();
    // Pre-fill from Google Sign-In
    if (widget.firebaseUser != null) {
      _nameController.text = widget.firebaseUser!.displayName ?? '';
      _emailController.text = widget.firebaseUser!.email ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _completeRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final uid = widget.firebaseUser?.uid ?? 
          ref.read(currentUserProvider)?.uid;
      
      if (uid == null) {
        setState(() {
          _errorMessage = 'User session expired. Please sign in again.';
          _isLoading = false;
        });
        return;
      }

      final result = await ref.read(authServiceProvider).completeUserRegistration(
        uid: uid,
        displayName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        preferredLanguage: _selectedLanguage,
      );

      if (!mounted) return;

      if (result.isSuccess) {
        context.go('/home');
      } else {
        setState(() {
          _errorMessage = result.errorMessage ?? 'Registration failed';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Text(
                  'Tell us about yourself',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'We need a few details to set up your account',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 32),

                // Error message
                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red.shade700),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Full Name
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Full Name *',
                    hintText: 'Enter your full name',
                    prefixIcon: Icon(Icons.person_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    if (value.trim().length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  enabled: widget.firebaseUser?.email == null,
                  decoration: InputDecoration(
                    labelText: 'Email *',
                    hintText: 'Enter your email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    suffixIcon: widget.firebaseUser?.email != null
                        ? const Icon(Icons.verified, color: Colors.green)
                        : null,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Phone Number
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number *',
                    hintText: 'e.g., 077 123 4567',
                    prefixIcon: Icon(Icons.phone_outlined),
                    prefixText: '+94 ',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your phone number';
                    }
                    // Sri Lanka phone number validation
                    final cleanNumber = value.replaceAll(RegExp(r'[\s-]'), '');
                    if (cleanNumber.length < 9 || cleanNumber.length > 10) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Language Selection
                Text(
                  'Preferred Language',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 12),
                ...(_languages.map((lang) => RadioListTile<String>(
                      title: Text(lang['name']!),
                      value: lang['code']!,
                      groupValue: _selectedLanguage,
                      onChanged: (value) {
                        setState(() {
                          _selectedLanguage = value!;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ))),

                const SizedBox(height: 32),

                // Submit button
                PrimaryButton(
                  text: 'Complete Registration',
                  onPressed: _isLoading ? null : _completeRegistration,
                  isLoading: _isLoading,
                  icon: Icons.check,
                ),

                const SizedBox(height: 16),

                // Terms notice
                Text(
                  'By completing registration, you agree to our Terms of Service and Privacy Policy',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
