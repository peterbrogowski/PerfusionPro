import Foundation

struct Hospital: Codable, Identifiable, Hashable {
    let id = UUID()
    
    // CMS API fields
    let providerNumber: String
    let hospitalName: String
    let address: String
    let city: String
    let state: String
    let zipCode: String
    let countyName: String?
    let phoneNumber: String?
    let hospitalType: String?
    let hospitalOwnership: String?
    let emergencyServices: String?
    let hospitalOverallRating: String?
    
    // This helps us search
    var searchableText: String {
        "\(hospitalName) \(city) \(state) \(countyName ?? "")".lowercased()
    }
    
    // Check if hospital has emergency services
    var hasEmergencyServices: Bool {
        emergencyServices?.lowercased() == "yes"
    }
    
    // This maps CMS field names to our variable names
    enum CodingKeys: String, CodingKey {
        case providerNumber = "provider_id"
        case hospitalName = "hospital_name"
        case address = "address"
        case city = "city"
        case state = "state"
        case zipCode = "zip_code"
        case countyName = "county_name"
        case phoneNumber = "phone_number"
        case hospitalType = "hospital_type"
        case hospitalOwnership = "hospital_ownership"
        case emergencyServices = "emergency_services"
        case hospitalOverallRating = "hospital_overall_rating"
    }
}
