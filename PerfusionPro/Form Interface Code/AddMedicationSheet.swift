import SwiftUI
import SwiftData

struct AddMedicationSheet: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let currentCase: Case
    let type: MedicationType
    
    // Form State
    @State private var medicationName = ""
    @State private var dose = ""
    @State private var unit = "mg"
    @State private var route = "IV"
    @State private var concentration = ""
    @State private var concentrationUnit = ""
    @State private var infusionRate = ""
    @State private var infusionRateUnit = "mL/hr"
    @State private var indication = ""
    @State private var administeredBy = ""
    @State private var notes = ""
    @State private var startDateTime = Date()
    @State private var stopDateTime: Date?
    @State private var hasStopTime = false
    
    var body: some View {
        NavigationStack {
            Form {
                // Medication Details
                Section("Medication Information") {
                    TextField("Medication Name", text: $medicationName)
                        .autocapitalization(.words)
                    
                    HStack {
                        TextField("Dose", text: $dose)
                            .keyboardType(.decimalPad)
                            .frame(maxWidth: .infinity)
                        
                        Picker("Unit", selection: $unit) {
                            Text("Units").tag("Units")
                            Text("mL").tag("mL")
                            Text("mg").tag("mg")
                            Text("µg").tag("µg")
                            Text("g").tag("g")
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(width: 100)
                    }
                    
                    Picker("Route", selection: $route) {
                        Text("IV").tag("IV")
                        Text("IV Push").tag("IV Push")
                        Text("IM").tag("IM")
                        Text("SubQ").tag("SubQ")
                        Text("PO").tag("PO")
                        Text("Machine").tag("Machine")
                        Text("Other").tag("Other")
                    }
                }
                
                // Infusion-specific fields
                if type == .infusion {
                    Section("Infusion Details") {
                        HStack {
                            TextField("Concentration", text: $concentration)
                                .keyboardType(.decimalPad)
                            TextField("Unit", text: $concentrationUnit, prompt: Text("e.g., mg/mL"))
                        }
                        
                        HStack {
                            TextField("Rate", text: $infusionRate)
                                .keyboardType(.decimalPad)
                            TextField("Unit", text: $infusionRateUnit, prompt: Text("e.g., mL/hr"))
                        }
                        
                        DatePicker("Start Date & Time", selection: $startDateTime, displayedComponents: [.date, .hourAndMinute])
                        
                        Toggle("Has Stop Time", isOn: $hasStopTime)
                        
                        if hasStopTime {
                            DatePicker("Stop Date & Time",
                                      selection: Binding(
                                          get: { stopDateTime ?? Date() },
                                          set: { stopDateTime = $0 }
                                      ),
                                      displayedComponents: [.date, .hourAndMinute])
                        }
                    }
                } else {
                    // For non-infusion medications, just show administration time
                    Section("Administration Time") {
                        DatePicker("Date & Time", selection: $startDateTime, displayedComponents: [.date, .hourAndMinute])
                    }
                }
                
                // Clinical Information
                Section("Clinical Information") {
                    TextField("Indication", text: $indication, prompt: Text("Reason for administration"))
                    
                    TextField("Administered By", text: $administeredBy, prompt: Text("Your name"))
                        .autocapitalization(.words)
                }
                
                // Notes
                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 80)
                }
            }
            .navigationTitle("Add \(type.rawValue.capitalized)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addMedication()
                    }
                    .disabled(!isValidForm)
                }
            }
        }
        .onAppear {
            // Set default administered by
            administeredBy = "Pete Brogowski"  // Default for now
        }
    }
    
    // MARK: - Helper Functions
    private var isValidForm: Bool {
        !medicationName.isEmpty &&
        !dose.isEmpty &&
        !administeredBy.isEmpty
    }
    
    private func addMedication() {
        let medication = PerfusionMedication(
            caseID: currentCase.caseID,
            medicationName: medicationName,
            medicationType: type.rawValue,
            dose: dose,
            unit: unit,
            route: route,
            administeredBy: administeredBy
        )
        
        // Set additional fields
        medication.concentration = concentration.isEmpty ? nil : concentration
        medication.concentrationUnit = concentrationUnit.isEmpty ? nil : concentrationUnit
        medication.infusionRate = infusionRate.isEmpty ? nil : infusionRate
        medication.infusionRateUnit = infusionRateUnit.isEmpty ? nil : infusionRateUnit
        medication.indication = indication.isEmpty ? nil : indication
        medication.notes = notes.isEmpty ? nil : notes
        
        // Set administration time
        medication.dateTimeAdministered = startDateTime
        
        // For infusions, set stop time if provided
        if type == .infusion && hasStopTime {
            medication.dateTimeStopped = stopDateTime
        }
        
        // Add to the current case
        if currentCase.medications == nil {
            currentCase.medications = []
        }
        currentCase.medications?.append(medication)
        
        // Save
        do {
            try modelContext.save()
        } catch {
            print("Failed to save medication: \(error)")
        }
        
        dismiss()
    }
}
