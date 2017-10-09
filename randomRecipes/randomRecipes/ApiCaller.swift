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
                    let json = try? JSONSerialization.jsonObject(with: usableData, options: .allowFragments) as! [String:AnyObject]
                    print(json)
                //Get back to the main queue
//                DispatchQueue.main.async {
//                    //print(articlesData)
////                    self.articles = articlesData
////                    self.collectionView?.reloadData()
//                }
                
                } catch  {
//                print(jsonError)
                }
             }
        }.resume()
    }
}
