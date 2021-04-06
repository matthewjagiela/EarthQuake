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
    
    var viewModel: EarthquakeHomeViewModel = EarthquakeHomeViewModel()
    lazy var refreshButton = UIBarButtonItem()
    var showMapButton = UIBarButtonItem()
    var filterButton = UIBarButtonItem()
    var activity = UIBarButtonItem()
    var activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.homeDelegate = self
        setupTableView()
        refreshData(self)
        if #available(iOS 13.0, *) {
            filterButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.decrease.circle"),
                                           landscapeImagePhone: nil,
                                           style: .plain,
                                           target: self,
                                           action: #selector(setDateFilter(_:)))
            showMapButton = UIBarButtonItem(image: UIImage(systemName: "map.fill"),
                                            landscapeImagePhone: nil,
                                            style: .plain,
                                            target: self,
                                            action: #selector(showMapView(_:)))
        } else {
            filterButton = UIBarButtonItem(title: "Filter",
                                           style: .plain,
                                           target: self,
                                           action: #selector(setDateFilter(_:)))
            showMapButton = UIBarButtonItem(title: "Map",
                                            style: .plain,
                                            target: self,
                                            action: #selector(showMapView(_:)))
        }
        navigationItem.leftBarButtonItem = showMapButton
        activity = UIBarButtonItem(customView: activityIndicator)
        activityIndicator.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            activityIndicator.style = .medium
        } else {
            activityIndicator.style = .gray
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 102
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    @objc func refreshData(_ sender: AnyObject) {
        activityIndicator.startAnimating()
        viewModel.fetchData()
    }
    
    @objc func showMapView(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "showMap", sender: sender)
    }
    
    @objc func setDateFilter(_ sender: UIBarButtonItem) {
        let
            currentFilter = viewModel.dateFilter
        let dateFilterView = UIAlertController(title: "Set The Date Range",
                                               message: "Please select how many days you would like to see data for",
                                               preferredStyle: .actionSheet)
        dateFilterView.popoverPresentationController?.barButtonItem = filterButton
        dateFilterView.addAction(UIAlertAction(title: currentFilter == .Today ? "24 Hours (Current)" : "24 Hours",
                                               style: .default,
                                               handler: { _ in
                                                self.viewModel.setFilterAndRefresh(filter: .Today)
                                                self.activityIndicator.startAnimating()
                                                self.refreshData(sender)
                                               }))
        dateFilterView.addAction(UIAlertAction(title: currentFilter == .Week ? "This Week (Current)" : "This Week",
                                               style: .default,
                                               handler: { _ in
                                                self.viewModel.setFilterAndRefresh(filter: .Week)
                                                self.activityIndicator.startAnimating()
                                                self.refreshData(sender)
                                               }))
        dateFilterView.addAction(UIAlertAction(title: currentFilter == .FifteenDays ? "Fifteen Days (Current)" : "Fifteen Days",
                                               style: .default,
                                               handler: { _ in
                                                self.viewModel.setFilterAndRefresh(filter: .FifteenDays)
                                                self.activityIndicator.startAnimating()
                                                self.refreshData(sender)
                                               }))
        dateFilterView.addAction(UIAlertAction(title: currentFilter == .ThirtyDays ? "Thirty Days (Current)" : "Thirty Days",
                                               style: .default,
                                               handler: { _ in
                                                self.viewModel.setFilterAndRefresh(filter: .Today)
                                                self.activityIndicator.startAnimating()
                                                self.refreshData(sender)
                                               }))
        dateFilterView.addAction(UIAlertAction(title: "Cancel",
                                               style: .cancel))
        DispatchQueue.main.async {
            self.present(dateFilterView, animated: true)
        }
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
                self.navigationItem.rightBarButtonItems = [self.filterButton, self.refreshButton, self.activity]
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
            self.activityIndicator.startAnimating()
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0),
                                       at: UITableView.ScrollPosition.top,
                                       animated: true)
            self.activityIndicator.stopAnimating()
        }
    }
}
