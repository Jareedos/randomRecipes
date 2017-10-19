
import Foundation
import UIKit

class ApiCaller : fillerProtocal {
    func getRecipe(completion: @escaping (Recipe) -> Void){
        let urlString = apiCall
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) {data,respone,error in
                if error == nil,let usableData = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: usableData, options: .allowFragments) as! [String:AnyObject]
                        let meals = json["meals"] as! [[String: AnyObject]]
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
                        let newRecipe = Recipe(recipeTitle: recipeTitle as! String, recipeType: recipeType as! String, recipeOrigin: recipeOrigin as! String, recipeImage: recipeImage as! String, recipeInstructions: recipeInstructions as! String, favoriteLetter: "T")
                            for tuple in tupleArray {
                                newRecipe._ingredientsArray.append(tuple.0)
                                newRecipe._ingredientMeasurementsArray.append(tuple.1)
                            }
                        completion(newRecipe)
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
    

