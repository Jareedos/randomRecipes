//
//  ViewController.swift
//  randomRecipes
//
//  Created by Jared Sobol on 10/9/17.
//  Copyright © 2017 Appmaker. All rights reserved.
//

import UIKit
import CoreData

class RecipesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var delegate: fillerProtocal?
    var calledApi = ApiCaller()
    var recipesArray = [NSManagedObject]()
    var resultsArray = [NSManagedObject]()
    // let context = appDelegate.persistentContainer.viewContext
    

   
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
//        getRecipe()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Recipes")
        do {
            recipesArray = try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipesTableViewCell", for: indexPath) as? RecipesTableViewCell else {
            fatalError("The world is coming to an End")
        }
        if let title = recipesArray[indexPath.row].value(forKey: "recipeTitle") as? String {
         cell.foodTitle.text = title
        }
//        if let recipeType = recipesArray[indexPath.row].value(forKey: "recipeType") as? String {
//            cell.foodType.text = recipeType
//        }
        
        if let recipeImage = recipesArray[indexPath.row].value(forKey: "recipeImage") as? Data {
            let image = UIImage(data: recipeImage)
            cell.foodImg.image = image
        }
//        cell.foodType.text = recipesArray[indexPath.row]._recipeType
//        let recipeImageURL = URL(string: String(recipesArray[indexPath.row]._recipeImage))
//        let recipePictureData = NSData(contentsOf: recipeImageURL!)
//        let recipePicture = UIImage(data: recipePictureData! as Data) ?? #imageLiteral(resourceName: "foodApiTester")
//        cell.foodImg.image = recipePicture
        return cell
    }

   
//    func getRecipe(){
//        for _ in 1...20 {
//            calledApi.getRecipe(completion:{ (Recipe) in
//                self.recipesArray.append(Recipe)
//                DispatchQueue.main.async(){
//                self.tableView.reloadData()
//             }
//            })
//        }
//    }
    

    
 

}

