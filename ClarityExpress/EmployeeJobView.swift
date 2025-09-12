import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct EmployeeJobView: View {
    @State private var job = Job(vehicle: Vehicle(year: "", make: "", model: "", color: ""))

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Status")) {
                    Text("Current: \(job.status.rawValue.capitalized)")
                    if job.status == .pending {
                        Button("On The Way") { updateStatus(.onTheWay) }
                            .buttonStyle(PillButtonStyle())
                    } else if job.status == .onTheWay {
                        Button("Arrived") { updateStatus(.arrived) }
                            .buttonStyle(PillButtonStyle())
                    } else if job.status == .arrived {
                        Button("Service Completed") { updateStatus(.completed) }
                            .buttonStyle(PillButtonStyle())
                    }
                }

                Section {
                    Button("Call Dispatch") { callDispatch() }
                        .buttonStyle(PillButtonStyle())
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Theme.background)
            .navigationTitle("Job")
            .tint(Theme.accent)
        }
    }

    func updateStatus(_ newStatus: JobStatus) {
        job.status = newStatus
        notifyUser(status: newStatus)
    }

    func notifyUser(status: JobStatus) {
        // TODO: integrate messaging to inform the user of status
    }

    @MainActor
    func callDispatch() {
        #if canImport(UIKit)
        if let url = URL(string: "tel://6195107939") {
            UIApplication.shared.open(url)
        }
        #else
        print("Dispatch: 619-510-7939")
        #endif
    }
}

struct EmployeeJobView_Previews: PreviewProvider {
    static var previews: some View {
        EmployeeJobView()
    }
}
