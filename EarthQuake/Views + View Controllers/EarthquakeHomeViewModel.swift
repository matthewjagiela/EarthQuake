//
//  EarthquakeHomeViewModel.swift
//  EarthQuake
//
//  Created by Matthew Jagiela on 4/3/21.
//

import Foundation

class EarthquakeHomeViewModel {
    private var earthQuakeData: [Feature]?
    private let api = APIHandler()
    weak var homeDelegate: EarthquakeViewControllerDelegate?
    
    init(homeDelegate: EarthquakeViewControllerDelegate? = nil) {
        self.homeDelegate = homeDelegate
    }
    
    func fetchData() {
        let errorMessage = "We Could Not Fetch Data At This Time"
        api.fetchEarthQuakeData { (success, features) in
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
}
