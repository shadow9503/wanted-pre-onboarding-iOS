//
//  ViewController.swift
//  weather_caster
//
//  Created by 유영훈 on 2022/09/06.
//

import UIKit

class WeatherTableViewController: UIViewController {
    
    //- 도시이름, 날씨 아이콘, 현재기온, 체감기온, 헌재습도, 최저기온, 최고기온, 기압, 풍속, 날씨설명
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var naviItem: UINavigationItem!
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var reports: [OpenWeatherMap.report] = []
    var selectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.decelerationRate = .fast
        tableView.layer.cornerRadius = 10
        naviItem.largeTitleDisplayMode = .automatic
        reports = (appDelegate?.openWeatherMap.getWeatherReports())!
//        reports = Utils.UserDefaultsManager.reports!
    }
}

extension WeatherTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailViewController = segue.destination as? WeatherDetailViewController else {
            return
        }
        detailViewController.reports.append(reports[selectedIndex])
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedIndex = indexPath.row
        return indexPath
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 1.0, delay: 0) {
            self.naviItem.largeTitleDisplayMode = scrollView.contentOffset.y < 5 ? .automatic : .never
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(reports.count)
        return reports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
        let item = reports[indexPath.row]
        let cityNameKR = appDelegate?.openWeatherMap.cityNames.filter { $0.value == item.name.split(separator: " ")[0] }
        let weather = item.weather.first!
        
        cell.city.text = cityNameKR?.first?.key
        cell.weather.text = weather.main
        cell.temp.text = "\(String(format: "%.0f", item.main.temp - 273.15))°"
        cell.weatherIcon.loadImage(from: "https://openweathermap.org/img/wn/\(weather.icon)@2x.png")
//        DispatchQueue.global(qos: .userInitiated).async {
//            let url = URL(string: "https://openweathermap.org/img/wn/\(weather.icon)@2x.png")
//            let data = try! Data(contentsOf: url!)
//            DispatchQueue.main.async {
//                cell.weatherIcon.image = UIImage(data: data)
//            }
//        }
        return cell
    }
}

