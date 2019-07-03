//
//  YLPClient.swift
//  YelpApi-DILearning
//
//  Created by Karthick Ramasamy on 6/28/19.
//  Copyright © 2019 Karthick Ramasamy. All rights reserved.
//

import Foundation
import SwiftyJSON

public enum YLPClientError: Error {
    case networkCommunicationError(Error)
    case jsonParsingError
    case typeCastingError
    case couldNotBuildURL
    case unknownError
    case jsonDecodingError(Error)
}

public enum HTTPRequestType {
    case get
    case post
}

public class YLPClient {
    private let YLPApiHost = "api.yelp.com"
    private let apiKey = "uHVKlKY9Is_SFXvylnM6cmUuT69OxKeFxQtx75Xm_P-OudVwCZMvq98GhbB4pfstq3Eie27pSupxiJftjkpmQ56R8Y00ueOkbiMNQFQGv5EmIfoy8tB5ULa0MEcKXXYx"
    
    public typealias JSONSuccessHandler = (JSON) -> ()
    public typealias DataSuccessHandler = (Data) -> ()
    public typealias ModelSuccessHandler = (Codable) -> ()
    public typealias FailureHandler = (YLPClientError) -> ()

    func getModel<T: Codable>(withPath path: String,
                              params: [String: String]? = nil,
                              successHandler:  @escaping (T) -> (),
                              failureHandler: @escaping FailureHandler) {
        getData(withPath: path, params: params, successHandler: { data in
            do {
                let jsonDecoder = JSONDecoder()
                let result = try jsonDecoder.decode(T.self, from: data)
                successHandler(result)
            } catch {
                failureHandler(.jsonDecodingError(error))
            }
        }, failureHandler: failureHandler)
    }
    
    func getData(withPath path: String, params: [String: String]? = nil,
                 successHandler:  @escaping DataSuccessHandler,
                 failureHandler: @escaping FailureHandler) {
        do {
            let request = try getRequest(withPath: path, params: params)
            query(withRequest: request, successHandler: successHandler, failureHandler: failureHandler)
        } catch YLPClientError.couldNotBuildURL  {
            failureHandler(.couldNotBuildURL)
        } catch {
            failureHandler(.unknownError)
        }
    }
    
    func getJSON(withPath path: String,
                 params: [String: String]? = nil,
                 successHandler:  @escaping (JSON) -> (),
                 failureHandler: @escaping (YLPClientError) -> ()) {
        do {
            let request = try getRequest(withPath: path, params: params)
            query(withRequest: request, successHandler: { data in
                guard let json = try? JSON(data: data) else {
                    failureHandler(.jsonParsingError)
                    return
                }
                successHandler(json)
            }, failureHandler: failureHandler)
        } catch YLPClientError.couldNotBuildURL  {
            failureHandler(.couldNotBuildURL)
        } catch {
            failureHandler(.unknownError)
        }
    }
    
    func getRequest(withPath path: String,
                    params: [String: String]? = nil) throws -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = YLPApiHost
        urlComponents.path = path
        
        if let params = params, params.count > 0 {
            urlComponents.queryItems = queryItems(for: params)
        }
        
        guard let url = urlComponents.url else {
            throw YLPClientError.couldNotBuildURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(authHeader, forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    func queryItems(for params: [String: String]) -> [URLQueryItem] {
        return params.map { URLQueryItem(name: $0, value: $1) }
    }
    
    func query(withRequest request: URLRequest,
               successHandler: @escaping DataSuccessHandler,
               failureHandler: @escaping FailureHandler) {
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                failureHandler(.networkCommunicationError(error))
            } else if let data = data {
               successHandler(data)
            } else {
                failureHandler(.unknownError)
            }
        }.resume()
    }
    
    var authHeader: String {
        return "Bearer \(apiKey)"
    }
}
