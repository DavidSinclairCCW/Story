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
    /// Raw data for before-service photos stored locally
    var beforePhotos: [Data] = []
    /// Raw data for after-service photos stored locally
    var afterPhotos: [Data] = []
}
