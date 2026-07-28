import SwiftUI
import Foundation

struct MenuItem: Identifiable {
    let id = UUID()
    let icon: String
    let screen: AppScreen
}

enum MenuData {
    static let items: [MenuItem] = [
        MenuItem(icon: "clock", screen: .recentCalls),
        MenuItem(icon: "person", screen: .profile),
        MenuItem(icon: "circle.grid.2x2", screen: .dialPad),
        MenuItem(icon: "gearshape", screen: .settings)
    ]
}

struct Menus: View {
    @Binding var activeScreen: AppScreen

    var body: some View {
        HStack {
            ForEach(MenuData.items) { item in
                menuButton(item: item)
            }
        }
        .padding(.leading, 10)
        .padding(.trailing, 12)
        .padding(.vertical, 10)
        .background(.white)
        .cornerRadius(230)
    }

    @ViewBuilder
    private func menuButton(item: MenuItem) -> some View {
        let isActive = activeScreen == item.screen

        Button {
            activeScreen = item.screen
        } label: {
            Image(systemName: item.icon)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundStyle(isActive ? .white : Color.brand.black)
        }
        .frame(width: 60, height: 60, alignment: .center)
        .background(isActive ? Color(red: 0.05, green: 0.69, blue: 0.45) : Color(red: 0.95, green: 0.96, blue: 0.98))
        .cornerRadius(130)
    }
}
