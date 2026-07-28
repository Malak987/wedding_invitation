/// ============================================================
/// GUEST GALLERY CONFIGURATION — Local Dashboard
/// ============================================================
/// Control whether and when guests can upload their wedding day
/// photos and videos directly into your Google Drive folder.
/// ============================================================

class GalleryConfig {
  GalleryConfig._();

  /// Globally enable or disable this feature
  static const bool enableGuestGallery = true;

  /// The exact date and time the Guest Gallery opens for uploads.
  /// Format: DateTime(yyyy, MM, dd, HH, mm)
  static final DateTime galleryOpenDate = DateTime(2026, 9, 15, 22, 0);

  /// Your Google Drive Folder ID where uploaded files will be stored.
  static const String googleDriveFolderId = "YOUR_GOOGLE_DRIVE_FOLDER_ID_HERE";
}
