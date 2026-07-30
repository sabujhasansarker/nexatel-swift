import SwiftUI

struct RootScreen: View {

    @State private var activeScreen: AppScreen = .recentCalls

    var body: some View {

        NavigationStack {

            ZStack {

                Color.brand.bg
                    .ignoresSafeArea()

                content
            }
            .safeAreaInset(edge: .bottom) {

                Menus(activeScreen: $activeScreen)
                    .padding(.bottom, -15)
            }
        }
    }


    @ViewBuilder
    private var content: some View {

        switch activeScreen {

        case .recentCalls:
            RecentCalls()

        case .profile:
            Contact()

        case .dialPad:
            DialPad()

        case .settings:
            Settings()
        }
    }
}


#Preview {
    RootScreen()
}
