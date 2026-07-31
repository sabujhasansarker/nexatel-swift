import SwiftUI
import LucideIcons

struct SettingsMenuContent: View {

    private let sections: [(String, [SettingsMenu], Bool, Bool)] = [
        (
            "Your Account",
            [
                SettingsMenu(icon: Lucide.userRound, title: "Edit Profile", subtitle: "Edit your profile"),
                SettingsMenu(icon: Lucide.creditCard, title: "Plan & Billing", subtitle: "Manage your plan")
            ],
            false,
            false
        ),
        (
            "Notifications",
            [
                SettingsMenu(icon: Lucide.bellOff, title: "Muting Preferences", subtitle: "Silence calls or messages"),
                SettingsMenu(icon: Lucide.mail, title: "Email Notifications", subtitle: "Not Set")
            ],
            false,
            false
        ),
        (
            "Security",
            [
                SettingsMenu(icon: Lucide.lock, title: "Remember Password"),
                SettingsMenu(icon: Lucide.scanFace, title: "Face ID"),
                SettingsMenu(icon: Lucide.view, title: "Biometric ID")
            ],
            true,
            false
        ),
        (
            "Preferences",
            [
                SettingsMenu(icon: Lucide.shield, title: "Legal & Policies"),
                SettingsMenu(icon: Lucide.circleQuestionMark, title: "Help & Support")
            ],
            false,
            true
        )
    ]


    var body: some View {
        VStack(spacing: 30) {
            ForEach(sections, id: \.0) { section in
                menuSection(
                    title: section.0,
                    menus: section.1,
                    switchInput: section.2,
                    dotIcon: section.3
                )
            }

        }
        .padding(.top, 15)
        .padding(.bottom, 100)
    }


    @ViewBuilder
    private func menuSection(
        title: String,
        menus: [SettingsMenu],
        switchInput: Bool = false,
        dotIcon: Bool = false
    ) -> some View {

        VStack(alignment: .leading, spacing: 15) {

            Text(title)
                .font(.poppins(size: 18, .medium))
                .foregroundColor(Color.brand.gray)


            VStack(spacing: 25) {

                ForEach(menus) { menu in

                    Button {

                    } label: {

                        HStack(spacing: 15) {

                            Image(uiImage: menu.icon)
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width:22,height:22)
                                .foregroundStyle(.white)
                                .frame(width:40,height:40)
                                .background(Color.brand.primary)
                                .clipShape(Circle())


                            VStack(alignment:.leading,spacing:5) {

                                Text(menu.title)
                                    .font(.poppins(size:18))
                                    .foregroundColor(Color.brand.black)


                                if let subtitle = menu.subtitle {
                                    Text(subtitle)
                                        .font(.poppins(size:14))
                                        .foregroundColor(Color.brand.gray)
                                }
                            }

                            Spacer()

                            Image(uiImage: dotIcon ? Lucide.ellipsisVertical : Lucide.chevronRight)
                                .resizable()
                                .scaledToFit()
                                .frame(width:16,height:16)
                                .foregroundColor(Color.brand.gray)

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
