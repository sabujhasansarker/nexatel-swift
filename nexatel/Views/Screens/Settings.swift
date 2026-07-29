import SwiftUI
import PhotosUI
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
        SettingsMenu(icon: Lucide.creditCard, title: "Plan & Billing", subtitle: "Manage your plan")
    ]
    private let notificationsMenus: [SettingsMenu] = [
        SettingsMenu(icon: Lucide.bellOff, title: "Muting Preferences", subtitle: "Silence calls or messages"),
        SettingsMenu(icon: Lucide.mail, title: "Email Notifications", subtitle: "Not Set")
    ]
    private let securityMenus: [SettingsMenu] = [
        SettingsMenu(icon: Lucide.lock, title: "Remember Password"),
        SettingsMenu(icon: Lucide.scanFace, title: "Face ID"),
        SettingsMenu(icon: Lucide.view, title: "Biometric ID")
    ]
    private let preferencesMenus: [SettingsMenu] = [
        SettingsMenu(icon: Lucide.shield, title: "Legal & Policies"),
        SettingsMenu(icon: Lucide.circleQuestionMark, title: "Help & Support")
    ]

    @State private var progress: CGFloat = 0

    private var isCompact: Bool { progress >= 0.65 }
    private var imageSize: CGFloat { 120 - 60 * progress }
    private var titleSize: CGFloat { 26 - 6 * progress }
    private var subtitleSize: CGFloat { 16 - 2 * progress }

    @State private var toggleStates: [String: Bool] = [
        "Remember Password": true,
        "Face ID": false,
        "Biometric ID": false
    ]

    @State private var activeScreen: SettingsScreen? = nil
    @State private var activePopup: SettingsPopup? = nil

    @State private var muteSelection: String = "None"
    @State private var emailPrefs: [String: Bool] = [
        "Account Activity": true,
        "Billing Receipts": true,
        "Product News": false
    ]

    var body: some View {
        NavigationStack {
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
                        .padding(.bottom, 100)
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
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(item: $activeScreen) { screen in
                switch screen {
                case .editProfile:
                    EditProfileScreen()
                case .planBilling:
                    PlanBillingScreen()
                case .mutingPreferences:
                    MutingPreferencesScreen(selection: $muteSelection)
                case .emailNotifications:
                    EmailNotificationsScreen(prefs: $emailPrefs)
                }
            }
            .sheet(item: $activePopup) { popup in
                switch popup {
                case .rememberPassword:
                    SecurityTogglePopup(
                        title: "Remember Password",
                        icon: Lucide.lock,
                        message: "When enabled, your password is stored securely on this device so you don't have to type it in every time you sign in.",
                        isOn: Binding(
                            get: { toggleStates["Remember Password"] ?? false },
                            set: { toggleStates["Remember Password"] = $0 }
                        )
                    )
                    .presentationDetents([.height(280)])
                    .presentationDragIndicator(.visible)
                case .faceID:
                    SecurityTogglePopup(
                        title: "Face ID",
                        icon: Lucide.scanFace,
                        message: "Use Face ID to unlock the app instantly and confirm sensitive actions like payments, without typing a password.",
                        isOn: Binding(
                            get: { toggleStates["Face ID"] ?? false },
                            set: { toggleStates["Face ID"] = $0 }
                        )
                    )
                    .presentationDetents([.height(280)])
                    .presentationDragIndicator(.visible)
                case .biometricID:
                    SecurityTogglePopup(
                        title: "Biometric ID",
                        icon: Lucide.view,
                        message: "Biometric ID lets you sign in and approve actions using your fingerprint or face, depending on what your device supports.",
                        isOn: Binding(
                            get: { toggleStates["Biometric ID"] ?? false },
                            set: { toggleStates["Biometric ID"] = $0 }
                        )
                    )
                    .presentationDetents([.height(280)])
                    .presentationDragIndicator(.visible)
                case .legalPolicies:
                    LinkListPopup(
                        title: "Legal & Policies",
                        icon: Lucide.shield,
                        links: [
                            ("Terms of Service", "doc.text", URL(string: "https://example.com/terms")),
                            ("Privacy Policy", "hand.raised", URL(string: "https://example.com/privacy"))
                        ]
                    )
                    .presentationDetents([.height(300)])
                    .presentationDragIndicator(.visible)
                case .helpSupport:
                    LinkListPopup(
                        title: "Help & Support",
                        icon: Lucide.circleQuestionMark,
                        links: [
                            ("FAQs", "questionmark.circle", URL(string: "https://example.com/faq")),
                            ("Contact Support", "envelope", URL(string: "mailto:support@example.com"))
                        ]
                    )
                    .presentationDetents([.height(300)])
                    .presentationDragIndicator(.visible)
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
                        handleTap(on: menu)
                    } label: {
                        HStack(alignment: menu.subtitle != nil ? .top : .center, spacing: 15) {
                            VStack {
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
                                HStack {
                                    Text(menu.title)
                                        .font(.poppins(size: 18))
                                        .foregroundColor(Color.brand.black)
                                    Spacer()
                                    if !switchInput {
                                        Image(uiImage: dotIcon ? Lucide.ellipsisVertical : Lucide.chevronRight)
                                            .renderingMode(.template)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 16, height: 16)
                                            .foregroundStyle(Color.brand.gray)
                                    } else {
                                        Toggle("", isOn: Binding(
                                            get: { toggleStates[menu.title] ?? false },
                                            set: { toggleStates[menu.title] = $0 }
                                        ))
                                        .labelsHidden()
                                        .toggleStyle(SwitchToggleStyle(tint: Color.brand.primary))
                                        .transaction { $0.disablesAnimations = true }
                                        .allowsHitTesting(true)
                                    }
                                }
                                if let subtitle = dynamicSubtitle(for: menu) {
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

    private func dynamicSubtitle(for menu: SettingsMenu) -> String? {
        switch menu.title {
        case "Muting Preferences":
            return muteSelection
        case "Email Notifications":
            let onCount = emailPrefs.values.filter { $0 }.count
            return onCount == 0 ? "Not Set" : "\(onCount) enabled"
        default:
            return menu.subtitle
        }
    }

    private func handleTap(on menu: SettingsMenu) {
        switch menu.title {
        case "Edit Profile":
            activeScreen = .editProfile
        case "Plan & Billing":
            activeScreen = .planBilling
        case "Muting Preferences":
            activeScreen = .mutingPreferences
        case "Email Notifications":
            activeScreen = .emailNotifications
        case "Remember Password":
            activePopup = .rememberPassword
        case "Face ID":
            activePopup = .faceID
        case "Biometric ID":
            activePopup = .biometricID
        case "Legal & Policies":
            activePopup = .legalPolicies
        case "Help & Support":
            activePopup = .helpSupport
        default:
            menu.action()
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

// MARK: - Full-page destinations (3-4 options)

enum SettingsScreen: String, Identifiable {
    case editProfile
    case planBilling
    case mutingPreferences
    case emailNotifications

    var id: String { rawValue }
}

// MARK: - Popup destinations (single toggle / short link list)

enum SettingsPopup: String, Identifiable {
    case rememberPassword
    case faceID
    case biometricID
    case legalPolicies
    case helpSupport

    var id: String { rawValue }
}

// MARK: - Popup: single security toggle

struct SecurityTogglePopup: View {
    let title: String
    let icon: UIImage
    let message: String
    @Binding var isOn: Bool

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color.brand.primary)
                    .frame(width: 52, height: 52)
                Image(uiImage: icon)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.white)
            }
            .padding(.top, 20)

            Text(title)
                .font(.poppins(size: 18, .medium))
                .foregroundColor(Color.brand.black)

            Text(message)
                .font(.poppins(size: 14))
                .foregroundColor(Color.brand.gray)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 24)

            HStack {
                Text("Enable \(title)")
                    .font(.poppins(size: 16))
                    .foregroundColor(Color.brand.black)
                Spacer()
                Toggle("", isOn: $isOn)
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: Color.brand.primary))
            }
            .padding(16)
            .background(Color.brand.bg)
            .cornerRadius(14)
            .padding(.horizontal, 20)

            Spacer(minLength: 0)
        }
        .background(Color.white)
    }
}

// MARK: - Popup: short link list (Legal & Policies / Help & Support)

struct LinkListPopup: View {
    let title: String
    let icon: UIImage
    let links: [(label: String, systemImage: String, url: URL?)]

    @Environment(\.openURL) private var openURL

    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.brand.primary)
                        .frame(width: 40, height: 40)
                    Image(uiImage: icon)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(.white)
                }
                Text(title)
                    .font(.poppins(size: 18, .medium))
                    .foregroundColor(Color.brand.black)
                Spacer()
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)

            VStack(spacing: 12) {
                ForEach(links, id: \.label) { link in
                    Button {
                        if let url = link.url { openURL(url) }
                    } label: {
                        HStack {
                            Image(systemName: link.systemImage)
                                .foregroundStyle(Color.brand.primary)
                            Text(link.label)
                                .font(.poppins(size: 16))
                                .foregroundColor(Color.brand.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 13))
                                .foregroundStyle(Color.brand.gray)
                        }
                        .padding(.vertical, 14)
                        .padding(.horizontal, 16)
                        .background(Color.brand.bg)
                        .cornerRadius(14)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)

            Spacer(minLength: 0)
        }
        .background(Color.white)
    }
}

// MARK: - Shared page scaffold (still used by the 3-4-option pages)

struct SettingsScaffold<Content: View>: View {
    let title: String
    let icon: UIImage
    let message: String
    @ViewBuilder var content: () -> Content

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.brand.bg.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.brand.primary)
                                .frame(width: 56, height: 56)
                            Image(uiImage: icon)
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 26, height: 26)
                                .foregroundStyle(.white)
                        }

                        Text(message)
                            .font(.poppins(size: 15))
                            .foregroundColor(Color.brand.gray)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, 12)
                    }
                    .padding(.top, 20)

                    content()
                        .padding(.horizontal, 20)
                }
                .padding(.bottom, 40)
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 34, height: 34)
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color.brand.black)
                    }
                }
            }
        }
    }
}

struct SettingsDetailRow: View {
    var systemImage: String? = nil
    let label: String
    var trailing: AnyView

    var body: some View {
        HStack {
            if let systemImage {
                Image(systemName: systemImage)
                    .foregroundStyle(Color.brand.primary)
            }
            Text(label)
                .font(.poppins(size: 16))
                .foregroundColor(Color.brand.black)
            Spacer()
            trailing
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
        .background(.white)
        .cornerRadius(14)
    }
}

// MARK: - Muting Preferences (4 options -> full page)

struct MutingPreferencesScreen: View {
    @Binding var selection: String
    private let options = ["None", "Mute All Calls", "Mute All Messages", "Custom Schedule"]

    var body: some View {
        SettingsScaffold(
            title: "Muting Preferences",
            icon: Lucide.bellOff,
            message: "Choose when calls and messages stay silent. You can mute everyone, only unknown numbers, or set a custom schedule."
        ) {
            VStack(spacing: 12) {
                ForEach(options, id: \.self) { option in
                    Button {
                        selection = option
                    } label: {
                        SettingsDetailRow(
                            label: option,
                            trailing: AnyView(
                                Image(systemName: selection == option ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(selection == option ? Color.brand.primary : Color.brand.gray)
                            )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

// MARK: - Email Notifications (3 options -> full page)

struct EmailNotificationsScreen: View {
    @Binding var prefs: [String: Bool]
    private let options: [(key: String, systemImage: String)] = [
        ("Account Activity", "person.crop.circle"),
        ("Billing Receipts", "doc.text"),
        ("Product News", "megaphone")
    ]

    var body: some View {
        SettingsScaffold(
            title: "Email Notifications",
            icon: Lucide.mail,
            message: "Pick which updates land in your inbox - account activity, billing receipts, product news, and more."
        ) {
            VStack(spacing: 12) {
                ForEach(options, id: \.key) { option in
                    SettingsDetailRow(
                        systemImage: option.systemImage,
                        label: option.key,
                        trailing: AnyView(
                            Toggle("", isOn: Binding(
                                get: { prefs[option.key] ?? false },
                                set: { prefs[option.key] = $0 }
                            ))
                            .labelsHidden()
                            .toggleStyle(SwitchToggleStyle(tint: Color.brand.primary))
                        )
                    )
                }
            }
        }
    }
}

// MARK: - Full screens (Edit Profile / Plan & Billing)

struct ProfileField: Identifiable {
    let id = UUID()
    let key: String
    let icon: UIImage
    let label: String
    var multiline: Bool = false
    var keyboardType: UIKeyboardType = .default
}

struct EditProfileScreen: View {
    @Environment(\.dismiss) private var dismiss

    private let fields: [ProfileField] = [
        ProfileField(key: "preferredName", icon: Lucide.userRound, label: "Preferred Name"),
        ProfileField(key: "role", icon: Lucide.users, label: "Your role", multiline: true),
        ProfileField(key: "email", icon: Lucide.mail, label: "Email Address", keyboardType: .emailAddress),
        ProfileField(key: "company", icon: Lucide.building2, label: "Company Name"),
        ProfileField(key: "industry", icon: Lucide.factory, label: "Industry", multiline: true),
        ProfileField(key: "website", icon: Lucide.link, label: "Website", keyboardType: .URL),
        ProfileField(key: "address", icon: Lucide.mapPin, label: "Address", multiline: true),
        ProfileField(key: "faq", icon: Lucide.fileText, label: "FAQ", multiline: true)
    ]

    @State private var values: [String: String] = [
        "preferredName": "Mehedi Hasan",
        "role": "Ride and delivery service provider",
        "email": "mehedi@gmail.com",
        "company": "Nexatel",
        "industry": "Transport and delivery service",
        "website": "https://themeforest.net/user/mehedi",
        "address": "Jatrabari, Dhaka - 1204",
        "faq": "Transport and delivery service related questions"
    ]

    @State private var editingField: ProfileField? = nil
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var avatarImageData: Data? = nil

    var body: some View {
        ZStack {
            Color.brand.bg.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    avatarSection

                    VStack(spacing: 0) {
                        ForEach(Array(fields.enumerated()), id: \.element.id) { index, field in
                            Button {
                                editingField = field
                            } label: {
                                HStack(spacing: 15) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.brand.primary)
                                            .frame(width: 40, height: 40)
                                        Image(uiImage: field.icon)
                                            .renderingMode(.template)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 18, height: 18)
                                            .foregroundStyle(.white)
                                    }

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(field.label)
                                            .font(.poppins(size: 13))
                                            .foregroundColor(Color.brand.gray)
                                        Text(values[field.key]?.isEmpty == false ? values[field.key]! : "Not set")
                                            .font(.poppins(size: 16, .medium))
                                            .foregroundColor(Color.brand.black)
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                    }

                                    Spacer()

                                    Image(uiImage: Lucide.chevronRight)
                                        .renderingMode(.template)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 14, height: 14)
                                        .foregroundStyle(Color.brand.gray)
                                }
                                .padding(.vertical, 14)
                            }
                            .buttonStyle(.plain)

                            if index < fields.count - 1 {
                                Divider()
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(.white)
                    .cornerRadius(20)
                    .padding(.horizontal, 20)
                }
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 34, height: 34)
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color.brand.black)
                    }
                }
            }
        }
        .sheet(item: $editingField) { field in
            FieldEditSheet(
                field: field,
                value: Binding(
                    get: { values[field.key] ?? "" },
                    set: { values[field.key] = $0 }
                )
            )
            .presentationDetents([.fraction(0.4), .medium])
            .presentationDragIndicator(.visible)
        }
        .onChange(of: selectedPhotoItem) { _, newItem in
            Task {
                if let newItem, let data = try? await newItem.loadTransferable(type: Data.self) {
                    avatarImageData = data
                }
            }
        }
    }

    @ViewBuilder
    private var avatarSection: some View {
        VStack(spacing: 10) {
            PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                ZStack(alignment: .bottomTrailing) {
                    Group {
                        if let data = avatarImageData, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                        } else {
                            Image("user-image")
                                .resizable()
                                .scaledToFill()
                        }
                    }
                    .frame(width: 96, height: 96)
                    .clipShape(Circle())

                    ZStack {
                        Circle()
                            .fill(Color.brand.primary)
                            .frame(width: 28, height: 28)
                        Image(uiImage: Lucide.pencil)
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 13, height: 13)
                            .foregroundStyle(.white)
                    }
                }
            }
            .buttonStyle(.plain)

            Text(values["preferredName"]?.isEmpty == false ? values["preferredName"]! : "Your Name")
                .font(.poppins(size: 20, .medium))
                .foregroundColor(Color.brand.black)

            Text(values["email"] ?? "")
                .font(.poppins(size: 14))
                .foregroundColor(Color.brand.gray)
        }
    }
}

struct FieldEditSheet: View {
    let field: ProfileField
    @Binding var value: String

    @Environment(\.dismiss) private var dismiss
    @State private var draft: String = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("Edit \(field.label)")
                .font(.poppins(size: 18, .medium))
                .foregroundColor(Color.brand.black)
                .padding(.top, 24)

            Group {
                if field.multiline {
                    TextEditor(text: $draft)
                        .frame(minHeight: 100)
                        .scrollContentBackground(.hidden)
                } else {
                    TextField(field.label, text: $draft)
                        .keyboardType(field.keyboardType)
                        .autocapitalization(.none)
                }
            }
            .font(.poppins(size: 16))
            .foregroundColor(Color.brand.black)
            .padding(14)
            .background(Color.brand.bg)
            .cornerRadius(14)
            .focused($isFocused)
            .padding(.horizontal, 20)

            Button {
                value = draft.trimmingCharacters(in: .whitespacesAndNewlines)
                dismiss()
            } label: {
                Text("Save")
                    .font(.poppins(size: 16, .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.brand.primary)
                    .cornerRadius(16)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 20)

            Spacer(minLength: 0)
        }
        .background(Color.white)
        .onAppear {
            draft = value
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isFocused = true
            }
        }
    }
}

// MARK: - Plan & Billing (updated design: Manage Subscription)

struct SubscriptionPlan: Identifiable {
    let id = UUID()
    let name: String
    let price: String
    let tagline: String
    let features: [String]
    var isDark: Bool = false
}

struct PlanBillingScreen: View {
    @Environment(\.dismiss) private var dismiss

    private let currentPlan = SubscriptionPlan(
        name: "Core unlimited",
        price: "$39",
        tagline: "Great for occasional travelers - up to 30 travel days a year included.",
        features: ["1GB Data", "Valid for 7 days", "Coverage 50+ Countries", "No Roaming Fees"]
    )

    private let switchPlan = SubscriptionPlan(
        name: "Global",
        price: "$55",
        tagline: "Everything in Core Unlimited, plus high-speed international data for occasional travelers.",
        features: [
            "Everything in Core Unlimited",
            "VPN included",
            "International roaming in up to 215",
            "High-speed amount varies by destination: 5GB, 10GB, or up to 20GB"
        ],
        isDark: true
    )

    var body: some View {
        ZStack {
            Color.brand.bg.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    sectionLabel("Current Plan")
                    currentPlanCard

                    sectionLabel("Switch Plan")
                    switchPlanCard
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("Manage Subscription")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 34, height: 34)
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color.brand.black)
                    }
                }
            }
        }
    }

    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.poppins(size: 14, .medium))
            .foregroundColor(Color.brand.gray)
    }

    private var currentPlanCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text(currentPlan.name)
                    .font(.poppins(size: 20, .medium))
                    .foregroundColor(Color.brand.black)

                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(currentPlan.price)
                        .font(.poppins(size: 22, .medium))
                        .foregroundColor(Color.brand.black)
                    Text("/Per month")
                        .font(.poppins(size: 14))
                        .foregroundColor(Color.brand.gray)
                }

                Text(currentPlan.tagline)
                    .font(.poppins(size: 14))
                    .foregroundColor(Color.brand.gray)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 4)
            }

            VStack(alignment: .leading, spacing: 10) {
                ForEach(currentPlan.features, id: \.self) { feature in
                    featureRow(feature, isDark: false)
                }
            }

            Button {
                // change billing method action
            } label: {
                Text("Change billing method")
                    .font(.poppins(size: 15, .medium))
                    .foregroundColor(Color.brand.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.brand.bg)
                    .cornerRadius(30)
            }
            .buttonStyle(.plain)
        }
        .padding(20)
        .background(.white)
        .cornerRadius(24)
    }

    private var switchPlanCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text(switchPlan.name)
                    .font(.poppins(size: 20, .medium))
                    .foregroundColor(.white)

                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(switchPlan.price)
                        .font(.poppins(size: 22, .medium))
                        .foregroundColor(.white)
                    Text("/Per month")
                        .font(.poppins(size: 14))
                        .foregroundColor(.white.opacity(0.6))
                }

                Text(switchPlan.tagline)
                    .font(.poppins(size: 14))
                    .foregroundColor(.white.opacity(0.7))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 4)
            }

            VStack(alignment: .leading, spacing: 10) {
                ForEach(switchPlan.features, id: \.self) { feature in
                    featureRow(feature, isDark: true)
                }
            }

            Button {
                // continue / upgrade action
            } label: {
                Text("Continue")
                    .font(.poppins(size: 15, .medium))
                    .foregroundColor(Color.brand.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(.white)
                    .cornerRadius(30)
            }
            .buttonStyle(.plain)
        }
        .padding(20)
        .background(Color.brand.black)
        .cornerRadius(24)
    }

    private func featureRow(_ text: String, isDark: Bool) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 14))
                .foregroundStyle(Color.brand.primary)
                .padding(.top, 2)

            Text(text)
                .font(.poppins(size: 14))
                .foregroundColor(isDark ? .white.opacity(0.85) : Color.brand.black)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    Settings()
}
