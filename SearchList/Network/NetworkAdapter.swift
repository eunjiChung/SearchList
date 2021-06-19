//
//  NetworkAdapter.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/19.
//

import Foundation
import Moya

enum ResponseCode: Int, Codable {
    case success = 200
}

struct NetworkAdapter {

    enum ResponseType: String, Codable {
        case success
    }

    struct Error: Codable {
        var code: Int?
        var message: String?
    }

    static let provider = MoyaProvider<MultiTarget>(plugins: [NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: .verbose))])

    @discardableResult
    static func request<T: TargetType>(target: T,
                                       success successCallback: @escaping (Response) -> Void,
                                       progress progressCallback: ((ProgressResponse) -> Void)? = nil,
                                       error errorCallback: @escaping (Swift.Error) -> Void,
                                       failure failureCallback: @escaping (MoyaError) -> Void) -> Cancellable {
        let cancellable = provider.request(MultiTarget(target), progress: { (progress) in
               progressCallback?(progress)
        }, completion: { (result) in
            switch result {
            case .success(let response):
                self.printCurl(for: target, request: response.request)

                if response.statusCode >= 200 && response.statusCode <= 300 {
                    successCallback(response)
                } else {
                    // 에러처리
                }
            case .failure(let error):
                self.printCurl(for: target, request: error.response?.request)
                failureCallback(error)
            }
        })

        return cancellable
    }

    private static func printCurl(for target: TargetType, request: URLRequest?) {
        #if DEBUG
        guard let request = request else { return }
        let message: String = "\ntarget: \(target)\n"
        #endif
    }
}
