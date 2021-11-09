//
//  CDWordEntity+Extension.swift
//  MyDictionary_App_Swift
//
//  Created by Dmytro Chumakov on 07.11.2021.
//

import Foundation

// MARK: - MDTextForSearchWithTwoPropertiesProtocol
extension CDWordEntity: MDTextForSearchWithTwoPropertiesProtocol {
    
    var textForSearch0: String {
        return wordText!
    }
    
    var textForSearch1: String {
        return wordDescription!
    }
    
}
