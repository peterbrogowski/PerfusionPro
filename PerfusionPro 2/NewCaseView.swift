import SwiftUI
import SwiftData

struct NewCaseView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var newCase = Case()
    @State private var showingIncompleteAlert = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Required Information Banner
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.blue)
                        Text("Only Case ID is required. Fill in other details as they become available.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    // Case Information Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Case Information")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Case ID")
                                Image(systemName: "lock.fill")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(newCase.caseID)
                                    .foregroundStyle(.secondary)
                                    .fontWeight(.medium)
                            }
                            .padding(.vertical, 8)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text("UNOS ID")
                                    Text("(Optional)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                TextField("Enter when available", text: $newCase.unoxID)
                                    .textFieldStyle(.roundedBorder)
                                    .textInputAutocapitalization(.characters)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                    
                    // Hospitals Section
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("Hospitals")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Text("(Optional)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack(spacing: 16) {
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
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                    
                    // Team Members Section
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("Team Members")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Text("(Optional)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack(spacing: 12) {
                            TextField("OMPS 1 (Optional)", text: $newCase.omps1)
                                .textFieldStyle(.roundedBorder)
                                .textInputAutocapitalization(.words)
                            
                            TextField("OMPS 2 (Optional)", text: $newCase.omps2)
                                .textFieldStyle(.roundedBorder)
                                .textInputAutocapitalization(.words)
                            
                            TextField("Recovery Surgeon 1 (Optional)", text: $newCase.surgeon1)
                                .textFieldStyle(.roundedBorder)
                                .textInputAutocapitalization(.words)
                            
                            TextField("Recovery Surgeon 2 (Optional)", text: $newCase.surgeon2)
                                .textFieldStyle(.roundedBorder)
                                .textInputAutocapitalization(.words)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                    
                    // Initial Status Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Initial Status")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Picker("Status", selection: $newCase.status) {
                            ForEach(CaseStatus.allCases, id
