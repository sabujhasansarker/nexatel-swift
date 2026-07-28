import SwiftUI

struct SettingsMenu: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let subtitle: String
    var action: () -> Void = {}
}

struct Settings: View {
    private let accountMenus: [SettingsMenu] = [
        SettingsMenu(icon: "person", title: "Edit Profile", subtitle: "Edit your profile"),
        SettingsMenu(icon: "bell", title: "Notifications", subtitle: "Manage your alerts"),
        SettingsMenu(icon: "lock", title: "Privacy", subtitle: "Control your privacy settings")
    ]

    private let supportMenus: [SettingsMenu] = [
        SettingsMenu(icon: "questionmark.circle", title: "Help Center", subtitle: "Get help and support"),
        SettingsMenu(icon: "arrow.right.square", title: "Log Out", subtitle: "Sign out of your account")
    ]

    @State private var progress: CGFloat = 0

    private var isCompact: Bool { progress >= 0.65 }
    private var imageSize: CGFloat { 120 - 60 * progress }
    private var titleSize: CGFloat { 26 - 6 * progress }
    private var subtitleSize: CGFloat { 16 - 2 * progress }

    var body: some View {
        ZStack {
            Color.brand.bg.ignoresSafeArea()

            VStack(spacing: 0) {
                header
                    .padding(.top, 10)
                    .padding(.bottom, 25 - 15 * progress)
                    .background(Color.brand.bg)

                ScrollView {
                    VStack(spacing: 30) {
                        menuSection(title: "Your Account", menus: accountMenus)
                        menuSection(title: "Support", menus: supportMenus)
                        menuSection(title: "Your Account", menus: accountMenus)
                        menuSection(title: "Support", menus: supportMenus)
                    }
                    .padding(.horizontal)
                    .padding(.top, 15)
                    Spacer().frame(height: 100)
                }
                
                .onScrollGeometryChange(for: CGFloat.self) { geo in
                    min(1, max(0, geo.contentOffset.y / 120))
                } action: { _, newProgress in
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        progress = newProgress
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var header: some View {
        let avatar = Image("user-image")
            .resizable()
            .scaledToFill()
            .frame(width: imageSize, height: imageSize)
            .clipShape(Circle())

        let name = Text("Mehedi Hasan")
            .font(.poppins(size: titleSize, .medium))
            .foregroundColor(Color.brand.black)

        let email = Text("mehedi@gmail.com")
            .font(.poppins(size: subtitleSize))
            .foregroundColor(Color.brand.gray)
            .accentColor(Color.brand.gray)

        if isCompact {
            HStack(spacing: 15) {
                avatar
                VStack(alignment: .leading, spacing: 2) {
                    name
                    email
                }
                Spacer()
            }
            .padding(.horizontal, 20)
        } else {
            VStack(spacing: 0) {
                avatar.padding(.bottom, 15 * (1 - progress))
                name.padding(.bottom, 5 * (1 - progress))
                email
            }
            .transition(.opacity.combined(with: .scale(scale: 0.95)))
        }
    }

    @ViewBuilder
    private func menuSection(title: String, menus: [SettingsMenu]) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.poppins(size: 18, .medium))
                .foregroundColor(Color.brand.gray)

            VStack(spacing: 25) {
                ForEach(menus) { menu in
                    Button {
                        menu.action()
                    } label: {
                        HStack(alignment: .top, spacing: 15) {
                            Image(systemName: menu.icon)
                                .font(.system(size: 22))
                                .frame(width: 40, height: 40)
                                .background(Color.brand.primary)
                                .foregroundStyle(.white)
                                .cornerRadius(30)

                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(menu.title)
                                        .font(.poppins(size: 18))
                                        .foregroundColor(Color.brand.black)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 16))
                                        .foregroundStyle(Color.brand.gray)
                                }
                                Text(menu.subtitle)
                                    .font(.poppins(size: 16))
                                    .foregroundColor(Color.brand.gray)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(20)
            .background(.white)
            .cornerRadius(20)
        }
    }
}

#Preview {
    Settings()
}
