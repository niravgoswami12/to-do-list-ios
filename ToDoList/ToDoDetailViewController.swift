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

class ToDoDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "To Do Detail"
        // Do any additional setup after loading the view.
    }
    
    func goBackToList(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func onCancel(_ sender: Any) {
        goBackToList()
    }
    @IBAction func onSave(_ sender: Any) {
        goBackToList()
    }
}
