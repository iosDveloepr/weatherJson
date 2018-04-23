//
//  WeatherTableViewController.swift
//  Json CoreLocation Weather
//
//  Created by Yermakov Anton on 15.10.17.
//  Copyright © 2017 Yermakov Anton. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var forecastData = [Weather]()

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        tableView.rowHeight = 130
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let locationString = searchBar.text, !locationString.isEmpty {
            updateWeatherFromLocation(location: locationString)
        }
    }
    
    func updateWeatherFromLocation(location: String) {
        CLGeocoder().geocodeAddressString(location) { (placemarks: [CLPlacemark]?, error) in
            if error == nil {
                if let location = placemarks?.first?.location {
                    NetworkProcessor.sharedInstance.dowbloadJson(fromLoaction: location.coordinate, completion: { (results: [Weather]?) in
                        if let weatherObject = results {
                            self.forecastData = weatherObject
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }, errorHandling:{ (message) in
                        if message != nil {
                            DispatchQueue.main.async { [weak self] in
                                self?.alertErrorMessage(title: "Some error", message: message!)
                            }
                        }
                    })
                }
            } else {
               self.alertErrorMessage(title: "Networking problems", message: "Place find a natworking connection")
            }
        }
    }
    
    private func alertErrorMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return forecastData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = Calendar.current.date(byAdding: .day, value: section, to: Date())
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MMMM dd, yyyy"
        
        return dateFormater.string(from: date!)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! WeatherTableViewCell

        let weatherObject = forecastData[indexPath.section]
        
        cell.weatherSummary.text = weatherObject.summary
        cell.weatherTemperature.text = "\(Int(weatherObject.temperature)) ºF"
        cell.weatherImage.image = UIImage(named: weatherObject.icon)

        return cell
    }
 

}
