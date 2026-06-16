//
//  AppColors.swift
//  Haze
//
//  Created by Noah McClung on 5/17/26.
//


//
//  AppColors.swift
//  HazeOS
//

import SwiftUI
import UIKit

enum AppColors {

    // MARK: - Backgrounds

    static let background = Color(
        uiColor: UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor.black
            : UIColor.white
        }
    )

    static let secondaryBackground = Color(
        uiColor: UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor(red: 0.08, green: 0.08, blue: 0.08, alpha: 1)
            : UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        }
    )

    // MARK: - Text

    static let primaryText = Color(
        uiColor: UIColor { trait in
            trait.userInterfaceStyle == .dark
            ? UIColor.white
            : UIColor.black
        }
    )

    static let secondaryText = Color.gray

    // MARK: - Accent

    static let accent = Color.white

    // MARK: - Atmospheric

    static let rain = Color.gray
    static let sun = Color.orange
    static let fog = Color.gray.opacity(0.7)
}
