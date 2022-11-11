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

    

    let dateFormatter = DateFormatter()
    private var todolist:[ToDoItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.toDoListTable.dataSource = self
        self.toDoListTable.delegate = self
        self.registerTableViewCells()
        
        loadToDoList()
    }
    
    func loadToDoList(){
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"

        todolist = [
            ToDoItem(name: "To Do 1",notes:"", isCompleted : true,hasDueDate:true,dueDate: Date()),
            ToDoItem(name: "To Do 2",notes:"", isCompleted : false,hasDueDate:true,dueDate: dateFormatter.date(from: "01-03-2021 09:15")!),
            ToDoItem(name: "To Do 3",notes:"", isCompleted : false,hasDueDate:true,dueDate: dateFormatter.date(from: "25-11-2022 09:15")!),
            ToDoItem(name: "To Do 4",notes:"", isCompleted : false,hasDueDate:true,dueDate: dateFormatter.date(from: "10-10-2022 09:15")!),
            ToDoItem(name: "To Do 5",notes:"", isCompleted : false,hasDueDate:false,dueDate: Date()),
            ToDoItem(name: "To Do 6",notes:"", isCompleted : false,hasDueDate:true,dueDate: dateFormatter.date(from: "20-12-2022 09:15")!),
            
    //        ToDoItem(name: "To Do 7",notes:"", isCompleted : false,hasDueDate:true,dueDate: Date()),
    //        ToDoItem(name: "To Do 8",notes:"", isCompleted : false,hasDueDate:true,dueDate: Date()),
    //        ToDoItem(name: "To Do 9",notes:"", isCompleted : true,hasDueDate:true,dueDate: Date()),
    //        ToDoItem(name: "To Do 10",notes:"", isCompleted : false,hasDueDate:true,dueDate: Date()),
    //        ToDoItem(name: "To Do 11",notes:"", isCompleted : false,hasDueDate:true,dueDate: Date()),
    //        ToDoItem(name: "To Do 12",notes:"", isCompleted : false,hasDueDate:true,dueDate: Date())
            ]
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
        
        cell?.backView.layer.cornerRadius = 5
        cell?.backView.clipsToBounds = true
        
        cell?.indexPath = indexPath
        
        cell?.editBtn.addTarget(self, action: #selector(RootViewController.onEdit(_:)), for: .touchUpInside)
       
        let todo = todolist[indexPath.row]

        if (todo.isCompleted == true){
            cell?.title?.attributedText = NSAttributedString(string: todo.name, attributes: attributesForCompletedTitle)
            
            cell?.subTitle?.attributedText = NSAttributedString(string: "Completed", attributes: attributesForCompletedSubTitle)

        }else {
            cell?.title?.text = todo.name
            if(todo.hasDueDate){
                if(todo.dueDate < Date()){
                    cell?.title?.attributedText = NSAttributedString(string: todo.name, attributes: attributesForDueTitle)
                    cell?.subTitle?.attributedText = NSAttributedString(string: "Overdue!", attributes: attributesForDueSubTitle)
                }else{
                    dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
                    cell?.subTitle?.text = dateFormatter.string(from: todo.dueDate)
                }
                
            }
            
            
        }
        

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

