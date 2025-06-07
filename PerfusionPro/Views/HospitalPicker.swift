import SwiftUI

struct HospitalPicker: View {
    @Binding var selectedHospital: String
    @StateObject private var hospitalService = CMSHospitalService.shared
    @State private var searchText = ""
    @State private var showingPicker = false
    
    var filteredHospitals: [Hospital] {
        hospitalService.searchHospitals(query: searchText)
    }
    
    var body: some View {
        Button(action: { showingPicker = true }) {
            HStack {
                Text(selectedHospital.isEmpty ? "Select Hospital" : selectedHospital)
                    .foregroundColor(selectedHospital.isEmpty ? .gray : .primary)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
        .sheet(isPresented: $showingPicker) {
            HospitalSelectionSheet(
                selectedHospital: $selectedHospital,
                searchText: $searchText,
                showingPicker: $showingPicker,
                filteredHospitals: filteredHospitals
            )
        }
    }
}

struct HospitalSelectionSheet: View {
    @Binding var selectedHospital: String
    @Binding var searchText: String
    @Binding var showingPicker: Bool
    let filteredHospitals: [Hospital]
    
    var groupedHospitals: [(key: String, value: [Hospital])] {
        let grouped = Dictionary(grouping: filteredHospitals) { $0.state }
        return grouped.sorted { $0.key < $1.key }
    }
    
    var body: some View {
        NavigationStack {
            List {
                // Quick selections for common hospitals
                if searchText.isEmpty {
                    Section("Common Selections") {
                        ForEach(Hospital.sampleHospitals.prefix(3), id: \.id) { hospital in
                            Button(action: {
                                selectedHospital = hospital.facilityName
                                showingPicker = false
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(hospital.facilityName)
                                            .foregroundColor(.primary)
                                        Text("\(hospital.city), \(hospital.state)")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    if selectedHospital == hospital.facilityName {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Grouped by state
                ForEach(groupedHospitals, id: \.key) { state, hospitals in
                    Section(stateName(for: state)) {
                        ForEach(hospitals, id: \.id) { hospital in
                            Button(action: {
                                selectedHospital = hospital.facilityName
                                showingPicker = false
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(hospital.facilityName)
                                            .foregroundColor(.primary)
                                        Text(hospital.city)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    if selectedHospital == hospital.facilityName {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search hospitals")
            .navigationTitle("Select Hospital")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showingPicker = false
                    }
                }
            }
        }
    }
    
    private func stateName(for abbreviation: String) -> String {
        let stateNames = [
            "MA": "Massachusetts",
            "RI": "Rhode Island",
            "CT": "Connecticut",
            "NH": "New Hampshire",
            "ME": "Maine",
            "VT": "Vermont"
        ]
        return stateNames[abbreviation] ?? abbreviation
    }
}
