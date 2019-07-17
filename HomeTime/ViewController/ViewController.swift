//
//  Copyright © 2017 REA. All rights reserved.
//

import UIKit

typealias JSONDictionary = [String: Any]

enum JSONError: Error {
  case serialization
}

class ViewController: UITableViewController {

  @IBOutlet var tramTimesTable: UITableView!
  
  var viewModel: TramTimeTableViewModel!
    
  override func viewDidLoad() {
    super.viewDidLoad()

    let tramDataService = TramDataService()
    viewModel = TramTimeTableViewModel(tramDataService: tramDataService)
    clearTramData()
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

extension ViewController {

  func clearTramData() {
    viewModel.clearTramData()
    tramTimesTable.reloadData()
  }

  func loadTramData() {
    viewModel.loadTramDataUsing(stopId: "4055") {[weak self] (error) in
        if let error = error{
            print("Error retrieving trams: \(String(describing: error))")
        }else{
            self?.tramTimesTable.reloadData()
        }
    }
    
    viewModel.loadTramDataUsing(stopId: "4155") {[weak self] (error) in
        if let error = error{
            print("Error retrieving trams: \(String(describing: error))")
        }else{
            self?.tramTimesTable.reloadData()
        }
    }
  }
}


// MARK - UITableViewDataSource

extension ViewController {
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TramCellIdentifier", for: indexPath)

    guard let text = viewModel.getTextLabel(section: indexPath.section, row: indexPath.row) else {
        return cell
    }
    cell.textLabel?.text = text
    
    return cell;
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    guard let destination = viewModel.getDestinationWith(section: section) else {
        return section == 0 ? "North" : "South"
    }
    return section == 0 ? "North To \(destination)" : "South To \(destination)"
  }
}
