import Foundation

struct ContactModel: Identifiable {
    let id = UUID()
    let name: String
    let phone: String
}
