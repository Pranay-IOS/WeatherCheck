//
//  WeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by Pranay Barua on 01/12/25.
//

import UIKit
import SkeletonView

class WeatherCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    static let identifier = "WeatherCollectionViewCell"

    static func nib() -> UINib {
        return UINib(nibName: "WeatherCollectionViewCell",
                     bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        isSkeletonable = true
        contentView.isSkeletonable = true
        
        timeLabel.isSkeletonable = true
        iconImg.isSkeletonable = true
        tempLabel.isSkeletonable = true
    }
    
    func configure(with viewModel: Current, index: Int) {
        
        let dateTime = viewModel.time ?? ""
        let time = (Constants.formattedHour(from: dateTime))
        
        timeLabel.text = time
        let tempInInt = Int(viewModel.tempC ?? 0)
        tempLabel.text = "\(tempInInt)°C"
        
        self.iconImg.image = UIImage(systemName: "\(viewModel.condition?.conditionName ?? "")")
    }
}
