//
//  ViewController.swift
//  ToDoList
//
//  Created by Zabihullah Najeeb on 2024-06-06 and update on 2024-06-13
//
import UIKit

// Struct to represent a to-do item
struct ToDoItem {
    var text: String
    var isCompleted: Bool
}

class ViewController: UIViewController {
    
    // Text field for user input
    var textField: UITextField?
    
    // Array to store the items added by the user
    var items: [ToDoItem] = [] {
        didSet {
            saveItems() // Save items to UserDefaults when the array is updated
        }
    }
    
    // Outlet to the table view in the storyboard
    @IBOutlet weak var table: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self // Set the table view delegate
        table.dataSource = self // Set the table view data source
        
        loadItems() // Load items from UserDefaults when the view loads
    }

    // Action triggered when the add button is pressed
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        // Create an alert controller to add a new item
        let alert = UIAlertController(title: "Add an Item", message: "", preferredStyle: .alert)
        
        // Add a cancel action to the alert
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        // Add a save action to the alert
        let save = UIAlertAction(title: "Save", style: .default) { _ in
            // Check if the text field is not empty
            if let newItemText = self.textField?.text, !newItemText.isEmpty {
                let newItem = ToDoItem(text: newItemText, isCompleted: false)
                self.items.append(newItem) // Append the new item to the items array
                self.table.reloadData() // Reload the table view to display the new item
            }
        }
        // Add a text field to the alert
        alert.addTextField { text in
            self.textField = text // Store a reference to the text field
            self.textField?.placeholder = "Add New Item" // Set the placeholder text
        }
        // Add the cancel and save actions to the alert
        alert.addAction(cancel)
        alert.addAction(save)
        
        // Present the alert to the user
        present(alert, animated: true, completion: nil)
    }
    
    // Save items to UserDefaults
    func saveItems() {
        let itemsData = items.map { ["text": $0.text, "isCompleted": $0.isCompleted] }
        UserDefaults.standard.set(itemsData, forKey: "items") // Save items array to UserDefaults
    }
    
    // Load items from UserDefaults
    func loadItems() {
        if let savedItemsData = UserDefaults.standard.array(forKey: "items") as? [[String: Any]] {
            items = savedItemsData.compactMap {
                guard let text = $0["text"] as? String, let isCompleted = $0["isCompleted"] as? Bool else { return nil }
                return ToDoItem(text: text, isCompleted: isCompleted)
            }
        }
    }
}

// Extension to handle table view delegate and data source methods
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count // Return number of items in the array as number of rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.text // Set cell text label to item text
        cell.accessoryType = item.isCompleted ? .checkmark : .none // Display checkmark if item is completed
        
        // Set selected background view color to light gray with alpha
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        cell.selectedBackgroundView = selectedBackgroundView
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Delete action
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completionHandler in
            self.items.remove(at: indexPath.row) // Remove item from the array
            tableView.deleteRows(at: [indexPath], with: .automatic) // Delete row from the table view
            completionHandler(true)
        }
        // Edit action
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, completionHandler in
            // Create an alert controller to edit the item
            let alert = UIAlertController(title: "Edit Item", message: "", preferredStyle: .alert)
            
            // Add a cancel action to the alert
            let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            
            // Add a save action to the alert
            let save = UIAlertAction(title: "Save", style: .default) { _ in
                // Check if the text field is not empty
                if let updatedItemText = self.textField?.text, !updatedItemText.isEmpty {
                    self.items[indexPath.row].text = updatedItemText // Update item text in the array
                    self.table.reloadData() // Reload the table view to display updated item
                }
            }
            
            // Add a text field to the alert, pre-filled with the current item
            alert.addTextField { text in
                self.textField = text // Store a reference to the text field
                self.textField?.text = self.items[indexPath.row].text // Set text field text to current item text
            }
            
            // Add the cancel and save actions to the alert
            alert.addAction(cancel)
            alert.addAction(save)
            
            // Present the alert to the user
            self.present(alert, animated: true, completion: nil)
            
            completionHandler(true)
        }
        editAction.backgroundColor = .blue // Set background color of edit action button
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction]) // Return swipe actions configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].isCompleted.toggle() // Toggle completion status of the selected item
        tableView.reloadRows(at: [indexPath], with: .automatic) // Reload row to update checkmark
    }
}
