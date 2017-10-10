//
//  ApiCaller.swift
//  randomRecipes
//
//  Created by Jared Sobol on 10/9/17.
//  Copyright © 2017 Appmaker. All rights reserved.
//

import Foundation

class ApiCaller : fillerProtocal {
    
    func fillRecipeArray(completion: @escaping (Recipe) -> Void){
        let urlString = apiCall
//        print("I got here")
        if let url = URL(string: urlString) {
//            print("I got here")
            URLSession.shared.dataTask(with: url) {data,respone,error in
//                print("I got here")
                if error == nil,let usableData = data {
//                    print("I got here")
                    do {
                        let json = try JSONSerialization.jsonObject(with: usableData, options: .allowFragments) as! [String:AnyObject]
                        let meals = json["meals"] as! [[String: AnyObject]]
                        let recipeOrigin = meals[0]["strArea"]
                        let recipeType = meals[0]["strCategory"]
                        let recipeTitle = meals[0]["strMeal"]
                        let recipeImage = meals[0]["strMealThumb"]
                        let recipeInstructions = meals[0]["strInstructions"]
                        var tupleArray: [(String, String)] = []
                        print(meals[0])
                        for index in 1...20 {
                            if meals[0]["strIngredient\(index)"] is NSNull {continue}
                            let tuple = (meals[0]["strIngredient\(index)"], meals[0]["strMeasure\(index)"])
                            guard let cleanString = tuple.0 else {return}
//                            print(cleanString)
//                            print(tuple.0, tuple.1)
                            
                            if String(describing: cleanString) != "" {
                                tupleArray.append((tuple.0 as! String,tuple.1 as! String))
                                print(tuple.0!, tuple.1!)
                            }
                        }
                        let newRecipe = Recipe(recipeTitle: recipeTitle as! String, recipeType: recipeType as! String, recipeOrigin: recipeOrigin as! String, recipeImage: recipeImage as! String, recipeInstructions: recipeInstructions as! String)
                        newRecipe._ingredients.append(contentsOf: tupleArray)
//                        print(newRecipe)
                        completion(newRecipe)
                    } catch {
                        fatalError("Sorry")
                    }
                    
                }
            }.resume()
        }
    }
    
    
//    func fillRecipeArray() -> Recipe{
//        let returnedReceipe = ApiCaller.callApi()
//        return returnedReceipe
//    }
}
