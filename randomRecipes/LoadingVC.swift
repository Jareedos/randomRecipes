//
//  LoadingVC.swift
//  randomRecipes
//
//  Created by Jared Sobol on 10/11/17.
//  Copyright © 2017 Appmaker. All rights reserved.
//

import UIKit
import CoreData

class LoadingVC: UIViewController {
    var delegate: fillerProtocal?
    var calledApi = ApiCaller()
//    var recipeArray = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "Recipes", into: context)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getRecipe(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
//        let newUser = NSEntityDescription.insertNewObject(forEntityName: "Recipes", into: context)
        for _ in 1...20 {
            calledApi.getRecipe(completion:{ (Recipe) in
            let newUser = NSEntityDescription.insertNewObject(forEntityName: "Recipes", into: context)
            newUser.setValue(Recipe._recipeTitle, forKey: "recipeTitle")
            newUser.setValue(Recipe._recipeType, forKey: "recipeType")
            newUser.setValue(Recipe._recipeImage, forKey: "recipeImage")
            newUser.setValue(Recipe._ingredientsArray, forKey: "recipeIngredients")
            newUser.setValue(Recipe._ingredientMeasurementsArray, forKey: "recipeIngredientMeasurements")
            newUser.setValue(Recipe._recipeOrigin, forKey: "recipeOrigin")
//            self.recipeArray.append(Recipe)
            })
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
