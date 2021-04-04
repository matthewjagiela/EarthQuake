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
                    if success != true {
                        self.homeDelegate?.showErrorAlert(title: nil, message: errorMessage)
                    } else {
                        guard let features = features else {
                            self.homeDelegate?.showErrorAlert(title: nil, message: errorMessage)
                            return
                        }
                        self.earthQuakeData = features
                        self.homeDelegate?.refreshTableView()
                    }
                }
            } else {
                self.online = false
                self.homeDelegate?.updateOnlineStatus(online: false)
                self.homeDelegate?.showErrorAlert(title: "No Internet", message: "Your device current is not connected to the internet. When your device comes back online we will refresh the data for you.")
            }
            
        }
        monitor.start(queue: queue)
    }
    
    func numberOfItems() -> Int {
        return earthQuakeData?.count ?? 0
    }
    
    func getPlace(index: Int) -> String {
        guard let data = earthQuakeData?[index] else { return ""}
        return data.properties.title
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
}
