//
//  ViewController.swift
//  ToDoList
//
//  Created by Nirav Goswami on 2022-11-09.
//

import UIKit

struct ToDoItem {
    var name: String
    var notes: String
    var isCompleted: Bool
    var hasDueDate: Bool
    var dueDate: Date

}

class RootViewController: UITableViewController {
    
    
    private static let toDoItemCell = "ToDoItemCell"
    
    @IBOutlet var toDoListTable: UITableView!
    
    private var todolist = [
        ToDoItem(name: "To Do 1 1",notes:"", isCompleted : true,hasDueDate:true,dueDate: Date()),
        ToDoItem(name: "To Do 2",notes:"", isCompleted : false,hasDueDate:true,dueDate: Date()),
        ToDoItem(name: "To Do 3",notes:"", isCompleted : true,hasDueDate:true,dueDate: Date()),
        ToDoItem(name: "To Do 4",notes:"", isCompleted : false,hasDueDate:true,dueDate: Date()),
        ToDoItem(name: "To Do 5",notes:"", isCompleted : false,hasDueDate:true,dueDate: Date()),
        ToDoItem(name: "To Do 6",notes:"", isCompleted : false,hasDueDate:true,dueDate: Date()),
        ToDoItem(name: "To Do 7",notes:"", isCompleted : false,hasDueDate:true,dueDate: Date()),
        ToDoItem(name: "To Do 8",notes:"", isCompleted : false,hasDueDate:true,dueDate: Date()),
        ToDoItem(name: "To Do 9",notes:"", isCompleted : true,hasDueDate:true,dueDate: Date()),
        ToDoItem(name: "To Do 10",notes:"", isCompleted : false,hasDueDate:true,dueDate: Date()),
        ToDoItem(name: "To Do 11",notes:"", isCompleted : false,hasDueDate:true,dueDate: Date()),
        ToDoItem(name: "To Do 12",notes:"", isCompleted : false,hasDueDate:true,dueDate: Date())
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.toDoListTable.dataSource = self
            self.toDoListTable.delegate = self
            
            self.registerTableViewCells()
    }

    @IBAction func onAdd(_ sender: Any) {
        todolist.insert(ToDoItem(name: "",notes:"", isCompleted : false,hasDueDate:false,dueDate: Date()), at: 0)
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
//           let cell = tableView.dequeueReusableCell(withIdentifier: RootViewController.toDoItemCell, for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: RootViewController.toDoItemCell) as? ToDoItemCell
//        cell?.delegate = self
        cell?.indexPath = indexPath
        cell?.editBtn.addTarget(self, action: #selector(RootViewController.onEdit(_:)), for: .touchUpInside)
        let todo = todolist[indexPath.row]
        cell?.title?.text = todo.name
//        cell?.subTitle?.text
//        cell.textLabel?.text = todo.name

        if (todo.isCompleted == true){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YY/MM/dd"
            cell?.subTitle?.text = dateFormatter.string(from: todo.dueDate)
        }else{
            cell?.subTitle?.text = ""
        }
        
        print(cell,"----Cell------")

//        let editImage = UIImage(named: "edit")
//        cell.imageView?.image = editImage
//        cell.imageView.

//        let taskCompleted = UISwitch(frame: .zero)
//        taskCompleted.setOn(false, animated: true)
//        cell.accessoryView = taskCompleted
        if (todo.isCompleted == true){
            cell?.isCompleted.setOn(true, animated: true)
        }else{
            cell?.isCompleted.setOn(false, animated: true)
        }


        return cell ?? UITableViewCell()
    }
    
    
    @objc func onEdit(_ sender: Any?){
        print("Edit on", index)
        self.performSegue(withIdentifier: "showToDoDetail", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
//        let tableViewCell = sender as! UITableViewCell
//        let indexPath = tableView.indexPath(for: tableViewCell)!
        print(sender,"Prepare Called")
//        let font = fontForDisplay(atIndexPath: indexPath as NSIndexPath)
        let sizesVC =  segue.destination as! ToDoDetailViewController
        
    }
}

