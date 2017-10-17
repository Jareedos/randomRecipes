//
//  IngredientTableViewCell.swift
//  randomRecipes
//
//  Created by Jared Sobol on 10/16/17.
//  Copyright © 2017 Appmaker. All rights reserved.
//

import UIKit

class IngredientTableViewCell: UITableViewCell {
    @IBOutlet weak var cellCountLbl: UILabel!
    @IBOutlet weak var measurementLbl: UILabel!
    @IBOutlet weak var IngredientLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
