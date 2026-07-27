import SwiftUI

extension Font {
    static func poppins(size: CGFloat, _ weight: PoppinsWeight = .regular) -> Font {
        .custom(weight.rawValue, size: size)
    }

    static func poppins(fontStyle: Font.TextStyle = .body, _ weight: PoppinsWeight = .regular) -> Font {
        .custom(weight.rawValue, size: fontStyle.size)
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
    case medium = "Poppins-Medium"
    case semibold = "Poppins-SemiBold"
    case bold = "Poppins-Bold"
    case light = "Poppins-Light"
}
