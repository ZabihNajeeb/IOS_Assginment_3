//
//  ViewController.swift
//  ToDoList
//
//  Created by Zabihullah Najeeb on 2024-06-06.
//

import UIKit

// Main view controller class
class ViewController: UIViewController {
    
    // Text field for user input
    var textField: UITextField?
    
    // Array to store the items added by the user
    var items: [String] = []

    // Outlet to the table view in the storyboard
    @IBOutlet weak var table: UITableView!

    // Called after the view has been loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting the view controller as the delegate and data source of the table view
        table.delegate = self
        table.dataSource = self
    }

    // Action triggered when the add button is pressed
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        
        // Create an alert controller to add a new item
        let alert = UIAlertController(title: "Add an Item", message: "", preferredStyle: .alert)
        
        // Add a cancel action to the alert
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        // Add a save action to the alert
        let save = UIAlertAction(title: "Save", style: .default) { _ in
            // Check if the text field is not empty
            if let newItem = self.textField?.text, !newItem.isEmpty {
                // Append the new item to the items array
                self.items.append(newItem)
                // Reload the table view to display the new item
                self.table.reloadData()
            }
        }
        
        // Add a text field to the alert
        alert.addTextField { text in
            // Store a reference to the text field
            self.textField = text
            // Set the placeholder text
            self.textField?.placeholder = "Add New Item"
        }
        
        // Add the cancel and save actions to the alert
        alert.addAction(cancel)
        alert.addAction(save)
        
        // Present the alert to the user
        present(alert, animated: true, completion: nil)
    }
}

// Extension to handle table view delegate and data source methods
extension ViewController: UITableViewDelegate, UITableViewDataSource {

    // Return the number of rows in the section (number of items in the array)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    // Configure and return the cell for the given index path
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue a reusable cell with the identifier "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // Set the text label of the cell to the corresponding item
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
}



