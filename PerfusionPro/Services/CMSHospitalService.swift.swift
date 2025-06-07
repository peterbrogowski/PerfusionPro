import Foundation
import SwiftUI

@MainActor
class CMSHospitalService: ObservableObject {
    static let shared = CMSHospitalService()
    
    @Published var hospitals: [Hospital] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let nedsStates = ["MA", "ME", "NH", "VT", "RI", "CT"]
    
    init() {
        loadHospitals()
    }
    
    func loadHospitals() {
        isLoading = true
        errorMessage = nil
        
        // First try to load from CSV
        if let csvHospitals = loadHospitalsFromCSV() {
            self.hospitals = csvHospitals
        } else {
            // Fallback to sample data
            self.hospitals = Hospital.sampleHospitals
        }
        
        isLoading = false
    }
    
    private func loadHospitalsFromCSV() -> [Hospital]? {
        guard let csvPath = Bundle.main.path(forResource: "CMSHospitalData", ofType: "csv"),
              let csvContent = try? String(contentsOfFile: csvPath, encoding: .utf8) else {
            print("Could not find or read CMSHospitalData.csv")
            return nil
        }
        return parseCSV(content: csvContent)
    }
    
    private func parseCSV(content: String) -> [Hospital] {
        let lines = content.components(separatedBy: .newlines)
        guard lines.count > 1 else { return [] }
        
        // Skip header row
        let dataLines = Array(lines.dropFirst())
        var hospitals: [Hospital] = []
        
        for line in dataLines {
            guard !line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { continue }
            
            let columns = parseCSVLine(line)
            guard columns.count >= 7 else { continue }
            
            let state = columns[3].trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Only include NEDS states
            guard nedsStates.contains(state) else { continue }
            
            let hospital = Hospital(
                facilityID: String(hospitals.count + 1), // Generate ID
                facilityName: columns[0].trimmingCharacters(in: .whitespacesAndNewlines),
                address: columns[1].trimmingCharacters(in: .whitespacesAndNewlines),
                city: columns[2].trimmingCharacters(in: .whitespacesAndNewlines),
                state: state,
                zipCode: columns[4].trimmingCharacters(in: .whitespacesAndNewlines),
                county: nil,
                phoneNumber: columns[5].trimmingCharacters(in: .whitespacesAndNewlines),
                hospitalType: columns[6].trimmingCharacters(in: .whitespacesAndNewlines),
                emergencyServices: true
            )
            
            hospitals.append(hospital)
        }
        
        return hospitals.sorted { $0.facilityName < $1.facilityName }
    }
    
    private func parseCSVLine(_ line: String) -> [String] {
        var columns: [String] = []
        var currentColumn = ""
        var insideQuotes = false
        
        for char in line {
            if char == "\"" {
                insideQuotes.toggle()
            } else if char == "," && !insideQuotes {
                columns.append(currentColumn)
                currentColumn = ""
            } else {
                currentColumn.append(char)
            }
        }
        
        // Add the last column
        columns.append(currentColumn)
        
        return columns
    }
    
    func searchHospitals(query: String) -> [Hospital] {
        guard !query.isEmpty else { return hospitals }
        
        return hospitals.filter { hospital in
            hospital.searchableText.contains(query.lowercased())
        }
    }
}
