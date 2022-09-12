//
//  SplashViewController.swift
//  weather_caster
//
//  Created by 유영훈 on 2022/09/07.
//

import UIKit

class SplashViewController: UIViewController {

    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
//            test()
        initialize()
    }
    
    func test() {
        
        DispatchQueue.main.async {
            print(Utils.UserDefaultsManager.reports)
            self.performSegue(withIdentifier: "toMain", sender: nil)
        }
        
//        appDelegate?.openWeatherMap.getWeather(city: "Seoul", completion: { result in
//            switch result {
//            case .sucess:
//                DispatchQueue.main.async {
//                    print(Utils.UserDefaultsManager.reports)
//                    self.performSegue(withIdentifier: "toMain", sender: nil)
//                }
//                break
//            case .failed:
//                break
//            }
//        })
    }
    
    /// 기본 데이터 setup
    func initialize() {
        appDelegate?.openWeatherMap.getWeather(completion: { result in
            switch result {
            case .sucess:
                let reports = self.appDelegate?.openWeatherMap.getWeatherReports()
                Utils.UserDefaultsManager.reports = reports
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "toMain", sender: nil)
                }
                break
            case .failed:
                break
            }
        })
    }
}
