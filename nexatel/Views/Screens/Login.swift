import SwiftUI

struct Login: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedTab: FormTab = .signIn

    enum FormTab {
        case signIn, signUp
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.brand.bg
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    CustomNavHeader(
                        title: "Join with us",
                        detail: "Step 2 of 3",
                        onBack: { dismiss() }
                    )

                    ScrollView {
                        VStack {
                            // from and tab start
                            HStack(spacing: 7) {
                                tabButton(title: "Sign In", tab: .signIn)
                                tabButton(title: "Sign up", tab: .signUp)
                            }
                            .padding(7)
                            .frame(maxWidth: 346, minHeight: 70)
                            .background(Color(red: 0.95, green: 0.96, blue: 0.98))
                            .cornerRadius(50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 50)
                                    .inset(by: 0.5)
                                    .stroke(Color(red: 0.91, green: 0.91, blue: 0.92), lineWidth: 1)
                            )

                            if selectedTab == .signIn {
                                SigninForm()
                            } else {
                                SignupForm()
                            }
                            // from and tab end
                            
                        }
                        .padding(22)
                        .background(.white)
                        .cornerRadius(40)
                        
                        // Divider
                        HStack(alignment: .center, spacing: 10) {
                            Rectangle()
                              .foregroundColor(.clear)
                              .frame(width: 80, height: 2)
                              .background(Color.brand.gray.opacity(0.2))
                            Text("Or continue with")
                              .font(Font.custom("Poppins", size: 18))
                              .foregroundColor(Color(red: 0, green: 0.02, blue: 0.02))
                            Rectangle()
                              .foregroundColor(.clear)
                              .frame(width: 80, height: 2)
                              .background(Color.brand.gray.opacity(0.2))
                        }
                        .padding(.top, 50)
                        // Google and apple login
                        HStack(alignment: .center, spacing: 10) {
                            SocialButton(title: "Google", icon: "google", style: 2, iconSize: 30) { }
                            SocialButton(title: "Apple", icon: "apple", style: 2, verticalPadding: 18) { }
                        }
                        .padding(.top, 50)
                    }
                    .padding()
                }
            }
        }
        .navigationBarHidden(true)
    }

    @ViewBuilder
    private func tabButton(title: String, tab: FormTab) -> some View {
        let isSelected = selectedTab == tab
        Button {
            selectedTab = tab
        } label: {
            Text(title)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(isSelected ? .white : .black)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(isSelected ? Color.brand.black : Color(red: 0.95, green: 0.96, blue: 0.98))
                .cornerRadius(1000)
        }
    }
}

#Preview {
    Login()
}
