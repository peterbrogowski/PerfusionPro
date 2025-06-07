import Foundation
import SwiftData

@Model
class Case {
    // Unique identifiers
    var id: UUID
    var caseID: String
    var unosID: String
    @Relationship(deleteRule: .cascade)
        var medications: [PerfusionMedication]? = []
    
    // Case metadata
    var dateCreated: Date
    var dateModified: Date
    var status: CaseStatus
    
    // Hospital information
    var donorHospital: String
    var transplantCenter: String
    
    // Team members
    var omps1: String
    var omps2: String
    var surgeon1: String
    var surgeon2: String
    
    // Timing data
    var crossClampTime: Date?
    var flushStartTime: Date?
    var flushEndTime: Date?
    var pumpOnTime: Date?
    var pumpOffTime: Date?
    
 
    
    // Initialize with all required values
    init(caseID: String = "", unosID: String = "") {
        self.id = UUID()
        self.caseID = caseID.isEmpty ? Self.generateCaseID() : caseID
        self.unosID = unosID
        self.dateCreated = Date()
        self.dateModified = Date()
        self.status = .draft
        self.donorHospital = ""
        self.transplantCenter = ""
        self.omps1 = ""
        self.omps2 = ""
        self.surgeon1 = ""
        self.surgeon2 = ""
        self.crossClampTime = nil
        self.flushStartTime = nil
        self.flushEndTime = nil
        self.pumpOnTime = nil
        self.pumpOffTime = nil
    }
    
    // Computed properties
    var perfusionDuration: Int {
        guard let start = pumpOnTime, let end = pumpOffTime else { return 0 }
        return Int(end.timeIntervalSince(start) / 60)
    }
    
    var formattedDuration: String {
        let hours = perfusionDuration / 60
        let minutes = perfusionDuration % 60
        return String(format: "%02d:%02d", hours, minutes)
    }
    
    // Generate unique case ID
    private static func generateCaseID() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: Date())
        let randomNum = Int.random(in: 100...999)
        return "NEDS-\(year)-\(randomNum)"
    }
}

enum CaseStatus: String, Codable, CaseIterable {
    case draft = "Draft"
    case inProgress = "In Progress"
    case complete = "Complete"
    
    var color: String {
        switch self {
        case .draft: return "gray"
        case .inProgress: return "blue"
        case .complete: return "green"
        }
    }
}
