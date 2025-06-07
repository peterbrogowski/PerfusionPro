import Foundation
import SwiftData

@Model
class Case {
    // Unique identifiers
    var id = UUID()
    var caseID: String = ""
    var unoxID: String = ""
    
    // Case metadata
    var dateCreated = Date()
    var dateModified = Date()
    var status: CaseStatus = .draft
    
    // Hospital information
    var donorHospital: String = ""
    var transplantCenter: String = ""
    
    // Team members
    var omps1: String = ""
    var omps2: String = ""
    var surgeon1: String = ""
    var surgeon2: String = ""
    
    // Timing data
    var crossClampTime: Date?
    var flushStartTime: Date?
    var flushEndTime: Date?
    var pumpOnTime: Date?
    var pumpOffTime: Date?
    
    // Calculated duration (in minutes)
    var perfusionDuration: Int {
        guard let start = pumpOnTime, let end = pumpOffTime else { return 0 }
        return Int(end.timeIntervalSince(start) / 60)
    }
    
    // Formatted duration (HH:MM)
    var formattedDuration: String {
        let hours = perfusionDuration / 60
        let minutes = perfusionDuration % 60
        return String(format: "%02d:%02d", hours, minutes)
    }
    
    // Add a computed property to check if case has minimal info
    var isComplete: Bool {
        return !unoxID.isEmpty && !donorHospital.isEmpty
    }
    
    // Initialize with auto-generated Case ID
    init() {
        self.caseID = Self.generateCaseID()
    }
    
    // Generate unique case ID (e.g., "NEDS-2024-001")
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
