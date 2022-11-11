//
//  ToDoItemCell.swift
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

class ToDoItemCell: UITableViewCell {
    var indexPath:IndexPath!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    
    @IBOutlet weak var isCompleted: UISwitch!
    @IBAction func onToggleChange(_ sender: Any) {
    }
    
    
    @IBOutlet weak var editBtn: UIButton!
    @IBAction func onEdit(_ sender: Any) {
    }

    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
