import 'package:flutter/material.dart';
import '../services/config_manager.dart';
import '../core/localization.dart';

class AdminDashboardDrawer extends StatefulWidget {
  const AdminDashboardDrawer({super.key});

  @override
  State<AdminDashboardDrawer> createState() => _AdminDashboardDrawerState();
}

class _AdminDashboardDrawerState extends State<AdminDashboardDrawer> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // Controllers for all text fields
  late final TextEditingController _brideController;
  late final TextEditingController _groomController;
  late final TextEditingController _dateController;
  late final TextEditingController _timeController;
  late final TextEditingController _dayController;
  late final TextEditingController _venueNameController;
  late final TextEditingController _venueAddressController;
  late final TextEditingController _targetDateController;
  late final TextEditingController _storyController;
  late final TextEditingController _mapsController;
  late final TextEditingController _phoneController;
  late final TextEditingController _whatsappController;
  late final TextEditingController _instagramController;
  late final TextEditingController _facebookController;

  // Hex Colors
  late final TextEditingController _primaryColorController;
  late final TextEditingController _secondaryColorController;
  late final TextEditingController _accentColorController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    final manager = AppConfigManager.instance;

    _brideController = TextEditingController(text: manager.brideName);
    _groomController = TextEditingController(text: manager.groomName);
    _dateController = TextEditingController(text: manager.weddingDate);
    _timeController = TextEditingController(text: manager.weddingTime);
    _dayController = TextEditingController(text: manager.weddingDay);
    _venueNameController = TextEditingController(text: manager.venueName);
    _venueAddressController = TextEditingController(text: manager.venueAddress);
    _targetDateController = TextEditingController(text: manager.countdownTarget);
    _storyController = TextEditingController(text: manager.storyText);
    _mapsController = TextEditingController(text: manager.googleMapsUrl);
    _phoneController = TextEditingController(text: manager.phoneNumber);
    _whatsappController = TextEditingController(text: manager.whatsappNumber);
    _instagramController = TextEditingController(text: manager.instagramUrl);
    _facebookController = TextEditingController(text: manager.facebookUrl);

    _primaryColorController = TextEditingController(text: '0x${manager.primaryColor.value.toRadixString(16).toUpperCase()}');
    _secondaryColorController = TextEditingController(text: '0x${manager.secondaryColor.value.toRadixString(16).toUpperCase()}');
    _accentColorController = TextEditingController(text: '0x${manager.accentColor.value.toRadixString(16).toUpperCase()}');
  }

  @override
  void dispose() {
    _tabController.dispose();
    _brideController.dispose();
    _groomController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _dayController.dispose();
    _venueNameController.dispose();
    _venueAddressController.dispose();
    _targetDateController.dispose();
    _storyController.dispose();
    _mapsController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    _instagramController.dispose();
    _facebookController.dispose();
    _primaryColorController.dispose();
    _secondaryColorController.dispose();
    _accentColorController.dispose();
    super.dispose();
  }

  void _saveAllChanges() {
    final manager = AppConfigManager.instance;

    // Helper to sanitize hex string
    String sanitizeHex(String hex) {
      if (!hex.startsWith('0xFF') && !hex.startsWith('0xff')) {
        if (hex.startsWith('#')) {
          return '0xFF${hex.substring(1)}';
        } else if (hex.length == 8) {
          return '0x$hex';
        } else if (hex.length == 6) {
          return '0xFF$hex';
        }
      }
      return hex;
    }

    try {
      manager.updateConfig(
        brideName: _brideController.text,
        groomName: _groomController.text,
        weddingDate: _dateController.text,
        weddingTime: _timeController.text,
        weddingDay: _dayController.text,
        venueName: _venueNameController.text,
        venueAddress: _venueAddressController.text,
        storyText: _storyController.text,
        countdownTarget: _targetDateController.text,
        googleMapsUrl: _mapsController.text,
        phoneNumber: _phoneController.text,
        whatsappNumber: _whatsappController.text,
        instagramUrl: _instagramController.text,
        facebookUrl: _facebookController.text,
        primaryColor: sanitizeHex(_primaryColorController.text),
        secondaryColor: sanitizeHex(_secondaryColorController.text),
        accentColor: sanitizeHex(_accentColorController.text),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Localization.get(manager.selectedLanguage, 'admin_success_save')),
          backgroundColor: manager.primaryColor,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${Localization.get(manager.selectedLanguage, 'rsvp_error')}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    final manager = AppConfigManager.instance;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(fontFamily: manager.bodyFont, fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: manager.primaryColor, fontFamily: manager.bodyFont, fontSize: 13),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: manager.primaryColor, width: 1.5),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: manager.primaryColor.withOpacity(0.3), width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final manager = AppConfigManager.instance;
    final lang = manager.selectedLanguage;
    final isRtl = manager.textDirection == TextDirection.rtl;
    final primary = manager.primaryColor;
    final textOnDark = Colors.white;

    return Drawer(
      width: 420,
      backgroundColor: manager.accentColor,
      elevation: 32,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              color: manager.secondaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Localization.get(lang, 'admin_title'),
                        style: TextStyle(
                          fontFamily: manager.headingFont,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: manager.primaryColor,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: manager.primaryColor),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    Localization.get(lang, 'admin_desc'),
                    style: TextStyle(
                      fontFamily: manager.bodyFont,
                      fontSize: 12,
                      color: textOnDark.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),

            // Tab Buttons
            TabBar(
              controller: _tabController,
              indicatorColor: primary,
              labelColor: primary,
              unselectedLabelColor: Colors.grey,
              labelStyle: TextStyle(fontFamily: manager.bodyFont, fontWeight: FontWeight.bold, fontSize: 13),
              tabs: [
                Tab(text: isRtl ? 'التفاصيل' : 'Details'),
                Tab(text: isRtl ? 'الأقسام' : 'Toggles'),
                Tab(text: isRtl ? 'تأكيدات الحضور' : 'RSVPs'),
              ],
            ),

            // Tabs Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Configuration details
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          isRtl ? 'الأسماء والتواريخ' : 'Names & Dates',
                          style: TextStyle(fontFamily: manager.headingFont, fontWeight: FontWeight.bold, color: manager.secondaryColor, fontSize: 15),
                        ),
                        const Divider(height: 24),
                        _buildTextField(Localization.get(lang, 'admin_groom'), _groomController),
                        _buildTextField(Localization.get(lang, 'admin_bride'), _brideController),
                        _buildTextField(Localization.get(lang, 'admin_wedding_date'), _dateController),
                        _buildTextField(Localization.get(lang, 'admin_wedding_time'), _timeController),
                        _buildTextField(Localization.get(lang, 'admin_wedding_day'), _dayController),
                        _buildTextField(Localization.get(lang, 'admin_target_date'), _targetDateController),

                        const SizedBox(height: 16),
                        Text(
                          isRtl ? 'قصة الحب وموقع الحفل' : 'Story & Venue',
                          style: TextStyle(fontFamily: manager.headingFont, fontWeight: FontWeight.bold, color: manager.secondaryColor, fontSize: 15),
                        ),
                        const Divider(height: 24),
                        _buildTextField(Localization.get(lang, 'admin_story_text'), _storyController, maxLines: 4),
                        _buildTextField(Localization.get(lang, 'admin_venue_name'), _venueNameController),
                        _buildTextField(Localization.get(lang, 'admin_venue_address'), _venueAddressController),
                        _buildTextField('Google Maps Link', _mapsController),

                        const SizedBox(height: 16),
                        Text(
                          isRtl ? 'روابط التواصل الاجتماعي' : 'Social Links & Contacts',
                          style: TextStyle(fontFamily: manager.headingFont, fontWeight: FontWeight.bold, color: manager.secondaryColor, fontSize: 15),
                        ),
                        const Divider(height: 24),
                        _buildTextField('Phone (Rsvp)', _phoneController),
                        _buildTextField('WhatsApp Link', _whatsappController),
                        _buildTextField('Instagram Link', _instagramController),
                        _buildTextField('Facebook Link', _facebookController),

                        const SizedBox(height: 16),
                        Text(
                          Localization.get(lang, 'admin_colors_fonts'),
                          style: TextStyle(fontFamily: manager.headingFont, fontWeight: FontWeight.bold, color: manager.secondaryColor, fontSize: 15),
                        ),
                        const Divider(height: 24),
                        _buildTextField(Localization.get(lang, 'admin_primary_color'), _primaryColorController),
                        _buildTextField(Localization.get(lang, 'admin_secondary_color'), _secondaryColorController),
                        _buildTextField(Localization.get(lang, 'admin_accent_color'), _accentColorController),

                        // Preset presets
                        Wrap(
                          spacing: 8,
                          children: [
                            ActionChip(
                              label: const Text('Gold / Ivory'),
                              onPressed: () {
                                _primaryColorController.text = '0xFFC9A66B';
                                _secondaryColorController.text = '0xFF6B4F3B';
                                _accentColorController.text = '0xFFFFF9F3';
                              },
                            ),
                            ActionChip(
                              label: const Text('Rose Gold'),
                              onPressed: () {
                                _primaryColorController.text = '0xFFB76E79';
                                _secondaryColorController.text = '0xFF4A282D';
                                _accentColorController.text = '0xFFFFF0F1';
                              },
                            ),
                            ActionChip(
                              label: const Text('Classic Blue'),
                              onPressed: () {
                                _primaryColorController.text = '0xFFC5A059';
                                _secondaryColorController.text = '0xFF1A2F4C';
                                _accentColorController.text = '0xFFF0F4F8';
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        ElevatedButton(
                          onPressed: _saveAllChanges,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text(
                            Localization.get(lang, 'admin_save'),
                            style: TextStyle(fontFamily: manager.bodyFont, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),

                  // Tab 2: Section Toggles
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          Localization.get(lang, 'admin_section_toggles'),
                          style: TextStyle(fontFamily: manager.headingFont, fontWeight: FontWeight.bold, color: manager.secondaryColor, fontSize: 15),
                        ),
                        const Divider(height: 24),
                        SwitchListTile(
                          title: Text(Localization.get(lang, 'admin_show_story'), style: TextStyle(fontFamily: manager.bodyFont, fontSize: 14)),
                          value: manager.showStory,
                          activeColor: primary,
                          onChanged: (val) => manager.updateConfig(showStory: val),
                        ),
                        SwitchListTile(
                          title: Text(Localization.get(lang, 'admin_show_countdown'), style: TextStyle(fontFamily: manager.bodyFont, fontSize: 14)),
                          value: manager.showCountdown,
                          activeColor: primary,
                          onChanged: (val) => manager.updateConfig(showCountdown: val),
                        ),
                        SwitchListTile(
                          title: Text(Localization.get(lang, 'admin_show_gallery'), style: TextStyle(fontFamily: manager.bodyFont, fontSize: 14)),
                          value: manager.showGallery,
                          activeColor: primary,
                          onChanged: (val) => manager.updateConfig(showGallery: val),
                        ),
                        SwitchListTile(
                          title: Text(Localization.get(lang, 'admin_show_location'), style: TextStyle(fontFamily: manager.bodyFont, fontSize: 14)),
                          value: manager.showLocation,
                          activeColor: primary,
                          onChanged: (val) => manager.updateConfig(showLocation: val),
                        ),
                        SwitchListTile(
                          title: Text(Localization.get(lang, 'admin_show_schedule'), style: TextStyle(fontFamily: manager.bodyFont, fontSize: 14)),
                          value: manager.showSchedule,
                          activeColor: primary,
                          onChanged: (val) => manager.updateConfig(showSchedule: val),
                        ),
                        SwitchListTile(
                          title: Text(Localization.get(lang, 'admin_show_gift'), style: TextStyle(fontFamily: manager.bodyFont, fontSize: 14)),
                          value: manager.showGift,
                          activeColor: primary,
                          onChanged: (val) => manager.updateConfig(showGift: val),
                        ),
                        SwitchListTile(
                          title: Text(Localization.get(lang, 'admin_show_rsvp'), style: TextStyle(fontFamily: manager.bodyFont, fontSize: 14)),
                          value: manager.showRsvp,
                          activeColor: primary,
                          onChanged: (val) => manager.updateConfig(showRsvp: val),
                        ),
                        SwitchListTile(
                          title: Text(isRtl ? 'تفعيل الموسيقى' : 'Background Music', style: TextStyle(fontFamily: manager.bodyFont, fontSize: 14)),
                          value: manager.showMusic,
                          activeColor: primary,
                          onChanged: (val) => manager.updateConfig(showMusic: val),
                        ),
                        const SizedBox(height: 24),
                        // Reset all button
                        OutlinedButton(
                          onPressed: () {
                            manager.resetInvitation();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(isRtl ? 'تم إعادة تهيئة حالة الفتح وقائمة الحضور.' : 'Invitation state and RSVP list cleared.'),
                                backgroundColor: manager.secondaryColor,
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: manager.secondaryColor),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text(
                            isRtl ? 'إعادة ضبط تجربة الدخول' : 'Reset Welcome Screen State',
                            style: TextStyle(fontFamily: manager.bodyFont, color: manager.secondaryColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tab 3: RSVPs viewer
                  manager.rsvps.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.people_outline, color: manager.primaryColor.withOpacity(0.5), size: 48),
                                const SizedBox(height: 12),
                                Text(
                                  Localization.get(lang, 'admin_no_rsvps'),
                                  style: TextStyle(fontFamily: manager.bodyFont, color: Colors.grey, fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: manager.rsvps.length,
                          separatorBuilder: (context, index) => const Divider(height: 16),
                          itemBuilder: (context, index) {
                            final rsvp = manager.rsvps[index];
                            final bool attending = rsvp['attending'] ?? false;
                            return Card(
                              color: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: ListTile(
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: attending ? Colors.green.shade50 : Colors.red.shade50,
                                  ),
                                  child: Icon(
                                    attending ? Icons.check_circle_outline : Icons.cancel_outlined,
                                    color: attending ? Colors.green : Colors.red,
                                  ),
                                ),
                                title: Text(
                                  rsvp['name'] ?? '',
                                  style: TextStyle(fontFamily: manager.bodyFont, fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(
                                      '${isRtl ? "المرافقين" : "Companions"}: ${rsvp['guests'] ?? 0}',
                                      style: TextStyle(fontFamily: manager.bodyFont, fontSize: 12, color: Colors.black87),
                                    ),
                                    if (rsvp['message'] != null && rsvp['message'].toString().trim().isNotEmpty) ...[
                                      const SizedBox(height: 6),
                                      Text(
                                        '"${rsvp['message']}"',
                                        style: TextStyle(fontFamily: manager.bodyFont, fontStyle: FontStyle.italic, fontSize: 12, color: Colors.black54),
                                      ),
                                    ]
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
