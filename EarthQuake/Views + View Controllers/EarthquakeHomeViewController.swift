//
//  ViewController.swift
//  EarthQuake
//
//  Created by Matthew Jagiela on 4/2/21.
//

import UIKit
import SafariServices
protocol EarthquakeViewControllerDelegate: class {
    func showErrorAlert(title: String?, message: String)
    func refreshTableView()
    func updateOnlineStatus(online: Bool)
}
class EarthquakeHomeViewController: UIViewController {
    
    var refreshControl = UIRefreshControl()
    var viewModel: EarthquakeHomeViewModel = EarthquakeHomeViewModel()
        
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel.homeDelegate = self
        setupTableView()
        pullToRefresh(self)
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
        self.refreshControl.beginRefreshing()
        viewModel.fetchData()
    }
    
}

extension EarthquakeHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuakeCell") as? EarthquakeTableViewCell else { return UITableViewCell() }
        cell.titleLabel.text = viewModel.getPlace(index: indexPath.row)
        cell.magLabel.attributedText = NSMutableAttributedString()
            .bold("Mag: ")
            .normal(String(format: "%.1f", viewModel.getMagnitude(index: indexPath.row)))
        cell.timeLabel.attributedText = NSMutableAttributedString()
            .bold("Time: ")
            .normal("\(Date(milliseconds: viewModel.getTime(index: indexPath.row)).toString())")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = viewModel.getURL(index: indexPath.row) else {
            return
        }
        if viewModel.isOnline() {
            let safari = SFSafariViewController(url: url, configuration: SFSafariViewController.Configuration())
            self.present(safari, animated: true)
        } else {
            showErrorAlert(title: nil, message: "Cannot Open URL because your device is offline.")
        }
        
    }
}

extension EarthquakeHomeViewController: EarthquakeViewControllerDelegate {
    func updateOnlineStatus(online: Bool) {
        DispatchQueue.main.async {
            if online {
                self.navigationItem.rightBarButtonItems = nil
            } else {
                let status = UIBarButtonItem(title: "WARNING: Device Offline", style: .plain, target: nil, action: nil)
                status.isEnabled = false
                self.navigationItem.rightBarButtonItems = [status]
            }
        }
    }
    
    func showErrorAlert(title: String?, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Okay", style: .default))
        DispatchQueue.main.async {
            self.present(alertView, animated: true)
        }
    }
    
    func refreshTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
}

