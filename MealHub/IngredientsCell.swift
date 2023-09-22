//
//  IngredientTableViewCell.swift
//  DessertsHub
//
//  Created by Ryan Chevarria on 9/21/23.
//

import UIKit

class IngredientsCell: UITableViewCell {

    
    
    @IBOutlet weak var ingredientNameLabel: UILabel!
    @IBOutlet weak var measurementLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
