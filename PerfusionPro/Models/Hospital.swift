import Foundation

struct Hospital: Codable, Identifiable, Hashable {
    let id = UUID()
    let facilityID: String
    let facilityName: String
    let address: String
    let city: String
    let state: String
    let zipCode: String
    let county: String?
    let phoneNumber: String?
    let hospitalType: String?
    let emergencyServices: Bool
    
    // Define CodingKeys to exclude 'id' from encoding/decoding
    enum CodingKeys: String, CodingKey {
        case facilityID
        case facilityName
        case address
        case city
        case state
        case zipCode
        case county
        case phoneNumber
        case hospitalType
        case emergencyServices
    }
    
    // For search functionality
    var searchableText: String {
        "\(facilityName) \(city) \(state)".lowercased()
    }
    
    // Display name for UI
    var displayName: String {
        "\(facilityName) - \(city), \(state)"
    }
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(facilityID)
    }
    
    static func == (lhs: Hospital, rhs: Hospital) -> Bool {
        lhs.facilityID == rhs.facilityID
    }
}

// Sample NEDS hospitals for testing
extension Hospital {
    static let sampleHospitals = [
        Hospital(
            facilityID: "220001",
            facilityName: "Massachusetts General Hospital",
            address: "55 Fruit St",
            city: "Boston",
            state: "MA",
            zipCode: "02114",
            county: "Suffolk",
            phoneNumber: "(617) 726-2000",
            hospitalType: "Acute Care Hospitals",
            emergencyServices: true
        ),
        Hospital(
            facilityID: "220002",
            facilityName: "Brigham and Women's Hospital",
            address: "75 Francis St",
            city: "Boston",
            state: "MA",
            zipCode: "02115",
            county: "Suffolk",
            phoneNumber: "(617) 732-5500",
            hospitalType: "Acute Care Hospitals",
            emergencyServices: true
        ),
        Hospital(
            facilityID: "070001",
            facilityName: "Yale New Haven Hospital",
            address: "20 York St",
            city: "New Haven",
            state: "CT",
            zipCode: "06510",
            county: "New Haven",
            phoneNumber: "(203) 688-4242",
            hospitalType: "Acute Care Hospitals",
            emergencyServices: true
        ),
        Hospital(
            facilityID: "300001",
            facilityName: "Maine Medical Center",
            address: "22 Bramhall St",
            city: "Portland",
            state: "ME",
            zipCode: "04102",
            county: "Cumberland",
            phoneNumber: "(207) 662-0111",
            hospitalType: "Acute Care Hospitals",
            emergencyServices: true
        ),
        Hospital(
            facilityID: "300002",
            facilityName: "Dartmouth-Hitchcock Medical Center",
            address: "1 Medical Center Dr",
            city: "Lebanon",
            state: "NH",
            zipCode: "03756",
            county: "Grafton",
            phoneNumber: "(603) 650-5000",
            hospitalType: "Acute Care Hospitals",
            emergencyServices: true
        )
    ]
}
