import Foundation
import SwiftUI

class CMSHospitalService: ObservableObject {
    @Published var hospitals: [Hospital] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // NEDS states
    private let nedsStates = ["MA", "ME", "NH", "VT", "RI", "CT"]
    
    init() {
        loadHospitals()
    }
    
    func loadHospitals() {
        isLoading = true
        errorMessage = nil
        
        // Load from CSV file
        DispatchQueue.global(qos: .background).async {
            let loadedHospitals = self.loadHospitalsFromCSV()
            
            DispatchQueue.main.async {
                if loadedHospitals.isEmpty {
                    self.errorMessage = "No hospitals loaded"
                    // Use fallback data
                    self.hospitals = HospitalData.sampleHospitals
                } else {
                    self.hospitals = loadedHospitals.sorted { $0.hospitalName < $1.hospitalName }
                }
                self.isLoading = false
                print("Loaded \(self.hospitals.count) hospitals")
            }
        }
    }
    
    private func loadHospitalsFromCSV() -> [Hospital] {
        guard let path = Bundle.main.path(forResource: "CMSHospitalData", ofType: "csv") else {
            print("CSV file not found")
            return []
        }
        
        do {
            let csvString = try String(contentsOfFile: path, encoding: .utf8)
            let rows = csvString.components(separatedBy: "\n")
            
            // Skip header row
            guard rows.count > 1 else { return [] }
            
            var hospitals: [Hospital] = []
            
            for (index, row) in rows.dropFirst().enumerated() {
                let columns = parseCSVRow(row)
                
                // Make sure we have enough columns
                if columns.count >= 7 {
                    let state = columns[3].trimmingCharacters(in: .whitespaces)
                    
                    // Only include NEDS states
                    if nedsStates.contains(state) {
                        let hospital = Hospital(
                            providerNumber: "H\(index + 1)", // Generate unique ID
                            hospitalName: columns[0],
                            address: columns[1],
                            city: columns[2],
                            state: state,
                            zipCode: columns[4],
                            countyName: nil,
                            phoneNumber: columns[5],
                            hospitalType: columns[6],
                            hospitalOwnership: nil,
                            emergencyServices: nil,
                            hospitalOverallRating: nil
                        )
                        hospitals.append(hospital)
                    }
                }
            }
            
            return hospitals
            
        } catch {
            print("Error loading CSV: \(error)")
            return []
        }
    }
    
    // Handle CSV parsing with quotes and commas
    private func parseCSVRow(_ row: String) -> [String] {
        var result: [String] = []
        var currentField = ""
        var inQuotes = false
        
        for char in row {
            if char == "\"" {
                inQuotes.toggle()
            } else if char == "," && !inQuotes {
                result.append(currentField.trimmingCharacters(in: .whitespaces))
                currentField = ""
            } else {
                currentField.append(char)
            }
        }
        
        // Add the last field
        if !currentField.isEmpty || !result.isEmpty {
            result.append(currentField.trimmingCharacters(in: .whitespaces))
        }
        
        return result
    }
}
