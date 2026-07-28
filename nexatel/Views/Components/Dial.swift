import SwiftUI

struct Dial: View {
    let rows = [
        [("1", ""), ("2", ""), ("3", "")],
        [("4", ""), ("5", ""), ("6", "")],
        [("7", ""), ("8", ""), ("9", "")],
        [("*", ""), ("0", "+"), ("#", "")]
    ]
    
    @State private var dialedNumber: String = ""
    
    var body: some View {
        VStack {
            Text(dialedNumber.isEmpty ? " " : dialedNumber)
                .font(.poppins(size: 35, .medium))
                .foregroundStyle(Color.brand.black)
                .frame(height: 30)
    
            Button(action: {
                print("Add \(dialedNumber) to contacts")
            }) {
                Text(dialedNumber.isEmpty ? "" : "Add number")
                    .font(.poppins(size: 18, .medium))
                    .foregroundStyle(Color.brand.gray)
                    .frame(height: 40)
            }
            .disabled(dialedNumber.isEmpty)
            
            // Dial Pad Layout
            VStack(spacing: 10) {
                ForEach(0..<rows.count, id: \.self) { rowIndex in
                    HStack(spacing: 15) {
                        ForEach(0..<rows[rowIndex].count, id: \.self) { colIndex in
                            let item = rows[rowIndex][colIndex]
                            
                            VStack(spacing: -2) {
                                Text(item.0)
                                    .font(.poppins(size: 35, .medium))
                                if !item.1.isEmpty {
                                    Text(item.1)
                                        .font(.poppins(size: 15, .medium))
                                }
                            }
                            .foregroundStyle(.black)
                            .frame(width: 80, height: 80)
                            .background(Color.brand.border.opacity(0.5))
                            .clipShape(Circle())
                            .contentShape(Circle())
                            .onTapGesture {
                                dialedNumber.append(item.0)
                            }
                            .onLongPressGesture(minimumDuration: 0.5) {
                                if !item.1.isEmpty {
                                    dialedNumber.append(item.1)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.top, 25)
            
            // Action Controls Layout Container
            HStack(spacing: 0) {
                // Spacer pushes center buttons to align properly with the backspace icon layout
                Spacer()
                    .frame(width: 40)
                
                HStack(spacing: 2) {
                    bottomBtn(
                        title: "Call",
                        backgroundColor: Color.brand.black,
                        textColor: .white,
                        isLeftButton: true,
                        action: { print("Calling: \(dialedNumber)") }
                    )
                    
                    bottomBtn(
                        title: "Message",
                        backgroundColor: .white,
                        textColor: Color.brand.black,
                        isLeftButton: false,
                        action: { print("Messaging: \(dialedNumber)") }
                    )
                }
                
                // Interactive Backspace button
                Button(action: {
                    if !dialedNumber.isEmpty {
                        dialedNumber.removeLast()
                    }
                }) {
                    Image(systemName: "delete.backward")
                        .foregroundStyle(Color.brand.black)
                        .font(.system(size: 25))
                        .padding(.leading, 15)
                }
                .frame(width: 40)
                .opacity(dialedNumber.isEmpty ? 0 : 1) // Clean visual tap target state control
                .animation(.easeInOut(duration: 0.2), value: dialedNumber.isEmpty)
            }
            .padding(.top, 50)
            .padding(.horizontal, 20)
        }
        .padding(.top, 20)
    }
    
    @ViewBuilder
    private func bottomBtn(
        title: String,
        backgroundColor: Color,
        textColor: Color,
        isLeftButton: Bool,
        action: @escaping () -> Void
    ) -> some View {
        let buttonShape = UnevenRoundedRectangle(
            topLeadingRadius: isLeftButton ? 1000 : 0,
            bottomLeadingRadius: isLeftButton ? 1000 : 0,
            bottomTrailingRadius: isLeftButton ? 0 : 1000,
            topTrailingRadius: isLeftButton ? 0 : 1000
        )
        
        Button(action: action) {
            Text(title)
                .font(.poppins(size: 18, .medium))
                .foregroundColor(textColor)
                .padding(.horizontal, 35)
                .padding(.vertical, 15)
                .background(backgroundColor)
                .clipShape(buttonShape)
                .contentShape(buttonShape)
        }
    }
}
