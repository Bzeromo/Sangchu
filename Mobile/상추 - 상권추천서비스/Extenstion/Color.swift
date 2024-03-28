//
//  extensions.swift
//  상추 - 상권 분석 서비스
//
//  Created by 안상준 on 3/7/24.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 1) // Invalid format
        }
        self.init(
            .sRGB,
            red: Double(r) / 255.0,
            green: Double(g) / 255.0,
            blue:  Double(b) / 255.0,
            opacity: 1
        )
    }
}

struct AppColors {
    static let gradient = [Color(hex: "37683B"), Color(hex: "529B58")]
    static let gradientColors = [Color(hex: "FF8080"), Color(hex: "FFA680"), Color(hex: "FFBF80"), Color(hex: "FFD480"), Color(hex: "FFE680"), Color(hex: "F4FF80"), Color(hex: "D5FF80"), Color(hex: "A2FF80"), Color(hex: "80FF9E"), Color(hex: "80FFD5"), Color(hex: "80EAFF"), Color(hex: "80A6FF"), Color(hex: "8A80FF"), Color(hex: "BF80FF"), Color(hex: "FD80FF"), Color(hex: "FF8097")]
    static let topColors = [Color(hex: "87CC6C"), Color(hex: "6DBCCD"), Color(hex: "C078D2")]
    static let numberTop = [Color(hex: "F5DC82"), Color(hex: "FDFF93"), Color(hex: "F6F339"), Color(hex: "93C73D")]
    static let numberBottom = [Color(hex: "E36AD4"), Color(hex: "F45E35"), Color(hex: "86D979"), Color(hex: "F0F2ED")]
}
