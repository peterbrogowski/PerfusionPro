import SwiftUI
import SwiftData

struct MedicationSummaryView: View {
    let perfusionCase: Case  // Changed from PerfusionCase to Case
    @StateObject private var exportManager = ExportManager()
    @State private var showingExportOptions = false
    @State private var exportFormat: ExportFormat = .pdf
    
    var medicationsByType: [String: [PerfusionMedication]] {
        guard let medications = perfusionCase.medications else { return [:] }
        return Dictionary(grouping: medications) { $0.medicationType }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Medication Summary")
                        .font(.largeTitle.bold())
                    
                    HStack {
                        Label("\(perfusionCase.dateCreated.formatted(date: .abbreviated, time: .shortened))",
                              systemImage: "calendar")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                // Summary Statistics
                MedicationStatisticsCard(perfusionCase: perfusionCase)
                    .padding(.horizontal)
                
                // Medications by Type
                ForEach(["bolus", "infusion", "flush", "prn"], id: \.self) { type in
                    if let meds = medicationsByType[type], !meds.isEmpty {
                        MedicationTypeSection(
                            type: type,
                            medications: meds
                        )
                    }
                }
                
                // Export Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Export Options")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    HStack(spacing: 12) {
                        Button(action: {
                            exportFormat = .pdf
                            showingExportOptions = true
                        }) {
                            Label("PDF Report", systemImage: "doc.fill")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            exportFormat = .csv
                            showingExportOptions = true
                        }) {
                            Label("CSV Data", systemImage: "tablecells")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Export") {
                    showingExportOptions = true
                }
            }
        }
        .sheet(isPresented: $showingExportOptions) {
            NavigationView {
                ExportOptionsView(
                    exportManager: exportManager,
                    perfusionCase: perfusionCase,
                    format: exportFormat
                )
            }
        }
    }
}

// Helper view for medication type sections
struct MedicationTypeSection: View {
    let type: String
    let medications: [PerfusionMedication]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(type.capitalized)
                .font(.headline)
                .padding(.horizontal)
            
            ForEach(medications) { medication in
                MedicationRowView(medication: medication)
                    .padding(.horizontal)
            }
        }
    }
}

// Medication row view
struct MedicationRowView: View {
    let medication: PerfusionMedication
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(medication.medicationName)
                    .font(.headline)
                Spacer()
                if medication.medicationType == MedicationType.infusion.rawValue {
                    Text(medication.isActive ? "Active" : "Completed")
                        .font(.caption)
                        .foregroundColor(medication.isActive ? .green : .gray)
                }
            }
            
            HStack {
                Text("\(medication.dose) \(medication.unit)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("• \(medication.dateTimeAdministered, style: .time)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

// Export options view
struct ExportOptionsView: View {
    let exportManager: ExportManager
    let perfusionCase: Case
    let format: ExportFormat
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Export \(format == .pdf ? "PDF" : "CSV")")
                .font(.title2.bold())
            
            if exportManager.isExporting {
                ProgressView("Exporting...")
                    .padding()
            } else {
                Button("Export Now") {
                    Task {
                        if format == .pdf {
                            await exportManager.exportToPDF(
                                medications: perfusionCase.medications ?? [],
                                caseInfo: perfusionCase
                            )
                        } else {
                            let csvData = await exportManager.exportToCSV(
                                medications: perfusionCase.medications ?? [],
                                caseInfo: perfusionCase
                            )
                            // Handle CSV data (save to file, share, etc.)
                            print("CSV Data Generated")
                        }
                        dismiss()
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .navigationTitle("Export")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
}
