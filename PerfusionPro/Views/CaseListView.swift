import SwiftUI
import SwiftData

struct CaseListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Case.dateCreated, order: .reverse) private var cases: [Case]
    @State private var showingNewCase = false
    
    var body: some View {
        NavigationStack {
            List {
                if cases.isEmpty {
                    ContentUnavailableView {
                        Label("No Cases Yet", systemImage: "folder")
                    } description: {
                        Text("Tap the + button to create your first case")
                    }
                    .listRowBackground(Color.clear)
                } else {
                    ForEach(cases) { perfusionCase in
                        NavigationLink {
                            CaseDetailView(perfusionCase: perfusionCase)
                        } label: {
                            CaseRowView(perfusionCase: perfusionCase)
                        }
                    }
                    .onDelete(perform: deleteCases)
                }
            }
            .navigationTitle("Perfusion Cases")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingNewCase = true
                    } label: {
                        Label("New Case", systemImage: "plus.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $showingNewCase) {
                NewCaseView()
            }
        }
    }
    
    private func deleteCases(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(cases[index])
            }
        }
    }
}

// Individual row in the list
struct CaseRowView: View {
    let perfusionCase: Case
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(perfusionCase.caseID)
                    .font(.headline)
                Spacer()
                StatusBadge(status: perfusionCase.status)
            }
            
            if !perfusionCase.unosID.isEmpty {
                Text("UNOS: \(perfusionCase.unosID)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            HStack {
                Label(perfusionCase.formattedDuration, systemImage: "clock")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text(perfusionCase.dateCreated, style: .date)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

// Status indicator badge
struct StatusBadge: View {
    let status: CaseStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(Color(status.color).opacity(0.2))
            .foregroundColor(Color(status.color))
            .clipShape(Capsule())
    }
}
