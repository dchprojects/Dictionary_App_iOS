//
//  AddWordModule.swift
//  MyDictionary_App_Swift
//
//  Created Dmytro Chumakov on 27.09.2021.

import UIKit

final class AddWordModule {
    
    let sender: Any?
    
    init(sender: Any?) {
        self.sender = sender
    }
    
    deinit {
        debugPrint(#function, Self.self)
    }
    
}

extension AddWordModule {
    
    var module: UIViewController {
        
        let dataProvider: AddWordDataProviderProtocol = AddWordDataProvider.init()
        var dataManager: AddWordDataManagerProtocol = AddWordDataManager.init(dataProvider: dataProvider)
        
        let interactor: AddWordInteractorProtocol = AddWordInteractor.init(dataManager: dataManager)
        var router: AddWordRouterProtocol = AddWordRouter.init()
        let presenter: AddWordPresenterProtocol = AddWordPresenter.init(interactor: interactor, router: router)
        let vc = AddWordViewController.init(presenter: presenter)
        
        presenter.presenterOutput = vc
        interactor.interactorOutput = presenter
        dataManager.dataManagerOutput = interactor
        router.presenter = vc
        
        return vc
        
    }
    
}