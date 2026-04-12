# 🐾 Cat House

> **A Flutter-based cat marketplace app** with modern design, smooth animations, and intuitive UI/UX. Find your dream cat breed with ease.

---

## Table of Contents

- [About](#about)
- [Key Features](#key-features)
- [Screenshots](#screenshots)
- [Tech Stack](#tech-stack)
- [Design System](#design-system)
- [Project Structure](#project-structure)
- [Data Model](#data-model)
- [Installation & Running](#installation--running)
- [Supported Platforms](#supported-platforms)

---

## About

**Cat House** is a mobile cat marketplace app built with Flutter. It allows users to browse a list of cats from various breeds, view complete details for each cat including health information, vaccination status, price, and owner info. The entire UI is designed using a consistent theme system with an elegant violet-pink color palette.

Interface language: **English**

---

## Key Features

### Home Screen
- Staggered entrance animations on first load (fade-in, scale-up, slide-up over 1400ms)
- Dynamically floating cat illustration (sinusoidal effect ±10px, 3200ms loop)
- Three animated radial gradient decorative blobs in the background
- App name text with **ShaderMask gradient** effect
- Summary stats display: total cats, breeds, and healthy percentage
- **"Start Exploring"** CTA button with custom page transition (fade + slide)

### Cat List (Marketplace)
- **Real-time search** by name, breed, and fur color
- Clear button that appears automatically when search text is active
- **Breed category filter** with horizontally scrollable chips (6 categories: All, Persian, Maine Coon, Scottish Fold, Bengal, Siamese)
- **View toggle** between Grid View (2 columns) and List View
- Staggered animation on each cat card as it appears (per-item delay)
- Badge showing the number of filtered results
- Favorite button on each card (UI)
- Lazy image loading with progress indicator
- **Empty state** with contextual message and reset filter button
- Price formatted in **Rupiah (IDR)** with thousand separators

### Cat Detail
- **Hero animation** (shared-element transition) for cat image from list to detail
- Full-screen 400px image with gradient overlay at the bottom
- Dynamic age calculation from date of birth
- **Health status badge** with color coding (green = healthy, yellow = attention, red = issue)
- **Vaccination status** with color coding (green = routine, yellow = pending)
- Appropriate gender icon (male/female)
- **Quick stats row** showing 4 info items: age, weight, gender, vaccination
- **2-column spec grid**: fur color, food, owner, microchip number — with scale-in animation
- Cat description / special notes section
- Favorite toggle button in the AppBar (persistent during session)
- **"Contact [owner name]"** floating CTA button at the bottom of the screen
- Custom-designed owner contact confirmation dialog

### Navigation & Transitions
- 3-screen navigation stack: Home → List → Detail
- Custom page transitions using `PageRouteBuilder` (fade + directional slide combination)
- Hero shared-element animation for cat images between List and Detail
- Transparent overlay AppBar on hero image in the Detail screen
- **Cupertino (iOS)-style** page transitions on all platforms (Android & iOS)

---

## Screenshots

> Add app screenshots here

| Home Screen | Cat List | Cat Detail |
|:-----------:|:--------:|:----------:|
| *(screenshot)* | *(screenshot)* | *(screenshot)* |

---

## Tech Stack

| Technology | Version | Purpose |
|------------|---------|---------|
| Flutter | SDK ≥3.8.0 | Main cross-platform framework |
| Dart | Bundled with Flutter | Programming language |
| Material 3 | Built-in | Design system (`useMaterial3: true`) |
| `cupertino_icons` | ^1.0.8 | iOS-style icons |
| `flutter_launcher_icons` | ^0.14.3 | Generate adaptive app icon |

No external state management or HTTP packages — all data is static and images are loaded from network URLs.

---

## Design System

All design tokens are defined in `lib/theme/app_theme.dart`.

### Color Palette

| Role | Name | Hex |
|------|------|-----|
| Primary | Electric Violet | `#7C5CFC` |
| Primary Light | Soft Violet | `#9B80FF` |
| Primary Dark | Deep Violet | `#5B3FD9` |
| Secondary | Hot Pink | `#FF5C8D` |
| Accent | Cyan | `#00D4FF` |
| Background | Light Lavender | `#F5F3FF` |
| Surface | Lavender | `#EBE8FF` |
| Success | Teal Green | `#0BBF88` |
| Warning | Amber | `#E5A800` |
| Error | Crimson | `#E8234A` |
| Text Primary | Near Black | `#1A1A3E` |
| Text Muted | Cool Gray | `#9FA6B2` |

### Gradients

| Name | Description |
|------|-------------|
| `primaryGradient` | Violet to light violet (diagonal) |
| `secondaryGradient` | Hot pink spectrum |
| `accentGradient` | Cyan spectrum |
| `backgroundGradient` | Light lavender, vertical fade, 3 stops |
| `homeGradient` | 4-stop diagonal lavender (Home Screen) |
| `cardGradient` | White to very light lavender |
| `heroGradient` | Transparent to lavender (hero image overlay) |
| `shimmerGradient` | Violet → Cyan → Pink |

### Typography

| Token | Size | Weight |
|-------|------|--------|
| `heading1` | 36px | 800 |
| `heading2` | 28px | 700 |
| `heading3` | 22px | 700 |
| `subtitle1` | 18px | 600 |
| `subtitle2` | 16px | 600 |
| `body1` | 16px | Normal |
| `body2` | 14px | Normal |
| `caption` | 12px | Normal |

### Spacing & Radius

- **Spacing:** 4 · 8 · 12 · 16 · 20 · 24 · 32 · 40 · 48
- **Border Radius:** Small=8 · Medium=16 · Large=24 · XLarge=36

---

## Project Structure

```
cat-house-app-ui/
├── assets/
│   ├── launcher_icon.png                  # App icon source
│   └── launcher_icon_foreground.png       # Foreground adaptive icon
│
├── lib/
│   ├── main.dart                          # Entry point, theme & MaterialApp config
│   ├── models/
│   │   └── data_kucing.dart               # Cat model + static dataset (5 cats)
│   ├── screens/
│   │   ├── home_screen.dart               # Landing screen with animations
│   │   ├── list_cat.dart                  # Marketplace listing (grid/list + filter)
│   │   └── detail_kucing.dart             # Cat detail screen
│   └── theme/
│       └── app_theme.dart                 # All design constants & tokens
│
├── android/                               # Android configuration
├── ios/                                   # iOS configuration
├── linux/                                 # Linux configuration
├── macos/                                 # macOS configuration
├── web/                                   # Web configuration
├── windows/                               # Windows configuration
├── test/                                  # Unit & widget tests
├── pubspec.yaml                           # Dependencies & project config
└── analysis_options.yaml                  # Dart linting rules
```

---

## Data Model

`Cat` model (`lib/models/data_kucing.dart`):

```dart
class Kucing {
  String nama;            // Cat name
  String jenis;           // Breed / type
  String warnaBulu;       // Fur color
  DateTime tanggalLahir;  // Date of birth (for dynamic age calculation)
  double beratBadan;      // Body weight in kg
  String jenisKelamin;    // "Jantan" (Male) / "Betina" (Female)
  String statusKesehatan; // Health status (color coded)
  String vaksinasi;       // Vaccination status
  String makanan;         // Food brand
  String nomorMikrochip;  // Microchip ID
  String pemilik;         // Owner name
  String catatanKhusus;   // Description / special notes
  int harga;              // Price in Rupiah
  String foto;            // Image URL (network)
}
```

### Default Dataset (5 Cats)

| Name | Breed | Gender | Health Status | Vaccination | Price |
|------|-------|:------:|:-------------:|:-----------:|------:|
| Chiko Bloon | Persian | Female | Healthy | Routine | Rp 5,000,000 |
| Oreo | Maine Coon | Male | Rear Leg Defect | Pending | Rp 7,000,000 |
| Whiskers | Scottish Fold | Female | Healthy | Routine | Rp 6,000,000 |
| Simba | Bengal | Male | Healthy | Routine | Rp 7,500,000 |
| Luna | Siamese | Female | Healthy | Routine | Rp 5,500,000 |

---

## Installation & Running

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) version **≥3.8.0**
- Dart SDK (bundled with Flutter)
- Android Studio / VS Code with Flutter extension
- Android emulator / iOS simulator, or a physical device

### Steps

```bash
# 1. Clone the repository
git clone https://github.com/<username>/cat-house-app-ui.git
cd cat-house-app-ui

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run

# 4. (Optional) Build for Android release
flutter build apk --release

# 5. (Optional) Build for iOS release
flutter build ios --release
```

### Generate App Icon (if needed)

```bash
flutter pub run flutter_launcher_icons
```

---

## Supported Platforms

| Platform | Status |
|----------|:------:|
| Android | ✅ |
| iOS | ✅ |
| Web | ⚠️ (stub) |
| Windows | ⚠️ (stub) |
| macOS | ⚠️ (stub) |
| Linux | ⚠️ (stub) |

---

## License

Kode ini **bebas digunakan** tanpa syarat apapun.

- Boleh dipakai untuk belajar dan dipublikasikan sebagai bahan belajar
- Boleh dicantumkan di portofolio pribadi **tanpa perlu mencantumkan kredit apapun**
- Boleh dijual, dikomersilkan, atau didistribusikan dalam bentuk apapun
- Boleh disalin dan dikembangkan menjadi proyek pribadi maupun komersial

Lihat file [LICENSE](./LICENSE) untuk detail lengkap.

**Kontak:** Instagram [@agungkurniawan.id](https://instagram.com/agungkurniawan.id)

---

*Built with Flutter*
