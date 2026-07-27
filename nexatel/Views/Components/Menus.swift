import SwiftUI

struct MenuItem: Identifiable {
    let id = UUID()
    let icon: String
    var isActive: Bool = false
}

enum MenuData {
    static let items: [MenuItem] = [
        MenuItem(icon: "clock", isActive: true),
        MenuItem(icon: "circle-user-round"),
        MenuItem(icon: "settings")
    ]
}

struct Menus: View {
    var body: some View {
        HStack {
            ForEach(MenuData.items) { item in
                Button{}
                label: {
                    Image(item.icon)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(item.isActive ? .white : Color.brand.black)
                }
                .frame(width: 60, height: 60, alignment: .center)
                .background(item.isActive ? Color(red: 0.05, green: 0.69, blue: 0.45) : Color(red: 0.95, green: 0.96, blue: 0.98))
                .cornerRadius(130)
            }
        }
        .padding(.leading, 10)
        .padding(.trailing, 12)
        .padding(.vertical, 10)
        .background(.white)
        .cornerRadius(230)
    }
}
