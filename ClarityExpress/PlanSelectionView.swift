import SwiftUI

struct PlanSelectionView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState

    let plans: [Plan] = [
        Plan(name: "Basic", price: 119, description: "Foam wash & rinse, air dry, window scrubbing, light road grime removal", washesPerCycle: 4),
        Plan(name: "Premium", price: 149, description: "Includes Basic plus microfiber mitt scrub, heavy dirt & grime removal", washesPerCycle: 4),
        Plan(name: "Elite", price: 199, description: "Includes Premium plus towel dry and ceramic wax", washesPerCycle: 4)
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(plans) { plan in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(plan.name)
                                .font(.headline)
                            Text("$\(plan.price)/mo")
                            Text(plan.description)
                                .font(.subheadline)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Theme.background)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(appState.selectedPlan?.name == plan.name ? Theme.selection : Color.clear, lineWidth: 2)
                        )
                        .cornerRadius(12)
                        .shadow(color: Theme.selection.opacity(0.3), radius: 2, x: 0, y: 1)
                        .onTapGesture {
                            withAnimation {
                                appState.purchase(plan: plan)
                                dismiss()
                            }
                        }
                    }
                }
                .padding()
            }
            .background(Theme.background)
            .navigationTitle("Select Plan")
            .tint(Theme.accent)
        }
    }
}
