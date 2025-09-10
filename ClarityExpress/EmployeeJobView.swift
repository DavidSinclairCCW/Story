import SwiftUI
import PhotosUI
#if canImport(UIKit)
import UIKit
#endif

struct EmployeeJobView: View {
    @State private var job = Job(vehicle: Vehicle(year: "", make: "", model: "", color: ""))
    @State private var beforeItems: [PhotosPickerItem] = []
    @State private var afterItems: [PhotosPickerItem] = []

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

                Section(header: Text("Before Photos")) {
                    PhotosPicker("Select Photos", selection: $beforeItems, maxSelectionCount: 4, matching: .images)
                    Text("\(job.beforePhotos.count)/4 selected")
                }

                Section(header: Text("After Photos")) {
                    PhotosPicker("Select Photos", selection: $afterItems, maxSelectionCount: 4, matching: .images)
                    Text("\(job.afterPhotos.count)/4 selected")
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
        .onChange(of: beforeItems) { _ in
            Task {
                job.beforePhotos = await loadPhotos(items: beforeItems)
            }
        }
        .onChange(of: afterItems) { _ in
            Task {
                job.afterPhotos = await loadPhotos(items: afterItems)
            }
        }
    }

    func updateStatus(_ newStatus: JobStatus) {
        job.status = newStatus
        notifyUser(status: newStatus)
    }

    func notifyUser(status: JobStatus) {
        // TODO: integrate messaging to inform the user of status
    }

    func loadPhotos(items: [PhotosPickerItem]) async -> [Data] {
        var photos: [Data] = []
        for item in items {
            if let data = try? await item.loadTransferable(type: Data.self) {
                photos.append(data)
            }
        }
        return photos
    }

    func callDispatch() {
        if let url = URL(string: "tel://6195107939") {
            UIApplication.shared.open(url)
        }
    }
}

struct EmployeeJobView_Previews: PreviewProvider {
    static var previews: some View {
        EmployeeJobView()
    }
}
