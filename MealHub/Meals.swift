//
//  Meals.swift
//  DessertsHub
//
//  Created by Ryan Chevarria on 9/18/23.
//

import Foundation

struct MealsResponse: Codable{
    let meals: [Meals]
}

struct Meals:Codable{
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
}
