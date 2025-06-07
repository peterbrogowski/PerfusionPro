# 🚑 PerfusionPro

**Version**: 0.1 – *Medication System Integration Phase*  
**Developer**: Pete Brogowski  
**Platform**: Native iOS (SwiftUI + SwiftData)  
**Org**: New England Donor Services (NEDS)

---

## 🧭 Overview

**PerfusionPro** is a native iOS application built to modernize and streamline organ machine perfusion documentation. The app digitizes clinical flowsheets for the **OrganOx Metra** device and is being developed to support both **real-time entry** and **offline-first workflows** in transplant environments.

It replaces handwritten forms and fragmented documentation systems (like Smartsheet, paper flowsheets, and TrueNorth) with a fully structured, auditable, and portable iOS solution.

---

## 🧠 Key Problems Solved

- 📝 Eliminate handwritten flowsheets and transcription errors  
- 🔐 Secure team communication + role-based audit logging  
- 🧪 Standardize data capture across devices (OrganOx, XVIVO, LLT)  
- 📈 Visualize perfusion parameters (lactate, glucose, flow)  
- ⏰ Track timing data with precision and alerts  
- 📤 Export structured PDFs compatible with DonorNet  

---

## ✅ Current Status

**🟡 Phase 1 (in progress):**  
> Medication entry, structured case creation, and real-time perfusion tracking

### ✔️ Completed
- SwiftUI/SwiftData environment setup
- Project structure defined and implemented in Xcode
- `PerfusionMedication.swift` – medication model with enums and time tracking
- `MedicationManager.swift` – CRUD logic and alert triggers
- `AddMedicationSheet.swift` – medication entry UI
- `MedicationSummaryView.swift` – report & export UI
- `Case.swift` – now includes `[PerfusionMedication]` relationship

### 🔧 Active Tasks
- Fix visibility error for `MedicationManager`
- Complete integration of `MedicationView.swift`
- Test CRUD operations and alert triggers
- Link clinical alerts to parameters (e.g., pH < 7.2 → Bicarbonate)
- Implement export manager for PDF/CSV

---

## 🏗️ Project Structure

```
PerfusionPro/
├── Models/
│   ├── Case.swift ✅
│   └── PerfusionMedication.swift ✅
├── Business Logic/
│   └── MedicationManager.swift ✅
├── Views/
│   ├── CaseListView.swift ✅
│   ├── CaseDetailView.swift ✅
│   └── MedicationView.swift ⚠️ (needs integration)
├── Form Interface Code/
│   └── AddMedicationSheet.swift ✅
├── Report & Export Code/
│   └── MedicationSummaryView.swift ✅
└── Services/
    └── CMSHospitalService.swift ✅
```

---

## ⚙️ Tech Stack

- **Language**: Swift
- **UI**: SwiftUI
- **Data**: SwiftData (no Core Data)
- **Architecture**: MVVM + modular components
- **Persistence**: Offline-first w/ CloudKit sync (planned)
- **Export**: SwiftUI print renderer for PDF + CSV (planned)

---

## 💊 Medication System Features

- Track: Bolus, Infusion, Flush, PRN meds  
- Calculate: Dose totals, infusion durations  
- Templates: OrganOx-specific med protocols  
- Alerts: Real-time triggers (e.g., glucose ≤ 180)  
- Export: Report-ready formats (PDF, CSV, JSON)  
- UI: Tabbed interface with gloved-hand friendly targets

---

## 🧪 Clinical Validation Needed

- Confirm: pH, glucose trigger thresholds  
- Validate: Medication templates with clinical protocols  
- Review: Export formatting for UNOS compliance  
- Test: Infusion rate formulas with real-case data

---

## 📤 To Export

> When implemented, reports will support:
- SwiftUI-based PDF output
- CSV + JSON generation
- Share/export via Apple share sheet

---

## 🚨 Known Issues / Todos

- `MedicationManager` visibility issue in `MedicationView`
- ExportManager class not implemented
- User login/auth still pending
- Infusion rate calculations require live testing
- Add audit tracking for user actions

---

## 🧭 Roadmap

| Phase | Focus |
|-------|-------|
| 1     | Core case & med tracking, offline sync ✅ |
| 2     | Secure messaging, user auth 🔐 |
| 3     | Real-time team tracking 📍 |
| 4     | Data analytics + dashboards 📊 |
| 5     | System integrations (TrueNorth, UNOS) 🔗 |
| 6     | AI insight & prediction modules 🤖 |

---

## 📌 Next Steps (June 8)

1. Resolve build error: `Cannot find MedicationManager in scope`
2. Wire up UI tabs and add/edit buttons in `MedicationView`
3. Test medication status transitions (Pending → Completed)
4. Start `ExportManager.swift` with SwiftUI PDF renderer
5. Validate sample case with mock infusion entries

---

## 🧷 Author

Pete Brogowski  
Army Veteran | Organ Recovery | Perfusion Innovation  
📍 New England Donor Services
