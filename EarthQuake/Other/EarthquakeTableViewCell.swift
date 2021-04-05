//
//  EarthquakeTableViewCell.swift
//  EarthQuake
//
//  Created by Matthew Jagiela on 4/3/21.
//

import UIKit
import MapKit

class EarthquakeTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var magLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var map: MKMapView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        map.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func annotate(annotation: Annotation) {
        map.removeAnnotations(map.annotations)
        let zooms: CLLocationDistance = 900000
        let marker = MKPointAnnotation()
        marker.coordinate = CLLocationCoordinate2D(latitude: annotation.latitude,
                                                   longitude: annotation.longitude)
        map.addAnnotation(marker)
        map.showAnnotations([marker], animated: false)
        let zoom  = MKCoordinateRegion(center: marker.coordinate,
                                       latitudinalMeters: zooms,
                                       longitudinalMeters: zooms)
        map.setRegion(zoom,
                      animated: false)
    }

}
