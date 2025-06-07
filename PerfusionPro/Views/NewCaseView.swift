import SwiftUI
import SwiftData

struct NewCaseView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var newCase = Case()
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Case Information") {
                    HStack {
                        Text("Case ID")
                        Spacer()
                        Text(newCase.caseID)
                            .foregroundStyle(.secondary)
                    }
                    
                    TextField("UNOS ID", text: $newCase.unosID)
                        .textInputAutocapitalization(.characters)
                }
                
                Section("Hospitals") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Donor Hospital")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        HospitalPicker(selectedHospital: $newCase.donorHospital)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Transplant Center")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        HospitalPicker(selectedHospital: $newCase.transplantCenter)
                    }
                }
                
                Section("Team Members") {
                    TextField("OMPS 1", text: $newCase.omps1)
                    TextField("OMPS 2", text: $newCase.omps2)
                    TextField("Recovery Surgeon 1", text: $newCase.surgeon1)
                    TextField("Recovery Surgeon 2", text: $newCase.surgeon2)
                }
                
                Section("Initial Status") {
                    Picker("Status", selection: $newCase.status) {
                        ForEach(CaseStatus.allCases, id: \.self) { status in
                            Text(status.rawValue).tag(status)
                        }
                    }
                }
            }
            .navigationTitle("New Case")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        createCase()
                    }
                    .fontWeight(.semibold)
                    .disabled(newCase.unosID.isEmpty)
                }
            }
        }
    }
    
    private func createCase() {
        modelContext.insert(newCase)
        dismiss()
    }
}
