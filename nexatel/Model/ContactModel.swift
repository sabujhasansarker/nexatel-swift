import Foundation

struct ContactModel: Identifiable,Hashable {
    let id = UUID()
    let name: String
    let phone: String
}
