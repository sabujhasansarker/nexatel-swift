import SwiftUI

struct RecentCalls: View {

    var body: some View {

        VStack(spacing: 0) {

            CallHeader()

            ScrollView {

                RecentCall()
                    .padding(.horizontal)

            }
        }
    }
}
