import SwiftUI

struct SocialButton: View {
    let title: String
    let icon: String
    var isSystemIcon: Bool = false
    var style: Int = 1
    var verticalPadding: CGFloat = 15
    var iconSize: CGFloat = 20
    var action: () -> Void = {}
    
    private var iconImage: Image {
           isSystemIcon ? Image(systemName: icon) : Image(icon)
       }
    
    var body: some View {
        switch style {
            
        case 2:
            Button(action: action) {
                HStack(alignment: .center,spacing: 17) {
                    iconImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: iconSize)
                    
                    Text(title)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Color.brand.black)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, verticalPadding)
                .padding(.leading, 25)
                .background(.white)
                .cornerRadius(180)
                .overlay(
                    RoundedRectangle(cornerRadius: 180)
                        .inset(by: 1)
                        .stroke(Color.brand.border, lineWidth: 2)
                )
            }
        default:
            Button(action: action) {
                HStack(alignment: .center,spacing: 60) {
                    iconImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                    
                    Text(title)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.black)
                }
                .padding(.leading, 20)
                .padding(.trailing, 0)
                .padding(.vertical, 0)
                .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60, alignment: .leading)
                .cornerRadius(180)
                .overlay(
                    RoundedRectangle(
                        cornerRadius: 180).inset(by: 1).stroke(Color(red: 0.91, green: 0.91, blue: 0.92), lineWidth: 2)
                )
            }
        }
        
    }
}
