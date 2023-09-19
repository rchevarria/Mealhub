//
//  DessertDetailsViewController.swift
//  MealHub
//
//  Created by Ryan Chevarria on 9/19/23.
//

import UIKit

class DessertDetailsViewController: UIViewController {
    
    var idMeal: String?
    
    
    @IBOutlet weak var dessertTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let idMeal = idMeal{
            print("idMeal: \(idMeal)")
            fetchDessertDetails(idMeal)
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
                let dessertDetailsResponse = try decoder.decode(MealsResponse.self, from: data)
                
                if let dessert = dessertDetailsResponse.meals.first{
                    DispatchQueue.main.async{
                        self?.dessertTitle.text = dessert.strMeal
                    }
                }
            } catch {
                print("JSON decoding error: \(error)")
            }
        }.resume()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
