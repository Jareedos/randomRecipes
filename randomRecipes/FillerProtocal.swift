//
//  FillerProtocal.swift
//  randomRecipes
//
//  Created by Jared Sobol on 10/9/17.
//  Copyright © 2017 Appmaker. All rights reserved.
//

import Foundation

protocol fillerProtocal {
    
//    func completion(result: Recipe) -> Void
    func getRecipe(completion: @escaping (Recipe) -> Void)
}
