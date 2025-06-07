import SwiftUI
import SwiftData

struct AddMedicationSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @ObservedObject var medicationManager: MedicationManager
    
    let type: MedicationType
    let isEditing: Bool
    
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
    @State private var startImmediately = true
    
    // Existing medication for editing
    var existingMedication: PerfusionMedication?
    
    init(medicationManager: MedicationManager,
         type: MedicationType,
         existingMedication: PerfusionMedication? = nil) {
        self.medicationManager = medicationManager
        self.type = type
        self.isEditing = existingMedication != nil
        self.existingMedication = existingMedication
    }
    
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
                        
                        TextField("Unit", text: $unit)
                            .frame(width: 80)
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
                if type == .infusion && startImmediately {
                    medication.startTime = Date()
                    // isActive is computed based on startTime and endTime
                }
                        
                        HStack {
                            TextField("Rate", text: $infusionRate)
                                .keyboardType(.decimalPad)
                            TextField("Unit", text: $infusionRateUnit, prompt: Text("e.g., mL/hr"))
                        }
                        
                        if !isEditing {
                            Toggle("Start immediately", isOn: $startImmediately)
                        }
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
            .navigationTitle(isEditing ? "Edit Medication" : "Add \(type.rawValue.capitalized)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(isEditing ? "Update" : "Add") {
                        isEditing ? updateMedication() : addMedication()
                    }
                    .disabled(!isValidForm)
                }
            }
        }
        .onAppear {
            if isEditing, let medication = existingMedication {
                loadMedicationData(medication)
            } else {
                // Set default administered by
                administeredBy = "Pete Brogowski"  // Default for now
            }
        }
    }
    
    // MARK: - Helper Functions
    private var isValidForm: Bool {
        !medicationName.isEmpty &&
        !dose.isEmpty &&
        !administeredBy.isEmpty
    }
    
    private func loadMedicationData(_ medication: PerfusionMedication) {
        medicationName = medication.medicationName
        dose = medication.dose
        unit = medication.unit
        route = medication.route
        concentration = medication.concentration ?? ""
        concentrationUnit = medication.concentrationUnit ?? ""
        infusionRate = medication.infusionRate ?? ""
        infusionRateUnit = medication.infusionRateUnit ?? ""
        indication = medication.indication ?? ""
        administeredBy = medication.administeredBy
        notes = medication.notes ?? ""
    }
    
    private func addMedication() {
        let medication = PerfusionMedication(
            caseID: medicationManager.currentCase?.id.uuidString ?? "",
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
        
        // Set active status for infusions
        if type == .infusion && startImmediately {
            medication.isActive = true
            medication.startTime = Date()
        }
        
        medicationManager.addMedication(medication)
        dismiss()
    }
    
    private func updateMedication() {
        guard let medication = existingMedication else { return }
        
        // Update fields
        medication.medicationName = medicationName
        medication.dose = dose
        medication.unit = unit
        medication.route = route
        medication.concentration = concentration.isEmpty ? nil : concentration
        medication.concentrationUnit = concentrationUnit.isEmpty ? nil : concentrationUnit
        medication.infusionRate = infusionRate.isEmpty ? nil : infusionRate
        medication.infusionRateUnit = infusionRateUnit.isEmpty ? nil : infusionRateUnit
        medication.indication = indication.isEmpty ? nil : indication
        medication.administeredBy = administeredBy
        medication.notes = notes.isEmpty ? nil : notes
        medication.dateModified = Date()
        
        medicationManager.updateMedication(medication)
        dismiss()
    }
}
