//
//  SessionManager.swift
//  VideoCallDemo
//
//  Created by Tùng Anh Nguyễn on 22/02/2022.
//

import Foundation
typealias Json = [String: Any]
typealias SuccessEvent<T: Codable> = (T) -> Void
typealias ErrorEvent = (Error?) -> Void

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

class ResponseModel: Codable {
    
}

class RequestModel: Codable {
}

protocol BaseRequest {
    associatedtype Response: Codable
    associatedtype Request: Codable
    
    var url: String { get }
    var method: RequestMethod { get }
    var body: Request { get }
    func parseData(data: Data) throws -> Response
}

class SessionManager: NSObject {
    static let share = SessionManager()
    
    func getSesstionId(onSuccess: @escaping SuccessEvent<LoginResponse>, onError: @escaping ErrorEvent) {
        let api = LoginApi()
        request(request: api, onSuccess: onSuccess, onError: onError)
    }
    
    func logout(sessionId: String) {
        let api = LogoutApi(sessionId: sessionId)
        request(request: api) { (data: ResponseModel) in
            
        } onError: { error in
            
        }
    }
    
    private func createRequest<T: BaseRequest>(request: T) -> URLRequest {
        let url = URL(string: request.url)!
        var urlRequest = URLRequest(url: url)
        let body = try? JSONEncoder().encode(request.body)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = body
        
        return urlRequest
    }
    
    private func request<T: BaseRequest, R: Codable>(request: T, onSuccess: @escaping SuccessEvent<R>, onError: @escaping ErrorEvent) {
        var dataTask: URLSessionDataTask?
        let urlRequest = createRequest(request: request)
        
        let allCookies = HTTPCookieStorage.shared.cookies
        for cookie in allCookies ?? [] {
            HTTPCookieStorage.shared.deleteCookie(cookie)
        }
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            defer {
                dataTask = nil
            }
            
            do {
                if let error = error {
                    DispatchQueue.main.async {
                        onError(error)
                    }
                } else if
                    let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    
                    print("GetSesstionId Response------------------")
                    print("\(String(decoding: data, as: UTF8.self))")
                    print("----------------------------------------")
                    
                    
                    let data = try? request.parseData(data: data)
                    
                    DispatchQueue.main.async {
                        onSuccess(data as! R)
                    }
                }
            } catch (let error) {
                onError(error)
            }
        }
        
        dataTask?.resume()
    }
}

extension SessionManager: URLSessionDelegate, URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge) async -> (URLSession.AuthChallengeDisposition, URLCredential?) {
        if challenge.protectionSpace.serverTrust == nil {
            return (.useCredential, nil)
        } else {
            let trust: SecTrust = challenge.protectionSpace.serverTrust!
            let credential = URLCredential(trust: trust)
            return (.useCredential, credential)
        }
    }
}
