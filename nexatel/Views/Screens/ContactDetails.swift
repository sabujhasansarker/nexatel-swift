import SwiftUI

struct ContactDetails: View {
    let contact: ContactModel

    var body: some View {
        ZStack {
            Color.brand.bg
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack(alignment: .center, spacing: 20) {
                    Image("user-image")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 15) {
                        Text(contact.name)
                            .font(.poppins(size: 22, .medium))
                            .foregroundColor(Color.brand.black)

                        Text(contact.phone)
                            .font(.poppins(size: 18))
                            .foregroundStyle(Color.brand.gray)
                    }

                    Spacer()
                }
                .padding(.top, 20)
                .padding(.horizontal)
                .padding(.bottom, 25)
                
                // email, phone, message
                HStack{
                    actionButton(icon: "phone", label: "Phone", isPrimary: true) {
                    }

                    actionButton(icon: "ellipsis.message", label: "Message") {
                    }

                    actionButton(icon: "at", label: "Email") {
                    }
                }
                // End
                Spacer()
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                } label: {
                    Text("Edit")
                        .font(.poppins(size: 16, .medium))
                        .foregroundColor(Color.brand.black)
                }
            }
        }
    }
    
    @ViewBuilder
    private func actionButton(icon: String, label: String, isPrimary: Bool = false,action: @escaping () -> Void) -> some View {
        Button (action: action){
            HStack(alignment: .center, spacing: 5) {
                Image(systemName: icon)
                  .frame(width: 20, height: 20)
                Text(label)
                    .font(.poppins(size: 16, .medium))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .background(isPrimary ? Color.brand.black : Color.brand.border)
            .foregroundColor(isPrimary ? .white : Color.brand.black)
            .cornerRadius(180)
        }
    }
}

#Preview {
    ContactDetails(contact: ContactModel.sampleData[0])
}
