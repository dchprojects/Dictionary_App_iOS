//
//  ConfigurationAppearanceControllerProtocol.swift
//  MyDictionary_App_Swift
//
//  Created by Dmytro Chumakov on 06.06.2021.
//

import UIKit

protocol ConfigureAppearanceViewBackgroundColor {
    static func viewBackgroundColor(fromAppearanceType type: AppearanceType) -> UIColor
}

protocol ConfigureAppearanceNavigationBarTintColor {
    static func navigationBarTintColor(fromAppearanceType type: AppearanceType) -> UIColor
}

protocol ConfigureAppearanceNavigationBarProtocol: ConfigureAppearanceNavigationBarTintColor {
    static func navigationBarTitleTextAttributes(fromAppearanceType type: AppearanceType) -> [NSAttributedString.Key : Any]
}

protocol ConfigureAppearanceButtonTextColor {
    static func buttonTextColor(fromAppearanceType type: AppearanceType) -> UIColor
}

protocol ConfigureAppearanceButtonBackgroundColor {
    static func buttonBackgroundColor(fromAppearanceType type: AppearanceType) -> UIColor
}

protocol ConfigureAppearanceLabelTextColor {
    static func labelTextColor(fromAppearanceType type: AppearanceType) -> UIColor
}

protocol ConfigurationAppearanceControllerProtocol: ConfigureAppearanceViewBackgroundColor,
                                                    ConfigureAppearanceNavigationBarProtocol,
                                                    ConfigureAppearanceButtonTextColor,
                                                    ConfigureAppearanceButtonBackgroundColor,
                                                    ConfigureAppearanceLabelTextColor {
    
}

struct ConfigurationAppearanceController: ConfigurationAppearanceControllerProtocol {
    
}

// MARK: - Configured
extension ConfigurationAppearanceController {
    
    /// - Parameter fromAppearanceType type: Appearance.current.appearanceType by default
    static func viewBackgroundColor(fromAppearanceType type: AppearanceType = Appearance.current.appearanceType) -> UIColor {
        switch type {
        case .automatic:
            return self.viewBackgroundColor(fromAppearanceType: .light)
        case .light:
            return MDAppStyling.Color.md_FFFFFF.color()
        case .dark:
            return MDAppStyling.Color.md_FFFFFF.color()
        }
    }
    
    /// - Parameter fromAppearanceType type: Appearance.current.appearanceType by default
    static func navigationBarTitleTextAttributes(fromAppearanceType type: AppearanceType = Appearance.current.appearanceType) -> [NSAttributedString.Key : Any] {
        switch type {
        case .automatic:
            return self.navigationBarTitleTextAttributes(fromAppearanceType: .light)
        case .light, .dark:
            return self.navigationBarAttributedStringForegroundColorAndFont(fromAppearanceType: type)
        }
    }
    
    fileprivate static func navigationBarAttributedStringForegroundColorAndFont(fromAppearanceType type: AppearanceType) -> [NSAttributedString.Key : Any] {
        switch type {
        case .light:
            return [NSAttributedString.Key.foregroundColor : MDAppStyling.Color.md_FFFFFF.color(),
                    NSAttributedString.Key.font : MDAppStyling.Font.MyriadProRegular.font()]
        case .dark:
            return [NSAttributedString.Key.foregroundColor : MDAppStyling.Color.md_FFFFFF.color(),
                    NSAttributedString.Key.font : MDAppStyling.Font.MyriadProRegular.font()]
        default:
            return Self.navigationBarAttributedStringForegroundColorAndFont(fromAppearanceType: .light)
        }
    }
    
    /// - Parameter fromAppearanceType type: Appearance.current.appearanceType by default
    static func navigationBarTintColor(fromAppearanceType type: AppearanceType = Appearance.current.appearanceType) -> UIColor {
        switch type {
        case .automatic:
            return self.navigationBarTintColor(fromAppearanceType: .light)
        case .light:
            return MDAppStyling.Color.md_FFFFFF.color()
        case .dark:
            return MDAppStyling.Color.md_FFFFFF.color()
        }
    }
    
    /// - Parameter fromAppearanceType type: Appearance.current.appearanceType by default
    static func buttonBackgroundColor(fromAppearanceType type: AppearanceType = Appearance.current.appearanceType) -> UIColor {
        switch type {
        case .automatic:
            return self.buttonBackgroundColor(fromAppearanceType: .light)
        case .light:
            return MDAppStyling.Color.md_FFFFFF.color()
        case .dark:
            return MDAppStyling.Color.md_FFFFFF.color()
        }
    }
    
    /// - Parameter fromAppearanceType type: Appearance.current.appearanceType by default
    static func buttonTextColor(fromAppearanceType type: AppearanceType = Appearance.current.appearanceType) -> UIColor {
        switch type {
        case .automatic:
            return self.buttonTextColor(fromAppearanceType: .light)
        case .light:
            return MDAppStyling.Color.md_FFFFFF.color()
        case .dark:
            return MDAppStyling.Color.md_FFFFFF.color()
        }
    }
    
    /// - Parameter fromAppearanceType type: Appearance.current.appearanceType by default
    static func labelTextColor(fromAppearanceType type: AppearanceType = Appearance.current.appearanceType) -> UIColor {
        switch type {
        case .automatic:
            return self.labelTextColor(fromAppearanceType: .light)
        case .light:
            return MDAppStyling.Color.md_FFFFFF.color()
        case .dark:
            return MDAppStyling.Color.md_FFFFFF.color()
        }
    }
    
}
