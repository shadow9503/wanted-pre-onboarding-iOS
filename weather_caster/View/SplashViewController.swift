//
//  SplashViewController.swift
//  weather_caster
//  
//  Created by 유영훈 on 2022/09/07.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    /// 기본 데이터 setup
    func initialize() {
        appDelegate?.openWeatherMap.getWeather(completion: { result in
            switch result {
            case .sucess:
                let reports = self.appDelegate?.openWeatherMap.getWeatherReports()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.performSegue(withIdentifier: "toMain", sender: nil)
                }
                break
            case .failed:
                break
            }
        })
    }
}
