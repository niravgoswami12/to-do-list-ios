//
//  ToDoItemCell.swift
//  ToDoList
//
//  Created by Nirav Goswami on 2022-11-10.
//

import UIKit

//protocol ToDoItemDelegate{
//    func onEdit(at index:IndexPath)
//}

class ToDoItemCell: UITableViewCell {
//    var delegate:ToDoItemDelegate!
    var indexPath:IndexPath!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    
    @IBOutlet weak var isCompleted: UISwitch!
    @IBAction func onToggleChange(_ sender: Any) {
    }
    
    
    @IBOutlet weak var editBtn: UIButton!
    @IBAction func onEdit(_ sender: Any) {
//        self.delegate?.onEdit(at: indexPath)
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
