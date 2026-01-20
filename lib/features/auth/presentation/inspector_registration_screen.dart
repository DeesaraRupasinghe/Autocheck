import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../models/models.dart';

/// Inspector registration screen with full business details
class InspectorRegistrationScreen extends ConsumerStatefulWidget {
  final User? firebaseUser;

  const InspectorRegistrationScreen({super.key, this.firebaseUser});

  @override
  ConsumerState<InspectorRegistrationScreen> createState() =>
      _InspectorRegistrationScreenState();
}

class _InspectorRegistrationScreenState
    extends ConsumerState<InspectorRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  bool _isLoading = false;
  String? _errorMessage;

  // Step 1: Business Info
  final _businessNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  // Step 2: Location
  final _addressController = TextEditingController();
  double _latitude = 6.9271;  // Default: Colombo
  double _longitude = 79.8612;
  double _coverageRadius = 10.0;

  // Step 3: Services
  final List<String> _selectedInspectionTypes = [];
  final _priceFromController = TextEditingController();
  final _priceToController = TextEditingController();
  final _experienceController = TextEditingController();
  final _certificationsController = TextEditingController();

  // Step 4: Availability
  final List<String> _selectedDays = [];
  TimeOfDay _openTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _closeTime = const TimeOfDay(hour: 18, minute: 0);
  String _selectedLanguage = 'en';

  final List<String> _inspectionTypeOptions = [
    'Full Vehicle Inspection',
    'Pre-Purchase Inspection',
    'Engine Diagnostic',
    'Body & Paint Check',
    'Electrical Systems',
    'Suspension & Steering',
    'Brake Inspection',
    'Transmission Check',
    'Hybrid/EV Battery Check',
  ];

  final List<String> _weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  final List<Map<String, String>> _languages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'si', 'name': 'සිංහල (Sinhala)'},
    {'code': 'ta', 'name': 'தமிழ் (Tamil)'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.firebaseUser != null) {
      _ownerNameController.text = widget.firebaseUser!.displayName ?? '';
      _emailController.text = widget.firebaseUser!.email ?? '';
    }
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _ownerNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _priceFromController.dispose();
    _priceToController.dispose();
    _experienceController.dispose();
    _certificationsController.dispose();
    super.dispose();
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _businessNameController.text.trim().isNotEmpty &&
            _ownerNameController.text.trim().isNotEmpty &&
            _emailController.text.trim().isNotEmpty &&
            _phoneController.text.trim().isNotEmpty;
      case 1:
        return _addressController.text.trim().isNotEmpty;
      case 2:
        return _selectedInspectionTypes.isNotEmpty &&
            _priceFromController.text.trim().isNotEmpty &&
            _experienceController.text.trim().isNotEmpty;
      case 3:
        return _selectedDays.isNotEmpty;
      default:
        return false;
    }
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

      final inspectorId = const Uuid().v4();
      
      final certifications = _certificationsController.text.trim().isNotEmpty
          ? _certificationsController.text.split(',').map((e) => e.trim()).toList()
          : <String>[];

      final inspectorProfile = InspectorProfile(
        id: inspectorId,
        userId: uid,
        businessName: _businessNameController.text.trim(),
        ownerName: _ownerNameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        latitude: _latitude,
        longitude: _longitude,
        coverageRadiusKm: _coverageRadius,
        inspectionTypes: _selectedInspectionTypes,
        priceFrom: double.tryParse(_priceFromController.text.trim()) ?? 0,
        priceTo: double.tryParse(_priceToController.text.trim()),
        yearsOfExperience: int.tryParse(_experienceController.text.trim()) ?? 0,
        certifications: certifications.isNotEmpty ? certifications : null,
        availableDays: _selectedDays,
        openTime: '${_openTime.hour.toString().padLeft(2, '0')}:${_openTime.minute.toString().padLeft(2, '0')}',
        closeTime: '${_closeTime.hour.toString().padLeft(2, '0')}:${_closeTime.minute.toString().padLeft(2, '0')}',
        status: InspectorStatus.pendingVerification,
        createdAt: DateTime.now(),
      );

      final result = await ref.read(authServiceProvider).completeInspectorRegistration(
        uid: uid,
        displayName: _ownerNameController.text.trim(),
        email: _emailController.text.trim(),
        inspectorProfile: inspectorProfile,
        preferredLanguage: _selectedLanguage,
      );

      if (!mounted) return;

      if (result.isSuccess) {
        _showSuccessDialog();
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

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.hourglass_empty, size: 48, color: Colors.orange),
        title: const Text('Registration Submitted'),
        content: const Text(
          'Your inspector account is pending verification. '
          'You will be notified once your account is approved. '
          'This usually takes 1-2 business days.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/inspector-dashboard');
            },
            child: const Text('Go to Dashboard'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectTime(bool isOpenTime) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isOpenTime ? _openTime : _closeTime,
    );
    if (picked != null) {
      setState(() {
        if (isOpenTime) {
          _openTime = picked;
        } else {
          _closeTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inspector Registration'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            if (_validateCurrentStep()) {
              if (_currentStep < 3) {
                setState(() => _currentStep++);
              } else {
                _completeRegistration();
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please complete all required fields'),
                ),
              );
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            }
          },
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      text: _currentStep == 3 ? 'Submit' : 'Continue',
                      onPressed: _isLoading ? null : details.onStepContinue,
                      isLoading: _isLoading,
                    ),
                  ),
                  if (_currentStep > 0) ...[
                    const SizedBox(width: 12),
                    SecondaryButton(
                      text: 'Back',
                      onPressed: details.onStepCancel,
                      width: 100,
                    ),
                  ],
                ],
              ),
            );
          },
          steps: [
            // Step 1: Business Info
            Step(
              title: const Text('Business Info'),
              subtitle: const Text('Basic business details'),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
              content: _buildBusinessInfoStep(),
            ),
            // Step 2: Location
            Step(
              title: const Text('Location'),
              subtitle: const Text('Service area'),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
              content: _buildLocationStep(),
            ),
            // Step 3: Services
            Step(
              title: const Text('Services'),
              subtitle: const Text('What you offer'),
              isActive: _currentStep >= 2,
              state: _currentStep > 2 ? StepState.complete : StepState.indexed,
              content: _buildServicesStep(),
            ),
            // Step 4: Availability
            Step(
              title: const Text('Availability'),
              subtitle: const Text('Working hours'),
              isActive: _currentStep >= 3,
              state: _currentStep > 3 ? StepState.complete : StepState.indexed,
              content: _buildAvailabilityStep(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_errorMessage != null)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Text(_errorMessage!, style: TextStyle(color: Colors.red.shade700)),
          ),
        TextFormField(
          controller: _businessNameController,
          decoration: const InputDecoration(
            labelText: 'Business / Workshop Name *',
            hintText: 'e.g., ABC Auto Inspection Center',
            prefixIcon: Icon(Icons.business),
          ),
          validator: (v) => v?.trim().isEmpty == true ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _ownerNameController,
          decoration: const InputDecoration(
            labelText: 'Owner / Manager Name *',
            prefixIcon: Icon(Icons.person),
          ),
          validator: (v) => v?.trim().isEmpty == true ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          enabled: widget.firebaseUser?.email == null,
          decoration: InputDecoration(
            labelText: 'Email *',
            prefixIcon: const Icon(Icons.email),
            suffixIcon: widget.firebaseUser?.email != null
                ? const Icon(Icons.verified, color: Colors.green)
                : null,
          ),
          validator: (v) {
            if (v?.isEmpty == true) return 'Required';
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v!)) {
              return 'Invalid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Phone Number *',
            hintText: 'e.g., 077 123 4567',
            prefixIcon: Icon(Icons.phone),
            prefixText: '+94 ',
          ),
          validator: (v) => v?.trim().isEmpty == true ? 'Required' : null,
        ),
      ],
    );
  }

  Widget _buildLocationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _addressController,
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'Business Address *',
            hintText: 'Full address including city',
            prefixIcon: Icon(Icons.location_on),
          ),
          validator: (v) => v?.trim().isEmpty == true ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        
        // Map placeholder - in production, integrate Google Maps picker
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map, size: 48, color: Colors.grey.shade600),
                const SizedBox(height: 8),
                Text(
                  'Map picker will be shown here',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 8),
                Text(
                  'Location: ${_latitude.toStringAsFixed(4)}, ${_longitude.toStringAsFixed(4)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        Text(
          'Coverage Radius: ${_coverageRadius.toInt()} km',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Slider(
          value: _coverageRadius,
          min: 5,
          max: 50,
          divisions: 9,
          label: '${_coverageRadius.toInt()} km',
          onChanged: (v) => setState(() => _coverageRadius = v),
        ),
        Text(
          'Customers within this radius will see your service',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }

  Widget _buildServicesStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Inspection Types Offered *',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _inspectionTypeOptions.map((type) {
            final isSelected = _selectedInspectionTypes.contains(type);
            return FilterChip(
              label: Text(type),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedInspectionTypes.add(type);
                  } else {
                    _selectedInspectionTypes.remove(type);
                  }
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _priceFromController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price From (LKR) *',
                  prefixText: 'Rs. ',
                ),
                validator: (v) => v?.trim().isEmpty == true ? 'Required' : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _priceToController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price To (LKR)',
                  prefixText: 'Rs. ',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        TextFormField(
          controller: _experienceController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Years of Experience *',
            suffixText: 'years',
            prefixIcon: Icon(Icons.work_history),
          ),
          validator: (v) => v?.trim().isEmpty == true ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        
        TextFormField(
          controller: _certificationsController,
          decoration: const InputDecoration(
            labelText: 'Certifications (Optional)',
            hintText: 'Comma-separated, e.g., ASE, Hybrid Certified',
            prefixIcon: Icon(Icons.verified_user),
          ),
        ),
      ],
    );
  }

  Widget _buildAvailabilityStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Days *',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _weekDays.map((day) {
            final isSelected = _selectedDays.contains(day);
            return FilterChip(
              label: Text(day.substring(0, 3)),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedDays.add(day);
                  } else {
                    _selectedDays.remove(day);
                  }
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        
        Text(
          'Working Hours',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.access_time),
                title: const Text('Open'),
                subtitle: Text(_openTime.format(context)),
                onTap: () => _selectTime(true),
              ),
            ),
            Expanded(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.access_time_filled),
                title: const Text('Close'),
                subtitle: Text(_closeTime.format(context)),
                onTap: () => _selectTime(false),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        Text(
          'Preferred Language',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        ...(_languages.map((lang) => RadioListTile<String>(
              title: Text(lang['name']!),
              value: lang['code']!,
              groupValue: _selectedLanguage,
              onChanged: (v) => setState(() => _selectedLanguage = v!),
              contentPadding: EdgeInsets.zero,
            ))),
        
        const SizedBox(height: 16),
        
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.shade200),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.orange.shade700),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Your profile will be reviewed before appearing publicly. This usually takes 1-2 business days.',
                  style: TextStyle(color: Colors.orange.shade700, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
