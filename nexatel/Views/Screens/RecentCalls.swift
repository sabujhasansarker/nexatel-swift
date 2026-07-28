import SwiftUI

struct RecentCalls: View {
    var body: some View {
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
}

#Preview {
    RecentCalls()
}
