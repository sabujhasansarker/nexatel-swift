import SwiftUI

struct Welcome: View {
    var body: some View {
            NavigationStack {
                ZStack {
                    Color.brand.bg
                        .ignoresSafeArea()
                    ScrollView {
                        VStack {
                            Image("nexatel-logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 90)
                                .padding(.top, 80)
                            
                            Text("Let's Get Started")
                                .font(.system(size: 30, weight: .medium))
                                .foregroundStyle(Color.brand.black)
                                .padding(.bottom, 10)
                            
                            Text("Experience smarter conversations with NexaTel")
                                .font(.system(size: 20))
                                .lineSpacing(6)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(Color.brand.gray)
                                .frame(maxWidth: 286)
                                .padding(.bottom, 10)
                            
                            PrimaryButton(text: "Sign up with email") {
                            }
                            
                            Text("or use instant signup")
                                .font(.system(size: 18))
                                .foregroundStyle(Color.brand.gray)
                                .padding(.top, 10)
                                .padding(.bottom, 10)
                            
                            VStack(spacing: 15){
                                SocialButton(title: "Sign up with Google", icon: "google") {
                                }
                                SocialButton(title: "Sign up with Apple", icon: "apple") {
                                }
                            }
                            
                            HStack{
                                Text("Already have an account?")
                                    .foregroundStyle(Color.brand.black)
                                NavigationLink(destination: Login()) {
                                    Text("Sign in")
                                        .foregroundStyle(Color.brand.primary)
                                }
                            }
                            .font(.system(size: 18, weight: .medium))
                        }
                    }
                    .padding()
            }
        }
    }
}

#Preview {
    Welcome()
}
