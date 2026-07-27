import Foundation

enum CallType {
    case outgoing
    case missed
    case incoming
    case message
}

struct Call: Identifiable {
    let id = UUID()
    let name: String
    let number: String
    let time: Date
    let type: CallType
    let note: String?
}
