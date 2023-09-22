//
//  DessertDetailsViewController.swift
//  DessertsHub
//
//  Created by Ryan Chevarria on 9/19/23.
//

import UIKit
import AlamofireImage

struct IngredientItem{
    let ingredient: String
    let measurement: String
}

class DessertDetailsViewController: UIViewController, UITableViewDataSource {
    
    var idMeal: String?
    var mealDetails: MealDetails?
    var ingredientItems: [IngredientItem] = []
    
    
    
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var dessertTitle: UILabel!
    @IBOutlet weak var dessertImage: UIImageView!
    
    
    @IBAction func customBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let idMeal = idMeal{
            fetchDessertDetails(idMeal)
        }
        
        ingredientsTableView.rowHeight = UITableView.automaticDimension
        ingredientsTableView.estimatedRowHeight = 100
        ingredientsTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as! IngredientsCell
            
            let ingredientItem = ingredientItems[indexPath.row]
            cell.ingredientNameLabel.text = ingredientItem.ingredient
            cell.measurementLabel.text = ingredientItem.measurement
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InstructionsCell", for: indexPath) as! InstructionsCell
            
            cell.instructionsText?.text = mealDetails?.strInstructions
            cell.instructionsText?.numberOfLines = 0
            cell.instructionsText?.lineBreakMode = .byWordWrapping
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return "Ingredients"
        case 1:
            return "Instructions"
        default:
            return nil
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return ingredientItems.count
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func fetchDessertDetails(_ idMeal: String){
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(idMeal)") else{
            return
        }
        URLSession.shared.dataTask(with: url){ [weak self] data, response, error in
            if let error = error{
                print("JSON Error: \(error)")
                return
                
            }
            guard let data = data else{
                print("NO data")
                return
            }
            
            do{
                let decoder = JSONDecoder()
                let dessertDetailsResponse = try decoder.decode(MealDetailsResponse.self, from: data)
                
                if let dessert = dessertDetailsResponse.meals.first{
                    DispatchQueue.main.async{
                        self?.dessertTitle.text = dessert.strMeal.capitalized
                        
                        let dessertThumb = dessert.strMealThumb
                        let dessertThumbURL = URL(string: dessertThumb)!
                        self?.dessertImage.af.setImage(withURL: dessertThumbURL)
                        
                        self?.ingredientItems = self?.createIngredientItems(from: dessert) ?? []
                        self?.mealDetails = dessert
                        self?.ingredientsTableView.reloadData()
                    }
                }
            } catch {
                print("JSON decoding error: \(error)")
            }
        }.resume()
    }
    
    func createIngredientItems(from mealDetails: MealDetails) -> [IngredientItem] {
        var items: [IngredientItem] = []
        
        for i in 1...20 {
            let ingredientKey = "strIngredient\(i)"
            let measurementKey = "strMeasure\(i)"
            
            let ingredient = getValue(for: ingredientKey, in: mealDetails)
            let measurement = getValue(for: measurementKey, in: mealDetails)
            
            if !ingredient.isEmpty{
                let item = IngredientItem(ingredient: ingredient, measurement: measurement)
                items.append(item)
            }
        }
        
        return items
    }
    
    func getValue(for key: String, in mealDetails: MealDetails) -> String {
        let mirror = Mirror(reflecting: mealDetails)
        for case let (label?, value) in mirror.children {
            if label == key, let stringValue = value as? String {
                return stringValue
            }
        }
        return ""
    }
    
}
