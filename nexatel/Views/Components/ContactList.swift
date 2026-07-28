import SwiftUI

struct ContactList: View {

    private var groupedContacts: [String: [ContactModel]] {
        Dictionary(grouping: ContactModel.sampleData) { contact in
            String(contact.name.prefix(1)).uppercased()
        }
    }

    private var sortedKeys: [String] {
        groupedContacts.keys.sorted()
    }

    var body: some View {
        VStack(spacing: 30) {
            ForEach(sortedKeys, id: \.self) { key in
                VStack(alignment: .leading, spacing: 22) {
                    Text(key)
                        .font(.poppins(size: 22, .medium))
                        .foregroundColor(Color.brand.gray)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .padding(.leading, 5)

                    VStack(spacing: 22) {
                        ForEach(groupedContacts[key] ?? []) { contact in
                            NavigationLink {
                                ContactDetails(contact: contact)
                            } label: {
                                contactRow(contact: contact)
                            }
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func contactRow(contact: ContactModel) -> some View {
        HStack(spacing: 14) {
            VStack(alignment: .center) {
                Image("user-round")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            .frame(width: 52, height: 52)
            .background(.white)
            .cornerRadius(100)

            VStack(alignment: .leading, spacing: 9) {
                Text(contact.name)
                    .font(.poppins(size: 18, .medium))
                    .foregroundColor(Color.brand.black)
                Text(contact.phone)
                    .font(.poppins(size: 16))
                    .foregroundColor(Color.brand.gray)
            }

            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        ContactList()
    }
}
