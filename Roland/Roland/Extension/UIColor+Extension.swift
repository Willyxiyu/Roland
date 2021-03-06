//
//  UIColor+Extension.swift
//  Roland
//
//  Created by 林希語 on 2021/10/27.
//

import UIKit

private enum STColor: String {

    // swiftlint:disable identifier_name
    case themeColor

    case secondThemeColor

}

extension UIColor {

    static let themeColor = STColor(.themeColor)

    static let secondThemeColor = STColor(.secondThemeColor)
    // swiftlint:enable identifier_name
    private static func STColor(_ color: STColor) -> UIColor? {

        return UIColor(named: color.rawValue)
    }

    static func hexStringToUIColor(hex: String) -> UIColor {

        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count) != 6 {
            return UIColor.gray
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
