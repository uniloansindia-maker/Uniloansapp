# UniLoans — Your Home Loan Partner
**Document Scanner App · Flutter · Android**

---

## 🚀 Build APK with GitHub Actions (No PC setup needed)

### Step 1 — Push to GitHub
```bash
git init
git add .
git commit -m "UniLoans app"
git remote add origin https://github.com/YOUR_USERNAME/uniloans.git
git push -u origin main
```

### Step 2 — GitHub builds automatically
Go to repo → **Actions** tab → watch the build (5–8 min)

### Step 3 — Download APK
Build complete → click workflow run → **Artifacts** → download **UniLoans-APK**

---

## 📱 Features
- Document scanning with auto edge detection
- Loan details form (Full Name, Mobile, Loan Number)
- Google Drive auto-save
- PDF tools (convert, edit, merge, sign)
- OCR text recognition (on-device)
- Recycle bin (30-day auto-delete)
- Dark / Light mode
- Slide-out sidebar with quick actions

---

## 📁 Project Structure
```
uniloans/
├── lib/
│   ├── main.dart
│   ├── models/         app_colors.dart, document_model.dart
│   ├── providers/      theme_provider.dart, document_provider.dart
│   ├── screens/        home, camera, preview, loan_form, pdf_tools,
│   │                   recycle_bin, settings, library
│   └── widgets/        uniloans_logo.dart, sidebar_menu.dart, document_card.dart
├── assets/icon/        uniloans_icon_1024.png  ← real logo included
├── android/            AndroidManifest.xml
├── .github/workflows/  build-apk.yml
└── pubspec.yaml
```

---

## 🎨 Brand
- Navy: `#0D1E5C`  Blue: `#1560D4`  Sky: `#4A9FF5`

*UniLoans · Your Home Loan Partner*
