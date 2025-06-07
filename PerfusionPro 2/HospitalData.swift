import Foundation

// Temporary hardcoded hospitals for testing
struct HospitalData {
    static let sampleHospitals = [
        Hospital(
            providerNumber: "220001",
            hospitalName: "Massachusetts General Hospital",
            address: "55 Fruit St",
            city: "Boston",
            state: "MA",
            zipCode: "02114",
            countyName: "Suffolk",
            phoneNumber: "(617) 726-2000",
            hospitalType: "Acute Care Hospitals",
            hospitalOwnership: "Voluntary non-profit - Private",
            emergencyServices: "Yes",
            hospitalOverallRating: "5"
        ),
        Hospital(
            providerNumber: "220002",
            hospitalName: "Brigham and Women's Hospital",
            address: "75 Francis St",
            city: "Boston",
            state: "MA",
            zipCode: "02115",
            countyName: "Suffolk",
            phoneNumber: "(617) 732-5500",
            hospitalType: "Acute Care Hospitals",
            hospitalOwnership: "Voluntary non-profit - Private",
            emergencyServices: "Yes",
            hospitalOverallRating: "5"
        ),
        Hospital(
            providerNumber: "070001",
            hospitalName: "Yale New Haven Hospital",
            address: "20 York St",
            city: "New Haven",
            state: "CT",
            zipCode: "06510",
            countyName: "New Haven",
            phoneNumber: "(203) 688-4242",
            hospitalType: "Acute Care Hospitals",
            hospitalOwnership: "Voluntary non-profit - Private",
            emergencyServices: "Yes",
            hospitalOverallRating: "5"
        )
    ]
}
