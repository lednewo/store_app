import 'package:base_app/common/utils/extensions/text_words_extension.dart';
import 'package:base_app/common/utils/formatters/cep_formatter.dart';
import 'package:base_app/common/utils/formatters/contato_formatter.dart';
import 'package:base_app/common/widgets/app_button.dart';
import 'package:base_app/domain/dto/profile_dto.dart';
import 'package:base_app/domain/entities/profile_entity.dart';
import 'package:base_app/l10n/l10n.dart';
import 'package:flutter/material.dart';

class UpdateProfileSheet extends StatefulWidget {
  const UpdateProfileSheet({
    required this.profile,
    required this.onConfirm,
    super.key,
  });

  final ProfileEntity profile;
  final ValueChanged<ProfileDto> onConfirm;

  @override
  State<UpdateProfileSheet> createState() => _UpdateProfileSheetState();
}

class _UpdateProfileSheetState extends State<UpdateProfileSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _streetController;
  late final TextEditingController _numberController;
  late final TextEditingController _neighborhoodController;
  late final TextEditingController _zipCodeController;

  @override
  void initState() {
    super.initState();
    final parts = widget.profile.address.split(', ');
    _nameController = TextEditingController(text: widget.profile.name);
    _phoneController = TextEditingController(
      text: widget.profile.phone.phoneFormatter(),
    );
    _streetController = TextEditingController(
      text: parts.elementAtOrNull(0) ?? '',
    );
    _numberController = TextEditingController(
      text: parts.elementAtOrNull(1) ?? '',
    );
    _neighborhoodController = TextEditingController(
      text: parts.elementAtOrNull(2) ?? '',
    );
    _zipCodeController = TextEditingController(
      text: parts.elementAtOrNull(3) ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    _neighborhoodController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final street = _streetController.text.trim();
    final number = _numberController.text.trim();
    final neighborhood = _neighborhoodController.text.trim();
    final zipCode = _zipCodeController.text.trim();

    final hasAddress =
        street.isNotEmpty ||
        number.isNotEmpty ||
        neighborhood.isNotEmpty ||
        zipCode.isNotEmpty;

    final address = hasAddress
        ? [street, number, neighborhood, zipCode].join(', ')
        : null;

    final dto = ProfileDto(
      id: widget.profile.id,
      name: name.isEmpty ? null : name,
      phone: phone.isEmpty ? null : phone,
      address: address,
    );

    if (dto.name == null && dto.phone == null && dto.address == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.updateProfileFillAtLeastOne)),
      );
      return;
    }

    widget.onConfirm(dto);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.person_outline_rounded,
                        size: 20,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.updateProfileTitle,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          l10n.updateProfileSubtitle,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Divider(
                  height: 1,
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: l10n.registerNameLabel,
                    prefixIcon: const Icon(Icons.badge_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [ContatoFormatter()],
                  decoration: InputDecoration(
                    labelText: l10n.registerPhoneLabel,
                    prefixIcon: const Icon(Icons.phone_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _streetController,
                  keyboardType: TextInputType.streetAddress,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: l10n.registerStreetLabel,
                    prefixIcon: const Icon(Icons.edit_road_rounded),
                  ),
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
                          prefixIcon: const Icon(
                            Icons.holiday_village_outlined,
                          ),
                        ),
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
                  onFieldSubmitted: (_) => _submit(),
                  decoration: InputDecoration(
                    labelText: l10n.registerZipCodeLabel,
                    prefixIcon: const Icon(Icons.location_on_outlined),
                  ),
                ),
                const SizedBox(height: 24),
                AppButton(
                  label: l10n.updateProfileSaveButton,
                  onTap: _submit,
                  size: AppButtonSize.large,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
