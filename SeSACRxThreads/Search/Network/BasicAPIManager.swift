//
//  BasicAPIManager.swift
//  SeSACRxThreads
//
//  Created by 선상혁 on 2023/11/09.
//

import Foundation
import RxSwift

enum APIError: Error {
    case invalidURL
    case unknown
    case statusError
}

final class BasicAPIManager {
    
    static func fetchData() -> Observable<SearchAppModel> {
        
        Observable<SearchAppModel>.create { value in
            
            let urlString = "https://itunes.apple.com/search?term=todo&country=KR&media=software&lang=ko_KR&limit=10"

            guard let url = URL(string: urlString) else {
                value.onError(APIError.invalidURL)
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let _ = error {
                    value.onError(APIError.unknown)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    value.onError(APIError.statusError)
                    return
                }
                
                if let data = data, let appData = try? JSONDecoder().decode(SearchAppModel.self, from: data) {
                    value.onNext(appData)
                }
                
            }.resume()
            
            return Disposables.create()
        }
        

    }
}
