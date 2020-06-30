//
//  Copyright © Webbhälsa AB. All rights reserved.
//

import UIKit

class WeatherViewController: UITableViewController {

    private var controller: WeatherController!

    static func create(controller: WeatherController) -> WeatherViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let viewController = storyboard.instantiateInitialViewController() as! WeatherViewController

        viewController.controller = controller
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        controller.bind(view: self)
        setup()
    }

    private func setup() {
        title = "Weather Code Test"
        createAddButton()
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        tableView.allowsSelection = true
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl!)
    }
    
    private func createAddButton() {
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addLocation)), animated: true)
    }
    
    @objc private func refresh() {
        controller.refresh()
    }
    
    @objc private func addLocation() {
        let uuid = UUID().uuidString
        let names = ["Moscow", "Malmö", "Riga", "Warsaw", "Berlin", "Vienna", "Budapest", "Bucharest", "Sofia", "Belgrade"]
        let name = names.randomElement()!
        let status = WeatherLocation.Status.allCases.randomElement()!
        let temperature = Int.random(in: 0 ..< 35)
        let location = WeatherLocation(id: uuid, name: name, status: status, temperature: temperature)
        print(location)
        controller.addLocation(location: location)
    }
}

extension WeatherViewController: WeatherView {
    func showEntries() {
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }

    func displayError(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true)
        refreshControl?.endRefreshing()
    }
}

extension WeatherViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller.entries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.reuseIdentifier, for: indexPath) as! LocationTableViewCell

        let entry = controller.entries[indexPath.row]
        cell.setup(entry)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let entry = controller.entries[indexPath.row]
        removeLocationConfirmation(location: entry)
    }
    
    fileprivate func removeLocationConfirmation(location: WeatherLocation) {
        let alertController = UIAlertController(title: "Removing location", message: "Are you sure you want to remove \(location.name)?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { action in
            self.controller.removeLocation(location: location)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true)
    }
}
