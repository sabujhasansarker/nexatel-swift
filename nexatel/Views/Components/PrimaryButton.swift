import SwiftUI

struct PrimaryButton: View {
    let text: String
    var action: () -> Void  = {}
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, minHeight: 60, alignment: .center)
        .background(Color.black)
        .clipShape(Capsule())
    }
}
