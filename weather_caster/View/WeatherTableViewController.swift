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
    var selectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate?.openWeatherMap.delegate = self
        appDelegate?.openWeatherMap.downloadWeatherReports()
        
        naviItem.largeTitleDisplayMode = .automatic
        tableView.decelerationRate = .fast
        tableView.layer.cornerRadius = 10
        
        // pull to refresh
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshView(_:)), for: .valueChanged)
        
//        reports = (appDelegate?.openWeatherMap.getWeatherReports())!
//        naviItem.title = "오늘의 전국 날씨 (\(reports.count))"
    }
    
    @objc func refreshView(_ refreshControl: UIRefreshControl) {
        appDelegate?.openWeatherMap.downloadWeatherReports()
//        appDelegate?.openWeatherMap.getWeather(completion: { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .sucess:
//                    self.reports = (self.appDelegate?.openWeatherMap.getWeatherReports())!
//                    self.tableView.refreshControl?.endRefreshing()
//                    break
//                case .failed:
//                    print("error: no results")
//                    self.tableView.refreshControl?.endRefreshing()
//                    break
//                }
//            }
//        })
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
        return reports.count != 0 ? reports.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if reports.count == 0 {
            let cell = UITableViewCell()
            var content = cell.defaultContentConfiguration()
            content.text = "인터넷 연결을 확인해주세요!"
            content.textProperties.alignment = .center
            cell.contentConfiguration = content
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell
        let item = reports[indexPath.row]
        let cityNameKR = appDelegate?.openWeatherMap.cityNames.filter { $0.value == item.name.split(separator: " ")[0] }
        let weather = item.weather.first!
        
        cell.cityLabel.text = cityNameKR?.first?.key
        cell.weatherLabel.text = weather.main
        cell.tempLabel.text = "\(String(format: "%.0f", item.main.temp - 273.15))°"
        cell.humidityLabel.text = "\(item.main.humidity)%"
        cell.weatherIcon.loadImage(from: "https://openweathermap.org/img/wn/\(weather.icon)@2x.png")
        return cell
    }
}

extension WeatherTableViewController: GetWeatherDataProtocol {
    func weatherIsUpdate(report: OpenWeatherMap.report) {}
    func weatherIsUpdate(reports: [OpenWeatherMap.report]) {
        self.reports = reports
        self.tableView.reloadData()
        self.tableView.refreshControl?.endRefreshing()
    }
}
