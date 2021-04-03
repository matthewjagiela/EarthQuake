//
//  ViewController.swift
//  EarthQuake
//
//  Created by Matthew Jagiela on 4/2/21.
//

import UIKit
import SafariServices
protocol ViewControllerDelegate: class {
    func showErrorAlert(message: String)
}
class ViewController: UIViewController {

    var data: [Feature]?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let apiHandler = APIHandler()
        data = apiHandler.fetchEarthQuakeData()
        print("This should come after the data print")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuakeCell"), let data = data else { return UITableViewCell() }
        cell.textLabel?.text = data[indexPath.row].properties.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = data else {
            return
        }
        if let url = URL(string: data[indexPath.row].properties.url) {
            let safari = SFSafariViewController(url: url, configuration: SFSafariViewController.Configuration())
            self.present(safari, animated: true)
        }
    }
}

extension ViewController: ViewControllerDelegate {
    func showErrorAlert(message: String) {
        print("SHOW MESSAGE")
    } //TODO: Show Alert Message
}

