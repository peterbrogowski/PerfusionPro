import SwiftUI
import SwiftData

// Add this enum definition at the top
enum MedicationType: String, CaseIterable {
    case bolus = "bolus"
    case infusion = "infusion"
    case flush = "flush"
    case prn = "prn"
}

@MainActor
class MedicationManager: ObservableObject {
    private let modelContext: ModelContext
    @Published var medications: [PerfusionMedication] = []
    @Published var currentCase: Case?
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchMedications()
    }
    
    func fetchMedications() {
        let descriptor = FetchDescriptor<PerfusionMedication>()
        do {
            medications = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch medications: \(error)")
        }
    }
    
    func addMedication(name: String, dose: Double, unit: String, concentration: String? = nil,
                       type: MedicationType, toCase perfusionCase: Case, administeredBy: String) {
        // Create medication using the initializer from your model
        let medication = PerfusionMedication(
            caseID: perfusionCase.id.uuidString,  // Convert UUID to String
            medicationName: name,
            medicationType: type.rawValue,  // Convert enum to String
            dose: String(dose),  // Convert Double to String
            unit: unit,
            route: "IV",  // Default route
            administeredBy: administeredBy
        )
        
        // Set additional properties
        medication.concentration = concentration
        medication.perfusionCase = perfusionCase
        medication.status = "active"  // Set initial status
        
        modelContext.insert(medication)
        fetchMedications() // Refresh the list
    }
    
    func medications(for perfusionCase: Case) -> [PerfusionMedication] {
        return medications.filter { $0.perfusionCase?.id == perfusionCase.id }
    }
    
    func deleteMedication(_ medication: PerfusionMedication) {
        modelContext.delete(medication)
        fetchMedications() // Refresh the list
    }
    
    func updateMedication(_ medication: PerfusionMedication) {
        medication.modifiedAt = Date()
        // SwiftData automatically tracks changes
        fetchMedications() // Refresh the list
    }
    
    // Helper function to stop an infusion
    func stopInfusion(_ medication: PerfusionMedication, reason: String? = nil) {
        medication.dateTimeStopped = Date()
        medication.status = "completed"
        medication.reasonStopped = reason
        medication.modifiedAt = Date()
        fetchMedications()
    }
    
    // Helper function to update infusion rate
    func updateInfusionRate(_ medication: PerfusionMedication, newRate: String, unit: String) {
        medication.infusionRate = newRate
        medication.infusionRateUnit = unit
        medication.modifiedAt = Date()
        fetchMedications()
    }
}
