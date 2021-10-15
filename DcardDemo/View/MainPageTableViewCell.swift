import UIKit

class MainPageTableViewCell: UITableViewCell {

    @IBOutlet weak var genderImageView: UIImageView!
    @IBOutlet weak var nameOfForumLabel: UILabel!
    @IBOutlet weak var nameOfSchoolLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var excerptLabel: UILabel!
    @IBOutlet weak var countOfLikeLabel: UILabel!
    @IBOutlet weak var countOfCommentLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    
    
}
