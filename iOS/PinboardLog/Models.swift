import Foundation

struct PinEntry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var setName: String
    var boardPosition: String
    var acquiredDate: String
    var notes: String = ""
    var createdAt: Date = Date()
}
