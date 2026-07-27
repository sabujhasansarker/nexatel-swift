import SwiftUI

struct SigninForm: View {
    var body: some View {
        // From
        VStack(spacing: 25){
            // Email
            VStack(alignment: .leading, spacing: 10) {
                Text("Email")
                    .font(.system(size: 18).weight(.medium))
                    .foregroundColor(Color(red: 0, green: 0.02, blue: 0.02))
                HStack(alignment: .center, spacing: 10) {
                    Image("mail")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.brand.gray500)
                    
                    TextField("Enter your email", text: .constant(""))
                        .cornerRadius(30)
                        .font(.poppins(size: 18))
                        .foregroundColor(.brand.gray)
                        .padding(.vertical, 15)
                }
                .padding(.horizontal, 20)
                .cornerRadius(270)
                .overlay(
                    RoundedRectangle(cornerRadius: 270)
                        .inset(by: 0.5)
                        .stroke(Color.brand.border, lineWidth: 1)
                )
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            // Password
            VStack(alignment: .leading, spacing: 10) {
                Text("Password")
                    .font(.system(size: 18).weight(.medium))
                    .foregroundColor(Color(red: 0, green: 0.02, blue: 0.02))
                HStack(alignment: .center, spacing: 10) {
                    Image("lock-keyhole")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.brand.gray500)
                    
                    SecureField("Enter your Password", text: .constant(""))
                        .cornerRadius(30)
                        .font(.poppins(size: 18))
                        .foregroundColor(.brand.gray)
                        .padding(.vertical, 15)
                        .submitLabel(.go)
                    Spacer()
                    Image("eye")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.brand.gray500)
                }
                .padding(.horizontal, 20)
                .cornerRadius(270)
                .overlay(
                    RoundedRectangle(cornerRadius: 270)
                        .inset(by: 0.5)
                        .stroke(Color.brand.border, lineWidth: 1)
                )
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            
            PrimaryButton(text: "Login"){
                
            }
            .padding(.top, -8)
        }
        .padding(.top, 30)
    }
}
