import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

@main
struct ClarityExpressApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            if appState.user.role == .employee {
                EmployeeJobView()
                    .environmentObject(appState)
            } else {
                ContentView()
                    .environmentObject(appState)
            }
        }
    }
}

final class AppState: ObservableObject {
    @Published var user: User = User()
    @Published var selectedVehicleIndex: Int = 0
    @Published var selectedPlan: Plan? = nil
    @Published var washesUsed: Int = 0

    var washesRemaining: Int {
        guard let plan = selectedPlan else { return 0 }
        return max(plan.washesPerCycle - washesUsed, 0)
    }

    func purchase(plan: Plan) {
        selectedPlan = plan
        washesUsed = 0
    }

    func requestWash() {
        guard let plan = selectedPlan,
              user.vehicles.indices.contains(selectedVehicleIndex) else { return }
        let vehicle = user.vehicles[selectedVehicleIndex]
        let subject = "Wash Request"
        let body = "User: \(user.firstName) \(user.lastName)\nPlan: \(plan.name)\nVehicle: \(vehicle.description)"
        let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "mailto:support@claritycarwashing.com?subject=\(subject)&body=\(encodedBody)"
        #if canImport(UIKit)
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
        #else
        print("Would send email: \(urlString)")
        #endif
        washesUsed += 1
    }
}
