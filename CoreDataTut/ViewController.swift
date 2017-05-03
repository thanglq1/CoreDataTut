//
//  ViewController.swift
//  CoreDataTut
//
//  Created by ThangLQ on 5/2/17.
//  Copyright © 2017 ThangLQ. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var people = [NSManagedObject]()
    
    @IBOutlet weak var tableView: UITableView!
    

    @IBAction func btnAdd(_ sender: Any) {
        let alert = UIAlertController(title: "New name", message: "Add a new name", preferredStyle: .alert)
        let actionSave = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (action) in
            if let name = alert.textFields?.first?.text {
//                self.names.append(name)
                self.save(name: name)
                self.tableView.reloadData()
            }
            
        }
        alert.addAction(actionSave)
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(actionCancel)
        
        alert.addTextField(configurationHandler: nil)
        present(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Personal")
        do {
            try people = managedObjectContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("error = \(error)")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let personal = people[indexPath.row]
        cell.textLabel?.text = personal.value(forKey: "name") as! String
        return cell
    }
    
    func save(name: String) {
        guard let appDelegate =  UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Personal", in: managedObjectContext)
        let personal = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
        personal.setValue(name, forKeyPath: "name")
        do {
            try managedObjectContext.save()
            people.append(personal)
        } catch let error as NSError {
            print("error: \(error)")
        }
        
    }
}


