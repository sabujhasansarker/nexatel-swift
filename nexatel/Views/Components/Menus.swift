import SwiftUI

struct MenuItem: Identifiable {
    var id: AppScreen { screen }
    let icon: String
    let screen: AppScreen
}

enum MenuData {
    static let items: [MenuItem] = [
        .init(icon: "clock", screen: .recentCalls),
        .init(icon: "person", screen: .profile),
        .init(icon: "circle.grid.2x2", screen: .dialPad),
        .init(icon: "gearshape", screen: .settings)
    ]
}

struct Menus: View {

    @Binding var activeScreen: AppScreen

    var body: some View {
        HStack(spacing: 10) {

            ForEach(MenuData.items) { item in

                Button {
                    activeScreen = item.screen
                } label: {

                    Image(systemName: item.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(
                            activeScreen == item.screen
                            ? .white
                            : Color.brand.black
                        )
                }
                .frame(width: 60, height: 60)
                .background(
                    activeScreen == item.screen
                    ? Color(red: 0.05, green: 0.69, blue: 0.45)
                    : Color(red: 0.95, green: 0.96, blue: 0.98)
                )
                .clipShape(Circle())
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(.white)
        .clipShape(Capsule())
    }
}
