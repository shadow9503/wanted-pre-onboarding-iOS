//
//  ViewController.swift
//  weather_caster
//
//  Created by 유영훈 on 2022/09/06.
//

import UIKit

class WeatherTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var naviItem: UINavigationItem!
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var reports: [OpenWeatherMap.report] = []
    let dummy = ["군산",
                 "공주",
                 "광주",
                 "구미",
                 "대구",
                 "대전",
                 "목포",
                 "부산",
                 "서산",
                 "서울",
                 "속초",
                 "수원",
                 "순천",
                 "울산",
                 "익산",
                 "전주",
                 "제주시",
                 "천안",
                 "청주",
                 "춘천"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.decelerationRate = .fast
        tableView.layer.cornerRadius = 10
        naviItem.largeTitleDisplayMode = .automatic
        reports = (appDelegate?.openWeatherMap.getWeatherReports())!
    }
}

extension WeatherTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 1.0, delay: 0) {
            self.naviItem.largeTitleDisplayMode = scrollView.contentOffset.y < 5 ? .automatic : .never
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reports.count
//        return dummy.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        cell.city.text = dummy[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
        let item = reports[indexPath.row]
        let cityNameKR = appDelegate?.openWeatherMap.cityNames.filter { $0.value == item.name.split(separator: " ")[0] }
        let weather = item.weather.first!
        
        cell.city.text = cityNameKR?.first?.key
        cell.weather.text = weather.main
        cell.temp.text = "\(String(format: "%.0f", item.main.temp - 273.15))°"
        DispatchQueue.global(qos: .userInitiated).async {
            let url = URL(string: "https://openweathermap.org/img/wn/\(weather.icon)@2x.png")
            let data = try! Data(contentsOf: url!)
            DispatchQueue.main.async {
                cell.weatherIcon.image = UIImage(data: data)
            }
        }
        return cell
    }
}

