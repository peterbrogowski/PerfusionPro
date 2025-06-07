import SwiftUI

struct CaseDetailView: View {
    @Environment(\.modelContext) private var modelContext  // Add this line
    let perfusionCase: Case
    
    var body: some View {
        List {
            Section("Case Information") {
                DetailRow(label: "Case ID", value: perfusionCase.caseID)
                DetailRow(label: "UNOS ID", value: perfusionCase.unosID)
                DetailRow(label: "Status", value: perfusionCase.status.rawValue)
                DetailRow(label: "Duration", value: perfusionCase.formattedDuration)
            }
            
            Section("Hospitals") {
                DetailRow(label: "Donor Hospital", value: perfusionCase.donorHospital)
                DetailRow(label: "Transplant Center", value: perfusionCase.transplantCenter)
            }
            
            Section("Team") {
                if !perfusionCase.omps1.isEmpty {
                    DetailRow(label: "OMPS 1", value: perfusionCase.omps1)
                }
                if !perfusionCase.omps2.isEmpty {
                    DetailRow(label: "OMPS 2", value: perfusionCase.omps2)
                }
                if !perfusionCase.surgeon1.isEmpty {
                    DetailRow(label: "Surgeon 1", value: perfusionCase.surgeon1)
                }
                if !perfusionCase.surgeon2.isEmpty {
                    DetailRow(label: "Surgeon 2", value: perfusionCase.surgeon2)
                }
            }
            
            Section("Actions") {
                NavigationLink {
                    Text("Timing Entry Coming Soon")
                } label: {
                    Label("Enter Timing Data", systemImage: "clock")
                }
                
                // Replace the placeholder with the actual MedicationView
                NavigationLink {
                    MedicationView(modelContext: modelContext, currentCase: perfusionCase)
                } label: {
                    Label("Enter Medications", systemImage: "pills")
                }
                
                NavigationLink {
                    Text("Parameters Entry Coming Soon")
                } label: {
                    Label("Enter Parameters", systemImage: "chart.line.uptrend.xyaxis")
                }
            }
        }
        .navigationTitle("Case Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}
