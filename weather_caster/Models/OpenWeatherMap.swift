//
//  Weather.swift
//  weather_caster
//
//  Created by 유영훈 on 2022/09/06.
//

import Foundation

class OpenWeatherMap {
    
    enum Result {
        case success
        case failed
    }
    
    public static let shared = OpenWeatherMap()
    private var weatherReports: [report] = []
    
    private init() {}
    
    /// 기상정보 setter
    private func setWeatherReports(weatherReport: report) -> Void {
        weatherReports.append(weatherReport)
    }

    /// 기상정보 getter
    func getWeatherReports() -> [report] {
        return weatherReports
    }
    
    let cityNames = [
//                    "군산": "Gunsan",
//                "공주": "Gongju",
//                "광주(전라남도)": "Gwangju",
//                "구미": "Gumi",
//                "대구": "Daegu",
//                "대전": "Daejeon",
//                "목포": "Mokpo",
//                "부산": "Busan",
//                "서산": "Seosan",
//                "서울": "Seoul",
//                "속초": "Sokcho",
//                "수원": "Suwon-si",
//                "순천": "Suncheon",
//                "울산": "Ulsan",
//                "익산": "Iksan",
//                "전주": "Jeonju",
                "제주시": "Jeju",
//                "천안": "Cheonan",
//                "청주": "Cheongju-si",
//                "춘천": "Chuncheon"
    ]
    
    struct report: Codable {
        let name: String
        let main: main
        let weather: [weather]
    }
    
    struct weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
        
        enum weather: String, Codable {
            case id
            case main = "city"
            case description
            case icon
        }
    }
    
    struct main: Codable {
        let temp: Double
        let humidity: Int
    }
    
    /// OpenWeatherMap API를 이용하여 cityNames 배열에 정의된 도시들의 정보를 가져온다.
    func getWeather(completion: @escaping((Result) -> ())) {
        let concurrentQueue = DispatchQueue(label: "api.weather", qos: .background, attributes: .concurrent, target: .global())
        let group1 = DispatchGroup()
        let apikey = "9cc7ad4ec735a5bf5571581dcd2f6118"
        
        let old = CFAbsoluteTimeGetCurrent()
        for (_, value) in cityNames {
            group1.enter()
            concurrentQueue.async {
                let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(value)&appid=\(apikey)"
                let url = URL(string: urlString)
                let session = URLSession(configuration: .default)
                session.dataTask(with: url!) { data, response, error in
//                    print("@error: \(error)")
                    guard let result = try? JSONDecoder().decode(report.self, from: data!) else { return }
//                    print("@result: \(result)")
                    self.setWeatherReports(weatherReport: result)
                    group1.leave()
                }.resume()
            }
        }
        
        group1.notify(queue: concurrentQueue) {
            completion(.success)
            print("end", CFAbsoluteTimeGetCurrent()-old)
        }
    }
}
