//
//  WeatherTableViewCell.swift
//  weather_caster
//
//  Created by 유영훈 on 2022/09/07.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var weather: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
