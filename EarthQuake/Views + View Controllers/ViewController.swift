//
//  ViewController.swift
//  EarthQuake
//
//  Created by Matthew Jagiela on 4/2/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let apiHandler = APIHandler()
        print(apiHandler.fetchEarthQuakeData()?[0].properties.title)
        print("This should come after the data print")
    }


}

