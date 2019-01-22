//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Melvin Lee on 1/20/19.
//  Copyright © 2019 Melvin Lee. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController { // SwipeTableViewController is inherited from a class we made
    
    // New Realm
    let realm = try! Realm()
    
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Nil Coalescing Operator
        // If categories.count is nil, return 1; if it's not nil, return categories.count
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories Added Yet"
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].color ?? "1D9BF6")
        return cell
    }
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat.hexValue()
            
            self.save(category: newCategory)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Delegate Methonds
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    // Prep for the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    //MARK: - Data Manipulation Methods
    func save(category: Category){
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category: \(error)")
        }
        
        tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath){
        super.updateModel(at: indexPath)
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category: \(error)")
            }
        }
    }
    
    func loadCategories(){
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
}
