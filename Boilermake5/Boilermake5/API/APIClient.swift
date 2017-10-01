//
//  APIClient.swift
//  Boilermake5
//
//  Created by Ryuji Mano on 10/1/17.
//  Copyright © 2017 Ryuji Mano. All rights reserved.
//

import UIKit

fileprivate let baseURL = ""

enum APIClientError: Error {
    case APIError
}

class APIClient {

    let shared: APIClient = APIClient()

    func sendRequest(path: String, success: @escaping ([String : Any]) -> (), failure: @escaping (Error) -> ()) {
        let totalURL = baseURL + path

        guard let url = URL(string: totalURL) else {
            return
        }

        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)

        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                failure(error)
            }
            if let data = data {
                if let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String : Any] {
                    success(json)
                } else {
                    failure(APIClientError.APIError)
                }
            }
            else {
                failure(APIClientError.APIError)
            }
        }
        dataTask.resume()
    }

}
