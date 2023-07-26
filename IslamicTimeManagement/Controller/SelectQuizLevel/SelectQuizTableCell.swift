//
//  SelectQuizTableCell.swift
//  IslamicTimeManagement
//
//  Created by Apple on 09/03/21.
//

import UIKit

class SelectQuizTableCell: UITableViewCell {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var btnOpenClose:UIButton! {
        didSet {
            btnOpenClose.layer.cornerRadius = 12
            btnOpenClose.clipsToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
