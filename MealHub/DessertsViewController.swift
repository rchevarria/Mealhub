//
//  DessertsViewControllerTableViewController.swift
//  DessertsHub
//
//  Created by Ryan Chevarria on 9/18/23.
//

import UIKit
import AlamofireImage

class DessertsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var dessertSearchBar: UISearchBar!
    
    var meals = [Meals]()
    var filteredData = [Meals]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchBarContainer = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 10, height: 80))
        searchBarContainer.addSubview(dessertSearchBar)
        tableView.tableHeaderView = searchBarContainer
        
        dessertSearchBar.delegate = self
        
        fetchDesserts{
            self.filteredData = self.meals
            self.tableView.reloadData()
        }
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func fetchDesserts(completed: @escaping () -> Void){
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else{
            completed()
            return
        }
        
        URLSession.shared.dataTask(with: url){ [weak self] data, response, error in
            if let error = error{
                print("JSON Error: \(error)")
                completed()
                return
            }
            guard let data = data else{
                print("NO data")
                completed()
                return
            }
            
            do{
                let decoder = JSONDecoder()
                let mealsResponse = try decoder.decode(MealsResponse.self, from: data)
                
                self?.meals = mealsResponse.meals.sorted(by: { $0.strMeal < $1.strMeal})
                
                DispatchQueue.main.async{
                    completed()
                }
            } catch {
                print("JSON decoding error: \(error)")
                completed()
            }
        }.resume()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = []
        if searchText == ""{
            filteredData = meals
        }
        else{
            for meal in meals{
                if meal.strMeal.lowercased().contains(searchText.lowercased()){
                    filteredData.append(meal)
                }
            }
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DessertCell", for: indexPath) as! DessertCell
        let dessert = filteredData[indexPath.section]
        
        
        cell.dessertLabel.text = dessert.strMeal.capitalized
        cell.dessertLabel.numberOfLines = 0
        cell.dessertLabel.lineBreakMode = .byWordWrapping
        
        let dessertThumb = dessert.strMealThumb
        let dessertThumbURL = URL(string: dessertThumb)!
        cell.dessertImage.af.setImage(withURL: dessertThumbURL)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DessertDetails"{
            if let destination = segue.destination as? DessertDetailsViewController,
               let indexPath = tableView.indexPathForSelectedRow{
                let selectedDessert = filteredData[indexPath.section]
                destination.idMeal = selectedDessert.idMeal
            }
        }
        
    }
}
