//
//  ContentTableViewCell.swift
//  DcardDemo
//
//  Created by 林俊緯 on 2021/9/21.
//

import UIKit

class ContentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contentProfileImage: UIImageView!
    @IBOutlet weak var contentNameOfSchoolLabel: UILabel!
    @IBOutlet weak var contentDepartmentLabel: UILabel!
    @IBOutlet weak var contentTitleLabel: UILabel!
    @IBOutlet weak var contentNameOfForumLabel: UILabel!
    @IBOutlet weak var contentCreatedAtLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentLikeCountLabel: UILabel!
    @IBOutlet weak var contentCommentCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentLabel.sizeToFit()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
