//
//  Weather.swift
//  weather_caster
//
//  Created by 유영훈 on 2022/09/06.
//

import Foundation

protocol GetWeatherDataProtocol: class {
    func weatherIsUpdate(report: OpenWeatherMap.report)
    func weatherIsUpdate(reports: [OpenWeatherMap.report])
}

// using api - https://openweathermap.org/current
class OpenWeatherMap {
    
    enum Result {
        case sucess
        case failed
    }
    
    public var delegate: GetWeatherDataProtocol!
    public static let shared = OpenWeatherMap()
    private let apikey = "9cc7ad4ec735a5bf5571581dcd2f6118"
    private var weatherReports: [report] = []
    
    private init() {}
    
    /// 기상정보 setter
    private func setWeatherReports(weatherReport: report) -> Void {
        weatherReports.append(weatherReport)
    }

    /// 기상정보 getter
    func getWeatherReports() -> [report] {
        return weatherReports.sorted { $0.nameKR! < $1.nameKR! }
    }
    
    let cityNames = [
        "군산": "Gunsan",
        "공주": "Gongju",
        "광주(전라남도)": "Gwangju",
        "구미": "Gumi",
        "대구": "Daegu",
        "대전": "Daejeon",
        "목포": "Mokpo",
        "부산": "Busan",
        "서산": "Seosan",
        "서울": "Seoul",
        "속초": "Sokcho",
        "수원": "Suwon-si",
        "순천": "Suncheon",
        "울산": "Ulsan",
        "익산": "Iksan",
        "전주": "Jeonju",
        "제주시": "Jeju",
        "천안": "Cheonan",
        "청주": "Cheongju-si",
        "춘천": "Chuncheon"
    ]
    
    struct report: Codable {
        var nameKR: String?
        let name: String
        let main: main
        let weather: [weather]
        let wind: wind
        let sys: sys
    }
    
    struct weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    struct main: Codable {
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let pressure: Int
        let humidity: Int
    }
    
    struct wind: Codable {
        let speed: Double
        let deg: Int
    }
    
    struct sys: Codable {
        let sunrise: Double
        let sunset: Double
    }
    
    /// 메인 날씨 리스트 불러올때 사용
//    func getWeather(completion: @escaping((Result) -> ())) {
//        weatherReports.removeAll(keepingCapacity: false)
//        let concurrentQueue = DispatchQueue(label: "api.weather", qos: .userInitiated, attributes: .concurrent, target: .global())
//        let customQueue = DispatchQueue(label: "api.weather.custom1", attributes: .concurrent)
//
//        let group1 = DispatchGroup()
//        for (_, value) in cityNames {
//
//            group1.enter()
//            concurrentQueue.async() {
//                let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(value)&appid=\(self.apikey)"
//                let url = URL(string: urlString)
//                let session = URLSession(configuration: .default)
//                session.dataTask(with: url!) { data, response, error in
//                    if let err = error {
//                        print(err.localizedDescription)
//                        completion(.failed)
//                    }
//                    guard var result = try? JSONDecoder().decode(report.self, from: data!) else { return }
//                    customQueue.async(flags: .barrier) {
//                        result.nameKR = self.cityNames.filter { $0.value == result.name.split(separator: " ")[0] }.first!.key
//                        self.setWeatherReports(weatherReport: result)
//                    }
//                    group1.leave()
//                }.resume()
//            }
//        }
//
//        group1.notify(queue: concurrentQueue) {
//            completion(.sucess)
//        }
//    }
    
    /// 메인 날씨 리스트 불러올때 사용 - using delegate pattern
    func downloadWeatherReports() {
        weatherReports.removeAll(keepingCapacity: false)
        let concurrentQueue = DispatchQueue(label: "api.weather", qos: .userInitiated, attributes: .concurrent, target: .global())
        let customQueue = DispatchQueue(label: "api.weather.custom1", attributes: .concurrent)
        
        let group1 = DispatchGroup()
        for (_, value) in cityNames {
            
            group1.enter()
            concurrentQueue.async() {
                let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(value)&appid=\(self.apikey)"
                let url = URL(string: urlString)
                let session = URLSession(configuration: .default)
                session.dataTask(with: url!) { data, response, error in
                    if let err = error {
                        print(err.localizedDescription)
                    }
                    guard var result = try? JSONDecoder().decode(report.self, from: data!) else { return }
                    customQueue.async(flags: .barrier) {
                        result.nameKR = self.cityNames.filter { $0.value == result.name.split(separator: " ")[0] }.first!.key
                        self.setWeatherReports(weatherReport: result)
                    }
                    group1.leave()
                }.resume()
            }
        }
        
        group1.notify(queue: concurrentQueue) {
            DispatchQueue.main.async {
                self.delegate.weatherIsUpdate(reports: self.getWeatherReports())
            }
        }
    }
    
    ///  날씨 상세화면에서 새로고침시 사용
//    func getWeather(city: String, completion: @escaping((report?) -> ())) {
//        DispatchQueue.global(qos: .userInitiated).async {
//            let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city.split(separator: " ")[0])&appid=\(self.apikey)"
//            let url = URL(string: urlString)
//            let session = URLSession(configuration: .default)
//            session.dataTask(with: url!) { data, response, error in
//                if let err = error {
//                    print(err.localizedDescription)
//                    completion(nil)
//                }
//                guard let result = try? JSONDecoder().decode(report.self, from: data!) else { return }
//                completion(result)
//            }.resume()
//        }
//    }
    
    ///  날씨 상세화면에서 새로고침시 사용 - using delegate pattern
    func downloadWeatherReport(city: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city.split(separator: " ")[0])&appid=\(self.apikey)"
            let url = URL(string: urlString)
            let session = URLSession(configuration: .default)
            session.dataTask(with: url!) { data, response, error in
                if let err = error {
                    print(err.localizedDescription)
                }
                guard let result = try? JSONDecoder().decode(report.self, from: data!) else { return }
                DispatchQueue.main.async {
                    self.delegate.weatherIsUpdate(report: result)
                }
            }.resume()
        }
    }
}
