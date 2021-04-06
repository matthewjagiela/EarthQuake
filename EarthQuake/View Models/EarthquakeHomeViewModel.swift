//
//  EarthquakeHomeViewModel.swift
//  EarthQuake
//
//  Created by Matthew Jagiela on 4/3/21.
//

import Foundation
import Network

class EarthquakeHomeViewModel {
    private var earthQuakeData: [Feature]?
    private let api = APIHandler()
    private let queue = DispatchQueue(label: "Monitor")
    private let monitor = NWPathMonitor()
    private var online = true
    weak var homeDelegate: EarthquakeViewControllerDelegate?

    init(homeDelegate: EarthquakeViewControllerDelegate? = nil) {
        self.homeDelegate = homeDelegate
    }

    func fetchData() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.online = true
                self.homeDelegate?.updateOnlineStatus(online: true)
                let errorMessage = "We Could Not Fetch Data At This Time"
                self.api.fetchEarthQuakeData { (success, features) in

                    switch success {
                    case .APIError(let code):
                        print("ERROR API \(code)")
                        self.homeDelegate?.showErrorAlert(title: "Server Error",
                                                          message: "Sorry... The server is not responding. Please try again later")
                    case .success:
                        self.makeAPIRequest(features: features)
                    default: self.homeDelegate?.showErrorAlert(title: nil,
                                                               message: errorMessage)
                    }

                }

            } else {
                self.online = false
                self.homeDelegate?.updateOnlineStatus(online: false)
                self.homeDelegate?.showErrorAlert(title: "No Internet",
                                                  message: "Your device current is not connected to the internet. When your device comes back online we will refresh the data for you.")
            }

        }
        monitor.start(queue: queue)
    }

    private func makeAPIRequest(features: [Feature]?) {
        guard let features = features else {
            self.homeDelegate?.showErrorAlert(title: nil,
                                              message: "We Could Not Fetch Data At This Time")
            return
        }
        self.earthQuakeData = features
        self.homeDelegate?.refreshTableView()
    }

    func numberOfItems() -> Int {
        return earthQuakeData?.count ?? 0
    }

    func getPlace(index: Int) -> String {
        guard let data = earthQuakeData?[index] else { return ""}
        return data.properties.place
    }

    func getMagnitude(index: Int) -> Double {
        guard let data = earthQuakeData?[index] else { return 0.0 }
        return data.properties.mag
    }

    func getTime(index: Int) -> Int {
        guard let data = earthQuakeData?[index] else { return 0 }
        return data.properties.time
    }

    func getURL(index: Int) -> URL? {
        guard let data = earthQuakeData?[index] else { return nil }
        return URL(string: data.properties.url)
    }

    func isOnline() -> Bool {
        return online
    }

    func getEarthquakeData() -> [Feature]? {
        return earthQuakeData
    }
    
    func getMapAnnotation(index: Int) -> Annotation {
        guard let earthquake = earthQuakeData else {
            print("Earthquake Home View Model: There was an error setting annotations")
            return Annotation(title: "", latitude: 0, longitude: 0)
            
        }
        return Annotation(title: "", latitude: earthquake[index].geometry.coordinates[1], longitude: earthquake[index].geometry.coordinates[0])
       
    }
}
