//
//  CustomURLProtocol.swift
//  web-view-ios
//
//  Created by Артур Гетьман on 11.05.2025.
//

import Foundation
import WebKit

struct Configuration {
    let headers: [String: String]
}

class CustomURLProtocol: URLProtocol {
    static var configuration: Configuration?

    override class func canInit(with request: URLRequest) -> Bool {
        if URLProtocol.property(forKey: "Handled", in: request) == nil {
            return request.url?.scheme == "http"
                || request.url?.scheme == "https"
        }
        return false
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest
    {
        return request
    }

    override func startLoading() {
        guard
            let mutableRequest = (request as NSURLRequest).mutableCopy()
                as? NSMutableURLRequest
        else {
            return
        }

        URLProtocol.setProperty(true, forKey: "Handled", in: mutableRequest)

        // Используйте конфигурацию для добавления заголовков
        if let headers = Bundle.main.object(forInfoDictionaryKey: "WebViewHeaders") as? [String: String] {
            for (key, value) in headers {
                mutableRequest.setValue(value, forHTTPHeaderField: key)
            }
        }

        let task = URLSession.shared.dataTask(
            with: mutableRequest as URLRequest
        ) { data, response, error in
            if let data = data {
                self.client?.urlProtocol(self, didLoad: data)
            }
            if let response = response {
                self.client?.urlProtocol(
                    self,
                    didReceive: response,
                    cacheStoragePolicy: .notAllowed
                )
            }
            self.client?.urlProtocolDidFinishLoading(self)
        }
        task.resume()
    }

    override func stopLoading() {
    }
    
}
