//
//  APIHandler.swift
//  EarthQuake
//
//  Created by Matthew Jagiela on 4/2/21.
//

import Foundation

class APIHandler {
    func fetchEarthQuakeData(amount: Int = 30) {
        guard let apiURL = URL(string: "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&limit=\(amount)&eventtype=earthquake") else { return }
        let completion = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: apiURL) { data, _, error in
            if let error = error {
                print("error fetching") //TODO: Change this
                return
            }
            
            print("Data: \(data)")
            completion.signal()
        }.resume()
        completion.wait()
    }
}
