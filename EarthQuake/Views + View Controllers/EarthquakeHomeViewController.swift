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
    lazy var refreshButton = UIBarButtonItem()
    var showMapButton = UIBarButtonItem()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.homeDelegate = self
        setupTableView()
        pullToRefresh(self)
        if #available(iOS 13.0, *) {
            showMapButton = UIBarButtonItem(image: UIImage(systemName: "map.fill"),
                                            landscapeImagePhone: nil,
                                            style: .plain,
                                            target: self,
                                            action: #selector(showMapView(_:)))
        } else {
            showMapButton = UIBarButtonItem(title: "Map",
                                            style: .plain,
                                            target: self,
                                            action: #selector(showMapView(_:)))
        }
        navigationItem.leftBarButtonItem = showMapButton
    }

    private func setupTableView() {
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing")
        refreshControl.addTarget(self,
                                 action: #selector(pullToRefresh(_:)),
                                 for: .valueChanged)
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

    @objc func refreshData(_ sender: UIBarButtonItem) {
        viewModel.fetchData()
    }

    @objc func showMapView(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "showMap", sender: sender)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let map = segue.destination as? MapViewController {
            map.viewModel = MapViewModel(earthQuakeData: viewModel.getEarthquakeData() ?? [])
        }
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
            .bold("Magnitude: ")
            .normal(String(format: "%.1f", viewModel.getMagnitude(index: indexPath.row)))
        cell.timeLabel.attributedText = NSMutableAttributedString()
            .bold("Time: ")
            .normal("\(Date(milliseconds: viewModel.getTime(index: indexPath.row)).toString())")
        cell.annotate(annotation: viewModel.getMapAnnotation(index: indexPath.row))
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = viewModel.getURL(index: indexPath.row) else {
            return
        }
        if viewModel.isOnline() {
            let safari = SFSafariViewController(url: url,
                                                configuration: SFSafariViewController.Configuration())
            self.present(safari,
                         animated: true)
        } else {
            showErrorAlert(title: nil,
                           message: "Cannot Open URL because your device is offline.")
        }
        tableView.deselectRow(at: indexPath,
                              animated: true)

    }
}

extension EarthquakeHomeViewController: EarthquakeViewControllerDelegate {
    func updateOnlineStatus(online: Bool) {
        DispatchQueue.main.async {
            if online {
                self.navigationItem.rightBarButtonItems = nil
                self.refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh,
                                                     target: self,
                                                     action: #selector(self.refreshData(_:)))
                self.navigationItem.rightBarButtonItems = [self.refreshButton]
            } else {
                self.navigationItem.rightBarButtonItem = nil
                var status = UIBarButtonItem()
                if #available(iOS 13.0, *) {
                    status = UIBarButtonItem(image: UIImage(systemName: "exclamationmark.icloud"),
                                             landscapeImagePhone: nil,
                                             style: .plain,
                                             target: nil,
                                             action: nil)
                } else {
                    status = UIBarButtonItem(title: "WARNING: Device Offline",
                                             style: .plain,
                                             target: nil,
                                             action: nil)
                }
                status.isEnabled = false
                self.navigationItem.rightBarButtonItems = [status]
            }
        }
    }

    func showErrorAlert(title: String?, message: String) {
        let alertView = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Okay",
                                          style: .default))
        DispatchQueue.main.async {
            self.present(alertView,
                         animated: true)
        }
    }

    func refreshTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0),
                                       at: UITableView.ScrollPosition.top,
                                       animated: true)
        }
    }
}
