//
//  MDMemoryStorage.swift
//  MyDictionary_App_Swift
//
//  Created by Dmytro Chumakov on 21.05.2021.
//

import Foundation

protocol MDWordMemoryStorageProtocol: MDCRUDWordProtocol,
                                      MDWordsCountProtocol {
    
}

final class MDWordMemoryStorage: MDWordMemoryStorageProtocol {
    
    fileprivate let operationQueueService: OperationQueueServiceProtocol
    
    var arrayWords: [WordModel]
    
    init(operationQueueService: OperationQueueServiceProtocol,
         arrayWords: [WordModel]) {
        
        self.operationQueueService = operationQueueService
        self.arrayWords = arrayWords
        
    }
    
    deinit {
        debugPrint(#function, Self.self)
    }
    
}

// MARK: - Count
extension MDWordMemoryStorage {
    
    func wordsCount(_ completionHandler: @escaping (MDWordsCountResult)) {
        self.readAllWords() { [unowned self] result in
            switch result {
            case .success(let words):
                completionHandler(.success(words.count))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
}

// MARK: - CRUD
extension MDWordMemoryStorage {
    
    func createWord(_ wordModel: WordModel, _ completionHandler: @escaping(MDWordResult)) {
        let operation = MDCreateWordMemoryStorageOperation.init(wordStorage: self,
                                                                word: wordModel) { result in
            completionHandler(result)
        }
        operationQueueService.enqueue(operation)
    }
    
    func readWord(fromID id: Int64, _ completionHandler: @escaping(MDWordResult)) {
        let operation = MDReadWordMemoryStorageOperation.init(wordStorage: self, id: id) { result in
            completionHandler(result)
        }
        operationQueueService.enqueue(operation)
    }
    
    func readWords(fetchLimit: Int, fetchOffset: Int, _ completionHandler: @escaping (MDWordsResult)) {
        completionHandler(.failure(MDWordOperationError.cantFindWord))
    }
    
    func readAllWords(_ completionHandler: @escaping (MDWordsResult)) {
        completionHandler(.success(self.arrayWords))
    }
    
    func updateWord(byID id: Int64, word: String, word_description: String, _ completionHandler: @escaping(MDWordResult)) {
        let operation = MDUpdateWordMemoryStorageOperation.init(wordStorage: self, id: id, word: word, word_description: word_description) { result in
            completionHandler(result)
        }
        operationQueueService.enqueue(operation)
    }
    
    func deleteWord(_ word: WordModel, _ completionHandler: @escaping(MDWordResult)) {
        let operation = MDDeleteWordMemoryStorageOperation.init(wordStorage: self, word: word) { result in
            completionHandler(result)
        }
        operationQueueService.enqueue(operation)
    }
    
}
