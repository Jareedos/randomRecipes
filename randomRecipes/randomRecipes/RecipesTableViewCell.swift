//
//  RecipesTableViewCell.swift
//  randomRecipes
//
//  Created by Jared Sobol on 10/9/17.
//  Copyright © 2017 Appmaker. All rights reserved.
//

import UIKit

class RecipesTableViewCell: UITableViewCell {
    @IBOutlet weak var foodImg: UIImageView!
    @IBOutlet weak var foodTitle: UILabel!
    @IBOutlet weak var foodType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}