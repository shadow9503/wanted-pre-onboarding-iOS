//
//  WeatherDetailViewController.swift
//  weather_caster
//
//  Created by 유영훈 on 2022/09/08.
//

import UIKit

class WeatherDetailViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var tempDetailLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    @IBOutlet weak var summaryStackView: UIStackView!
    @IBOutlet weak var windStackView: UIStackView!
    @IBOutlet weak var windIcon: UIImageView!
    @IBOutlet weak var pressureStackView: UIStackView!
    @IBOutlet weak var pressureIcon: UIImageView!
    @IBOutlet weak var sunriseStackView: UIStackView!
    @IBOutlet weak var sunriseTimeLabel: UILabel!
    @IBOutlet weak var sunsetStackView: UIStackView!
    @IBOutlet weak var sunsetTimeLabel: UILabel!
    
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var reports: [OpenWeatherMap.report] = []
    var report: OpenWeatherMap.report?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.addTarget(self, action: #selector(refreshView(_:)), for: .valueChanged)
        
        report = reports.first!
        setUI(report!)
    }
    
    func setUI(_ report: OpenWeatherMap.report) {
        DispatchQueue.main.async { [self] in
            
            // 스택뷰 세부 spacing 조정
            windStackView.setCustomSpacing(20, after: windIcon)
            pressureStackView.setCustomSpacing(20, after: pressureIcon)
            sunriseStackView.setCustomSpacing(20, after: sunriseTimeLabel)
            sunsetStackView.setCustomSpacing(20, after: sunsetTimeLabel)
            
            // 값 매핑
            let minTemp = "\(String(format: "%.0f", report.main.temp_min - 273.15))°"
            let maxTemp = "\(String(format: "%.0f", report.main.temp_max - 273.15))°"
            let curTemp = "\(String(format: "%.0f", report.main.temp - 273.15))°"
            let feelTemp = "\(String(format: "%.0f", report.main.feels_like - 273.15))°"
            let city = appDelegate?.openWeatherMap.cityNames.filter { $0.value == report.name.split(separator: " ")[0] }
            cityLabel.text = city?.first!.key
            tempLabel.text = curTemp
            tempDetailLabel.text = "\(maxTemp) | \(minTemp) 체감온도 \(feelTemp)"
            humidityLabel.text = "\(report.main.humidity)%"
            weatherConditionLabel.text = report.weather.first?.main
            weatherDescriptionLabel.text = report.weather.first?.description
            pressureLabel.text = "\(report.main.pressure) hPa"
            windLabel.text = "\(report.wind.speed) m/s"
            weatherIcon.loadImage(from: "https://openweathermap.org/img/wn/\(report.weather.first!.icon)@2x.png")
            sunriseTimeLabel.text = timeToString(report.sys.sunrise)
            sunsetTimeLabel.text = timeToString(report.sys.sunset)
            weatherDescriptionLabel.text = report.weather.first?.description
            
            // fade in animation
            summaryStackView.alpha = 0
            windStackView.alpha = 0
            pressureStackView.alpha = 0
            sunriseStackView.alpha = 0
            sunsetStackView.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0) { [self] in
                summaryStackView.alpha = 1
                windStackView.alpha = 1
                pressureStackView.alpha = 1
                sunriseStackView.alpha = 1
                sunsetStackView.alpha = 1
            }
            
            // refreshing 완료
            scrollView.refreshControl?.endRefreshing()
        }
    }
    
    func timeToString(_ interval: Double) -> String {
        let date = DateFormatter()
        date.locale = Locale(identifier: Locale.current.identifier)
        date.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        date.dateFormat = "a hh:mm"
        return date.string(from: Date(timeIntervalSince1970: interval))
    }
    
    deinit {
        cityLabel.text = "불러오는중..."
        summaryStackView.alpha = 0
        windStackView.alpha = 0
        pressureStackView.alpha = 0
        sunriseStackView.alpha = 0
        sunsetStackView.alpha = 0
        reports.removeAll(keepingCapacity: false)
    }
   
    @objc func refreshView(_ refreshControl: UIRefreshControl) {
        appDelegate?.openWeatherMap.getWeather(city: report!.name, completion: { result in
            self.setUI(result)
        })
    }
    
    @IBAction func backToMain(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
