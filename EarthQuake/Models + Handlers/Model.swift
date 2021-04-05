//
//  Model.swift
//  EarthQuake
//
//  Created by Matthew Jagiela on 4/2/21.
// Use this to store the classes we will be using for decodable JSON structures

import Foundation

class EarthQuakeData: Decodable {
    var type: String
    var metadata: Metadata
    var features: [Feature]?

    init(type: String, metadata: Metadata, features: [Feature]?) {
        self.type = type
        self.metadata = metadata
        self.features = features
    }

}

// MARK: - Feature
class Feature: Decodable {
    let type: String
    let properties: Properties
    let geometry: Geometry
    let id: String

    init(type: String, properties: Properties, geometry: Geometry, id: String) {
        self.type = type
        self.properties = properties
        self.geometry = geometry
        self.id = id
    }
}

// MARK: - Geometry
class Geometry: Decodable {
    var type: String
    var coordinates: [Double]

    init(type: String, coordinates: [Double]) {
        self.type = type
        self.coordinates = coordinates
    }
}

// MARK: - Properties
class Properties: Decodable {
    var mag: Double
    var place: String
    var time: Int
    var url: String
    var title: String
    var alert: String?

    init(mag: Double, place: String, time: Int, url: String, title: String, alert: String?) {
        self.mag = mag
        self.place = place
        self.time = time
        self.url = url
        self.title = title
        self.alert = alert
    }
}

// MARK: - Metadata
class Metadata: Decodable {
    var generated: Int
    var url: String
    var title: String
    var status: Int
    var api: String
    var limit, offset, count: Int

    init(generated: Int, url: String, title: String, status: Int, api: String, limit: Int, offset: Int, count: Int) {
        self.generated = generated
        self.url = url
        self.title = title
        self.status = status
        self.api = api
        self.limit = limit
        self.offset = offset
        self.count = count
    }
}
