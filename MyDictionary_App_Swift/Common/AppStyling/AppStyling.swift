//
//  AppStyling.swift
//  MyDictionary_App_Swift
//
//  Created by Dmytro Chumakov on 16.05.2021.
//

import UIKit

struct AppStyling {
    
    enum Color {
                
        // Light
        case md_White_0_Light_Appearence
        case md_Black_0_Light_Appearence
        case md_Light_Gray_0_Light_Appearence
        case md_Blue_0_Light_Appearence
        
        // Dark
        case md_White_0_Dark_Appearence
        case md_Black_0_Dark_Appearence
        case md_Light_Gray_0_Dark_Appearence
        case md_Blue_0_Dark_Appearence
        
        
        
        /// - Parameter alpha: 1.0 by default
        func color(_ alpha: CGFloat = 1.0) -> UIColor {
            switch self {
            
            // Light
            case .md_White_0_Light_Appearence:
                return UIColor.init(rgb: 0xFFFFFF, alpha: alpha)
                
            case .md_Black_0_Light_Appearence:
                return UIColor.init(rgb: 0x101010, alpha: alpha)
                
            case .md_Light_Gray_0_Light_Appearence:
                return UIColor.init(rgb: 0xF8F8F8, alpha: alpha)
                
            case .md_Blue_0_Light_Appearence:
                return UIColor.init(rgb: 0x007AFF, alpha: alpha)
                
            // Dark
            case .md_White_0_Dark_Appearence:
                return UIColor.init(rgb: 0xF2F2F7, alpha: alpha)
                
            case .md_Black_0_Dark_Appearence:
                return UIColor.init(rgb: 0x1C1C1E, alpha: alpha)
                
            case .md_Light_Gray_0_Dark_Appearence:
                return UIColor.init(rgb: 0x48484A, alpha: alpha)
                
            case .md_Blue_0_Dark_Appearence:
                return UIColor.init(rgb: 0x0A84FF, alpha: alpha)
                
            }
        }
        
    }
    
    enum Font {
        
        case systemFont
        case boldSystemFont
        
        /// - Parameter ofSize: 14.0 by default
        func font(ofSize size: CGFloat = 14.0) -> UIFont {
            switch self {
            case .systemFont:
                return .systemFont(ofSize: size)
            case .boldSystemFont:
                return .boldSystemFont(ofSize: size)
            }
        }
        
    }
    
}
