//
//  CourseListPresenter.swift
//  MyDictionary_App_Swift
//
//  Created Dmytro Chumakov on 11.08.2021.

import UIKit

protocol CourseListPresenterInputProtocol: TableViewDelegatePropertyProtocol,
                                           TableViewDataSourcePropertyProtocol {
    func addNewCourseButtonClicked()
    func settingsButtonClicked()
}

protocol CourseListPresenterOutputProtocol: AnyObject {
    
}

protocol CourseListPresenterProtocol: CourseListPresenterInputProtocol,
                                      CourseListInteractorOutputProtocol {
    var presenterOutput: CourseListPresenterOutputProtocol? { get set }
}

final class CourseListPresenter: NSObject, CourseListPresenterProtocol {
    
    fileprivate let interactor: CourseListInteractorInputProtocol
    fileprivate let router: CourseListRouterProtocol
       
    internal weak var presenterOutput: CourseListPresenterOutputProtocol?
    
    init(interactor: CourseListInteractorInputProtocol,
         router: CourseListRouterProtocol) {
        self.interactor = interactor
        self.router = router
        super.init()
    }
    
    deinit {
        debugPrint(#function, Self.self)
    }
    
}

// MARK: - CourseListInteractorOutputProtocol
extension CourseListPresenter {
    
}

// MARK: - CourseListPresenterInputProtocol
extension CourseListPresenter {
    
    internal var tableViewDelegate: UITableViewDelegate {
        return interactor.tableViewDelegate
    }
    
    internal var tableViewDataSource: UITableViewDataSource {
        return interactor.tableViewDataSource
    }
    
    // Actions //
    func addNewCourseButtonClicked() {
        debugPrint(Self.self, #function)
    }
    
    func settingsButtonClicked() {
        router.openSettings()        
    }
    // --- //
    
}