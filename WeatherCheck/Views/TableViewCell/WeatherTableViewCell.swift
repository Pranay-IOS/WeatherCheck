//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Pranay Barua on 01/12/25.
//

import UIKit
import SkeletonView

class WeatherTableViewCell: UITableViewCell {
    
    static let identifier = "WeatherTableViewCell"

    static func nib() -> UINib {
        return UINib(nibName: "WeatherTableViewCell",
                     bundle: nil)
    }

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherIconImg: UIImageView!
    @IBOutlet weak var maxMinTempLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isSkeletonable = true
        contentView.isSkeletonable = true
        
        dayLabel.isSkeletonable = true
        maxMinTempLabel.isSkeletonable = true
        weatherIconImg.isSkeletonable = true
    }
    
    func configure(with viewModel: Forecastday, index: Int) {
        
        if let dateString = viewModel.date {
            dayLabel.text = Constants.formattedForecastDateLabel(from: dateString)
        }
        
        let minTempInInt = Int(viewModel.day?.mintempC ?? 0)
        let maxTempInInt = Int(viewModel.day?.maxtempC ?? 0)
        maxMinTempLabel.text = "\(maxTempInInt)°/\(minTempInInt)°"
        self.weatherIconImg.image = UIImage(systemName: viewModel.day?.condition?.conditionName ?? "")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
