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
  
  var northTrams: [Any]?
  var southTrams: [Any]?
  var loadingNorth: Bool = false
  var loadingSouth: Bool = false
  var token: String?
  var session: URLSession?

  var tramDataService: TramDataService!
  override func viewDidLoad() {
    super.viewDidLoad()

    let config = URLSessionConfiguration.default
    session = URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
    tramDataService = TramDataService()

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
    northTrams = nil
    southTrams = nil
    loadingNorth = false
    loadingSouth = false

    tramTimesTable.reloadData()
  }

  func loadTramData() {
    loadingNorth = true
    loadingSouth = true
    
    tramDataService.loadTramDataUsing(stopId: "4055") { [weak self] trams, error in
        if let error = error {
            print("Error retrieving trams: \(String(describing: error))")
        } else {
            self?.northTrams = trams
            self?.tramTimesTable.reloadData()
        }
        self?.loadingNorth = false
    }
    
    tramDataService.loadTramDataUsing(stopId: "4155") { [weak self] trams, error in
        if let error = error {
            print("Error retrieving trams: \(String(describing: error))")
        } else {
            self?.southTrams = trams
            self?.tramTimesTable.reloadData()
        }
        self?.loadingSouth = false
    }
  }

  func tramsFor(section: Int) -> [Any]? {
    return (section == 0) ? northTrams : southTrams
  }

  func isLoading(section: Int) -> Bool {
    return (section == 0) ? loadingNorth : loadingSouth
  }
}


// MARK - UITableViewDataSource

extension ViewController {
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TramCellIdentifier", for: indexPath)

    let trams = tramsFor(section: indexPath.section)
    guard let tram = trams?[indexPath.row] as? JSONDictionary else {
      if isLoading(section: indexPath.section) {
        cell.textLabel?.text = "Loading upcoming trams..."
      } else {
        cell.textLabel?.text = "No upcoming trams. Tap load to fetch"
      }
      return cell
    }

    guard let arrivalDateString = tram["PredictedArrivalDateTime"] as? String else {
      return cell
    }
    let dateConverter = DotNetDateConverter()
    cell.textLabel?.text = dateConverter.formattedDateFromString(arrivalDateString)

    return cell;
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if (section == 0)
    {
      guard let count = northTrams?.count else { return 1 }
      return count
    }
    else
    {
      guard let count = southTrams?.count else { return 1 }
      return count
    }
  }

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return section == 0 ? "North" : "South"
  }
}
