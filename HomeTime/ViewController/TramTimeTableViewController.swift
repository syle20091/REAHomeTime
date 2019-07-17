//
//  TramTimeTableViewController.swift
//  HomeTime
//
//  Copyright © 2019 REA. All rights reserved.
//

import Foundation
import UIKit

class TramTimeTableViewController: UIViewController {
    
    @IBOutlet var tramTimesTable: UITableView!
    
    var viewModel: TramTimeTableViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        clearTramData()
    }
    
    func setUp() {
        let tramDataService = TramDataService()
        viewModel = TramTimeTableViewModel(tramDataService: tramDataService)
        tramTimesTable.register(UINib(nibName: "TramTimeTableViewCell", bundle: nil), forCellReuseIdentifier: "TramCellIdentifier")
        self.view?.setUpErrorBanner()
    }
    
    @IBAction func clearButtonTapped(_ sender: UIBarButtonItem) {
        clearTramData()
    }
    
    @IBAction func loadButtonTapped(_ sender: UIBarButtonItem) {
        clearTramData()
        loadTramData()
    }
    
}

// MARK: - Tram Data

extension TramTimeTableViewController {
    
    func clearTramData() {
        viewModel.clearTramData()
        tramTimesTable.reloadData()
        self.view.errorBanner(show: false)
    }
    
    func loadTramData() {
        viewModel.loadTramDataUsing(stopId: "4055") {[weak self] (error) in
            if let error = error{
                print("Error retrieving trams: \(String(describing: error))")
                self?.view.errorBanner(show: true, error: error)
            }else{
                self?.tramTimesTable.reloadData()
                self?.view.errorBanner(show: false)
            }
        }
        
        viewModel.loadTramDataUsing(stopId: "4155") {[weak self] (error) in
            if let error = error{
                print("Error retrieving trams: \(String(describing: error))")
                self?.view.errorBanner(show: true, error: error)
            }else{
                self?.tramTimesTable.reloadData()
                self?.view.errorBanner(show: false)
            }
        }
    }
}


// MARK - UITableViewDataSource

extension TramTimeTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TramCellIdentifier", for: indexPath) as! TramTimeTableViewCell
        
        guard let timeText = viewModel.getTramArrivedText(section: indexPath.section, row: indexPath.row) else {
            return cell
        }
        cell.timeLabel?.text = timeText
        cell.timeIntervalLabel?.text = viewModel.getTimeInterval(section: indexPath.section, row: indexPath.row)
        
        return cell;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0)
        {
            guard let count = viewModel.getNorthTramsCount() else { return 1 }
            return count
        }
        else
        {
            guard let count = viewModel.getSouthTramsCount() else { return 1 }
            return count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let destination = viewModel.getDestinationWith(section: section) else {
            return section == 0 ? "North" : "South"
        }
        return section == 0 ? "North To \(destination)" : "South To \(destination)"
    }
    
}
