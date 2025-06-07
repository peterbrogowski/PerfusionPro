import Foundation
import SwiftData

// MARK: - Medication Model for SwiftData
@Model
class PerfusionMedication {
    // Unique identifier
    var id: UUID
    var caseID: String // Links to parent Case
    
    // Basic medication info
    var medicationName: String
    var medicationType: String // "bolus", "infusion", "flush", "prn"
    var dose: String
    var unit: String
    var route: String
    
    // Concentration (for infusions)
    var concentration: String?
    var concentrationUnit: String?
    
    // Infusion specific
    var infusionRate: String?
    var infusionRateUnit: String?
    var totalDoseInfused: Double?
    
    // Timing
    var dateTimeAdministered: Date
    var dateTimeStopped: Date?
    var duration: TimeInterval?
    
    // Administration details
    var administeredBy: String
    var administeredByID: String?
    var verifiedBy: String?
    var verifiedByID: String?
    
    // Clinical information
    var indication: String?
    var clinicalTrigger: String? // e.g., "pH < 7.2", "Glucose < 180"
    var associatedLabValue: Double?
    var associatedLabParameter: String? // e.g., "pH", "glucose"
    
    // Status tracking
    var status: String // "pending", "active", "completed", "stopped", "held"
    var reasonStopped: String?
    var reasonHeld: String?
    
    // Notes and documentation
    var notes: String?
    var adverseReaction: String?
    var effectiveness: String?
    
    // Device specific
    var deviceSpecific: Bool
    var deviceProtocolName: String?
    
    // Audit fields
    var createdAt: Date
    var modifiedAt: Date
    var modifiedBy: String?
    
    // Relationships
    @Relationship(deleteRule: .nullify, inverse: \Case.medications)  // Use "Case" if that's your class name
    var perfusionCase: Case?
    
    init(caseID: String,
         medicationName: String,
         medicationType: String,
         dose: String,
         unit: String,
         route: String = "IV",
         administeredBy: String) {
        self.id = UUID()
        self.caseID = caseID
        self.medicationName = medicationName
        self.medicationType = medicationType
        self.dose = dose
        self.unit = unit
        self.route = route
        self.administeredBy = administeredBy
        self.dateTimeAdministered = Date()
        self.status = "pending"
        self.deviceSpecific = false
        self.createdAt = Date()
        self.modifiedAt = Date()
    }
    
    // Computed properties
    var isActive: Bool {
        return status == "active"
    }
    
    var isCompleted: Bool {
        return status == "completed"
    }
    
    var calculatedDuration: TimeInterval? {
        guard let stopTime = dateTimeStopped else {
            if isActive {
                return Date().timeIntervalSince(dateTimeAdministered)
            }
            return nil
        }
        return stopTime.timeIntervalSince(dateTimeAdministered)
    }
    
    var formattedDuration: String {
        guard let duration = calculatedDuration else { return "—" }
        let hours = Int(duration) / 3600
        let minutes = Int(duration) % 3600 / 60
        return String(format: "%02d:%02d", hours, minutes)
    }
    
    var infusionProgress: Double? {
        guard medicationType == "infusion", let duration = calculatedDuration else { return nil }
        let maxDuration: TimeInterval = 24 * 3600 // 24 hours max
        return min(duration / maxDuration, 1.0)
    }
}

// MARK: - Medication Protocol Templates
struct MedicationTemplate: Codable {
    let id: UUID
    let name: String
    let type: String
    let defaultDose: String
    let defaultUnit: String
    let defaultRoute: String
    let concentration: String?
    let concentrationUnit: String?
    let infusionRate: String?
    let infusionRateUnit: String?
    let indication: String?
    let clinicalTrigger: String?
    let deviceSpecific: Bool
    let deviceType: String?
    let orderIndex: Int
    
    // Convert template to medication
    func toMedication(caseID: String, administeredBy: String) -> PerfusionMedication {
        let med = PerfusionMedication(
            caseID: caseID,
            medicationName: name,
            medicationType: type,
            dose: defaultDose,
            unit: defaultUnit,
            route: defaultRoute,
            administeredBy: administeredBy
        )
        
        med.concentration = concentration
        med.concentrationUnit = concentrationUnit
        med.infusionRate = infusionRate
        med.infusionRateUnit = infusionRateUnit
        med.indication = indication
        med.clinicalTrigger = clinicalTrigger
        med.deviceSpecific = deviceSpecific
        med.deviceProtocolName = deviceType
        
        return med
    }
}

// MARK: - Medication Summary for Reports
extension PerfusionMedication {
    var summaryText: String {
        var summary = "\(medicationName) \(dose)\(unit)"
        if let concentration = concentration {
            summary += " (\(concentration)\(concentrationUnit ?? ""))"
        }
        if let rate = infusionRate {
            summary += " @ \(rate)\(infusionRateUnit ?? "")"
        }
        summary += " - \(route)"
        return summary
    }
    
    var auditTrail: String {
        var trail = "Administered: \(dateTimeAdministered.formatted(date: .numeric, time: .shortened))"
        trail += " by \(administeredBy)"
        if let verifiedBy = verifiedBy {
            trail += ", verified by \(verifiedBy)"
        }
        if let stopTime = dateTimeStopped {
            trail += "\nStopped: \(stopTime.formatted(date: .numeric, time: .shortened))"
            if let reason = reasonStopped {
                trail += " - \(reason)"
            }
        }
        return trail
    }
}

// MARK: - Case Relationship

