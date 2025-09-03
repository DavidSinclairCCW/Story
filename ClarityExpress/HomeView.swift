import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingPlanSheet = false
    @State private var showingVehicleSheet = false
    @State private var washRequested = false

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                if let plan = appState.selectedPlan {
                    Text("Current Plan: \(plan.name)")
                    HStack {
                        Text("Washes Remaining: ")
                        RollingNumberView(value: appState.washesRemaining)
                        Text("/\(plan.washesPerCycle)")
                    }
                } else {
                    Button("Select Plan") { showingPlanSheet = true }
                        .buttonStyle(PillButtonStyle())
                }

                if appState.user.vehicles.indices.contains(appState.selectedVehicleIndex) {
                    let vehicle = appState.user.vehicles[appState.selectedVehicleIndex]
                    Text("Vehicle: \(vehicle.description)")
                } else {
                    Button("Add Vehicle") { showingVehicleSheet = true }
                        .buttonStyle(PillButtonStyle())
                }

                Button("Request Wash") {
                    withAnimation {
                        appState.requestWash()
                        washRequested = true
                    }
                }
                .disabled(appState.selectedPlan == nil || appState.user.vehicles.isEmpty || appState.washesRemaining == 0)
                .buttonStyle(PillButtonStyle())
                .alert("Wash Requested!", isPresented: $washRequested) {
                    Button("OK", role: .cancel) { }
                }

                Spacer()
            }
            .padding()
            .background(Theme.background)
            .navigationTitle("Clarity Express")
            .tint(Theme.accent)
            .sheet(isPresented: $showingPlanSheet) {
                PlanSelectionView()
                    .environmentObject(appState)
            }
            .sheet(isPresented: $showingVehicleSheet) {
                VehicleFormView()
                    .environmentObject(appState)
            }
        }
    }
}
