import SwiftUI

struct DialPad: View {

    var body: some View {
        VStack(spacing: 0) {
            CallHeader()

            VStack {
                Dial()
            }

            ScrollView {
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    DialPad()
}
