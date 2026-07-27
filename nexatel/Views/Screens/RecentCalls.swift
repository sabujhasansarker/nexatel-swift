import SwiftUI

struct RecentCalls: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.brand.bg
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    CallHeader()

                    ScrollView {
                        VStack {
                            RecentCall()
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                ZStack {
                    Menus()
                }
                .padding(-15)
            }
        }
    }
}

#Preview {
    RecentCalls()
}
