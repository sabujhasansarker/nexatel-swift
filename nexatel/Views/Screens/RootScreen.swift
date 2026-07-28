import SwiftUI

struct RootScreen: View {
    @State private var activeScreen: AppScreen = .recentCalls

    var body: some View {
        NavigationStack {
            ZStack {
                Color.brand.bg
                    .ignoresSafeArea()

                currentContent
                Spacer().frame(height: 120)
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Menus(activeScreen: $activeScreen).padding(.bottom, -15)
        }
    }

    @ViewBuilder
    private var currentContent: some View {
        switch activeScreen {
        case .recentCalls:
            RecentCalls()
        case .dialPad:
            DialPad()
        case .profile:
            Contact()
        case .settings:
            Settings()
        }
    }
}

#Preview {
    RootScreen()
}
