//
//  MapViewController.swift
//  EarthQuake
//
//  Created by Matthew Jagiela on 4/4/21.
//

import UIKit
import MapKit
protocol MapViewControllerDelegate: class {
    func showMessgae(title: String?, message: String)
}
class MapViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    
    var viewModel: MapViewModel!
    var mapAnnotations = [MKPointAnnotation]()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.mapControllerDelegate = self
        map.delegate = self
        createAnnotation()
    }
    
    func createAnnotation() {
        map.visibleMapRect = .world
        for annotation in viewModel.annotations {
            let marker = MKPointAnnotation()
            marker.title = annotation.title
            marker.coordinate = CLLocationCoordinate2D(latitude: annotation.latitude, longitude: annotation.longitude)
            map.addAnnotation(marker)
            mapAnnotations.append(marker)
        }
        map.showAnnotations(mapAnnotations, animated: true)
    }

}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: "reuseIdentifier") as? MKMarkerAnnotationView
        if view == nil {
            view = MKMarkerAnnotationView(annotation: nil, reuseIdentifier: "reuseIdentifier")
        }
        view?.annotation = annotation
        view?.displayPriority = .required
        return view
    }
    
}

extension MapViewController: MapViewControllerDelegate {
    func showMessgae(title: String?, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}
