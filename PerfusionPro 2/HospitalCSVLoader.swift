import Foundation

class HospitalCSVLoader {
    // NEDS states
    static let nedsStates = ["MA", "ME", "NH", "VT", "RI", "CT"]
    
    static func loadHospitals() -> [Hospital] {
        guard let path = Bundle.main.path(forResource: "CMSHospitalData", ofType: "csv") else {
            print("CSV file not found")
            return []
        }
        
        do {
            let csvString = try String(contentsOfFile: path, encoding: .utf8)
            let rows = csvString.components(separatedBy: "\n")
            
            // Skip header row
            guard rows.count > 1 else { return [] }
            let dataRows = rows.dropFirst()
            
            var hospitals: [Hospital] = []
            
            for row in dataRows {
                let columns = parseCSVRow(row)
                
                // Make sure we have enough columns and it's a NEDS state
                if columns.count >= 7 {
                    let state = columns[3].trimmingCharacters(in: .whitespaces)
                    
                    // Only include NEDS states
                    if nedsStates.contains(state) {
                        let hospital = Hospital(
                            providerNumber: String(hospitals.count + 1), // Generate ID
                            hospitalName: columns[0],
                            address: columns[1],
                            city: columns[2],
                            state: state,
                            zipCode: columns[4],
                            countyName: nil, // Not in this CSV
                            phoneNumber: columns[5],
                            hospitalType: columns[6],
                            hospitalOwnership: nil, // Not in this CSV
                            emergencyServices: nil, // Not in this CSV
                            hospitalOverallRating: nil // Not in this CSV
                        )
                        hospitals.append(hospital)
                    }
                }
            }
            
            print("Loaded \(hospitals.count) NEDS hospitals")
            return hospitals
            
        } catch {
            print("Error loading CSV: \(error)")
            return []
        }
    }
    
    // Handle CSV parsing with quotes and commas
    private static func parseCSVRow(_ row: String) -> [String] {
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
        if !currentField.isEmpty {
            result.append(currentField.trimmingCharacters(in: .whitespaces))
        }
        
        return result
    }
}
