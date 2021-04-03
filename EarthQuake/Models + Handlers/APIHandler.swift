//
//  APIHandler.swift
//  EarthQuake
//
//  Created by Matthew Jagiela on 4/2/21.
//

import Foundation

class APIHandler {
    func fetchEarthQuakeData(amount: Int = 30) -> [Feature]? {
        var eqData: [Feature]?
        guard let apiURL = URL(string: "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&limit=\(amount)&eventtype=earthquake") else { return nil }
        let completion = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: apiURL) { data, _, error in
            if let error = error {
                print("error fetching \(error.localizedDescription)") //TODO: Change this
                return
            }
            if let data = data {
                let decoder = JSONDecoder()
                let decodableStructure = try? decoder.decode(EarthQuakeData.self, from: data)
                eqData = decodableStructure?.features
            } else {
                print("error decoding data...") //TODO: Change This
            }
            completion.signal()
        }.resume()
        completion.wait()
        return eqData
    }
}
