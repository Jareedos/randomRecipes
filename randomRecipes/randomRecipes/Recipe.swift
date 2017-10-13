//
//  Recipe.swift
//  randomRecipes
//
//  Created by Jared Sobol on 10/9/17.
//  Copyright © 2017 Appmaker. All rights reserved.
//

import Foundation

class Recipe {
    var _recipeTitle: String
    let _recipeType: String
    let _recipeOrigin: String
    let _recipeImage: String
    let _recipeInstructions: String
    var _ingredients: [(String,String)] = [] // creating an array of tuples for the ingredients and it's measurements
    
    
  
    
    init(recipeTitle: String, recipeType: String, recipeOrigin: String, recipeImage: String, recipeInstructions: String){
        _recipeTitle = recipeTitle
        _recipeType = recipeType
        _recipeOrigin = recipeOrigin
        _recipeImage = recipeImage
        _recipeInstructions = recipeInstructions
    }
    
    

    
}
