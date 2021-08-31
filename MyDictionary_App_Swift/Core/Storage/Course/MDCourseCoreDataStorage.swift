//
//  MDCourseCoreDataStorage.swift
//  MyDictionary_App_Swift
//
//  Created by Dmytro Chumakov on 23.08.2021.
//

import Foundation
import CoreData

protocol MDCourseCoreDataStorageProtocol: MDCRUDCourseProtocol,
                                          MDStorageInterface {
    
}

final class MDCourseCoreDataStorage: MDCourseCoreDataStorageProtocol {
    
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
extension MDCourseCoreDataStorage {
    
    func entitiesCount(_ completionHandler: @escaping(MDEntitiesCountResultWithCompletion)) {
        self.readAllCourses { result in
            switch result {
            case .success(let entities):
                completionHandler(.success(entities.count))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func entitiesIsEmpty(_ completionHandler: @escaping(MDEntitiesIsEmptyResultWithCompletion)) {
        self.readAllCourses { result in
            switch result {
            case .success(let entities):
                completionHandler(.success(entities.isEmpty))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
}

// MARK: - CRUD
extension MDCourseCoreDataStorage {
    
    func createCourse(_ courseEntity: CourseResponse, _ completionHandler: @escaping (MDOperationResultWithCompletion<CourseResponse>)) {
        let operation: MDCreateCourseCoreDataStorageOperation = .init(managedObjectContext: self.managedObjectContext,
                                                                      coreDataStorage: self,
                                                                      courseEntity: courseEntity) { result in
            completionHandler(result)
        }
        operationQueueService.enqueue(operation)
    }
    
    func readCourse(fromCourseId courseId: Int64, _ completionHandler: @escaping (MDOperationResultWithCompletion<CourseResponse>)) {
        let operation: MDReadCourseCoreDataStorageOperation = .init(managedObjectContext: self.managedObjectContext,
                                                                    coreDataStorage: self,
                                                                    courseId: courseId) { result in
            completionHandler(result)
        }
        operationQueueService.enqueue(operation)
    }
    
    func readAllCourses(_ completionHandler: @escaping (MDOperationResultWithCompletion<[CourseResponse]>)) {
        let operation: MDReadAllCoursesCoreDataStorageOperation = .init(managedObjectContext: self.managedObjectContext,
                                                                        coreDataStorage: self) { result in
            completionHandler(result)
        }
        operationQueueService.enqueue(operation)
    }
    
    func deleteCourse(fromCourseId courseId: Int64, _ completionHandler: @escaping (MDOperationResultWithCompletion<Void>)) {
        let operation: MDDeleteCourseCoreDataStorageOperation = .init(managedObjectContext: self.managedObjectContext,
                                                                      coreDataStorage: self,
                                                                      courseId: courseId) { result in
            completionHandler(result)
        }
        operationQueueService.enqueue(operation)
    }
    
    func deleteAllCourses(_ completionHandler: @escaping (MDOperationResultWithCompletion<Void>)) {
        let operation: MDDeleteAllCoursesCoreDataStorageOperation = .init(managedObjectContext: self.managedObjectContext,
                                                                          coreDataStorage: self) { result in
            completionHandler(result)
        }
        operationQueueService.enqueue(operation)
    }
    
}

// MARK: - Save
extension MDCourseCoreDataStorage {
    
    func savePerform(completionHandler: @escaping CDResultSaved) {
        coreDataStack.savePerform(completionHandler: completionHandler)
    }
    
    func savePerform(courseID: Int64, completionHandler: @escaping(MDOperationResultWithCompletion<CourseResponse>)) {
        coreDataStack.savePerform() { [unowned self] (result) in
            switch result {
            case .success:
                self.readCourse(fromCourseId: courseID) { (result) in
                    switch result {
                    case .success(let courseEntity):
                        completionHandler(.success(courseEntity))
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func save(courseID: Int64, completionHandler: @escaping(MDOperationResultWithCompletion<CourseResponse>)) {
        coreDataStack.savePerformAndWait() { [unowned self] (result) in
            switch result {
            case .success:
                self.readCourse(fromCourseId: courseID) { (result) in
                    switch result {
                    case .success(let courseEntity):
                        completionHandler(.success(courseEntity))
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
