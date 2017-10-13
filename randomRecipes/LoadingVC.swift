//
//  LoadingVC.swift
//  randomRecipes
//
//  Created by Jared Sobol on 10/11/17.
//  Copyright © 2017 Appmaker. All rights reserved.
//

import UIKit

class LoadingVC: UIViewController {
    var delegate: fillerProtocal?
    var calledApi = ApiCaller()
    var recipeArray = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return url!.appendingPathComponent("Data").path
    }
    
    func saveData() {
        NSKeyedArchiver.archiveRootObject(recipeArray, toFile: filePath)
    }
    
    func getRecipe(){
        for _ in 1...20 {
            calledApi.getRecipe(completion:{ (Recipe) in
            self.recipeArray.append(Recipe)
            })
        }
        saveData()
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
