//
//  ApiCaller.swift
//  randomRecipes
//
//  Created by Jared Sobol on 10/9/17.
//  Copyright © 2017 Appmaker. All rights reserved.
//

import Foundation

class ApiCaller {
    
    static func callApi(){
        let urlString = apiCall
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) {data,respone,error in
            if error == nil,let usableData = data {
                do {
                //Decode retrived data with JSONDecoder and assing type of Article object
//                let recipes = try JSONDecoder().decode([Article].self, from: data)
                    let json = try JSONSerialization.jsonObject(with: usableData, options: .allowFragments) as! [String:AnyObject]
//                    print(json)
                    let meals = json["meals"] as! [[String:String?]]
//                    print(meals)
                    let recipeOrigin = meals[0]["strArea"]
                    let recipeType = meals[0]["strCategory"]
                    let recipeTitle = meals[0]["strMeal"]
                    let recipeImage = meals[0]["strMealThumb"]
                    let recipeInstructions = meals[0]["strInstructions"]
                    var tupleArray: [(String, String)] = []
                    for index in 1...20 {
                        let tuple = (meals[0]["strIngredient\(index)"], meals[0]["strMeasure\(index)"])
                        guard let cleanString = tuple.0 else {return}
                        if cleanString != "" && cleanString != "null"{
                            tupleArray.append((tuple.0!!,tuple.1!!))
                        }
                    }
                    print(tupleArray)
                    let newRecipe = Recipe(recipeTitle: recipeTitle!!, recipeType: recipeType!!, recipeOrigin: recipeOrigin!!, recipeImage: recipeImage!!, recipeInstructions: recipeInstructions!!)
                    newRecipe._ingredients.append(contentsOf: tupleArray)
                    print(newRecipe)
                } catch {
                    fatalError("Sorry")
                }
             }
        }.resume()
    }
}
