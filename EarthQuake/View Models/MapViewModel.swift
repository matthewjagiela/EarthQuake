//
//  MapViewModel.swift
//  EarthQuake
//
//  Created by Matthew Jagiela on 4/4/21.
//

import Foundation

struct Annotation {
    var title: String
    var latitude: Double
    var longitude: Double
}

class MapViewModel {
    private var earthQuakeData: [Feature]?
    var annotations = [Annotation]()
    weak var mapControllerDelegate: MapViewControllerDelegate?
    init(earthQuakeData: [Feature]) {
        self.earthQuakeData = earthQuakeData
        makeAnnotationsData()
    }

    func makeAnnotationsData() {
        guard let data = earthQuakeData else {
            mapControllerDelegate?.showMessgae(title: "Error",
                                               message: "There does not appear to be any Earthquake data to plot. Please try again later")
            return
        }
        for dataPoint in data {
            let annotation = Annotation(title: dataPoint.properties.title,
                                        latitude: dataPoint.geometry.coordinates[1],
                                        longitude: dataPoint.geometry.coordinates[0])
            annotations.append(annotation)
        }
    }
}
