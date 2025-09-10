import SwiftUI

struct PlanOption: Identifiable {
    let id = UUID()
    let planName: String
    let washesPerMonth: Int
    let pricePerWash: Double
    let monthlyPrice: Double
}

struct PlanSelectionView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState

    private let planDescriptions: [String: String] = [
        "Basic": "Foam wash & rinse, air dry, window scrubbing, light road grime removal",
        "Premium": "Includes Basic plus microfiber mitt scrub, heavy dirt & grime removal",
        "Elite": "Includes Premium plus towel dry and ceramic wax"
    ]

    private let options: [PlanOption] = [
        PlanOption(planName: "Basic", washesPerMonth: 1, pricePerWash: 45.0, monthlyPrice: 45.0),
        PlanOption(planName: "Basic", washesPerMonth: 2, pricePerWash: 40.0, monthlyPrice: 80.0),
        PlanOption(planName: "Basic", washesPerMonth: 4, pricePerWash: 29.75, monthlyPrice: 119.0),
        PlanOption(planName: "Premium", washesPerMonth: 1, pricePerWash: 50.0, monthlyPrice: 50.0),
        PlanOption(planName: "Premium", washesPerMonth: 2, pricePerWash: 45.0, monthlyPrice: 90.0),
        PlanOption(planName: "Premium", washesPerMonth: 4, pricePerWash: 37.25, monthlyPrice: 149.0),
        PlanOption(planName: "Elite", washesPerMonth: 1, pricePerWash: 60.0, monthlyPrice: 60.0),
        PlanOption(planName: "Elite", washesPerMonth: 2, pricePerWash: 55.0, monthlyPrice: 110.0),
        PlanOption(planName: "Elite", washesPerMonth: 4, pricePerWash: 49.75, monthlyPrice: 199.0)
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    headerRow
                    ForEach(options) { option in
                        row(for: option)
                    }
                }
                .padding()
            }
            .background(Theme.background)
            .navigationTitle("Select Plan")
            .tint(Theme.accent)
        }
    }

    private var headerRow: some View {
        HStack {
            Text("Plan")
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("Washes/Month")
                .frame(maxWidth: .infinity)
            Text("Price/Wash")
                .frame(maxWidth: .infinity)
            Text("Monthly")
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .font(.caption)
        .foregroundColor(.secondary)
    }

    @ViewBuilder
    private func row(for option: PlanOption) -> some View {
        let isSelected = appState.selectedPlan?.name == option.planName && appState.selectedPlan?.washesPerCycle == option.washesPerMonth
        HStack {
            Text(option.planName)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("\(option.washesPerMonth)")
                .frame(maxWidth: .infinity)
            Text(String(format: "$%.2f", option.pricePerWash))
                .frame(maxWidth: .infinity)
            Text(String(format: "$%.2f", option.monthlyPrice))
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(8)
        .background(Theme.background)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? Theme.selection : Color.clear, lineWidth: 2)
        )
        .cornerRadius(8)
        .onTapGesture {
            let description = planDescriptions[option.planName] ?? ""
            let plan = Plan(name: option.planName, price: Int(option.monthlyPrice), description: description, washesPerCycle: option.washesPerMonth)
            withAnimation {
                appState.purchase(plan: plan)
                dismiss()
            }
        }
    }
}
