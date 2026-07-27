
import SwiftUI

struct Contact: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.brand.bg
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    CallHeader(search: true)

                    ScrollView {
                        VStack {
                            ContactList()
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
    Contact()
}
