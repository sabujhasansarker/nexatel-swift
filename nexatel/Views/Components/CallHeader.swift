import SwiftUI

struct CallHeader : View {
    var search: Bool = false
    var body: some View {
        VStack{
            HStack(alignment: .center){
                HStack(alignment: .center, spacing: 15){
                    Image("user-image")
                        .foregroundColor(.clear)
                        .frame(width: 52, height: 52)
                        .cornerRadius(150)
                    VStack(alignment: .leading, spacing: 5){
                        Text("Mehedi Hasan")
                            .font(.poppins(size: 20, .medium))
                            .foregroundColor(.black)
                        Text("mehedi@gmail.com")
                            .font(.poppins(size: 16, .regular))
                            .foregroundColor(Color.brand.gray)
                            .accentColor(Color.brand.gray)
                    }
                }
                
                Spacer()
                
                Button
                {
                    
                } label:{
                    Image("bell-dot")
                        .font(.system(size: 30))
                }
                .frame(width: 52, height: 52)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 130))
                .overlay(
                    RoundedRectangle(cornerRadius: 130)
                        .inset(by: 0.5)
                        .stroke(Color(red: 0.91, green: 0.91, blue: 0.92), lineWidth: 1)
                )
            }
          if search {
              VStack{
                  HStack(alignment: .center, spacing: 10) {
                      Image("search")
                          .renderingMode(.template)
                          .resizable()
                          .scaledToFit()
                          .frame(width: 20, height: 20)
                          .foregroundColor(Color.brand.gray500)
                      
                      TextField("Search or start a new chat", text: .constant(""))
                          .cornerRadius(30)
                          .font(.poppins(size: 18))
                          .foregroundColor(.brand.gray)
                          .padding(.vertical, 15)
                  }
                  .padding(.horizontal, 20)
                  .background(.white)
                  .cornerRadius(270)
                  .overlay(
                    RoundedRectangle(cornerRadius: 270)
                        .inset(by: 0.5)
                        .stroke(Color.brand.border, lineWidth: 1)
                  )
              }.padding(.top, 15)
            }
        }
        .padding(.bottom, 35)
        .padding(.horizontal)
    }
}
