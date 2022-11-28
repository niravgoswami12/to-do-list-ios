//
//  ViewController.swift
//  ToDoList
//
//  Created by Nirav Goswami on 2022-11-09.
//

//  Description: To Do List App will allow the user to enter a list of Todos (or tasks) on the main screen. Include a
//               second screen that displays the Todo Details.
//  Version: v1.0.0
//
//  Group #18
//  Nirav Goswami (301252385)
//  Samir Patel (301286671)
//  Esha Naik (301297804)

import UIKit
import CoreData


class RootViewController: UITableViewController, ToDoItemCellDelegate {
    
    
    
    
    private static let toDoItemCell = "ToDoItemCell"
    
    
    
    @IBOutlet var toDoListTable: UITableView!
    
    let attributesForCompletedTitle: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor(red: 0.06, green: 0.76, blue: 0.00, alpha: 1.00),
        .strikethroughColor: UIColor(red: 0.07, green: 0.07, blue: 0.07, alpha: 1.00),
        .strikethroughStyle: 3
    ]
    
    let attributesForCompletedSubTitle: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor(red: 0.06, green: 0.76, blue: 0.00, alpha: 1.00)
    ]
    
    let attributesForDueTitle: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor(red: 0.94, green: 0.28, blue: 0.23, alpha: 1.00)
    ]
    let attributesForDueSubTitle: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor(red: 0.94, green: 0.28, blue: 0.23, alpha: 1.00)
    ]
    
    let attributesForDefault: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
    ]

    let dateFormatter = DateFormatter()
    
    var todolist = [ToDo]()
    weak var actionToEnable : UIAlertAction?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadToDoList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.toDoListTable.dataSource = self
        self.toDoListTable.delegate = self
        self.registerTableViewCells()
    }
    
    func loadToDoList(){
        let toDoFetch: NSFetchRequest<ToDo> = ToDo.fetchRequest()
        let sortByDate = NSSortDescriptor(key: #keyPath(ToDo.createdDate), ascending: false)
        toDoFetch.sortDescriptors = [sortByDate]
        do {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let results = try managedContext.fetch(toDoFetch)
            todolist = results
            let range = NSMakeRange(0, self.toDoListTable.numberOfSections)
            let sections = NSIndexSet(indexesIn: range)
            self.toDoListTable.reloadSections(sections as IndexSet, with: .automatic)
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
    @IBAction func onAdd(_ sender: Any) {
        let dialogMessage = UIAlertController(title: "", message: "Add New ToDo", preferredStyle: .alert)
        
        
        dialogMessage.addTextField(configurationHandler: {(titleStr: UITextField) in
            titleStr.placeholder = "Enter title here..."
            titleStr.addTarget(dialogMessage, action: #selector(dialogMessage.textDidChangeInAlert), for: .editingChanged)

        })
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { [self] (action) -> Void in
           
            var titleStr:String = ((dialogMessage.textFields![0]).text!)
            
            
            if titleStr != "" {
                saveData(title: titleStr)
            }
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
        }
        
        //Add OK and Cancel button to dialog message
        ok.isEnabled = false
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)

        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
    
    
    
    func saveData(title: String){
        let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
        let newToDo = ToDo(context: managedContext)
        newToDo.setValue(title, forKey: #keyPath(ToDo.name))
        newToDo.setValue(false, forKey: #keyPath(ToDo.hasDueDate))
        newToDo.setValue(false, forKey: #keyPath(ToDo.isCompleted))
        newToDo.setValue(Date(), forKey: #keyPath(ToDo.createdDate))
        self.todolist.insert(newToDo, at: 0)
        do {
            try managedContext.save()
            let range = NSMakeRange(0, self.toDoListTable.numberOfSections)
            let sections = NSIndexSet(indexesIn: range)
            self.toDoListTable.reloadSections(sections as IndexSet, with: .automatic)
        } catch  {
            print(error)
        }
    }
    
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: RootViewController.toDoItemCell,
                                  bundle: nil)
        self.toDoListTable.register(textFieldCell,
                                    forCellReuseIdentifier: RootViewController.toDoItemCell)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todolist.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RootViewController.toDoItemCell, for: indexPath) as? ToDoItemCell
        cell?.delegate = self
        cell?.backView.layer.cornerRadius = 5
        cell?.backView.clipsToBounds = true
        
        cell?.indexPath = indexPath
     
        let todo = todolist[indexPath.row]
        if (todo.isCompleted){
            cell?.title?.attributedText = NSAttributedString(string: todo.name!, attributes: attributesForCompletedTitle)
            cell?.subTitle?.attributedText = NSAttributedString(string: "Completed", attributes: attributesForCompletedSubTitle)
        }else {
            cell?.title?.attributedText = NSAttributedString(string: todo.name!, attributes: attributesForDefault)
            cell?.subTitle?.attributedText = NSAttributedString(string: "", attributes: attributesForDefault)
            if(todo.hasDueDate && (todo.dueDate != nil)){
                var components = DateComponents()
                components.day = 1
                components.second = -1
                let endOfToday =  Calendar.current.date(byAdding: components, to: Calendar.current.startOfDay(for: Date()))!
                if(todo.dueDate! < endOfToday){
                    cell?.title?.attributedText = NSAttributedString(string: todo.name!, attributes: attributesForDueTitle)
                    cell?.subTitle?.attributedText = NSAttributedString(string: "Overdue!", attributes: attributesForDueSubTitle)
                }else{
                    dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
                    cell?.subTitle?.text = dateFormatter.string(from: todo.dueDate!)
                }
            }
        }
        if (todo.isCompleted == true){
            cell?.isCompleted.setOn(true, animated: true)
        }else{
            cell?.isCompleted.setOn(false, animated: true)
        }
        cell?.isCompleted.isHidden = true
        cell?.editBtn.isHidden = true
        return cell ?? UITableViewCell()
    }
    
    func onEdit(index: Int){
        self.performSegue(withIdentifier: "showToDoDetail", sender: index)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        let toDoDetailVC =  segue.destination as! ToDoDetailViewController
        toDoDetailVC.currentIndex = sender as? Int
    }
    
    func onIsCompletedToggleChange(value: Bool, index: Int){
        let todo = todolist[index]
        todo.setValue(value, forKey: #keyPath(ToDo.isCompleted))
        do {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            try managedContext.save()
            let indexPath = IndexPath(item: index, section: 0)
            self.toDoListTable.reloadRows(at: [indexPath], with: .automatic)
        } catch  {
            print(error)
        }
    }
    
    
    override func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "Edit") { [weak self] (action, view, completionHandler) in
                                            self?.onEdit(index: indexPath.row)
                                            completionHandler(true)
        }
        action.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [action])
    }

    private func removeToDo(index: Int) {
        do {
//            let todo = todolist[index]
//            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
//            managedContext.delete(todo)
//            try managedContext.save()
//            loadToDoList()
            
            let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this?", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { [self] (action) -> Void in
                // Save Changes
                do {
                    let todo = todolist[index]
                    let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
                    managedContext.delete(todo)
                    try managedContext.save()
                    loadToDoList()
                } catch  {
                    print(error)
                }
                
            })
            
            // Create Cancel button with action handlder
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                
            }
            
            //Add OK and Cancel button to dialog message
            dialogMessage.addAction(ok)
            dialogMessage.addAction(cancel)
            
            // Present dialog message to user
            self.present(dialogMessage, animated: true, completion: nil)
        } catch  {
            print(error)
        }

    }

    override func tableView(_ tableView: UITableView,
                       trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let todo = todolist[indexPath.row]
        let toggleVal = !todo.isCompleted
        let label = toggleVal ? "Complete" : "Incomplete"
        let toggleAction = UIContextualAction(style: .normal,
                                        title: label) { [weak self] (action, view, completionHandler) in
                                        self?.onIsCompletedToggleChange(value: toggleVal, index: indexPath.row)
                                            completionHandler(true)
        }
        toggleAction.backgroundColor = .systemYellow

        let deleteAction = UIContextualAction(style: .normal,
                                        title: "Delete") { [weak self] (action, view, completionHandler) in
                                        self?.removeToDo(index: indexPath.row)
                                            completionHandler(true)
        }
        deleteAction.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [deleteAction, toggleAction])
    }
}

extension UIAlertController {

    @objc func textDidChangeInAlert() {
        let tf = textFields?[0]
        var titleStr = tf!.text
        let action = actions.first
        action!.isEnabled = false
        titleStr = titleStr!.trimmingCharacters(in: .whitespacesAndNewlines)
        if(titleStr != ""){
            action!.isEnabled = true
        }
    }
}
