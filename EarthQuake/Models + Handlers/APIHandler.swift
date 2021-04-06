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
    func fetchEarthQuakeData(daysAway: DatesForFilter, fetched: @escaping(_ success: APIResponse, _ data: [Feature]?) -> Void) {
        let date = Date().dateFrom(daysAway: daysAway.rawValue)
        guard let apiURL = URL(string: "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&eventtype=earthquake&starttime=\(date)") else { return }
        let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
        session.dataTask(with: apiURL) { data, _, error in
            if error != nil {
                fetched(APIResponse.fetchingError, nil)
                return
            }
            if let data = data {
                let decoder = JSONDecoder()
                let decodableStructure = try? decoder.decode(EarthQuakeData.self, from: data)
                guard let data = decodableStructure?.features else {
                    fetched(.decodingError, nil)
                    return
                }
                guard let metaData = decodableStructure?.metadata else {
                    fetched(.decodingError, nil)
                    return
                }
                if metaData.status != 200 {
                    fetched(.APIError(code: metaData.status), nil)
                } else {
                    fetched(.success, data)
                }
            } else {
                fetched(.decodingError, nil)
            }
        }.resume()
    }
}
