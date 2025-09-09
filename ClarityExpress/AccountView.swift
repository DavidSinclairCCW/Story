import SwiftUI

struct AccountView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingVehicleForm = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("User Information")) {
                    TextField("First Name", text: $appState.user.firstName)
                    TextField("Last Name", text: $appState.user.lastName)
                    TextField("Phone", text: $appState.user.phone)
                    TextField("Email", text: $appState.user.email)
                    TextField("Address", text: $appState.user.address)
                }

                Section(header: Text("Plan")) {
                    if let plan = appState.selectedPlan {
                        Text("\(plan.name) - $\(plan.price)/mo")
                        Button("Change Plan") { showingVehicleForm = false }
                            .buttonStyle(PillButtonStyle())
                    } else {
                        Button("Select Plan") { showingVehicleForm = false }
                            .buttonStyle(PillButtonStyle())
                    }
                }

                Section(header: Text("Vehicles")) {
                    ForEach(appState.user.vehicles.indices, id: \.self) { index in
                        Text(appState.user.vehicles[index].description)
                            .padding(8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(appState.selectedVehicleIndex == index ? Theme.selection.opacity(0.3) : Color.clear)
                            .cornerRadius(8)
                            .onTapGesture {
                                withAnimation { appState.selectedVehicleIndex = index }
                            }
                    }
                    Button("Add Vehicle") { showingVehicleForm = true }
                        .buttonStyle(PillButtonStyle())
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Theme.background)
            .navigationTitle("Account")
            .tint(Theme.accent)
            .sheet(isPresented: $showingVehicleForm) {
                VehicleFormView()
                    .environmentObject(appState)
            }
        }
    }
}
