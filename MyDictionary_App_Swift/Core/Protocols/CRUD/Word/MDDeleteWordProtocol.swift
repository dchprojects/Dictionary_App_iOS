//
//  MDDeleteWordProtocol.swift
//  MyDictionary_App_Swift
//
//  Created by Dmytro Chumakov on 29.05.2021.
//

import Foundation

protocol MDDeleteWordProtocol {
    
    func deleteWord(_ word: WordResponse,
                    _ completionHandler: @escaping(MDEntityResult<WordResponse>))
    
    func deleteAllWords(_ completionHandler: @escaping(MDEntityResult<Void>))
    
}
