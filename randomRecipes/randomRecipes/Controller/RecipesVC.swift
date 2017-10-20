//
//  ViewController.swift
//  randomRecipes
//
//  Created by Jared Sobol on 10/9/17.
//  Copyright © 2017 Appmaker. All rights reserved.
//

import UIKit
import CoreData

class RecipesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var delegate: fillerProtocal?
    var calledApi = ApiCaller()
    var recipesArray = [NSManagedObject]()
    var favoritesArray = [NSManagedObject]()
    var effect: UIVisualEffect!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        searchBar.delegate = self
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
            for recipeObject in recipesArray {
                if let unwrappedValue = recipeObject.value(forKey: "favorited") as? Bool {
                    if unwrappedValue == true {
                        favoritesArray.append(recipeObject)
                    }
                }
            }
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        let currentRecipe = recipesArray[indexPath.row]
        if let currentFavoriteValue = currentRecipe.value(forKey: "favorited") as? Bool {
            if currentFavoriteValue == false {
                let favoriteAction = UITableViewRowAction(style: .normal, title: "♥︎ Favorite") { (action, index) in
                    currentRecipe.setValue(true, forKey: "favorited")
                    do
                    {
                        try managedContext!.save()
                    }
                    catch
                    {
                        print("this isnt working wtf")
                    }
                }
                   favoriteAction.backgroundColor = UIColor(red:0.92, green:0.07, blue:0.07, alpha:1.0)
                   return [favoriteAction]
            } else {
                let unFavoriteAction = UITableViewRowAction(style: .normal, title: "♡ UnFavorite") { (action, index) in
                    currentRecipe.setValue(false, forKey: "favorited")
                    do
                    {
                        try managedContext!.save()
                    }
                    catch
                    {
                        print("I may have figured it out")
                    }
                }
                unFavoriteAction.backgroundColor = UIColor(red:0.05, green:0.47, blue:0.96, alpha:1.0)
                return [unFavoriteAction]
            }
        }
        return []
    }

    
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "notificationSegue") {
            let arrayToPass = favoritesArray
            let notificationVC = segue.destination as! NotificationVC
            notificationVC.favoritesArray = arrayToPass
        } else {
            let todoListsCellThatWasClicked = sender as! UITableViewCell
            let indexPath = self.tableView.indexPath(for: todoListsCellThatWasClicked)
            let toDoItemToPass = recipesArray[(indexPath?.row)!]
            let detailViewController = segue.destination as! RecipeDetailVC
            detailViewController.recipeObj = toDoItemToPass
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Its here")
        let userInput = searchBar.text
        if let trimmedString = stringTrimmer(stringToTrim: userInput) {
            if trimmedString.isEmpty {
                let alert = UIAlertController(title: "The Search Bar is empty", message: "Please enter Text" , preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            self.recipesArray = []
            deleteRecipes()
            
            SearchApiCaller.searchRecipes(searchResult: trimmedString, completion: {
               
                
           DispatchQueue.main.async {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
                
                
                let managedContext = appDelegate.persistentContainer.viewContext
                
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Recipes")
                do {
                    self.recipesArray = try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [NSManagedObject]
                    
                    for fetchedRecipe in self.recipesArray {
                        let recipeTitle = fetchedRecipe.value(forKey: "recipeTitle") as? String
                        print(recipeTitle)
                    }
                } catch let error as NSError {
                    print("Could not fetch. \(error), \(error.userInfo)")
                }
                
                
                    self.tableView.reloadData()
                }
            })
            //The following to run after
            
        }
        }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    func deleteRecipes() -> Void {
        let moc = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipes")
        let result = try? moc.fetch(fetchRequest)
        let resultData = result as! [NSManagedObject]
        for object in resultData {
            if object.value(forKey: "favorited") as? Bool == false {
                moc.delete(object)
            }
        }
        do {
            try moc.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
        
    }

}
