import SwiftUI

struct Contact: View {
    var body: some View {
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
}

#Preview {
    Contact()
}
