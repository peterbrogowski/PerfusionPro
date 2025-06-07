import Foundation
import SwiftData

@Model
class AdminSettings {
    // MARK: - Organization Settings
    var organizationName: String = "NEDS"
    var organizationCode: String = "NEDS"
    var organizationLogo: Data? // Store logo image
    
    // MARK: - Hospital Selection Settings
    var hospitalSelectionMode: HospitalSelectionMode = .byState
    var selectedStates: [String] = ["MA", "ME", "NH", "VT", "RI", "CT"]
    var selectedCounties: [String] = [] // For county-based selection
    var radiusFromCenter: Double = 0 // For radius-based selection (miles)
    var centerLatitude: Double? // For radius-based selection
    var centerLongitude: Double? // For radius-based selection
    
    // MARK: - Hospital Management
    var excludedHospitalIDs: [String] = []
    var customHospitals: [Hospital] = []
    var favoriteHospitalIDs: [String] = [] // Pre-set favorites for all users
    var requiredHospitals: [String] = [] // Hospitals that cannot be removed
    var hospitalAliases: [String: String] = [:] // Custom names for hospitals
    
    // MARK: - Display Preferences
    var hospitalSortOrder: HospitalSortOrder = .alphabetical
    var showHospitalType: Bool = true
    var showHospitalCity: Bool = true
    var showHospitalCounty: Bool = false
    var showEmergencyServicesOnly: Bool = false
    var groupHospitalsByState: Bool = false
    var groupHospitalsByType: Bool = false
    
    // MARK: - Data Source Settings
    var dataSource: DataSource = .hardcoded
    var cmsAPIEnabled: Bool = false
    var customAPIEndpoint: String = ""
    var updateFrequency: UpdateFrequency = .monthly
    var lastDataUpdate: Date = Date()
    var autoUpdateEnabled: Bool = false
    
    // MARK: - Search & Filter Settings
    var minimumSearchCharacters: Int = 2
    var searchIncludesCity: Bool = true
    var searchIncludesCounty: Bool = false
    var searchIncludesZipCode: Bool = false
    var enableFuzzySearch: Bool = true
    
    // MARK: - User Permissions
    var allowUserFavorites: Bool = true
    var allowManualHospitalEntry: Bool = false
    var requireHospitalSelection: Bool = true
    var allowDuplicateHospitals: Bool = false // Same hospital as donor/recipient
    
    // MARK: - Default Selections
    var defaultDonorHospitals: [String] = [] // Pre-populate common donors
    var defaultTransplantCenters: [String] = [] // Pre-populate common recipients
    
    // MARK: - Validation Rules
    var validateHospitalDistance: Bool = false
    var maximumDistance: Double = 500 // miles
    var warnOnLongDistance: Bool = true
    var warningDistanceThreshold: Double = 300 // miles
    
    // MARK: - Admin Security
    var adminPasscode: String = "1234" // Should be encrypted
    var requirePasscodeForChanges: Bool = true
    var adminEmails: [String] = []
    var lastModifiedBy: String = ""
    var lastModifiedDate: Date = Date()
    
    // MARK: - Export Settings
    var includeHospitalIDInExport: Bool = true
    var includeHospitalAddressInExport: Bool = false
    var hospitalNameFormat: HospitalNameFormat = .fullName
    
    init() {
        // Initialize with defaults
    }
}

// MARK: - Supporting Enums

enum HospitalSelectionMode: String, Codable, CaseIterable {
    case byState = "By State"
    case byCounty = "By County"
    case byRadius = "By Radius"
    case byRegion = "By Region"
    case custom = "Custom Selection"
    case all = "All Hospitals"
}

enum HospitalSortOrder: String, Codable, CaseIterable {
    case alphabetical = "A-Z"
    case byState = "By State"
    case byType = "By Type"
    case byDistance = "By Distance"
    case mostUsed = "Most Used"
    case recentlyUsed = "Recently Used"
}

enum DataSource: String, Codable, CaseIterable {
    case hardcoded = "Built-in List"
    case cmsAPI = "CMS API"
    case customAPI = "Custom API"
    case excelImport = "Excel Import"
    case manual = "Manual Entry"
}

enum UpdateFrequency: String, Codable, CaseIterable {
    case never = "Never"
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
    case quarterly = "Quarterly"
}

enum HospitalNameFormat: String, Codable, CaseIterable {
    case fullName = "Full Name"
    case shortName = "Short Name"
    case nameWithCity = "Name - City"
    case nameWithState = "Name (State)"
    case custom = "Custom Format"
}

// MARK: - Region Definitions

struct OPORegion: Identifiable {
    let id = UUID()
    let name: String
    let states: [String]
    
    static let commonRegions = [
        OPORegion(name: "New England", states: ["CT", "ME", "MA", "NH", "RI", "VT"]),
        OPORegion(name: "Mid-Atlantic", states: ["NJ", "NY", "PA"]),
        OPORegion(name: "Southeast", states: ["FL", "GA", "NC", "SC", "VA"]),
        OPORegion(name: "Midwest", states: ["IL", "IN", "MI", "OH", "WI"]),
        OPORegion(name: "Southwest", states: ["AZ", "NM", "OK", "TX"]),
        OPORegion(name: "West", states: ["CA", "NV", "OR", "WA"]),
        // Add more regions...
    ]
}
