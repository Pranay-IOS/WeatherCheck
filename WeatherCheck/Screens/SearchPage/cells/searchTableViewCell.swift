//
//  searchTableViewCell.swift
//  WeatherCheck
//
//  Created by Pranay Barua on 02/12/25.
//

import UIKit

class searchTableViewCell: UITableViewCell {
    
    static let identifier = "searchTableViewCell"

    static func nib() -> UINib {
        return UINib(nibName: "searchTableViewCell",
                     bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
