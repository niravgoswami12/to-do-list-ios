//
//  ToDoDetailViewController.swift
//  ToDoList
//
//  Created by Nirav Goswami on 2022-11-10.
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

class ToDoDetailViewController: UIViewController {
    
    var currentIndex : Int?
    var todolist = [ToDo]()
    var todo: ToDo?
    
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var notes: UITextView!
    @IBOutlet weak var hasDueDate: UISwitch!
    @IBOutlet weak var isCompleted: UISwitch!
    @IBOutlet weak var dueDate: UIDatePicker!
    
    var managedContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Detail"
        // Do any additional setup after loading the view.
        dueDate.isEnabled = false
        loadData(index: currentIndex!)
        
        name.addTarget(self, action: #selector(ToDoDetailViewController.textFieldDidChange(_:)), for: .editingChanged)
        
        
    }
    
    @IBAction func onDueDateToggleChange(_ sender: UISwitch) {
        if(sender.isOn){
            dueDate.isEnabled = true
        }else{
            dueDate.isEnabled = false
        }
    }
    
    @IBAction func onIsCompletedToggleChanges(_ sender: Any) {
    }
    
    @IBAction func onDueDateSelectionChange(_ sender: Any) {
    }
    
    @IBAction func onDelete(_ sender: Any) {
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this?", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { [self] (action) -> Void in
            // Save Changes
            do {
                let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
                managedContext.delete(todo!)
                try managedContext.save()
            } catch  {
                print(error)
            }
            
            goBackToList()
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            
        }
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func loadData(index: Int){
        let toDoFetch: NSFetchRequest<ToDo> = ToDo.fetchRequest()
        let sortByDate = NSSortDescriptor(key: #keyPath(ToDo.createdDate), ascending: false)
        toDoFetch.sortDescriptors = [sortByDate]
        do {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let results = try managedContext.fetch(toDoFetch)
            todolist = results
            todo = todolist[currentIndex!]
            name.text = todo?.name
            notes.text = todo?.notes
            hasDueDate.isOn = todo?.hasDueDate ?? false
            isCompleted.isOn = todo?.isCompleted ?? false
            dueDate.date = todo?.dueDate ?? Date()
            dueDate.isEnabled = hasDueDate.isOn
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    func goBackToList(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func onCancel(_ sender: Any) {
        goBackToList()
    }
    @IBAction func onSave(_ sender: Any) {
        name.text = name.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if(name.text == ""){
            name.layer.cornerRadius = 5
            name.layer.borderColor = UIColor.red.cgColor
            name.layer.borderWidth = 1
            return
        }
        
        todo!.setValue(name.text, forKey: #keyPath(ToDo.name))
        todo!.setValue(notes.text, forKey: #keyPath(ToDo.notes))
        todo!.setValue(hasDueDate.isOn, forKey: #keyPath(ToDo.hasDueDate))
        todo!.setValue(isCompleted.isOn, forKey: #keyPath(ToDo.isCompleted))
        if(hasDueDate.isOn){
            var components = DateComponents()
            components.day = 1
            components.second = -1
            let selectedDate =  Calendar.current.date(byAdding: components, to: Calendar.current.startOfDay(for: dueDate.date))!
            todo!.setValue(selectedDate, forKey: #keyPath(ToDo.dueDate))
        }
        
        do {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            try managedContext.save()
        } catch  {
            print(error)
        }
        goBackToList()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if(name.text == ""){
            name.layer.cornerRadius = 5
            name.layer.borderColor = UIColor.red.cgColor
            name.layer.borderWidth = 1
        }else{
            name.layer.borderWidth = 0
        }
    }
}
