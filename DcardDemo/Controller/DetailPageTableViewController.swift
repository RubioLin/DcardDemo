import UIKit

    
class DetailPageTableViewController: UITableViewController {
    
    var comments: [Comments] = []
    var detailPage: DetailPage?
    var posts: Posts!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "\(posts.title)"
        setupDetailPageCell()
        setupCommentCell()
        fetchComments()
        fetchDetailPage()
    }
    
    func fetchComments() {
        let urlStr = "https://www.dcard.tw/service/api/v2/posts/\(posts.id)/comments"
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let comment = try decoder.decode([Comments].self, from: data)
                        self.comments = comment
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } catch {
                        print(error)
                    }
                    
                }
            }.resume()
        }
    }
    
    func fetchDetailPage() {
        let urlStr = "https://www.dcard.tw/service/api/v2/posts/\(posts.id)"
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let detailPages = try decoder.decode(DetailPage.self, from: data)
                        self.detailPage = detailPages
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    func setupDetailPageCell() {
        let detailPageCellNib = UINib(nibName: "DetailPageTableViewCell", bundle: .main)
        tableView.register(detailPageCellNib, forCellReuseIdentifier: "DetailPageTableViewCell")
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(DetailPageTableViewCell.self)", for: indexPath) as? DetailPageTableViewCell
            else { return DetailPageTableViewCell() }
            //genderImageView
            if detailPage?.gender == "M" {
                cell.DetailGenderImageView.image = UIImage(named: "M")
            } else {
                cell.DetailGenderImageView.image = UIImage(named: "F")
            }
            
            //DetailSchoolNameLabel
            if let school = detailPage?.school {
                cell.DetailSchoolNameLabel.text = "\(school)"
            } else {
                cell.DetailSchoolNameLabel.text = "匿名"
            }
            
            //DetailDepartmentLabel
            if let department = detailPage?.department {
                cell.DetailDepartmentLabel.text = "\(department)"
            } else {
                if detailPage?.gender == "M"{
                    cell.DetailDepartmentLabel.text = "男生"
                } else {
                    cell.DetailDepartmentLabel.text = "女生"
                }
            }
            
            //DetailArticleTitleLabel
            if let title = detailPage?.title {
                cell.DetailArticleTitleLabel.text = "\(title)"
            }
            
            //DetailForumNameLabel
            cell.DetailForumNameLabel.text = detailPage?.forumName
            
            //DetailCreatedAtLabel
            let dateFormatter = ISO8601DateFormatter()
            dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let createdAt = detailPage?.createdAt {
                let date = dateFormatter.date(from: createdAt)
                let theCaleder = Calendar.current
                let now = Date()
                let diff: DateComponents = theCaleder.dateComponents([.day, .hour], from: date!, to: now)
                if diff.day! < 1 {
                    cell.DetailCreatedAtLabel.text = "\(diff.hour!)小時前"
                } else if 1 < diff.day! || diff.day! < 7 {
                    cell.DetailCreatedAtLabel.text = "\(diff.day!)天前"
                } else {
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: "zh_Hant_TW")
                    dateFormatter.dateFormat = "MM月dd日"
                    let dateStr = dateFormatter.string(from: date!)
                    cell.DetailCreatedAtLabel.text = "\(dateStr)"
                }
            }
            
            //DetailContentLabel
            cell.DetailContentLabel.text = nil
            if let content = detailPage?.content {
                DispatchQueue.main.async {
                    cell.DetailContentLabel.text = content
                }
            }
            
            //DetailLikeCountLabel, DetailCommentCountLabel
            cell.DetailLikeCountLabel.text = nil
            cell.DetailCommentCountLabel.text = nil
            if let likeCount = detailPage?.likeCount,
               let commentCount = detailPage?.commentCount {
                cell.DetailLikeCountLabel.text = "\(likeCount)"
                cell.DetailCommentCountLabel.text = "\(commentCount)"
            }
            
            return cell
            
        } else {
            
            let comment = comments[indexPath.row]

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(CommentTableViewCell.self)", for: indexPath) as? CommentTableViewCell
            else { return CommentTableViewCell() }
            
            //genderImageView
            cell.commentGenderImageVIew.image = nil
            if let gender = comment.gender {
                if gender == "M" {
                    cell.commentGenderImageVIew.image = UIImage(named: "M")
                } else {
                    cell.commentGenderImageVIew.image = UIImage(named: "F")
                }
            } else {
                cell.commentGenderImageVIew.image = UIImage(named: "Default")
            }
            
            //SchoolNameLabel
            cell.commentSchoolNameLabel.text = nil
            if comment.hiddenByAuthor == true {
                cell.commentSchoolNameLabel.text = "這則留言已被刪除"
            } else {
                if comment.host == true {
                    cell.commentSchoolNameLabel.text = "原PO"
                } else {
                    cell.commentSchoolNameLabel.text = comment.school
                }
            }
            
            //ContentLabel
            cell.commentContentLabel.text = nil
            if let content = comment.content {
                cell.commentContentLabel.text = content
            } else {
                cell.commentContentLabel.text = "已經刪除的內容就像 Dcard 一樣，錯過是無法再相見的！"
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



