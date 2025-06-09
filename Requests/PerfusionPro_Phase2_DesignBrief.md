# 🚀 PerfusionPro – Phase 2 Design Brief (Updated)
**Submitted by:** Pete Brogowski  
**Platform:** iOS/iPadOS  
**Framework:** SwiftUI + SwiftData (UIKit references as needed)  
**Date:** June 09, 2025  
**Version:** Phase 2 Planning & Redirection

---

## 🎯 Overview

PerfusionPro is a purpose-built app for documenting and managing organ machine perfusion cases at NEDS. Phase 1 is functionally complete and now shifting to Phase 2: building structured flowsheet functionality, parameter tracking, PDF export, and **professional UI design**.

### 🔄 Phase 2 Redirection Focus:
We are now redesigning the interface using a **sidebar + tab-based navigation layout** modeled after Apple’s `UITabGroup` and `TabView` samples, in order to improve clinical usability and scale future sections like export, event logging, and device-specific modules.

---

## 🧭 Navigation Architecture (Sidebar Redesign)

### Objective:
Build a modular, scalable **sidebar-style navigation** system that adapts for iPad and optionally iPhone, allowing clinicians to switch between documentation areas within each case.

### Use This Pattern (UIKit Example):
```swift
let collectionsGroup = UITabGroup(
    title: "Collections",
    image: UIImage(systemName: "folder"),
    identifier: "Tabs.CollectionsGroup",
    children: self.collectionsTabs()
)

tabBarController.mode = .tabSidebar
tabBarController.tabs = [
    UITab(title: "Case Details", image: UIImage(systemName: "doc.text")) { _ in ... },
    UITab(title: "Medications", image: UIImage(systemName: "pills")) { _ in ... },
    collectionsGroup,
    UITab(title: "Export", image: UIImage(systemName: "square.and.arrow.up")) { _ in ... },
    UISearchTab { _ in SearchViewController() }
]
```

### SwiftUI Alternative:
```swift
TabView {
    Tab("Case Details", systemImage: "doc.text") { CaseDetailView() }
    Tab("Medications", systemImage: "pills") { MedicationView() }
    Tab("Perfusion Parameters", systemImage: "waveform.path.ecg") { ParametersView() }
    Tab("Export", systemImage: "square.and.arrow.up") { ExportView() }
}
.tabViewStyle(.sidebarAdaptable)
```

---

## 🔥 Sidebar Tabs – Required Sections

Each case should open into a view with sidebar tabs or a collapsible nav panel.

### Required Tabs:
1. **Case Details** – Scrollable editable form
2. **Case Timing** – With live perfusion timer (see next section)
3. **Medications** – Full eMAR-style table
4. **Perfusion Parameters** – Hourly data entries
5. **Point of Care Testing** – Blood gas/I-STAT data
6. **Event Log** – Clinical notes with timestamps
7. **Export** – Generate and share ORG-159-style flowsheet PDF

### Optional / Future Tabs:
- **Attachments** – Upload annotated images
- **Milestones Tracker** – Timeline of events
- **Admin Tab** – Custom fields, device config

---

## 🕒 Perfusion Timer – Specification Update

**Timer only activates** once perfusion begins.

| Stage                   | Timer Behavior           |
|------------------------|--------------------------|
| Case Created           | Not displayed            |
| Priming / Setup        | Not displayed            |
| Perfusion Started      | Timer starts (MM:SS/HH:MM) |
| Perfusion Ended        | Timer stops, duration shown |
| Case Canceled (No Perf)| Timer never starts       |

### Implementation Guidance:
- Use `@State var perfusionStarted = false`
- Show `TimerView()` only if `perfusionStarted == true`
- Update `perfusionStartTime` manually or via button
- Display timer persistently in tab headers using `ToolbarItem` or injected view

---

## 🧱 UI Design Goals

- **Landing Page** with “New Case,” “All Cases,” “Settings,” etc.
- **Professional medical theme** (minimalist, accessible, intuitive)
- **Persistent header** for UNOS ID and reference number
- **Quick actions**: start perfusion, stop timer, export PDF

---

## ✅ Technical To-Do Summary (as of June 9, 2025)

### Fixed:
- ✅ AddMedicationSheet.swift – errors resolved, simplified
- ✅ MedicationType enum added

### Still to Fix:
- ❌ CaseListView.swift – `@Query` not defined  
  Add this at top of `CaseListView.swift`:
  ```swift
  @Query(sort: \Case.dateCreated, order: .reverse)
  private var cases: [Case]
  ```
- ❌ Case.swift – needs missing enum:
  ```swift
  enum CaseStatus: String, Codable, CaseIterable {
      case active = "Active"
      case completed = "Completed"
      case cancelled = "Cancelled"
  }
  ```

---

## 📚 Dev Notes to Claude (or any AI Assistant)

### Current Issues:
- Please ensure the navigation design uses a **sidebar/tab-based layout**
- Align all case content under a **Case Detail container with sidebar**
- Do NOT continue building as a single-page or flat navigation app

### Communication Preferences for Pete:
✅ Small steps  
✅ One focus at a time  
✅ Visual confirmation (before/after error count)  
✅ Avoid overwhelming information dumps  
✅ Celebrate reductions in errors!

---

## 📂 Supporting Files to Reference
- ORG-159 flowsheet structure  
- OrganOx Metra CSV parameter set  
- SwiftData medication model  
- Sample case metadata (UNOS ID, hospital, device)
