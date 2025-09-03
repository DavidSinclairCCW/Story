import SwiftUI

struct VehicleFormView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState

    @State private var year = ""
    @State private var make = ""
    @State private var model = ""
    @State private var color = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("Year", text: $year)
                TextField("Make", text: $make)
                TextField("Model", text: $model)
                TextField("Color", text: $color)
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Theme.background)
            .navigationTitle("Add Vehicle")
            .tint(Theme.accent)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let vehicle = Vehicle(year: year, make: make, model: model, color: color)
                        appState.user.vehicles.append(vehicle)
                        dismiss()
                    }
                    .buttonStyle(PillButtonStyle())
                }
            }
        }
    }
}
