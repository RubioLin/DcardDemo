import UIKit

    
class PostViewController: UITableViewController {
    
    var comments: [Comments] = []
    var post: Post?
    var media: Media?
    var dcard: Dcard!
    //解決圖片比例用
//    var widths: [Int] = []
//    var heights: [Int] = []
//    if let count = post?.mediaMeta.count {
//        for i in 1...(count-1) {
//            if let width = post?.mediaMeta[i]?.width {
//                widths.append(width)
//            }
//            if let height = post?.mediaMeta[i]?.height {
//                heights.append(height)
//            }
//        }
//    }
//    print(heights)
//    print(widths)
//    print(dcard.id)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "\(dcard.title)"
        setupContentCell()
        setupCommentCell()
        fetchComments()
        fetchContent()
    }
    
    func fetchComments() {
        DcardClient.shard.fetchComments(urlString: "https://www.dcard.tw/service/api/v2/posts/\(dcard.id)/comments") { comment in
            if let comment = comment {
                self.comments = comment
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchContent() {
        DcardClient.shard.fetchContent(urlString: "https://www.dcard.tw/service/api/v2/posts/\(dcard.id)") { content in
            if let content = content {
                self.post = content
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func setupContentCell() {
        let ContentCellNib = UINib(nibName: "ContentTableViewCell", bundle: .main)
        tableView.register(ContentCellNib, forCellReuseIdentifier: "ContentTableViewCell")
    }
    
    func setupCommentCell() {
        let commentCellNib = UINib(nibName: "CommentTableViewCell", bundle: .main)
        tableView.register(commentCellNib, forCellReuseIdentifier: "CommentTableViewCell")

    }
    
  
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        } else {
            return comments.count
        }
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ContentTableViewCell.self)", for: indexPath) as? ContentTableViewCell
            else { return ContentTableViewCell() }
        
            //genderImageView
            cell.contentProfileImage.image = UIImage(named: "Default")
            if post?.gender == "M" {
                cell.contentProfileImage.image = UIImage(named: "M")
            } else {
                cell.contentProfileImage.image = UIImage(named: "F")
            }
            
            //DetailSchoolNameLabel
            cell.contentNameOfSchoolLabel.text = nil
            if let school = post?.school {
                cell.contentNameOfSchoolLabel.text = "\(school)"
            } else {
                cell.contentNameOfSchoolLabel.text = "匿名"
            }
            
            //DetailDepartmentLabel
            cell.contentDepartmentLabel.text = nil
            if let department = post?.department {
                cell.contentDepartmentLabel.text = "\(department)"
            } else {
                if post?.gender == "M"{
                    cell.contentDepartmentLabel.text = "男生"
                } else {
                    cell.contentDepartmentLabel.text = "女生"
                }
            }
            
            //DetailArticleTitleLabel
            cell.contentTitleLabel.text = nil
            if let title = post?.title {
                cell.contentTitleLabel.text = "\(title)"
            }
            
            
            
            
            //DetailForumNameLabel
            cell.contentNameOfForumLabel.text = nil
            cell.contentNameOfForumLabel.text = post?.forumName
            
            //DetailCreatedAtLabel
            cell.contentCreatedAtLabel.text = nil
            let dateFormatter = ISO8601DateFormatter()
            dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let createdAt = post?.createdAt {
                let date = dateFormatter.date(from: createdAt)
                let theCaleder = Calendar.current
                let now = Date()
                let diff: DateComponents = theCaleder.dateComponents([.day, .hour], from: date!, to: now)
                if diff.day! < 1 {
                    cell.contentCreatedAtLabel.text = "\(diff.hour!)小時前"
                } else if 1 < diff.day! || diff.day! < 7 {
                    cell.contentCreatedAtLabel.text = "\(diff.day!)天前"
                } else {
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: "zh_Hant_TW")
                    dateFormatter.dateFormat = "MM月dd日"
                    let dateStr = dateFormatter.string(from: date!)
                    cell.contentCreatedAtLabel.text = "\(dateStr)"
                }
            }
            
            //DetailContentLabel
            cell.contentLabel.attributedText = nil
            let contentArray = post?.content.split(separator: "\n").map(String.init)
            let mutableAttributedString = NSMutableAttributedString()
            contentArray?.forEach{ row in
                if row.contains("http") {
                    mutableAttributedString.append(imageFrom: row, label: cell.contentLabel)
                } else {
                    mutableAttributedString.append(string: row)
                }
            }
            cell.contentLabel.attributedText = mutableAttributedString
           
            //DetailLikeCountLabel, DetailCommentCountLabel
            cell.contentLikeCountLabel.text = nil
            cell.contentCommentCountLabel.text = nil
            if let likeCount = post?.likeCount,
               let commentCount = post?.commentCount {
                cell.contentLikeCountLabel.text = "\(likeCount)"
                cell.contentCommentCountLabel.text = "\(commentCount)"
            }
            
            
            
            return cell
            
        } else {

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(CommentTableViewCell.self)", for: indexPath) as? CommentTableViewCell
            else { return CommentTableViewCell() }
            
            let comment = comments[indexPath.row]
            
            //genderImageView
            cell.commentProfileImage.image = UIImage(named: "Default")
            if let gender = comment.gender {
                if gender == "M" {
                    cell.commentProfileImage.image = UIImage(named: "M")
                } else {
                    cell.commentProfileImage.image = UIImage(named: "F")
                }
            } else {
                cell.commentProfileImage.image = UIImage(named: "Default")
            }
            
            //SchoolNameLabel
            cell.commentNameOfSchoolLabel.text = nil
            if comment.hiddenByAuthor == true {
                cell.commentNameOfSchoolLabel.text = "這則留言已被本人刪除"
            } else {
                if comment.host == true {
                    cell.commentNameOfSchoolLabel.text = "原PO"
                } else {
                    cell.commentNameOfSchoolLabel.text = comment.school
                }
            }
            
            //ContentLabel
            cell.commentLabel.text = nil
            let commentArray = comment.content?.split(separator: "\n").map(String.init)
            let mutableAttributedString = NSMutableAttributedString()
            commentArray?.forEach({ row in
                if row.contains("http") {
                    mutableAttributedString.append(imageFrom: row, label: cell.commentLabel)
                } else {
                    mutableAttributedString.append(string: row)
                }
            })
            if comment.hiddenByAuthor == true {
                cell.commentLabel.text = "已經刪除的內容就像Dcard一樣，錯過是無法再相見的！"
            } else {
                cell.commentLabel.attributedText = mutableAttributedString
            }


            //CommentFloorCreatedAtLabel
            cell.commentFloorCreatedAtLabel.text = nil
            DispatchQueue.main.async {
                let dateFormatter = ISO8601DateFormatter()
                dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                let date = dateFormatter.date(from: comment.createdAt)
                let theCaleder = Calendar.current
                let now = Date()
                let diff: DateComponents = theCaleder.dateComponents([.day, .hour], from: date!, to: now)
                if diff.day! < 1 {
                    cell.commentFloorCreatedAtLabel.text = "B\(comment.floor), \(diff.hour!)小時前"
                } else {
                    cell.commentFloorCreatedAtLabel.text = "B\(comment.floor), \(diff.day!)天前"
                }
            }
            
            return cell
        }
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
extension UIImage {
    static func image(from url: URL, handel: @escaping (UIImage?) -> ()) {
        
        guard let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
            handel(nil)
            return
        }
        handel(image)
    }
    
    func scaled(with scale: CGFloat) -> UIImage? {
        let size = CGSize(width: floor(self.size.width * scale ), height: floor(self.size.height * scale))
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension NSMutableAttributedString {
    func append(string: String) {
        self.append(NSAttributedString(string: string + "\n"))
    }
    
    func append(imageFrom: String, label: UILabel) {
        guard let url = URL(string: imageFrom) else { return }
        
        UIImage.image(from: url) { (image) in
            guard let image = image else { return }
            let scaledImg = image.scaled(with: UIScreen.main.bounds.width / image.size.width * 0.8 )
            let attachment = NSTextAttachment()
            attachment.image = scaledImg
            self.append(NSAttributedString(attachment: attachment))
            self.append(NSAttributedString(string: "\n"))
        }
    }
}
