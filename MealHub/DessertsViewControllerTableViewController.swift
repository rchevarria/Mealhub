//
//  DessertsViewControllerTableViewController.swift
//  MealHub
//
//  Created by Ryan Chevarria on 9/18/23.
//

import UIKit

class DessertsViewControllerTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var meals = [Meals]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchDesserts{
            self.tableView.reloadData()
        }
        tableView.delegate = self
        tableView.dataSource = self
    }

    func fetchDesserts(completion: @escaping () -> Void){
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else{
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: url){ [weak self] data, response, error in
            if let error = error{
                print("JSON Error: \(error)")
                completion()
                return
            }
            guard let data = data else{
                print("NO data")
                completion()
                return
            }
            
            do{
                let decoder = JSONDecoder()
                let mealsResponse = try decoder.decode(MealsResponse.self, from: data)
                self?.meals = mealsResponse.meals
                
                DispatchQueue.main.async{
                    completion()
                }
            } catch {
                print("JSON decoding error: \(error)")
                completion()
            }
        }.resume()
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DessertCell", for: indexPath) as! DessertCell
        let dessert = meals[indexPath.row]
        
        cell.dessertLabel.text = dessert.strMeal
        
        return cell
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
