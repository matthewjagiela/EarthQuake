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
    var refreshControl = UIRefreshControl()
    let apiHandler = APIHandler()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupTableView()
        refreshData()
    }
    
    func refreshData() {
        refreshControl.beginRefreshing()
        let errorMessage = "We Could Not Fetch The Data At This Time"
        apiHandler.fetchEarthQuakeData { (success, features) in
            if success != true {
                self.showErrorAlert(message: errorMessage)
            } else {
                guard let features = features else {
                    self.showErrorAlert(message: errorMessage)
                    return
                }
                self.data = features
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
        
    }
    
    private func setupTableView() {
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing")
        refreshControl.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 102
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    @objc func pullToRefresh(_ sender: AnyObject) {
        refreshData()
        
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuakeCell") as? EarthquakeTableViewCell, let data = data?[indexPath.row] else { return UITableViewCell() }
        cell.titleLabel.text = data.properties.place
        cell.magLabel.attributedText = NSMutableAttributedString()
            .bold("Mag: ")
            .normal(String(format: "%.1f", data.properties.mag))
        cell.timeLabel.attributedText = NSMutableAttributedString()
            .bold("Time: ")
            .normal("\(Date(milliseconds: data.properties.time).toString())")
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

