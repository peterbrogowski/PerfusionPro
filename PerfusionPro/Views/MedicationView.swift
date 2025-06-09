import SwiftUI
import SwiftData

struct MedicationView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var medicationManager: MedicationManager
    @State private var selectedTab = 0
    @State private var showingAddMedication = false
    @State private var selectedMedicationType: MedicationType?
    
    let currentCase: Case
    
    init(modelContext: ModelContext, currentCase: Case) {
        self.currentCase = currentCase
        self._medicationManager = StateObject(wrappedValue: MedicationManager(modelContext: modelContext))
    }
    
    var body: some View {
        VStack {
            // Tab selector
            Picker("Medication Type", selection: $selectedTab) {
                Text("Bolus").tag(0)
                Text("Infusion").tag(1)
                Text("Flush").tag(2)
                Text("PRN").tag(3)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            // Medication list
            List {
                ForEach(filteredMedications) { medication in
                    // Inline row view instead of MedicationRowView
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
                .onDelete(perform: deleteMedications)
            }
            
            // Add button
            Button(action: {
                // Set medication type based on selected tab
                switch selectedTab {
                case 0:
                    selectedMedicationType = .bolus
                case 1:
                    selectedMedicationType = .infusion
                case 2:
                    selectedMedicationType = .flush
                case 3:
                    selectedMedicationType = .prn
                default:
                    selectedMedicationType = .bolus
                }
                
                // Small delay to ensure state is set
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    showingAddMedication = true
                }
            }){
                Label("Add Medication", systemImage: "plus.circle.fill")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("Medications")
        .sheet(isPresented: $showingAddMedication) {
            if let type = selectedMedicationType {
                AddMedicationSheet(currentCase: currentCase, type: type)
            }
        }
        .onChange(of: showingAddMedication) { oldValue, newValue in
            if !newValue {  // Sheet just closed
                medicationManager.fetchMedications()
            }
        }
        .onAppear {
            medicationManager.currentCase = currentCase
            medicationManager.fetchMedications()
        }
    }
            
            var filteredMedications: [PerfusionMedication] {
                let allMedications = medicationManager.medications(for: currentCase)
                let typeString = medicationTypeFromTab(selectedTab).rawValue
                return allMedications.filter { $0.medicationType == typeString }
            }
            
            func medicationTypeFromTab(_ tab: Int) -> MedicationType {
                switch tab {
                case 0: return .bolus
                case 1: return .infusion
                case 2: return .flush
                case 3: return .prn
                default: return .bolus
                }
            }
            
            func deleteMedications(at offsets: IndexSet) {
                for index in offsets {
                    let medications = medicationManager.medications(for: currentCase)
                    if medications.indices.contains(index) {
                        let medication = medications[index]
                        medicationManager.deleteMedication(medication)
                    }
                }
            }
        }
    
