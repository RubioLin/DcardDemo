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
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(DetailPageTableViewCell.self)") as? DetailPageTableViewCell
            
            //genderImageView
            if detailPage?.gender == "M" {
                cell?.DetailGenderImageView.image = UIImage(named: "M")
            } else {
                cell?.DetailGenderImageView.image = UIImage(named: "F")
            }
            
            //DetailSchoolNameLabel
            if let school = detailPage?.school {
                cell?.DetailSchoolNameLabel.text = school
            } else {
                cell?.DetailSchoolNameLabel.text = "匿名"
            }
            //DetailDepartmentLabel
            if let department = detailPage?.department {
                cell?.DetailDepartmentLabel.text = department
            } else {
                if detailPage?.gender == "M"{
                    cell?.DetailDepartmentLabel.text = "男生"
                } else {
                    cell?.DetailDepartmentLabel.text = "女生"
                }
            }
            //DetailArticleTitleLabel
            if let title = detailPage?.title {
                cell?.DetailArticleTitleLabel.text = "\(title)"
            }
            
            //DetailForumNameLabel
            cell?.DetailForumNameLabel.text = detailPage?.forumName
            
            //DetailCreatedAtLabel
            let dateFormatter = ISO8601DateFormatter()
            dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let createdAt = detailPage?.createdAt {
                let date = dateFormatter.date(from: createdAt)
                let theCaleder = Calendar.current
                let now = Date()
                let diff: DateComponents = theCaleder.dateComponents([.day, .hour], from: date!, to: now)
                if diff.day! < 1 {
                    cell?.DetailCreatedAtLabel.text = "\(diff.hour!)小時前"
                } else if diff.day! > 1, diff.day! < 7 {
                    cell?.DetailCreatedAtLabel.text = "\(diff.day)天前"
                } else {
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: "zh_Hant_TW")
                    dateFormatter.dateFormat = "MM月dd日"
                    let dateStr = dateFormatter.string(from: date!)
                    cell?.DetailCreatedAtLabel.text = "\(dateStr)"
                }
            }
            
            //DetailContentLabel
            if let content = detailPage?.content {
                cell?.DetailContentLabel.text = content
            }
            
            //DetailLikeCountLabel, DetailCommentCountLabel
            if let likeCount = detailPage?.likeCount,
               let commentCount = detailPage?.commentCount {
                cell?.DetailLikeCountLabel.text = String(likeCount)
                cell?.DetailCommentCountLabel.text = String(commentCount)
            }
            
            return cell!
            
        } else {
            
            let comment = comments[indexPath.row]

            let cell = tableView.dequeueReusableCell(withIdentifier: "\(CommentTableViewCell.self)") as? CommentTableViewCell
            
            //genderImageView
            if comment.gender == "M" {
                cell?.commentGenderImageVIew.image = UIImage(named: "M")
            } else {
                cell?.commentGenderImageVIew.image = UIImage(named: "F")
            }
            
            //SchoolNameLabel
            cell?.commentSchoolNameLabel.text = comment.school
            
            //ContentLabel
            cell?.commentContentLabel.text = ""
            cell?.commentContentLabel.text = comment.content
            
            //CommentFloorCreatedAtLabel
            let dateFormatter = ISO8601DateFormatter()
            dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            let date = dateFormatter.date(from: comment.createdAt)
            let theCaleder = Calendar.current
            let now = Date()
            let diff: DateComponents = theCaleder.dateComponents([.day, .hour], from: date!, to: now)
            if diff.day! < 1 {
                cell?.commentFloorCreatedAtLabel.text = "B\(comment.floor), \(diff.hour!)小時前"
            } else {
                cell?.commentFloorCreatedAtLabel.text = "B\(comment.floor), \(diff.day!)天前"
            }
            return cell!
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



