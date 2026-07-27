import Foundation

extension Call {
    static let sampleData: [Call] = [
        Call(name: "Mehedi Hasan", number: "5551234567", time: Date().addingTimeInterval(-60 * 5), type: .outgoing, note: "heading to the meeting now"),
        Call(name: "Ayesha Rahman", number: "5559876543", time: Date().addingTimeInterval(-60 * 40), type: .missed, note: nil),
        Call(name: "Rima Chowdhury", number: "5550123456", time: Date().addingTimeInterval(-60 * 55), type: .message, note: "sent you a document"),
        Call(name: "Tanvir Ahmed", number: "5552345678", time: Date().addingTimeInterval(-60 * 90), type: .incoming, note: nil),
        Call(name: "Nusrat Jahan", number: "5553456789", time: Date().addingTimeInterval(-60 * 60 * 3), type: .outgoing, note: "call me back please"),
        Call(name: "Rafiq Islam", number: "5554567890", time: Date().addingTimeInterval(-60 * 60 * 5), type: .missed, note: nil),
        Call(name: "Sadia Akter", number: "5555678901", time: Date().addingTimeInterval(-60 * 60 * 6), type: .message, note: "are we still meeting today?"),
        Call(name: "Imran Khan", number: "5556789012", time: Date().addingTimeInterval(-60 * 60 * 8), type: .incoming, note: nil),
        Call(name: "Farida Begum", number: "5557890123", time: Date().addingTimeInterval(-60 * 60 * 24), type: .outgoing, note: "on my way"),
        Call(name: "Shakil Ahmed", number: "5558901234", time: Date().addingTimeInterval(-60 * 60 * 26), type: .missed, note: nil),
        Call(name: "Nabila Sultana", number: "5559012345", time: Date().addingTimeInterval(-60 * 60 * 30), type: .message, note: "thanks for the update"),
        Call(name: "Kamal Uddin", number: "5551122334", time: Date().addingTimeInterval(-60 * 60 * 48), type: .incoming, note: nil),
        Call(name: "Sharmin Akter", number: "5552233445", time: Date().addingTimeInterval(-60 * 60 * 50), type: .outgoing, note: "see you soon"),
        Call(name: "Jahangir Alam", number: "5553344556", time: Date().addingTimeInterval(-60 * 60 * 72), type: .missed, note: nil),
        Call(name: "Tania Islam", number: "5554455667", time: Date().addingTimeInterval(-60 * 60 * 96), type: .message, note: "let's catch up soon")
    ]
}
