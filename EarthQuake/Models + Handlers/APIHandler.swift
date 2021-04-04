//
//  APIHandler.swift
//  EarthQuake
//
//  Created by Matthew Jagiela on 4/2/21.
//

import Foundation
enum APIResponse: Error {
    case success
    case fetchingError
    case decodingError
    case APIError(code: Int)
}

class APIHandler {
    func fetchEarthQuakeData(amount: Int = 30, fetched: @escaping(_ success: APIResponse, _ data: [Feature]?) -> Void) {
        guard let apiURL = URL(string: "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&limit=\(amount)&eventtype=earthquake") else { return }
        let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
        session.dataTask(with: apiURL) { data, _, error in
            if error != nil {
                fetched(APIResponse.fetchingError, nil)
                return
            }
            if let data = data {
                let decoder = JSONDecoder()
                let decodableStructure = try? decoder.decode(EarthQuakeData.self, from: data)
                guard let featureData = decodableStructure?.features else {
                    fetched(.APIError(code: decodableStructure?.metadata.status ?? 404), nil)
                    return
                }
                fetched(.success, featureData)
            } else {
                fetched(.decodingError, nil)
            }
        }.resume()
    }
}
