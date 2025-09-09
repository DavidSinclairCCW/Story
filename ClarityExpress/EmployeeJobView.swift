import SwiftUI
import PhotosUI
import MapKit
import FirebaseStorage

struct EmployeeJobView: View {
    @State private var job = Job(vehicle: Vehicle(year: "", make: "", model: "", color: ""))
    @State private var beforeItems: [PhotosPickerItem] = []
    @State private var afterItems: [PhotosPickerItem] = []
    @State private var eta: TimeInterval? = nil

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
                    if let eta = eta, job.status == .onTheWay {
                        Text("ETA: \(format(eta))")
                    }
                }

                Section(header: Text("Before Photos")) {
                    PhotosPicker("Select Photos", selection: $beforeItems, maxSelectionCount: 4, matching: .images)
                    Text("\(job.beforePhotoURLs.count)/4 uploaded")
                }

                Section(header: Text("After Photos")) {
                    PhotosPicker("Select Photos", selection: $afterItems, maxSelectionCount: 4, matching: .images)
                    Text("\(job.afterPhotoURLs.count)/4 uploaded")
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
                job.beforePhotoURLs = await uploadPhotos(items: beforeItems, folder: "before")
            }
        }
        .onChange(of: afterItems) { _ in
            Task {
                job.afterPhotoURLs = await uploadPhotos(items: afterItems, folder: "after")
            }
        }
    }

    func updateStatus(_ newStatus: JobStatus) {
        job.status = newStatus
        if newStatus == .onTheWay {
            fetchETA()
        }
        notifyUser(status: newStatus, eta: eta)
    }

    func notifyUser(status: JobStatus, eta: TimeInterval?) {
        // TODO: integrate messaging to inform the user of status and optional ETA
    }

    func fetchETA() {
        let request = MKDirections.Request()
        request.source = .forCurrentLocation()
        // Destination should be set based on job address
        // request.destination = ...
        MKDirections(request: request).calculateETA { response, _ in
            eta = response?.expectedTravelTime
        }
    }

    func uploadPhotos(items: [PhotosPickerItem], folder: String) async -> [URL] {
        var uploaded: [URL] = []
        for item in items {
            if let data = try? await item.loadTransferable(type: Data.self) {
                let path = "jobs/\(job.id.uuidString)/\(folder)/\(UUID().uuidString).jpg"
                let ref = Storage.storage().reference().child(path)
                do {
                    _ = try await ref.putDataAsync(data)
                    let url = try await ref.downloadURL()
                    uploaded.append(url)
                } catch {
                    print("Upload failed: \(error)")
                }
            }
        }
        return uploaded
    }

    func callDispatch() {
        if let url = URL(string: "tel://6195107939") {
            UIApplication.shared.open(url)
        }
    }

    func format(_ interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute]
        formatter.unitsStyle = .short
        return formatter.string(from: interval) ?? ""
    }
}

struct EmployeeJobView_Previews: PreviewProvider {
    static var previews: some View {
        EmployeeJobView()
    }
}
