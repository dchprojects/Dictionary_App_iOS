//
//  EditWordModule.swift
//  MyDictionary_App_Swift
//
//  Created Dmytro Chumakov on 28.09.2021.

import UIKit

final class EditWordModule {
    
    let sender: WordResponse
    
    init(sender: WordResponse) {
        self.sender = sender
    }
    
    deinit {
        debugPrint(#function, Self.self)
    }
    
}

extension EditWordModule {
    
    var module: UIViewController {
        let dataProvider: EditWordDataProviderProtocol = EditWordDataProvider.init(word: sender,
                                                                                   editButtonIsSelected: false)
        var dataManager: EditWordDataManagerProtocol = EditWordDataManager.init(dataProvider: dataProvider)
        
        let interactor: EditWordInteractorProtocol = EditWordInteractor.init(dataManager: dataManager)
        var router: EditWordRouterProtocol = EditWordRouter.init()
        let presenter: EditWordPresenterProtocol = EditWordPresenter.init(interactor: interactor, router: router)
        let vc = EditWordViewController.init(presenter: presenter)
        
        presenter.presenterOutput = vc
        interactor.interactorOutput = presenter
        dataManager.dataManagerOutput = interactor
        router.presenter = vc
        
        return vc
    }
    
}