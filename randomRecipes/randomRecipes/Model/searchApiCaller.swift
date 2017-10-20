//
//  searchApiCall.swift
//  randomRecipes
//
//  Created by Jared Sobol on 10/19/17.
//  Copyright © 2017 Appmaker. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SearchApiCaller {

    
    static func searchRecipes(searchResult: String, completion: @escaping ()->() ) {
        var recipeIDsArray = [String]()
        var ingredientsArray = [String]()
        var measurementsArray = [String]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let urlString = searchApiCall + searchResult
        if let url = URL(string: urlString) {
            
            //MARK FIRST URLSESSION
            URLSession.shared.dataTask(with: url) {
                data,respone,error in
                if error == nil,let usableData = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: usableData, options: .allowFragments) as! [String:AnyObject]
                        let meals = json["meals"] as! [[String: AnyObject]]
                        for index in 0..<meals.count {
                            print("+++++++++++++++++++++++++++++++++")
                            let recipeId = meals[index]["idMeal"] as! String
                            recipeIDsArray.append(recipeId)
                            print(recipeIDsArray)
                            let recipeIdUrlString = lookupID + recipeId
                            print(recipeIdUrlString)
                            if let recipeIdurl = URL(string: recipeIdUrlString){
                                
                                //MARK: Nested second URLSession
                                URLSession.shared.dataTask(with: recipeIdurl) {data,respone,error in
                                    if error == nil, let usableData = data {
                                        do {
                                            let newJson = try JSONSerialization.jsonObject(with: usableData, options: .allowFragments) as! [String:AnyObject]
                                            let meals = newJson["meals"] as! [[String: AnyObject]]
                                            let recipeOrigin = meals[0]["strArea"]
                                            let recipeType = meals[0]["strCategory"]
                                            let recipeTitle = meals[0]["strMeal"]
                                            let recipeImage = meals[0]["strMealThumb"]
                                            let recipeInstructions = meals[0]["strInstructions"]
                                            var tupleArray: [(String, String)] = []
                                            for index in 1...20 {
                                                if meals[0]["strIngredient\(index)"] is NSNull {continue}
                                                let tuple = (meals[0]["strIngredient\(index)"], meals[0]["strMeasure\(index)"])
                                                guard let cleanString = tuple.0 else {return}
                                                if String(describing: cleanString) != "" {
                                                    tupleArray.append((tuple.0 as! String,tuple.1 as! String))
                                                }
                                            }
                                            
                                            let entity = NSEntityDescription.entity(forEntityName: "Recipes", in: context)!
                                            let newRecipe = NSManagedObject(entity: entity, insertInto: context)
                                            let recipeImageURL = URL(string: recipeImage as! String)
                                            let recipePictureData = NSData(contentsOf: recipeImageURL!)
                                            for tuple in tupleArray {
                                                ingredientsArray.append(tuple.0)
                                                measurementsArray.append(tuple.1)
                                            }
                                            print(recipeTitle)
                                            print("******")
                                            newRecipe.setValue(recipePictureData, forKey: "recipeImage")
                                            newRecipe.setValue(recipeTitle, forKey: "recipeTitle")
                                            newRecipe.setValue(recipeType, forKey: "recipeType")
                                            newRecipe.setValue(ingredientsArray, forKey: "recipeIngredients")
                                            newRecipe.setValue(measurementsArray, forKey: "recipeIngredientMeasurements")
                                            newRecipe.setValue(recipeOrigin, forKey: "recipeOrigin")
                                            newRecipe.setValue(false, forKey: "favorited")
                                            newRecipe.setValue(recipeInstructions, forKey: "recipeInstructions")
                                            do {
                                                try context.save()
                                            }
                                            catch {print("sorry")}
                                            
                                        }
                                        catch {
                                            let alert = UIAlertController(title: "No Current Internet Connection", message: "This app requires Internet connection, Please connect to the Internet and restart the app" , preferredStyle: UIAlertControllerStyle.alert)
                                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
                                            alert.present(alert, animated: true, completion: nil)
                                            fatalError("Sorry")
                                        }
                                    }
                                    completion()
                                    }.resume()
                            }
                        }
                    } catch {
                        let alert = UIAlertController(title: "No Current Internet Connection", message: "This app requires Internet connection, Please connect to the Internet and restart the app" , preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
                        alert.present(alert, animated: true, completion: nil)
                        fatalError("Sorry")
                    }
                    
                }
                }.resume()
        }
    }
}
