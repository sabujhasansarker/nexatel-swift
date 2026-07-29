import SwiftUI

// MARK: - Models

enum MessageStatus {
    case sent, delivered, read
}

struct ChatMessage: Identifiable, Equatable {
    let id = UUID()
    var text: String
    let isSender: Bool
    let timestamp: Date
    var status: MessageStatus = .sent
    var isVoiceNote: Bool = false
    var voiceDuration: Int = 0
}

struct Chat: Identifiable {
    let id = UUID()
    var name: String
    var phoneNumber: String
    var avatarInitials: String
    var avatarColor: Color
    var isOnline: Bool
    var messages: [ChatMessage]
    var unreadCount: Int = 0
    var isPinned: Bool = false
    var isMuted: Bool = false
    var isTyping: Bool = false

    var lastMessage: ChatMessage? { messages.last }
}

extension Chat {
    static let sample: [Chat] = [
        Chat(
            name: "Nusrat Jahan",
            phoneNumber: "+1 (555) 534-5678",
            avatarInitials: "NJ",
            avatarColor: Color(red: 0.98, green: 0.6, blue: 0.4),
            isOnline: true,
            messages: [
                ChatMessage(text: "Hey! Are we still on for tomorrow?", isSender: false, timestamp: Date().addingTimeInterval(-3600 * 6)),
                ChatMessage(text: "Yes, 6 PM at the usual place 👍", isSender: true, timestamp: Date().addingTimeInterval(-3600 * 5.9), status: .read),
                ChatMessage(text: "Perfect, see you then!", isSender: false, timestamp: Date().addingTimeInterval(-3600 * 5.8)),
                ChatMessage(text: "Should I bring the laptop or is this just a casual catch-up?", isSender: false, timestamp: Date().addingTimeInterval(-3600 * 5.7)),
                ChatMessage(text: "Bring it, we might go over the proposal too", isSender: true, timestamp: Date().addingTimeInterval(-3600 * 5.6), status: .read),
                ChatMessage(text: "", isSender: false, timestamp: Date().addingTimeInterval(-3600 * 5.4), isVoiceNote: true, voiceDuration: 14),
                ChatMessage(text: "Got it, will do 🙌", isSender: true, timestamp: Date().addingTimeInterval(-3600 * 5.3), status: .read),
                ChatMessage(text: "Running 5 min late, traffic on the bridge", isSender: false, timestamp: Date().addingTimeInterval(-3600 * 0.3)),
            ],
            unreadCount: 2
        ),
        Chat(
            name: "Team Nexatel",
            phoneNumber: "+1 (555) 000-1122",
            avatarInitials: "TN",
            avatarColor: Color(red: 0.4, green: 0.55, blue: 0.95),
            isOnline: false,
            messages: [
                ChatMessage(text: "Deploy went out clean ✅", isSender: false, timestamp: Date().addingTimeInterval(-3600 * 22)),
                ChatMessage(text: "Nice work everyone", isSender: true, timestamp: Date().addingTimeInterval(-3600 * 21.5), status: .read),
                ChatMessage(text: "QA passed on staging too, no regressions", isSender: false, timestamp: Date().addingTimeInterval(-3600 * 21)),
                ChatMessage(text: "Great, let's monitor crash reports for the next few hours", isSender: true, timestamp: Date().addingTimeInterval(-3600 * 20.8), status: .read),
                ChatMessage(text: "Will keep an eye on it", isSender: false, timestamp: Date().addingTimeInterval(-3600 * 20.5)),
            ],
            unreadCount: 0
        ),
        Chat(
            name: "Mom",
            phoneNumber: "+1 (555) 222-9090",
            avatarInitials: "M",
            avatarColor: Color(red: 0.95, green: 0.45, blue: 0.55),
            isOnline: true,
            messages: [
                ChatMessage(text: "Have you eaten yet?", isSender: false, timestamp: Date().addingTimeInterval(-3600 * 2)),
                ChatMessage(text: "Not yet, working through lunch today", isSender: true, timestamp: Date().addingTimeInterval(-3600 * 1.9), status: .read),
                ChatMessage(text: "Eat something na, don't skip meals", isSender: false, timestamp: Date().addingTimeInterval(-3600 * 1.8)),
                ChatMessage(text: "I know, ordering right now 😅", isSender: true, timestamp: Date().addingTimeInterval(-3600 * 1.7), status: .read),
                ChatMessage(text: "Good. Call me tonight, I want to talk about Eid plans", isSender: false, timestamp: Date().addingTimeInterval(-1800)),
            ],
            unreadCount: 1,
            isPinned: true
        ),
        Chat(
            name: "Rafiq Vai",
            phoneNumber: "+1 (555) 945-6789",
            avatarInitials: "RV",
            avatarColor: Color(red: 0.5, green: 0.75, blue: 0.5),
            isOnline: false,
            messages: [
                ChatMessage(text: "Bhai, invoice ta pathaye din", isSender: false, timestamp: Date().addingTimeInterval(-3600 * 30)),
                ChatMessage(text: "Sure, sending it now", isSender: true, timestamp: Date().addingTimeInterval(-3600 * 29.9), status: .delivered),
                ChatMessage(text: "", isSender: true, timestamp: Date().addingTimeInterval(-3600 * 29.8), status: .delivered, isVoiceNote: true, voiceDuration: 8),
                ChatMessage(text: "Thanks bhai, payment kal kore dibo", isSender: false, timestamp: Date().addingTimeInterval(-3600 * 29.5)),
            ],
            unreadCount: 0,
            isMuted: true
        ),
        Chat(
            name: "Design Feedback",
            phoneNumber: "+1 (555) 778-3344",
            avatarInitials: "DF",
            avatarColor: Color(red: 0.7, green: 0.5, blue: 0.9),
            isOnline: false,
            messages: [
                ChatMessage(text: "Loved the new onboarding flow!", isSender: false, timestamp: Date().addingTimeInterval(-3600 * 50)),
                ChatMessage(text: "Thank you! Took a few iterations to get the animation timing right", isSender: true, timestamp: Date().addingTimeInterval(-3600 * 49.5), status: .read),
                ChatMessage(text: "It shows, feels really smooth. One small note - the CTA button could be a touch bigger on smaller phones", isSender: false, timestamp: Date().addingTimeInterval(-3600 * 49)),
                ChatMessage(text: "Good catch, I'll bump it up in the next update", isSender: true, timestamp: Date().addingTimeInterval(-3600 * 48.8), status: .read),
            ],
            unreadCount: 0
        ),
    ]
}

// MARK: - Root

struct MessagesRoot: View {
    @State private var chats: [Chat] = Chat.sample
    @State private var searchText = ""
    @State private var showNewChat = false
    @State private var navigateTo: UUID? = nil

    @State private var isSelecting = false
    @State private var selectedIDs: Set<UUID> = []
    @State private var showBulkDeleteConfirm = false
    @State private var singleDeleteTarget: Chat? = nil

    private var filteredChats: [Chat] {
        let base = searchText.isEmpty
            ? chats
            : chats.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        return base.sorted { lhs, rhs in
            if lhs.isPinned != rhs.isPinned { return lhs.isPinned }
            let l = lhs.lastMessage?.timestamp ?? .distantPast
            let r = rhs.lastMessage?.timestamp ?? .distantPast
            return l > r
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.brand.bg.ignoresSafeArea()

                VStack(spacing: 0) {
                    topBar

                    searchField
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                        .padding(.bottom, 8)

                    if filteredChats.isEmpty {
                        emptyState
                    } else {
                        List {
                            ForEach(filteredChats) { chat in
                                chatRowContainer(chat)
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                }

                VStack {
                    Spacer()
                    if isSelecting {
                        bulkActionBar
                    } else {
                        HStack {
                            Spacer()
                            Button {
                                showNewChat = true
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(Color.brand.primary)
                                        .frame(width: 56, height: 56)
                                        .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
                                    Image(systemName: "square.and.pencil")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundStyle(.white)
                                }
                            }
                            .buttonStyle(.plain)
                            .padding(.trailing, 20)
                            .padding(.bottom, 24)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(item: $navigateTo) { chatID in
                if let index = chats.firstIndex(where: { $0.id == chatID }) {
                    ChatDetailScreen(chat: $chats[index])
                        .onAppear { chats[index].unreadCount = 0 }
                }
            }
            .fullScreenCover(isPresented: $showNewChat) {
                NewChatScreen { name, phone in
                    startNewChat(named: name, phone: phone)
                }
            }
            .alert("Delete \(selectedIDs.count) chat\(selectedIDs.count == 1 ? "" : "s")?", isPresented: $showBulkDeleteConfirm) {
                Button("Delete", role: .destructive) { deleteSelected() }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This can't be undone.")
            }
            .alert("Delete this chat?", isPresented: Binding(
                get: { singleDeleteTarget != nil },
                set: { if !$0 { singleDeleteTarget = nil } }
            )) {
                Button("Delete", role: .destructive) {
                    if let target = singleDeleteTarget { delete(target) }
                    singleDeleteTarget = nil
                }
                Button("Cancel", role: .cancel) { singleDeleteTarget = nil }
            } message: {
                Text("This can't be undone.")
            }
        }
    }

    // MARK: Row + per-row actions (works individually, not just in bulk)

    @ViewBuilder
    private func chatRowContainer(_ chat: Chat) -> some View {
        Button {
            if isSelecting {
                toggleSelection(chat.id)
            } else {
                navigateTo = chat.id
            }
        } label: {
            HStack(spacing: 10) {
                if isSelecting {
                    selectionCircle(for: chat.id)
                }
                ChatRow(chat: chat)
            }
        }
        .buttonStyle(.plain)
        .listRowInsets(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        // Per-row context menu — every action here works on this single
        // chat only, independent of select-mode / bulk actions.
        .contextMenu {
            Button {
                toggleReadStatus(chat)
            } label: {
                Label(chat.unreadCount > 0 ? "Mark as Read" : "Mark as Unread",
                      systemImage: chat.unreadCount > 0 ? "envelope.open" : "envelope.badge")
            }
            Button {
                toggleMute(chat)
            } label: {
                Label(chat.isMuted ? "Unmute" : "Mute", systemImage: chat.isMuted ? "bell" : "bell.slash")
            }
            Button {
                togglePin(chat)
            } label: {
                Label(chat.isPinned ? "Unpin" : "Pin", systemImage: "pin.fill")
            }
            Button(role: .destructive) {
                singleDeleteTarget = chat
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.5).onEnded { _ in
                guard !isSelecting else { return }
                withAnimation {
                    isSelecting = true
                    selectedIDs = [chat.id]
                }
            }
        )
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            if !isSelecting {
                Button(role: .destructive) {
                    singleDeleteTarget = chat
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                Button {
                    toggleMute(chat)
                } label: {
                    Label(chat.isMuted ? "Unmute" : "Mute", systemImage: chat.isMuted ? "bell" : "bell.slash")
                }
                .tint(Color.brand.primary)
                Button {
                    toggleReadStatus(chat)
                } label: {
                    Label(chat.unreadCount > 0 ? "Read" : "Unread", systemImage: chat.unreadCount > 0 ? "envelope.open" : "envelope.badge")
                }
                .tint(.blue)
            }
        }
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            if !isSelecting {
                Button {
                    togglePin(chat)
                } label: {
                    Label(chat.isPinned ? "Unpin" : "Pin", systemImage: "pin.fill")
                }
                .tint(.orange)
            }
        }
    }

    private var topBar: some View {
        HStack {
            if isSelecting {
                Button("Cancel") { exitSelection() }
                    .font(.poppins(size: 15, .medium))
                    .foregroundColor(Color.brand.primary)

                Spacer()

                Text("\(selectedIDs.count) selected")
                    .font(.poppins(size: 16, .medium))
                    .foregroundColor(Color.brand.black)

                Spacer()

                Button(selectedIDs.count == filteredChats.count ? "Deselect All" : "Select All") {
                    toggleSelectAll()
                }
                .font(.poppins(size: 15, .medium))
                .foregroundColor(Color.brand.primary)
            } else {
                Text("Chats")
                    .font(.poppins(size: 28, .medium))
                    .foregroundColor(Color.brand.black)

                Spacer()

                let totalUnread = chats.reduce(0) { $0 + $1.unreadCount }
                if totalUnread > 0 {
                    Text("\(totalUnread) new")
                        .font(.poppins(size: 12, .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.brand.primary)
                        .cornerRadius(20)
                }

                Menu {
                    Button {
                        isSelecting = true
                    } label: {
                        Label("Select Chats", systemImage: "checkmark.circle")
                    }
                    Button {
                        markAllRead()
                    } label: {
                        Label("Mark All Read", systemImage: "envelope.open")
                    }
                    Button {
                        showNewChat = true
                    } label: {
                        Label("New Chat", systemImage: "square.and.pencil")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.system(size: 22))
                        .foregroundStyle(Color.brand.black)
                        .padding(.leading, 14)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 14)
        .animation(.easeInOut(duration: 0.2), value: isSelecting)
    }

    private var bulkActionBar: some View {
        HStack {
            bulkActionButton(icon: "bell.slash", label: "Mute") { muteSelected() }
            Spacer()
            bulkActionButton(icon: "envelope.open", label: "Read") {
                markSelectedRead()
                exitSelection()
            }
            Spacer()
            bulkActionButton(icon: "trash", label: "Delete", tint: .red) {
                showBulkDeleteConfirm = true
            }
        }
        .disabled(selectedIDs.isEmpty)
        .opacity(selectedIDs.isEmpty ? 0.4 : 1)
        .padding(.horizontal, 28)
        .padding(.vertical, 14)
        .background(.white)
        .cornerRadius(22)
        .shadow(color: .black.opacity(0.12), radius: 10, y: 4)
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
    }

    @ViewBuilder
    private func bulkActionButton(icon: String, label: String, tint: Color = Color.brand.primary, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                Text(label)
                    .font(.poppins(size: 11))
            }
            .foregroundStyle(tint)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func selectionCircle(for id: UUID) -> some View {
        Image(systemName: selectedIDs.contains(id) ? "checkmark.circle.fill" : "circle")
            .font(.system(size: 22))
            .foregroundStyle(selectedIDs.contains(id) ? Color.brand.primary : Color.brand.gray)
    }

    private var searchField: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.brand.gray)
            TextField("Search chats", text: $searchText)
                .font(.poppins(size: 15))
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color.brand.gray)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
        .background(.white)
        .cornerRadius(14)
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "bubble.left.and.bubble.right")
                .font(.system(size: 40))
                .foregroundStyle(Color.brand.gray)
            Text("No chats found")
                .font(.poppins(size: 16, .medium))
                .foregroundColor(Color.brand.black)
            Text("Try a different name, or start a new conversation.")
                .font(.poppins(size: 13))
                .foregroundColor(Color.brand.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            Spacer()
        }
    }

    // MARK: Actions (all mutate the array by index — this is what makes
    // mute / read actually persist and reflect in the row immediately)

    private func delete(_ chat: Chat) {
        withAnimation {
            chats.removeAll { $0.id == chat.id }
        }
    }

    private func toggleMute(_ chat: Chat) {
        guard let index = chats.firstIndex(where: { $0.id == chat.id }) else { return }
        withAnimation {
            chats[index].isMuted.toggle()
        }
    }

    /// Marks read (clears the badge) if currently unread, or marks
    /// unread (sets the badge to 1) if currently read — a real two-way
    /// toggle, not just a one-directional "clear on open".
    private func toggleReadStatus(_ chat: Chat) {
        guard let index = chats.firstIndex(where: { $0.id == chat.id }) else { return }
        withAnimation {
            chats[index].unreadCount = chats[index].unreadCount > 0 ? 0 : 1
        }
    }

    private func togglePin(_ chat: Chat) {
        guard let index = chats.firstIndex(where: { $0.id == chat.id }) else { return }
        withAnimation {
            chats[index].isPinned.toggle()
        }
    }

    private func markAllRead() {
        for index in chats.indices { chats[index].unreadCount = 0 }
    }

    // MARK: Selection / bulk actions

    private func toggleSelection(_ id: UUID) {
        if selectedIDs.contains(id) { selectedIDs.remove(id) } else { selectedIDs.insert(id) }
    }

    private func toggleSelectAll() {
        if selectedIDs.count == filteredChats.count {
            selectedIDs.removeAll()
        } else {
            selectedIDs = Set(filteredChats.map { $0.id })
        }
    }

    private func exitSelection() {
        withAnimation {
            isSelecting = false
            selectedIDs.removeAll()
        }
    }

    private func muteSelected() {
        for index in chats.indices where selectedIDs.contains(chats[index].id) {
            chats[index].isMuted = true
        }
        exitSelection()
    }

    private func markSelectedRead() {
        for index in chats.indices where selectedIDs.contains(chats[index].id) {
            chats[index].unreadCount = 0
        }
    }

    private func deleteSelected() {
        withAnimation {
            chats.removeAll { selectedIDs.contains($0.id) }
        }
        exitSelection()
    }

    private func startNewChat(named name: String, phone: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        // If a chat already exists for this contact, just open it instead
        // of creating a duplicate.
        if let existing = chats.first(where: { $0.name == trimmedName }) {
            showNewChat = false
            navigateTo = existing.id
            return
        }

        let trimmedPhone = phone.trimmingCharacters(in: .whitespacesAndNewlines)
        let initials = String(trimmedName.split(separator: " ").compactMap { $0.first }.prefix(2)).uppercased()

        let newChat = Chat(
            name: trimmedName,
            phoneNumber: trimmedPhone.isEmpty ? "Unknown" : trimmedPhone,
            avatarInitials: initials.isEmpty ? "?" : initials,
            avatarColor: Color.brand.primary,
            isOnline: Bool.random(),
            messages: [],
            unreadCount: 0
        )
        chats.insert(newChat, at: 0)
        showNewChat = false
        navigateTo = newChat.id
    }
}

// MARK: - Chat row

struct ChatRow: View {
    let chat: Chat

    var body: some View {
        HStack(spacing: 14) {
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(chat.avatarColor)
                    .frame(width: 52, height: 52)
                    .overlay(
                        Text(chat.avatarInitials)
                            .font(.poppins(size: 16, .medium))
                            .foregroundColor(.white)
                    )
                if chat.isOnline {
                    Circle()
                        .fill(Color.brand.primary)
                        .frame(width: 13, height: 13)
                        .overlay(Circle().stroke(.white, lineWidth: 2))
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    if chat.isPinned {
                        Image(systemName: "pin.fill")
                            .font(.system(size: 10))
                            .foregroundStyle(Color.brand.gray)
                    }
                    Text(chat.name)
                        .font(.poppins(size: 16, chat.unreadCount > 0 ? .semibold : .medium))
                        .foregroundColor(Color.brand.black)
                        .lineLimit(1)
                    if chat.isMuted {
                        Image(systemName: "bell.slash.fill")
                            .font(.system(size: 11))
                            .foregroundStyle(Color.brand.gray)
                    }
                }

                HStack(spacing: 4) {
                    if let last = chat.lastMessage, last.isSender {
                        Image(systemName: last.status == .read ? "checkmark.circle.fill" : "checkmark")
                            .font(.system(size: 11))
                            .foregroundStyle(last.status == .read ? Color.brand.primary : Color.brand.gray)
                    }
                    Text(previewText)
                        .font(.poppins(size: 14))
                        .foregroundColor(chat.isTyping ? Color.brand.primary : Color.brand.gray)
                        .lineLimit(1)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 6) {
                if let last = chat.lastMessage {
                    Text(relativeTime(last.timestamp))
                        .font(.poppins(size: 12))
                        .foregroundColor(Color.brand.gray)
                }
                // Unread badge and mute icon are independent — both can
                // show at once, so muting an unread chat doesn't hide
                // the fact that it's muted (or vice versa).
                if chat.unreadCount > 0 {
                    Text("\(chat.unreadCount)")
                        .font(.poppins(size: 11, .medium))
                        .foregroundColor(.white)
                        .frame(minWidth: 20, minHeight: 20)
                        .background(chat.isMuted ? Color.brand.gray : Color.brand.primary)
                        .clipShape(Circle())
                }
            }
        }
        .padding(12)
        .background(.white)
        .cornerRadius(18)
    }

    private var previewText: String {
        if chat.isTyping { return "typing…" }
        if let last = chat.lastMessage {
            return last.isVoiceNote ? "🎤 Voice message" : last.text
        }
        return "No messages yet"
    }

    private func relativeTime(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

// MARK: - Conversation screen

struct ChatDetailScreen: View {
    @Binding var chat: Chat
    @Environment(\.dismiss) private var dismiss

    @State private var draft: String = ""
    @State private var isRecording = false
    @State private var recordingSeconds = 0
    @State private var recordingTimer: Timer? = nil
    @State private var showOtherTyping = false
    @State private var showInCall = false

    var body: some View {
        ZStack {
            Color.brand.bg.ignoresSafeArea()

            VStack(spacing: 0) {
                header

                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(chat.messages) { message in
                                MessageBubble(message: message)
                                    .id(message.id)
                            }
                            if showOtherTyping {
                                TypingBubble()
                                    .id("typing")
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                        .padding(.bottom, 8)
                    }
                    .onChange(of: chat.messages.count) { _, _ in scrollToBottom(proxy) }
                    .onChange(of: showOtherTyping) { _, _ in scrollToBottom(proxy) }
                    .onAppear { scrollToBottom(proxy, animated: false) }
                }

                inputBar
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .navigationBar)
        .fullScreenCover(isPresented: $showInCall) {
            InCallScreen(chat: chat)
        }
    }

    private var header: some View {
        HStack(spacing: 12) {
            Button { dismiss() } label: {
                ZStack {
                    Circle().fill(.white).frame(width: 34, height: 34)
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.brand.black)
                }
            }
            .buttonStyle(.plain)

            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(chat.avatarColor)
                    .frame(width: 38, height: 38)
                    .overlay(
                        Text(chat.avatarInitials)
                            .font(.poppins(size: 13, .medium))
                            .foregroundColor(.white)
                    )
                if chat.isOnline {
                    Circle()
                        .fill(Color.brand.primary)
                        .frame(width: 10, height: 10)
                        .overlay(Circle().stroke(.white, lineWidth: 1.5))
                }
            }

            VStack(alignment: .leading, spacing: 1) {
                Text(chat.name)
                    .font(.poppins(size: 16, .medium))
                    .foregroundColor(Color.brand.black)
                Text(showOtherTyping ? "typing…" : (chat.isOnline ? "Online" : "Offline"))
                    .font(.poppins(size: 12))
                    .foregroundColor(showOtherTyping ? Color.brand.primary : Color.brand.gray)
            }

            Spacer()

            Button { showInCall = true } label: {
                Image(systemName: "phone.fill")
                    .foregroundStyle(Color.brand.primary)
                    .padding(8)
                    .background(.white)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)

            Button { showInCall = true } label: {
                Image(systemName: "video.fill")
                    .foregroundStyle(Color.brand.primary)
                    .padding(8)
                    .background(.white)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.brand.bg)
    }

    private var inputBar: some View {
        HStack(spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "paperclip").foregroundStyle(Color.brand.gray)
                TextField(isRecording ? "Recording \(formattedRecording)…" : "Message", text: $draft, axis: .vertical)
                    .font(.poppins(size: 15))
                    .disabled(isRecording)
                    .lineLimit(1...4)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 14)
            .background(.white)
            .cornerRadius(24)

            Button {
                if !draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { send() }
            } label: {
                ZStack {
                    Circle().fill(isRecording ? Color.red : Color.brand.primary).frame(width: 44, height: 44)
                    Image(systemName: draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "mic.fill" : "arrow.up")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }
            .buttonStyle(.plain)
            .simultaneousGesture(
                LongPressGesture(minimumDuration: 0.25).onEnded { _ in
                    guard draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                    startRecording()
                }
            )
            .simultaneousGesture(
                DragGesture(minimumDistance: 0).onEnded { _ in
                    if isRecording { stopRecordingAndSend() }
                }
            )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.brand.bg)
    }

    private var formattedRecording: String { String(format: "0:%02d", recordingSeconds) }

    private func send() {
        let text = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        chat.messages.append(ChatMessage(text: text, isSender: true, timestamp: Date(), status: .sent))
        draft = ""
        simulateDeliveryAndReply()
    }

    private func startRecording() {
        isRecording = true
        recordingSeconds = 0
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in recordingSeconds += 1 }
    }

    private func stopRecordingAndSend() {
        recordingTimer?.invalidate()
        recordingTimer = nil
        guard isRecording else { return }
        isRecording = false
        let duration = max(recordingSeconds, 1)
        recordingSeconds = 0
        chat.messages.append(ChatMessage(text: "", isSender: true, timestamp: Date(), status: .sent, isVoiceNote: true, voiceDuration: duration))
        simulateDeliveryAndReply()
    }

    private func simulateDeliveryAndReply() {
        guard let messageID = chat.messages.last?.id else { return }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            if let idx = chat.messages.firstIndex(where: { $0.id == messageID }) {
                chat.messages[idx].status = .delivered
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            if let idx = chat.messages.firstIndex(where: { $0.id == messageID }) {
                chat.messages[idx].status = .read
            }
            showOtherTyping = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) {
            showOtherTyping = false
            let replies = ["Got it 👍", "Sounds good!", "Okay, noted.", "Haha nice", "Let me check and get back to you."]
            chat.messages.append(ChatMessage(text: replies.randomElement() ?? "Okay", isSender: false, timestamp: Date()))
        }
    }

    private func scrollToBottom(_ proxy: ScrollViewProxy, animated: Bool = true) {
        let target: AnyHashable? = showOtherTyping ? "typing" : chat.messages.last?.id
        guard let target else { return }
        if animated {
            withAnimation(.easeOut(duration: 0.25)) { proxy.scrollTo(target, anchor: .bottom) }
        } else {
            proxy.scrollTo(target, anchor: .bottom)
        }
    }
}

// MARK: - In-app call screen (fully simulated: ringing -> connected -> ended)

struct InCallScreen: View {
    let chat: Chat
    @Environment(\.dismiss) private var dismiss

    private enum CallState { case ringing, connected, ended }

    @State private var state: CallState = .ringing
    @State private var seconds = 0
    @State private var timer: Timer? = nil
    @State private var isMuted = false
    @State private var isSpeakerOn = false
    @State private var pulse = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.brand.black, Color.brand.black.opacity(0.92)],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(chat.avatarColor)
                            .frame(width: 120, height: 120)
                            .scaleEffect(pulse && state == .ringing ? 1.08 : 1)
                            .animation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true), value: pulse)
                            .overlay(
                                Text(chat.avatarInitials)
                                    .font(.poppins(size: 40, .medium))
                                    .foregroundColor(.white)
                            )
                    }

                    Text(chat.name)
                        .font(.poppins(size: 24, .medium))
                        .foregroundColor(.white)

                    Text(statusLabel)
                        .font(.poppins(size: 15))
                        .foregroundColor(.white.opacity(0.7))
                }

                Spacer()

                if state == .connected {
                    HStack(spacing: 36) {
                        callToggleButton(icon: isMuted ? "mic.slash.fill" : "mic.fill", isActive: isMuted) {
                            isMuted.toggle()
                        }
                        callToggleButton(icon: "keypad", isActive: false) {}
                        callToggleButton(icon: isSpeakerOn ? "speaker.wave.3.fill" : "speaker.fill", isActive: isSpeakerOn) {
                            isSpeakerOn.toggle()
                        }
                    }
                    .padding(.bottom, 10)
                }

                Button {
                    endCall()
                } label: {
                    Image(systemName: "phone.down.fill")
                        .font(.system(size: 26))
                        .foregroundColor(.white)
                        .frame(width: 72, height: 72)
                        .background(Color.brand.danger)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            pulse = true
            // Simulate the other side picking up.
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                guard state == .ringing else { return }
                state = .connected
                startTimer()
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    private var statusLabel: String {
        switch state {
        case .ringing: return "Calling…"
        case .connected: return formattedDuration
        case .ended: return "Call ended"
        }
    }

    private var formattedDuration: String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%02d:%02d", m, s)
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            seconds += 1
        }
    }

    private func endCall() {
        timer?.invalidate()
        state = .ended
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            dismiss()
        }
    }

    @ViewBuilder
    private func callToggleButton(icon: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(isActive ? Color.brand.black : .white)
                .frame(width: 56, height: 56)
                .background(isActive ? .white : Color.white.opacity(0.15))
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Message bubble

struct MessageBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.isSender { Spacer(minLength: 40) }

            VStack(alignment: .trailing, spacing: 4) {
                Group {
                    if message.isVoiceNote {
                        HStack(spacing: 8) {
                            Image(systemName: "play.fill")
                                .foregroundStyle(message.isSender ? .white : Color.brand.primary)
                            Capsule()
                                .fill((message.isSender ? Color.white : Color.brand.primary).opacity(0.4))
                                .frame(width: 90, height: 3)
                            Text("0:\(String(format: "%02d", message.voiceDuration))")
                                .font(.poppins(size: 12))
                                .foregroundColor(message.isSender ? .white.opacity(0.85) : Color.brand.gray)
                        }
                    } else {
                        Text(message.text)
                            .font(.poppins(size: 15))
                            .foregroundColor(message.isSender ? .white : Color.brand.black)
                            .multilineTextAlignment(.leading)
                    }
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 14)
                .background(message.isSender ? Color.brand.primary : .white)
                .cornerRadius(18, corners: message.isSender
                    ? [.topLeft, .topRight, .bottomLeft]
                    : [.topLeft, .topRight, .bottomRight])

                HStack(spacing: 4) {
                    Text(timeString(message.timestamp))
                        .font(.poppins(size: 11))
                        .foregroundColor(Color.brand.gray)
                    if message.isSender {
                        Image(systemName: message.status == .sent ? "checkmark" : "checkmark.circle.fill")
                            .font(.system(size: 10))
                            .foregroundStyle(message.status == .read ? Color.brand.primary : Color.brand.gray)
                    }
                }
                .padding(.horizontal, 4)
            }

            if !message.isSender { Spacer(minLength: 40) }
        }
        .frame(maxWidth: .infinity, alignment: message.isSender ? .trailing : .leading)
    }

    private func timeString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}

// MARK: - Typing indicator

struct TypingBubble: View {
    @State private var bounce = false

    var body: some View {
        HStack {
            HStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { i in
                    Circle()
                        .fill(Color.brand.gray)
                        .frame(width: 6, height: 6)
                        .offset(y: bounce ? -3 : 0)
                        .animation(
                            .easeInOut(duration: 0.5).repeatForever().delay(Double(i) * 0.15),
                            value: bounce
                        )
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(.white)
            .cornerRadius(18, corners: [.topLeft, .topRight, .bottomRight])

            Spacer(minLength: 40)
        }
        .onAppear { bounce = true }
    }
}

// MARK: - New Chat (completely rebuilt: full-screen contact picker + search + manual entry)

struct NewChatScreen: View {
    var onSelect: (String, String) -> Void
    @Environment(\.dismiss) private var dismiss

    @State private var searchText = ""
    @State private var showManualEntry = false

    private let allContacts: [(name: String, phone: String)] = [
        ("Fahim Ahmed", "+1 (555) 321-6547"),
        ("Priya Das", "+1 (555) 654-3210"),
        ("Support Team", "+1 (555) 100-2000"),
        ("Tanvir Rahman", "+1 (555) 789-4561"),
        ("Nusrat Jahan", "+1 (555) 534-5678"),
        ("Rafiq Vai", "+1 (555) 945-6789"),
        ("Sadia Akter", "+1 (555) 856-7890"),
        ("Kamal Uddin", "+1 (555) 112-2334"),
        ("Sharmin Akter", "+1 (555) 223-3445"),
        ("Imran Khan", "+1 (555) 767-8901"),
    ]

    private var grouped: [String: [(name: String, phone: String)]] {
        let filtered = searchText.isEmpty
            ? allContacts
            : allContacts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        return Dictionary(grouping: filtered) { String($0.name.prefix(1)).uppercased() }
    }

    private var sortedKeys: [String] { grouped.keys.sorted() }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.brand.bg.ignoresSafeArea()

                VStack(spacing: 0) {
                    searchField
                        .padding(.horizontal, 20)
                        .padding(.top, 12)

                    Button {
                        showManualEntry = true
                    } label: {
                        HStack(spacing: 14) {
                            ZStack {
                                Circle().fill(Color.brand.primary).frame(width: 44, height: 44)
                                Image(systemName: "person.badge.plus")
                                    .foregroundStyle(.white)
                            }
                            Text("New Contact")
                                .font(.poppins(size: 16, .medium))
                                .foregroundColor(Color.brand.black)
                            Spacer()
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 16)
                        .background(.white)
                        .cornerRadius(16)
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 20)
                    .padding(.top, 16)

                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 20) {
                            ForEach(sortedKeys, id: \.self) { key in
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(key)
                                        .font(.poppins(size: 14, .medium))
                                        .foregroundColor(Color.brand.gray)

                                    VStack(spacing: 10) {
                                        ForEach(grouped[key] ?? [], id: \.name) { contact in
                                            Button {
                                                onSelect(contact.name, contact.phone)
                                            } label: {
                                                contactRow(contact)
                                            }
                                            .buttonStyle(.plain)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationTitle("New Chat")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .font(.poppins(size: 15))
                        .foregroundColor(Color.brand.primary)
                }
            }
            .sheet(isPresented: $showManualEntry) {
                ManualContactEntrySheet { name, phone in
                    showManualEntry = false
                    onSelect(name, phone)
                }
                .presentationDetents([.height(280)])
                .presentationDragIndicator(.visible)
            }
        }
    }

    private var searchField: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass").foregroundStyle(Color.brand.gray)
            TextField("Search contacts", text: $searchText)
                .font(.poppins(size: 15))
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
        .background(.white)
        .cornerRadius(14)
    }

    @ViewBuilder
    private func contactRow(_ contact: (name: String, phone: String)) -> some View {
        HStack(spacing: 14) {
            Circle()
                .fill(Color.brand.primary.opacity(0.15))
                .frame(width: 42, height: 42)
                .overlay(
                    Text(String(contact.name.first ?? "?"))
                        .font(.poppins(size: 15, .medium))
                        .foregroundColor(Color.brand.primary)
                )
            VStack(alignment: .leading, spacing: 2) {
                Text(contact.name)
                    .font(.poppins(size: 16))
                    .foregroundColor(Color.brand.black)
                Text(contact.phone)
                    .font(.poppins(size: 13))
                    .foregroundColor(Color.brand.gray)
            }
            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
        .background(.white)
        .cornerRadius(14)
    }
}

struct ManualContactEntrySheet: View {
    var onCreate: (String, String) -> Void
    @State private var name = ""
    @State private var phone = ""

    private var canCreate: Bool { !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }

    var body: some View {
        VStack(spacing: 16) {
            Text("New Contact")
                .font(.poppins(size: 18, .medium))
                .foregroundColor(Color.brand.black)
                .padding(.top, 20)

            TextField("Name", text: $name)
                .font(.poppins(size: 16))
                .padding(14)
                .background(Color.brand.bg)
                .cornerRadius(14)
                .padding(.horizontal, 20)

            TextField("Phone number", text: $phone)
                .font(.poppins(size: 16))
                .keyboardType(.phonePad)
                .padding(14)
                .background(Color.brand.bg)
                .cornerRadius(14)
                .padding(.horizontal, 20)

            Button {
                onCreate(name, phone)
            } label: {
                Text("Start Chat")
                    .font(.poppins(size: 16, .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(canCreate ? Color.brand.primary : Color.brand.gray.opacity(0.4))
                    .cornerRadius(16)
            }
            .buttonStyle(.plain)
            .disabled(!canCreate)
            .padding(.horizontal, 20)

            Spacer(minLength: 0)
        }
        .background(.white)
    }
}

// MARK: - Corner-radius helper

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

#Preview {
    MessagesRoot()
}
