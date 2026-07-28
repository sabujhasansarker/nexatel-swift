import SwiftUI
import LucideIcons

struct SettingsMenu: Identifiable {
    let id = UUID()
    let icon: UIImage
    let title: String
    var subtitle: String? = nil
    var action: () -> Void = {}
}

struct Settings: View {
    private let accountMenus: [SettingsMenu] = [
        SettingsMenu(icon: Lucide.userRound, title: "Edit Profile", subtitle: "Edit your profile"),
        SettingsMenu(icon: Lucide.creditCard, title: "Plan & Billing", subtitle: "Manage your plan"),
    ]
    private let notificationsMenus: [SettingsMenu] = [
        SettingsMenu(icon: Lucide.bellOff, title: "Muting Preferences", subtitle: "Silence calls or messages"),
        SettingsMenu(icon: Lucide.mail, title: "Email Notifications", subtitle: "Not Set"),
    ]
    private let securityMenus: [SettingsMenu] = [
        SettingsMenu(icon: Lucide.lock, title: "Remember Password" ),
        SettingsMenu(icon: Lucide.scanFace, title: "Face ID"),
        SettingsMenu(icon: Lucide.view, title: "Biometric ID"),
    ]
    private let preferencesMenus: [SettingsMenu] = [
        SettingsMenu(icon: Lucide.shield, title: "Legal & Policies"),
        SettingsMenu(icon: Lucide.circleQuestionMark, title: "Help & Support", )
    ]

  
    @State private var progress: CGFloat = 0

    private var isCompact: Bool { progress >= 0.65 }
    private var imageSize: CGFloat { 120 - 60 * progress }
    private var titleSize: CGFloat { 26 - 6 * progress }
    private var subtitleSize: CGFloat { 16 - 2 * progress }
    
    @State private var toggleStates: [UUID: Bool] = [:]

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
                        menuSection(title: "Notifications", menus: notificationsMenus)
                        menuSection(title: "Security", menus: securityMenus, switchInput: true)
                        menuSection(title: "Preferences", menus: preferencesMenus, dotIcon: true)
                    }
                    .padding(.horizontal)
                    .padding(.top, 15)
                    Spacer().frame(height: 50)
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
    private func menuSection(title: String, menus: [SettingsMenu], switchInput: Bool = false, dotIcon: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.poppins(size: 18, .medium))
                .foregroundColor(Color.brand.gray)

            VStack(spacing: 25) {
                ForEach(menus) { menu in
                    Button {
                        menu.action()
                    } label: {
                        HStack(alignment: menu.subtitle != nil ? .top : .center, spacing: 15) {
                            VStack{
                                Image(uiImage: menu.icon)
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 22, height: 22)
                            }
                            .frame(width: 40, height: 40)
                            .background(Color.brand.primary)
                            .foregroundStyle(.white)
                            .cornerRadius(30)

                            VStack(alignment: .leading, spacing: 8) {
                                HStack{
                                    Text(menu.title)
                                        .font(.poppins(size: 18))
                                        .foregroundColor(Color.brand.black)
                                    Spacer()
                                    if !switchInput {
                                        if dotIcon {
                                            Image(uiImage: Lucide.ellipsisVertical)
                                                .renderingMode(.template)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 16, height: 16)
                                                .foregroundStyle(Color.brand.gray)
                                        } else {
                                            Image(uiImage: Lucide.chevronRight)
                                                .renderingMode(.template)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 16, height: 16)
                                                .foregroundStyle(Color.brand.gray)
                                        }
                                    } else {
                                        Toggle("", isOn: Binding(
                                            get: { toggleStates[menu.id] ?? false },
                                            set: { toggleStates[menu.id] = $0 }
                                        ))
                                        .labelsHidden()
                                        .toggleStyle(SwitchToggleStyle(tint: Color.brand.primary))
                                        .transaction { $0.disablesAnimations = true }
                                    }
                                }
                                if let subtitle = menu.subtitle {
                                    Text(subtitle)
                                        .font(.poppins(size: 16))
                                        .foregroundColor(Color.brand.gray)
                                }
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
}

#Preview {
    Settings()
}
