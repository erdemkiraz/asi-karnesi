//
//  TodoCell.swift
//  QRCodeApp
//
//  Created by Elif Basak  Yildirim on 27.03.2021.
//

import UIKit

class TodoCell: UITableViewCell {

    @IBOutlet weak var checkmarkImageView: UIImageView!
    @IBOutlet weak var taskLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
struct Todo{
    var title: String
    var isMarked: Bool
}

