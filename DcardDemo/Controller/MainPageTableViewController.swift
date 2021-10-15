import UIKit



class MainPageTableViewController: UITableViewController {
    
    var dcard: [Dcard] = []
    
    @objc func fetchPosts() {
        DcardClient.shard.fetchPosts(urlString: "https://www.dcard.tw/service/api/v2/posts?popular=true&limit=30") { dcard in
            if let post = dcard {
                self.dcard = post
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    func refreshControl() {
        refreshControl = UIRefreshControl()
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.systemGray2] //文字顏色
        refreshControl?.attributedTitle = NSAttributedString(string: "更新中", attributes: attributes) //文字內容跟屬性
        refreshControl?.tintColor = UIColor.white
        refreshControl?.backgroundColor = UIColor.systemGray4
        refreshControl?.addTarget(self, action: #selector(fetchPosts), for: UIControl.Event.valueChanged) //下拉後執行的動作
        tableView.refreshControl = refreshControl
    }
    
    func updateBarBtn() {
        let barButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = barButtonItem
        let image = UIImage(systemName: "arrow.backward")
        let barAppearance = UINavigationBarAppearance()
        barAppearance.setBackIndicatorImage(image, transitionMaskImage: image)
        navigationController?.navigationBar.standardAppearance = barAppearance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        fetchPosts()
        refreshControl()
        updateBarBtn()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dcard.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(MainPageTableViewCell.self)", for: indexPath) as? MainPageTableViewCell
        else { return MainPageTableViewCell()}
        
        let post = dcard[indexPath.row]
        
        //genderImageView
        if post.gender == "M" {
            cell.genderImageView.image = UIImage(named: "M")
        } else {
            cell.genderImageView.image = UIImage(named: "F")
        }
        
        //nameOfForumLabel
        cell.nameOfForumLabel.text = post.forumName
        
        //nameOfSchoolLabel
        if let school = post.school {
            cell.nameOfSchoolLabel.text = school
        } else {
            cell.nameOfSchoolLabel.text = "匿名"
        }
        
        //titleLabel
        cell.titleLabel.text = post.title
        
        //excerptLabel
        cell.excerptLabel.text = post.excerpt
        
        //countOfCommentLabel
        cell.countOfCommentLabel.text = String(post.commentCount)
        
        //countOfLikeLabel
        cell.countOfLikeLabel.text = String(post.likeCount)
        
        //thumbnailImageView
        if !post.mediaMeta.isEmpty {
            let url = URL(string: post.mediaMeta[0]!.url)
            URLSession.shared.dataTask(with: url!) { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        cell.thumbnailImageView.image = UIImage(data: data)
                        cell.thumbnailImageView.isHidden = false
                    }
                }
            }.resume()
        } else {
            cell.thumbnailImageView.isHidden = true
        }
        return cell
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
    
    
    // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let row = tableView.indexPathForSelectedRow?.row, let controller = segue.destination as? PostViewController {
            let post = dcard[row]
            controller.dcard = post
        }
     }
     
    
}
