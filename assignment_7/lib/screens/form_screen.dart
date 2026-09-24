import 'package:flutter/material.dart';
import '../models/user_registration.dart';
import '../routes/app_routes.dart';
import '../widgets/custom_text_field.dart';

/// Screen 2: Form Screen implementing a complete registration form with live and on-submit validation.
class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text Editing Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Focus Nodes for keyboard navigation
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  // State toggles & selections
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _selectedAccountType = 'Student';
  String _selectedGender = 'Male';
  bool _agreeToTerms = false;
  bool _subscribeNewsletter = true;

  final List<String> _accountTypes = const [
    'Student',
    'Developer',
    'Designer',
    'Manager',
    'Other',
  ];

  final List<String> _genderOptions = const [
    'Male',
    'Female',
    'Other',
    'Prefer not to say',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _emailFocus.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  void _submitForm() {
    // Trigger validation on all FormField widgets inside the form
    if (_formKey.currentState!.validate()) {
      final user = UserRegistration(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
        accountType: _selectedAccountType,
        gender: _selectedGender,
        agreeToTerms: _agreeToTerms,
        subscribeNewsletter: _subscribeNewsletter,
        registrationDate: DateTime.now(),
      );

      // Navigate to Detail Screen using Named Route and pass user data as argument
      Navigator.pushNamed(
        context,
        AppRoutes.detail,
        arguments: user,
      );
    } else {
      // Feedback on validation failure
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please correct the errors in the form before submitting.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _resetForm() {
    setState(() {
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      _selectedAccountType = 'Student';
      _selectedGender = 'Male';
      _agreeToTerms = false;
      _subscribeNewsletter = true;
      _obscurePassword = true;
      _obscureConfirmPassword = true;
    });
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registration Form',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: colorScheme.inversePrimary,
        actions: [
          IconButton(
            tooltip: 'Reset Form',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _resetForm,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header guidance text
                Text(
                  'Create Your Account',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Please fill in the required fields with valid details.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),

                // 1. Full Name Field
                CustomTextField(
                  key: const Key('name_field'),
                  controller: _nameController,
                  label: 'Full Name *',
                  hint: 'e.g. John Doe',
                  prefixIcon: Icons.person_outline,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _emailFocus.requestFocus(),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Full name is required';
                    }
                    if (value.trim().length < 3) {
                      return 'Full name must be at least 3 characters long';
                    }
                    if (!RegExp(r"^[a-zA-Z\s.'-]+$").hasMatch(value.trim())) {
                      return 'Name can only contain alphabets and spaces';
                    }
                    return null;
                  },
                ),

                // 2. Email Address Field
                CustomTextField(
                  key: const Key('email_field'),
                  controller: _emailController,
                  focusNode: _emailFocus,
                  label: 'Email Address *',
                  hint: 'e.g. user@domain.com',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _phoneFocus.requestFocus(),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email address is required';
                    }
                    final emailRegex = RegExp(
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                    );
                    if (!emailRegex.hasMatch(value.trim())) {
                      return 'Please enter a valid email address (e.g. name@example.com)';
                    }
                    return null;
                  },
                ),

                // 3. Phone Number Field
                CustomTextField(
                  key: const Key('phone_field'),
                  controller: _phoneController,
                  focusNode: _phoneFocus,
                  label: 'Phone Number *',
                  hint: '10-digit mobile number',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Phone number is required';
                    }
                    if (!RegExp(r'^\d{10}$').hasMatch(value.trim())) {
                      return 'Please enter a valid 10-digit phone number';
                    }
                    return null;
                  },
                ),

                // 4. Password Field
                CustomTextField(
                  key: const Key('password_field'),
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  label: 'Password *',
                  hint: 'Min. 8 chars with letters & numbers',
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => _confirmPasswordFocus.requestFocus(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters long';
                    }
                    if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
                      return 'Password must contain at least one letter';
                    }
                    if (!RegExp(r'\d').hasMatch(value)) {
                      return 'Password must contain at least one digit';
                    }
                    return null;
                  },
                ),

                // 5. Confirm Password Field
                CustomTextField(
                  key: const Key('confirm_password_field'),
                  controller: _confirmPasswordController,
                  focusNode: _confirmPasswordFocus,
                  label: 'Confirm Password *',
                  hint: 'Re-enter your password',
                  prefixIcon: Icons.lock_reset_outlined,
                  obscureText: _obscureConfirmPassword,
                  textInputAction: TextInputAction.done,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                // 6. Account Type Dropdown
                DropdownButtonFormField<String>(
                  initialValue: _selectedAccountType,
                  decoration: InputDecoration(
                    labelText: 'Account Role / Type',
                    prefixIcon: const Icon(Icons.work_outline),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  items: _accountTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedAccountType = val;
                      });
                    }
                  },
                ),

                const SizedBox(height: 16),

                // 7. Gender Selection (Choice Chips)
                Text(
                  'Gender',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  children: _genderOptions.map((gender) {
                    final isSelected = _selectedGender == gender;
                    return ChoiceChip(
                      label: Text(gender),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedGender = gender;
                          });
                        }
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 12),

                // 8. Newsletter Subscription Switch
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Subscribe to newsletter'),
                  subtitle: const Text('Receive product updates and announcements'),
                  value: _subscribeNewsletter,
                  onChanged: (val) {
                    setState(() {
                      _subscribeNewsletter = val;
                    });
                  },
                ),

                // 9. Terms and Conditions Required Checkbox (FormField)
                FormField<bool>(
                  initialValue: _agreeToTerms,
                  validator: (_) {
                    if (!_agreeToTerms) {
                      return 'You must accept the terms and conditions to proceed';
                    }
                    return null;
                  },
                  builder: (state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CheckboxListTile(
                          key: const Key('terms_checkbox'),
                          contentPadding: EdgeInsets.zero,
                          title: const Text('I agree to the Terms and Conditions *'),
                          value: _agreeToTerms,
                          onChanged: (val) {
                            setState(() {
                              _agreeToTerms = val ?? false;
                            });
                            state.didChange(_agreeToTerms);
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        if (state.hasError)
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0, bottom: 8.0),
                            child: Text(
                              state.errorText!,
                              style: TextStyle(
                                color: colorScheme.error,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Submit Button
                FilledButton.icon(
                  key: const Key('submit_button'),
                  onPressed: _submitForm,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text(
                    'Submit & View Details',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Reset Button
                OutlinedButton.icon(
                  onPressed: _resetForm,
                  icon: const Icon(Icons.clear_all_rounded),
                  label: const Text('Clear All Fields'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
