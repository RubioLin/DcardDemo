//
//  CommentTableViewCell.swift
//  DcardDemo
//
//  Created by 林俊緯 on 2021/9/5.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var commentProfileImage: UIImageView!
    @IBOutlet weak var commentNameOfSchoolLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commentFloorCreatedAtLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
