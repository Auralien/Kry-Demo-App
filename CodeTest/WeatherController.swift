//
//  Copyright © Webbhälsa AB. All rights reserved.
//

import Foundation

protocol WeatherView {
    func showEntries()
    func displayError(message: String)
}

class WeatherController {
    var view: WeatherView?

    public private(set) var entries: [WeatherLocation] = []

    init() {}

    internal func bind(view: WeatherView) {
        self.view = view
        refresh()
    }
}

extension WeatherController {
    func refresh() {
        APIManager.shared.fetchLocations(success: { locations in
            self.entries = locations
            self.view?.showEntries()
        }) { message in
            self.view?.displayError(message: message)
        }
    }
    
    func addLocation(location: WeatherLocation) {
        APIManager.shared.addLocation(location: location, success: { addedLocation in
            print(addedLocation)
            self.entries.append(addedLocation)
            self.view?.showEntries()
        }) { message in
            self.view?.displayError(message: message)
        }
    }
    
    func removeLocation(location: WeatherLocation) {
        APIManager.shared.removeLocation(location: location, success: {
            self.entries.remove(element: location)
            self.view?.showEntries()
        }) { message in
            self.view?.displayError(message: message)
        }
    }
}
