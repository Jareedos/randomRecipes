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
//    var loadingVC = LoadingVC()
    // let context = appDelegate.persistentContainer.viewContext
    

   
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
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
         cell.foodTitle.text = title.capitalized
        }
        
        if let recipeImage = recipesArray[indexPath.row].value(forKey: "recipeImage") as? Data {
            let image = UIImage(data: recipeImage)
            // SDWebImage
            cell.foodImg.image = image
        }

        return cell
    }

    @IBAction func randomizeBtnPressed(_ sender: Any) {
        LoadingVC().getRecipe()
    }
    

    

    
 

}

