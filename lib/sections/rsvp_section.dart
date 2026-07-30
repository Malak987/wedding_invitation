import 'package:flutter/material.dart';
import '../services/config_manager.dart';
import '../core/localization.dart';
import '../core/responsive.dart';
import '../core/constants.dart';
import '../widgets/section_title.dart';
import '../widgets/glass_card.dart';
import '../animations/fade_in.dart';

class RsvpSection extends StatefulWidget {
  const RsvpSection({super.key});

  @override
  State<RsvpSection> createState() => _RsvpSectionState();
}

class _RsvpSectionState extends State<RsvpSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _messageController = TextEditingController();

  bool _isAttending = true;
  bool _isLoading = false;
  bool _isSubmitted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitRsvp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Brief, elegant loading pause before confirming locally
    await Future.delayed(const Duration(milliseconds: 900));

    final manager = AppConfigManager.instance;
    manager.addRsvp(
      name: _nameController.text.trim(),
      attending: _isAttending,
      message: _messageController.text.trim(),
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
        _isSubmitted = true;
      });
    }
  }

  void _resetForm() {
    setState(() {
      _nameController.clear();
      _messageController.clear();
      _isAttending = true;
      _isSubmitted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final manager = AppConfigManager.instance;
    final lang = manager.selectedLanguage;
    final primary = manager.primaryColor;
    final secondary = manager.secondaryColor;
    final isMobile = Responsive.isMobile(context);

    return Container(
      color: manager.accentColor,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding(context),
        vertical: Responsive.value(
          context,
          mobile: AppConstants.sectionSpacingMobile,
          desktop: AppConstants.sectionSpacing,
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 550),
          child: Column(
            children: [
              SectionTitle(
                title: Localization.get(lang, 'rsvp_title'),
                subtitle: Localization.get(lang, 'rsvp_desc'),
              ),
              const SizedBox(height: 36),
              AnimatedSize(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOutCubic,
                child: _isSubmitted
                    ? _buildSuccessCard(manager, lang, primary, secondary)
                    : _buildFormCard(manager, lang, primary, secondary, isMobile),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard(
    AppConfigManager manager,
    String lang,
    Color primary,
    Color secondary,
    bool isMobile,
  ) {
    return GlassCard(
      padding: EdgeInsets.all(isMobile ? 20 : 32),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Full Name
            Text(
              Localization.get(lang, 'rsvp_name'),
              style: TextStyle(
                fontFamily: manager.bodyFont,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: secondary,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return Localization.get(lang, 'rsvp_name_error');
                }
                return null;
              },
              style: TextStyle(fontFamily: manager.bodyFont, fontSize: 14),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_outline, color: primary),
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primary, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primary.withOpacity(0.3), width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.redAccent, width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
            const SizedBox(height: 24),

            // Attending Radio Cards
            Text(
              Localization.get(lang, 'rsvp_attendance'),
              style: TextStyle(
                fontFamily: manager.bodyFont,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: secondary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildAttendanceOption(
                    title: Localization.get(lang, 'rsvp_yes'),
                    selected: _isAttending,
                    onTap: () => setState(() => _isAttending = true),
                    primary: primary,
                    manager: manager,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAttendanceOption(
                    title: Localization.get(lang, 'rsvp_no'),
                    selected: !_isAttending,
                    onTap: () => setState(() => _isAttending = false),
                    primary: primary,
                    manager: manager,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Congratulatory Message / Special note
            Text(
              Localization.get(lang, 'rsvp_message'),
              style: TextStyle(
                fontFamily: manager.bodyFont,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: secondary,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _messageController,
              maxLines: 3,
              style: TextStyle(fontFamily: manager.bodyFont, fontSize: 14),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primary, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primary.withOpacity(0.3), width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 32),

            // Submit Button
            _isLoading
                ? Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(color: primary),
                        const SizedBox(height: 12),
                        Text(
                          Localization.get(lang, 'rsvp_submitting'),
                          style: TextStyle(
                            fontFamily: manager.bodyFont,
                            fontSize: 13,
                            color: secondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: _submitRsvp,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: primary.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          Localization.get(lang, 'rsvp_submit'),
                          style: TextStyle(
                            fontFamily: manager.bodyFont,
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceOption({
    required String title,
    required bool selected,
    required VoidCallback onTap,
    required Color primary,
    required AppConfigManager manager,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            color: selected ? primary.withOpacity(0.12) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? primary : primary.withOpacity(0.2),
              width: selected ? 1.8 : 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontFamily: manager.bodyFont,
              color: selected ? manager.secondaryColor : Colors.black54,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessCard(
    AppConfigManager manager,
    String lang,
    Color primary,
    Color secondary,
  ) {
    return FadeIn(
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          children: [
            // Rotating gold seal / icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green.shade50,
                border: Border.all(color: Colors.green, width: 2),
              ),
              child: const Icon(Icons.check, color: Colors.green, size: 40),
            ),
            const SizedBox(height: 24),
            Text(
              Localization.get(lang, 'rsvp_success_title'),
              style: TextStyle(
                fontFamily: manager.headingFont,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: secondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              _isAttending
                  ? Localization.get(lang, 'rsvp_success_desc')
                  : Localization.get(lang, 'rsvp_success_no'),
              style: TextStyle(
                fontFamily: manager.bodyFont,
                fontSize: 15,
                color: Colors.black54,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Confirm New Button
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: _resetForm,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: primary),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    Localization.get(lang, 'rsvp_new_submission'),
                    style: TextStyle(
                      fontFamily: manager.bodyFont,
                      color: primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
