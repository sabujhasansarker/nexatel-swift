import SwiftUI

struct RecentCall: View {
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            ForEach(Call.sampleData){ call in
                HStack(alignment: .top) {
                    HStack(alignment: .center, spacing: 16){
                        VStack(alignment: .center) {
                            Image("user-round")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                        }
                        .frame(width: 52, height: 52)
                        .background(.white)
                        .cornerRadius(100)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            HStack{
                                Text(call.number)
                                    .font(.poppins(size: 18, .medium))
                                    .foregroundColor(Color.brand.black)
                                Spacer()
                                Text(call.time.formattedRelative())
                                    .font(.poppins(size: 14))
                                    .foregroundColor(Color.brand.gray)
                            }
                            
                            switch call.type {
                                
                            case .incoming:
                                HStack{
                                    Image("arrow-up-right")
                                        .renderingMode(.template)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 16, height: 16)
                                        .foregroundStyle(Color.brand.gray)
                                    
                                    Text("Voice call")
                                        .font(.poppins(size: 14))
                                        .foregroundColor(Color.brand.gray)
                                }
                            case .outgoing:
                                HStack{
                                    Image("arrow-up-right")
                                        .renderingMode(.template)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 16, height: 16)
                                        .foregroundStyle(Color.brand.gray)
                                    
                                    Text("Voice call")
                                        .font(.poppins(size: 14))
                                        .foregroundColor(Color.brand.gray)
                                }
                            case .missed:
                                HStack{
                                    Image("arrow-down-left")
                                        .renderingMode(.template)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 16, height: 16)
                                        .foregroundStyle(Color.brand.danger)
                                    
                                    Text("You missed a call")
                                        .font(.poppins(size: 14))
                                        .foregroundColor(Color.brand.danger)
                                }
                                
                            case .message:
                                Text(call.note ?? "Message")
                                        .font(.poppins(size: 14))
                                        .foregroundColor(Color.brand.gray)
                            }
                        }
                    }
                }
            }
        }
    }
}
