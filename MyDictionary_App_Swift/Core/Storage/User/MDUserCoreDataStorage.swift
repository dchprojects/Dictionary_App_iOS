//
//  MDUserCoreDataStorage.swift
//  MyDictionary_App_Swift
//
//  Created by Dmytro Chumakov on 15.08.2021.
//

import Foundation
import CoreData

protocol MDUserCoreDataStorageProtocol: MDCRUDUserProtocol,
                                        MDStorageInterface {
    
}

final class MDUserCoreDataStorage: NSObject,
                                   MDUserCoreDataStorageProtocol {
    
    fileprivate let operationQueueService: OperationQueueServiceProtocol
    fileprivate let managedObjectContext: NSManagedObjectContext
    fileprivate let coreDataStack: CoreDataStack
    
    init(operationQueueService: OperationQueueServiceProtocol,
         managedObjectContext: NSManagedObjectContext,
         coreDataStack: CoreDataStack) {
        
        self.operationQueueService = operationQueueService
        self.managedObjectContext = managedObjectContext
        self.coreDataStack = coreDataStack
        
    }
    
    deinit {
        debugPrint(#function, Self.self)
    }
    
}

// MARK: - Entities
extension MDUserCoreDataStorage {
    
    func entitiesIsEmpty(_ completionHandler: @escaping (MDEntitiesIsEmptyResultWithCompletion)) {
        self.readAllUsers() { result in
            switch result {
            case .success(let entities):
                completionHandler(.success(entities.isEmpty))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func entitiesCount(_ completionHandler: @escaping (MDEntitiesCountResultWithCompletion)) {
        self.readAllUsers() { result in
            switch result {
            case .success(let entities):
                completionHandler(.success(entities.count))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
}

// MARK: - Create
extension MDUserCoreDataStorage {
    
    func createUser(_ userEntity: UserResponse, _ completionHandler: @escaping (MDEntityResult<UserResponse>)) {
        let operation = MDCreateUserCoreDataStorageOperation.init(managedObjectContext: self.managedObjectContext,
                                                                  coreDataStorage: self,
                                                                  userEntity: userEntity) { result in
            completionHandler(result)
        }
        operationQueueService.enqueue(operation)
    }
    
}

// MARK: - Read
extension MDUserCoreDataStorage {
    
    func readUser(fromUserID userId: Int64, _ completionHandler: @escaping (MDEntityResult<UserResponse>)) {
        let operation = MDReadUserCoreDataStorageOperation.init(managedObjectContext: self.managedObjectContext,
                                                                coreDataStorage: self,
                                                                userId: userId) { result in
            completionHandler(result)
        }
        operationQueueService.enqueue(operation)
    }
    
    func readAllUsers(_ completionHandler: @escaping (MDEntitiesResult<UserResponse>)) {
        let operation = MDReadUsersCoreDataStorageOperation.init(managedObjectContext: self.managedObjectContext,
                                                                 coreDataStorage: self) { result in
            completionHandler(result)
        }
        operationQueueService.enqueue(operation)
    }
    
}

// MARK: - Update
extension MDUserCoreDataStorage {
    
    
}

// MARK: - Delete
extension MDUserCoreDataStorage {
    
    func deleteUser(_ userEntity: UserResponse, _ completionHandler: @escaping (MDEntityResult<UserResponse>)) {
        let operation = MDDeleteUserCoreDataStorageOperation.init(managedObjectContext: self.managedObjectContext,
                                                                  coreDataStorage: self,
                                                                  userEntity: userEntity) { result in
            completionHandler(result)
        }
        operationQueueService.enqueue(operation)
    }
    
}

// MARK: - Save
extension MDUserCoreDataStorage {
    
    func savePerform(completionHandler: @escaping CDResultSaved) {
        coreDataStack.savePerform(completionHandler: completionHandler)
    }
    
    func savePerform(userId: Int64, completionHandler: @escaping MDEntityResult<UserResponse>) {
        coreDataStack.savePerform() { [unowned self] (result) in
            switch result {
            case .success:
                self.readUser(fromUserID: userId) { (result) in
                    switch result {
                    case .success(let userEntity):
                        completionHandler(.success(userEntity))
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func save(userId: Int64, completionHandler: @escaping MDEntityResult<UserResponse>) {
        coreDataStack.savePerformAndWait() { [unowned self] (result) in
            switch result {
            case .success:
                self.readUser(fromUserID: userId) { (result) in
                    switch result {
                    case .success(let userEntity):
                        completionHandler(.success(userEntity))
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
}
