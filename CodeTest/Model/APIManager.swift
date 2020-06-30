import Foundation

struct APIManager {
    static let shared = APIManager()
    
    var apiKey: String {
        guard let apiKey = UserDefaults.standard.string(forKey: "API_KEY") else {
            let key = UUID().uuidString
            UserDefaults.standard.set(key, forKey: "API_KEY")
            return key
        }
        return apiKey
    }
    
    func fetchLocations(success: @escaping ([WeatherLocation]) -> Void, failure: @escaping (String) -> Void) {
        var urlRequest = URLRequest(url: URL(string: "https://app-code-test.kry.pet/locations")!)
        urlRequest.addValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        
        URLSession(configuration: .default).dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    guard let httpResponse = response as? HTTPURLResponse else { return }
                    if httpResponse.statusCode == 400 {
                        let message = NSLocalizedString("Invalid or missing ID", comment: "Invalid or missing ID")
                        failure(message)
                    } else if httpResponse.statusCode == 500 {
                        let message = NSLocalizedString("Unknown error happened", comment: "Unknown error happened")
                        failure(message)
                    } else {
                        failure(error.localizedDescription)
                    }
                } else if let data = data {
                    do {
                        let str = String(decoding: data, as: UTF8.self)
                        print(str)
                        let result = try JSONDecoder().decode(LocationsResult.self, from: data)
                        print(result)
                        success(result.locations)
                    } catch {
                        print(error)
                        failure(error.localizedDescription)
                    }
                } else {
                    let message = NSLocalizedString("Unknown error happened", comment: "Unknown error happened")
                    failure(message)
                }
            }
        }.resume()
    }
    
    func addLocation(location: WeatherLocation, success: @escaping (WeatherLocation) -> Void, failure: @escaping (String) -> Void) {
        var urlRequest = URLRequest(url: URL(string: "https://app-code-test.kry.pet/locations")!)
        urlRequest.addValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        urlRequest.httpMethod = "POST"
        guard let json = try? JSONEncoder().encode(location) else { return }
        urlRequest.httpBody = json
        
        URLSession(configuration: .default).dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    guard let httpResponse = response as? HTTPURLResponse else { return }
                    if httpResponse.statusCode == 400 {
                        let message = NSLocalizedString("Invalid or missing ID", comment: "Invalid or missing ID")
                        failure(message)
                    } else if httpResponse.statusCode == 500 {
                        let message = NSLocalizedString("Unknown error happened", comment: "Unknown error happened")
                        failure(message)
                    } else {
                        failure(error.localizedDescription)
                    }
                } else if let data = data {
                    do {
                        print(String(decoding: data, as: UTF8.self))
                        let result = try JSONDecoder().decode(WeatherLocation.self, from: data)
                        print(result)
                        success(result)
                    } catch {
                        print(error)
                        failure(error.localizedDescription)
                    }
                } else {
                    let message = NSLocalizedString("Unknown error happened", comment: "Unknown error happened")
                    failure(message)
                }
            }
        }.resume()
    }
    
    func removeLocation(location: WeatherLocation, success: @escaping () -> Void, failure: @escaping (String) -> Void) {
        var urlRequest = URLRequest(url: URL(string: "https://app-code-test.kry.pet/locations/\(location.id)")!)
        urlRequest.addValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        urlRequest.httpMethod = "DELETE"
        
        URLSession(configuration: .default).dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse else { return }
                if let error = error {
                    if httpResponse.statusCode == 400 {
                        let message = NSLocalizedString("Invalid or missing ID", comment: "Invalid or missing ID")
                        failure(message)
                    } else if httpResponse.statusCode == 500 {
                        let message = NSLocalizedString("Unknown error happened", comment: "Unknown error happened")
                        failure(message)
                    } else {
                        failure(error.localizedDescription)
                    }
                } else if httpResponse.statusCode == 200 {
                    print("All went well")
                    success()
                } else {
                    let message = NSLocalizedString("Unknown error happened", comment: "Unknown error happened")
                    failure(message)
                }
                
            }
        }.resume()
    }
}

private struct LocationsResult: Decodable {
    var locations: [WeatherLocation]
}
