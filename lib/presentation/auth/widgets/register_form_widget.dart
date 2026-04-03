import 'package:base_app/common/utils/formatters/cep_formatter.dart';
import 'package:base_app/common/utils/formatters/contato_formatter.dart';
import 'package:base_app/l10n/l10n.dart';
import 'package:flutter/material.dart';

class RegisterFormWidget extends StatefulWidget {
  const RegisterFormWidget({
    required this.isLoading,
    required this.onSubmit,
    super.key,
  });

  final bool isLoading;
  final Future<void> Function({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
  })
  onSubmit;

  @override
  State<RegisterFormWidget> createState() => _RegisterFormWidgetState();
}

class _RegisterFormWidgetState extends State<RegisterFormWidget> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _phoneController;
  late final TextEditingController _neighborhoodController;
  late final TextEditingController _streetController;
  late final TextEditingController _numberController;
  late final TextEditingController _zipCodeController;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _phoneController = TextEditingController();
    _neighborhoodController = TextEditingController();
    _streetController = TextEditingController();
    _numberController = TextEditingController();
    _zipCodeController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _neighborhoodController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid || widget.isLoading) {
      return;
    }

    FocusScope.of(context).unfocus();

    final address = [
      _streetController.text.trim(),
      _numberController.text.trim(),
      _neighborhoodController.text.trim(),
      _zipCodeController.text.trim(),
    ].join(', ');

    widget.onSubmit(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      phone: _phoneController.text,
      address: address,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AutofillGroup(
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              autofillHints: const [AutofillHints.name],
              decoration: InputDecoration(
                labelText: l10n.registerNameLabel,
                prefixIcon: const Icon(Icons.person_outline_rounded),
              ),
              validator: (value) {
                if ((value?.trim() ?? '').isEmpty) {
                  return l10n.registerNameRequiredMessage;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              decoration: InputDecoration(
                labelText: l10n.loginEmailLabel,
                prefixIcon: const Icon(Icons.alternate_email_rounded),
              ),
              validator: (value) {
                final trimmed = value?.trim() ?? '';
                if (trimmed.isEmpty) {
                  return l10n.loginEmailRequiredMessage;
                }
                final isValid = RegExp(
                  r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                ).hasMatch(trimmed);
                if (!isValid) {
                  return l10n.loginEmailInvalidMessage;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.newPassword],
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: l10n.loginPasswordLabel,
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  onPressed: () => setState(
                    () => _obscurePassword = !_obscurePassword,
                  ),
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
              validator: (value) {
                if ((value ?? '').isEmpty) {
                  return l10n.loginPasswordRequiredMessage;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.telephoneNumber],
              inputFormatters: [ContatoFormatter()],
              decoration: InputDecoration(
                labelText: l10n.registerPhoneLabel,
                prefixIcon: const Icon(Icons.phone_outlined),
              ),
              validator: (value) {
                if ((value?.trim() ?? '').isEmpty) {
                  return l10n.registerPhoneRequiredMessage;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _streetController,
              keyboardType: TextInputType.streetAddress,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              autofillHints: const [AutofillHints.streetAddressLine1],
              decoration: InputDecoration(
                labelText: l10n.registerStreetLabel,
                prefixIcon: const Icon(Icons.edit_road_rounded),
              ),
              validator: (value) {
                if ((value?.trim() ?? '').isEmpty) {
                  return l10n.registerStreetRequiredMessage;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _numberController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: l10n.registerNumberLabel,
                      prefixIcon: const Icon(Icons.tag_rounded),
                    ),
                    validator: (value) {
                      if ((value?.trim() ?? '').isEmpty) {
                        return l10n.registerNumberRequiredMessage;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _neighborhoodController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: l10n.registerNeighborhoodLabel,
                      prefixIcon: const Icon(Icons.holiday_village_outlined),
                    ),
                    validator: (value) {
                      if ((value?.trim() ?? '').isEmpty) {
                        return l10n.registerNeighborhoodRequiredMessage;
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _zipCodeController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              inputFormatters: [CepInputFormatter()],
              autofillHints: const [AutofillHints.postalCode],
              onFieldSubmitted: (_) => _handleSubmit(),
              decoration: InputDecoration(
                labelText: l10n.registerZipCodeLabel,
                prefixIcon: const Icon(Icons.location_on_outlined),
              ),
              validator: (value) {
                if ((value?.trim() ?? '').isEmpty) {
                  return l10n.registerZipCodeRequiredMessage;
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: widget.isLoading ? null : _handleSubmit,
              child: SizedBox(
                height: 24,
                child: Center(
                  child: widget.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.registerButton),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
