//
//  LisViewController.swift
//  TravelBook
//
//  Created by Jazmin on 27/08/24.
//

import UIKit
import CoreData
class LisViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   var titleArray = [String]()
   var idArray = [UUID]()
   var chosenTitle = ""
    var chosenTitleID : UUID?

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClick))
        tableView.delegate = self
        tableView.dataSource = self
      getData()
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("newPlace"), object: nil)
    }
    
  @objc  func getData()  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let contex = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Places")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try contex.fetch(request)
            if results.count > 0 {
                self.titleArray.removeAll(keepingCapacity: false)
                self.idArray.removeAll(keepingCapacity: false)
                for result in results as! [NSManagedObject]{
                    if let title =  result.value(forKey: "title") as? String {
                        titleArray.append(title)
                    }
                    if let id = result.value(forKey: "id") as? UUID{
                        idArray.append(id)
                    }
                    tableView.reloadData()
                }
            }
        } catch {
            print("Error")
        }
    }
    @objc func addButtonClick(){
        chosenTitle = ""
        performSegue(withIdentifier: "Segue", sender: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = titleArray[indexPath.row]
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenTitle = titleArray[indexPath.row]
        chosenTitleID = idArray[indexPath.row]
        performSegue(withIdentifier: "Segue", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Segue" {
            let destinationVC = segue.destination as! ViewController
            destinationVC.selectedTitle = chosenTitle
            destinationVC.selectedTitleID = chosenTitleID
        }
    }
}

