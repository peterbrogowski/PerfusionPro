import SwiftUI

struct MedicationStatisticsCard: View {
    let perfusionCase: Case
    
    var totalMedications: Int {
        perfusionCase.medications?.count ?? 0
    }
    
    var activeMedications: Int {
        perfusionCase.medications?.filter { $0.isActive }.count ?? 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Statistics")
                .font(.headline)
            
            HStack(spacing: 20) {
                StatItem(
                    title: "Total Meds",
                    value: "\(totalMedications)",
                    icon: "pills.fill"
                )
                
                StatItem(
                    title: "Active",
                    value: "\(activeMedications)",
                    icon: "waveform.path.ecg",
                    color: .green
                )
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct StatItem: View {
    let title: String
    let value: String
    let icon: String
    var color: Color = .blue
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Label(title, systemImage: icon)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.title2.bold())
                .foregroundColor(color)
        }
    }
}
