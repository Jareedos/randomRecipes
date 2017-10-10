//
//  ViewController.swift
//  randomRecipes
//
//  Created by Jared Sobol on 10/9/17.
//  Copyright © 2017 Appmaker. All rights reserved.
//

import UIKit

class RecipesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var delegate: fillerProtocal?
    var calledApi = ApiCaller()
    var recipesArray = [Recipe]()
    
    //Look up NSCoding Swift
   
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fillRecipeArray()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipesTableViewCell", for: indexPath) as? RecipesTableViewCell else {
            fatalError("The world is coming to an End")
        }
        cell.foodTitle.text = recipesArray[indexPath.row]._recipeTitle
        cell.foodType.text = recipesArray[indexPath.row]._recipeType
//        cell.foodImg.image = recipesArray[indexPath.row]._recipeImage
        return cell
    }

   
    func fillRecipeArray(){
        print("VIctory")
        for _ in 1...20 {
            calledApi.fillRecipeArray(completion:{ (Recipe) in
                print("I got here")
                print(Recipe)
                self.recipesArray.append(Recipe)
                DispatchQueue.main.async(){
                self.tableView.reloadData()
             }
            })
        }
    }
    
   
    


}

