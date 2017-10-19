//
//  UtilFuncs.swift
//  randomRecipes
//
//  Created by Jared Sobol on 10/19/17.
//  Copyright © 2017 Appmaker. All rights reserved.
//

import Foundation

func stringTrimmer(stringToTrim string: String?) -> String? {
    let trimmedString = string?.trimmingCharacters(in: .whitespacesAndNewlines)
    return trimmedString
}
