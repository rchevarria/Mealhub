//
//  DessertCell.swift
//  MealHub
//
//  Created by Ryan Chevarria on 9/18/23.
//

import UIKit

class DessertCell: UITableViewCell {

    @IBOutlet weak var dessertLabel: UILabel!
    @IBOutlet weak var dessertImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
