import SwiftUI

extension Font {
    static func poppins(_ weight: PoppinsWeight = .regular, fontStyle: Font.TextStyle = .body) -> Font{
        return custom(weight.rawValue, size: fontStyle.size)
    }
    static func poppins(_ weight: PoppinsWeight = .regular, size: CGFloat) -> Font {
            .custom(weight.rawValue, size: size)
    }
}

extension Font.TextStyle {
    var size: CGFloat {
        switch self {
          case .largeTitle: return 34
          case .title: return 28
          case .title2: return 22
          case .title3: return 20
          case .headline: return 17
          case .body: return 16
          case .callout: return 16
          case .subheadline: return 15
          case .footnote: return 13
          case .caption: return 12
          case .caption2: return 11
          @unknown default: return 8
        }
    }
}

enum PoppinsWeight: String {
    case regular = "Poppins-Regular"
    case bold = "Poppins-Bold"
    case semibold = "Poppins-SemiBold"
    case light = "Poppins-Light"
}
