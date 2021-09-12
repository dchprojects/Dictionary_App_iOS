//
//  MDRequestDispatcher.swift
//  MyDictionary_App_Swift
//
//  Created by Dmytro Chumakov on 13.07.2021.
//

import Foundation
import UIKit
import Reachability

protocol MDRequestDispatcherProtocol {
    init(reachability: Reachability, environment: MDEnvironmentProtocol, networkSession: MDNetworkSessionProtocol)
    func execute(endpoint: MDEndpoint, completion: @escaping (MDResponseOperationResult) -> Void) -> URLSessionTask?
}

final class MDRequestDispatcher: MDRequestDispatcherProtocol {
    
    fileprivate let reachability: Reachability
    /// The environment configuration.
    fileprivate var environment: MDEnvironmentProtocol
    /// The network session configuration.
    fileprivate var networkSession: MDNetworkSessionProtocol
    
    required init(reachability: Reachability,
                  environment: MDEnvironmentProtocol,
                  networkSession: MDNetworkSessionProtocol) {
        
        self.reachability = reachability
        self.environment = environment
        self.networkSession = networkSession
        
    }
    
    deinit {
        debugPrint(#function, Self.self)
    }
    
}

// MARK: - Execute
extension MDRequestDispatcher {
    
    func execute(endpoint: MDEndpoint, completion: @escaping (MDResponseOperationResult) -> Void) -> URLSessionTask? {
        // Check Internet Connection
        guard (isReachable) else {
            DispatchQueue.main.async {
                completion(.error(MDAPIError.noInternetConnection, nil))
            }
            return nil
        }
        // Show Indicator //
        showNetworkActivityIndicator()
        // Create a URL request.
        guard let urlRequest = endpoint.urlRequest(with: environment) else {
            // Hide Indicator //
            hideNetworkActivityIndicator()
            // -------------- //
            completion(.error(MDAPIError.badRequest, nil))
            return nil
        }
        
        // Create a URLSessionTask to execute the URLRequest.
        var task: URLSessionTask?
        switch endpoint.requestType {
        case .data:
            task = networkSession.dataTask(with: urlRequest, completionHandler: { (data, urlResponse, error) in
                self.handleJsonTaskResponse(data: data, urlResponse: urlResponse, error: error, completion: completion)
                // Hide Indicator //
                self.hideNetworkActivityIndicator()
                // -------------- //
            })
            break
        }
        
        // Start the task.
        task?.resume()
        
        return task
    }
    
}

fileprivate extension MDRequestDispatcher {
    
    func handleJsonTaskResponse(data: Data?, urlResponse: URLResponse?, error: Error?, completion: @escaping (MDResponseOperationResult) -> Void) {
        // Check if the response is valid.
        guard let urlResponse = urlResponse as? HTTPURLResponse else {
            DispatchQueue.main.async {
                completion(MDResponseOperationResult.error(MDAPIError.invalidResponse, nil))
            }
            return
        }
        // Verify the HTTP status code.
        let result = verify(data: data, urlResponse: urlResponse, error: error)
        switch result {
        case .success(let data):
            DispatchQueue.main.async {
                completion(MDResponseOperationResult.data(data, urlResponse))
            }
        case .failure(let error):
            DispatchQueue.main.async {
                completion(MDResponseOperationResult.error(error, urlResponse))
            }
        }
    }
    
    func verify(data: Data?, urlResponse: HTTPURLResponse, error: Error?) -> Result<Data?, Error> {
        guard let statusCode = MDAPIStatusCode.init(rawValue: urlResponse.statusCode) else { return .failure(MDAPIError.unknown) }
        switch statusCode {
        case .ok:
            return .success(data)
        case .badRequest:
            return .failure(MDAPIError.badRequest)
        case .unauthorized:
            return .failure(MDAPIError.unauthorized)
        case .forbidden:
            return .failure(MDAPIError.forbidden)
        case .notFound:
            return .failure(MDAPIError.notFound)
        case .methodNotAllowed:
            return .failure(MDAPIError.methodNotAllowed)
        case .conflict:
            return .failure(MDAPIError.conflict)
        case .internalServerError:
            return .failure(MDAPIError.internalServerError)
        }
    }
    
}

// MARK: - Network Activity Indicator
fileprivate extension MDRequestDispatcher {
    
    func showNetworkActivityIndicator() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
    
    func hideNetworkActivityIndicator() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
}

// MARK: - Check Internet Connection
fileprivate extension MDRequestDispatcher {
    
    var isReachable: Bool {
        return (reachability.connection == .cellular || reachability.connection == .wifi)
    }
    
}
