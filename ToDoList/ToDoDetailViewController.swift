//
//  ToDoDetailViewController.swift
//  ToDoList
//
//  Created by Nirav Goswami on 2022-11-10.
//

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
