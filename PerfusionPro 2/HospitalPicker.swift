import SwiftUI

struct HospitalPicker: View {
    @Binding var selectedHospital: String
    @State private var searchText = ""
    @State private var showingPicker = false
    @StateObject private var hospitalService = CMSHospitalService()
    
    var body: some View {
        Button(action: { showingPicker = true }) {
            HStack {
                Text(selectedHospital.isEmpty ? "Select Hospital" : selectedHospital)
                    .foregroundColor(selectedHospital.isEmpty ? .gray : .primary)
                    .lineLimit(1)
                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
        .sheet(isPresented: $showingPicker) {
            HospitalSelectionSheet(
                selectedHospital: $selectedHospital,
                showingPicker: $showingPicker,
                hospitalService: hospitalService
            )
        }
    }
}

struct HospitalSelectionSheet: View {
    @Binding var selectedHospital: String
    @Binding var showingPicker: Bool
    @ObservedObject var hospitalService: CMSHospitalService
    @State private var searchText = ""
    
    var filteredHospitals: [Hospital] {
        if searchText.isEmpty {
            return hospitalService.hospitals
        } else {
            return hospitalService.hospitals.filter {
                $0.searchableText.contains(searchText.lowercased())
            }
        }
    }
    
    var groupedHospitals: [(key: String, value: [Hospital])] {
        if searchText.isEmpty {
            // Group by state when not searching
            let grouped = Dictionary(grouping: filteredHospitals) { $0.state }
            return grouped.sorted { $0.key < $1.key }
        } else {
            // Don't group when searching
            return [("Search Results", filteredHospitals)]
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search bar - pinned at top
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("Search hospitals", text: $searchText)
                        .textFieldStyle(.plain)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding()
                
                // Hospital list
                if hospitalService.isLoading {
                    Spacer()
                    ProgressView("Loading hospitals...")
                    Spacer()
                } else if hospitalService.hospitals.isEmpty {
                    Spacer()
                    VStack(spacing: 20) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text("No hospitals loaded")
                        Button("Retry") {
                            hospitalService.loadHospitals()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    Spacer()
                } else {
                    // Main scrollable list
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 0, pinnedViews: []) {
                            ForEach(groupedHospitals, id: \.key) { state, hospitals in
                                // State header
                                Text(stateName(for: state))
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color(.systemGray5))
                                
                                // Hospitals in this state
                                ForEach(hospitals) { hospital in
                                    Button(action: {
                                        selectedHospital = hospital.hospitalName
                                        showingPicker = false
                                    }) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(hospital.hospitalName)
                                                    .foregroundColor(.primary)
                                                    .multilineTextAlignment(.leading)
                                                Text("\(hospital.city), \(hospital.state)")
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                            
                                            Spacer()
                                            
                                            if selectedHospital == hospital.hospitalName {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(.blue)
                                            }
                                        }
                                        .padding(.horizontal)
                                        .padding(.vertical, 12)
                                    }
                                    .buttonStyle(.plain)
                                    
                                    Divider()
                                        .padding(.leading)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select Hospital")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showingPicker = false
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    if !hospitalService.hospitals.isEmpty {
                        Text("\(filteredHospitals.count) hospitals")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
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
