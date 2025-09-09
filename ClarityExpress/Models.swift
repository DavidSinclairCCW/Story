import Foundation

struct Plan: Identifiable, Codable, Equatable {
    let id = UUID()
    let name: String
    let price: Int
    let description: String
    let washesPerCycle: Int
}

struct Vehicle: Identifiable, Codable {
    let id = UUID()
    var year: String
    var make: String
    var model: String
    var color: String

    var description: String {
        "\(year) \(make) \(model) - \(color)"
    }
}

struct User: Codable {
    enum Role: String, Codable {
        case customer
        case employee
    }

    var firstName: String = ""
    var lastName: String = ""
    var phone: String = ""
    var email: String = ""
    var address: String = ""
    var vehicles: [Vehicle] = []
    var role: Role = .customer
}

enum JobStatus: String, Codable, CaseIterable {
    case pending
    case onTheWay
    case arrived
    case completed
}

struct Job: Identifiable, Codable {
    let id = UUID()
    var vehicle: Vehicle
    var status: JobStatus = .pending
    /// Download URLs for before-service photos stored in Firebase Storage
    var beforePhotoURLs: [URL] = []
    /// Download URLs for after-service photos stored in Firebase Storage
    var afterPhotoURLs: [URL] = []
}
