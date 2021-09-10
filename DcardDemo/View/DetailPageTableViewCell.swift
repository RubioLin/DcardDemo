//
//  DetailPageTableViewCell.swift
//  DcardDemo
//
//  Created by 林俊緯 on 2021/9/5.
//

import UIKit

class DetailPageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var DetailGenderImageView: UIImageView!
    @IBOutlet weak var DetailSchoolNameLabel: UILabel!
    @IBOutlet weak var DetailDepartmentLabel: UILabel!
    @IBOutlet weak var DetailArticleTitleLabel: UILabel!
    @IBOutlet weak var DetailForumNameLabel: UILabel!
    @IBOutlet weak var DetailCreatedAtLabel: UILabel!
    @IBOutlet weak var DetailContentLabel: UILabel!
    @IBOutlet weak var DetailLikeCountLabel: UILabel!
    @IBOutlet weak var DetailCommentCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
