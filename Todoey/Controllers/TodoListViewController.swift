//
//  ViewController.swift
//  Todoey
//
//  Created by Srijan Raj on 16/05/18.
//  Copyright © 2018 Srijan Raj. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
//    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    var itemArray = [AddItem]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //UserDefaults is an interface to user database where you store key value pair consistently

    override func viewDidLoad() {
        super.viewDidLoad()

        loadItems()
        
        // Do any additional setup after loading the view, typically from a nib.
        
//        if let item = defaults.array(forKey: "TodoListArray") as? [AddItem]{
//            itemArray = item
//        }
    }

  //Mark-Tableview datasource Method
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }
    
    //Mark-Tableview Delegate Methods
   
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //Mark - Add New items
    // NSUserDefault can only take standard datatype rather than the objects or the other data types
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // What will happen once the user clicks the add item button
        
            let newItem = AddItem()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            self.saveItems()
          
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"
            textField = alertTextField
     
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
        
        
    }
    
    //Mark - Add function save list to save the data to the plist or model manipulation method
    
    func saveItems() {
        
        let encoder = PropertyListEncoder()
        
        
        do{
            let data = try encoder.encode(self.itemArray)
            try data.write(to: dataFilePath!)
        }
        catch{
            print("Error encoding item array, \(error)")
        }
        
         tableView.reloadData()
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([AddItem].self, from: data)
            }
            catch{
                print("Error decoding Item Array,\(error)")
            }
        }
    }
}

