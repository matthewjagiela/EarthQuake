//
//  APIHandler.swift
//  EarthQuake
//
//  Created by Matthew Jagiela on 4/2/21.
//

import Foundation

class APIHandler {
    func fetchEarthQuakeData(amount: Int = 30, fetched: @escaping(_ success: Bool, _ data: [Feature]?) -> Void) {
        var eqData: [Feature]?
        guard let apiURL = URL(string: "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&limit=\(amount)&eventtype=earthquake") else { return }
        URLCache.shared.removeAllCachedResponses()
        URLSession.shared.dataTask(with: apiURL) { data, _, error in
            if error != nil {
                fetched(false, nil)
                return
            }
            if let data = data {
                let decoder = JSONDecoder()
                let decodableStructure = try? decoder.decode(EarthQuakeData.self, from: data)
                eqData = decodableStructure?.features
                fetched(true, eqData)
            } else {
                fetched(false, nil)
            }
        }.resume()
    }
}
