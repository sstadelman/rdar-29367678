//
//  MasterViewController.swift
//  TestingEditMode
//
//  Created by Stadelman, Stan on 11/22/16.
//  Copyright © 2016 sstadelman. All rights reserved.
//

import UIKit

/**
 Simple `UITableViewCell` subclass, which only accounts for accessory type during reuse
 */
class CustomTableViewCell: UITableViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        self.accessoryType = .none
    }
}

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "Custom")
        self.tableView.allowsMultipleSelectionDuringEditing = true
        self.tableView.isEditing = true
    
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Custom", for: indexPath) as! CustomTableViewCell

//        let object = objects[indexPath.row] as! NSDate
        cell.textLabel!.text = "\(indexPath)"
        cell.accessoryType = .detailButton
        return cell
    }

    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row] as! NSDate
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
}

