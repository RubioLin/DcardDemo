import UIKit

class MainPageTableViewController: UITableViewController {

    var posts: [Posts] = []
    
    @objc func fetchPosts() {
        let urlStr = "https://www.dcard.tw/service/api/v2/posts"
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let posts = try decoder.decode([Posts].self, from: data)
                        self.posts = posts
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.refreshControl?.endRefreshing()
                        }
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    func refreshControl() {
        refreshControl = UIRefreshControl()
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white] //文字顏色
        refreshControl?.attributedTitle = NSAttributedString(string: "更新中", attributes: attributes) //文字內容跟屬性
        refreshControl?.tintColor = UIColor.white
        refreshControl?.addTarget(self, action: #selector(fetchPosts), for: UIControl.Event.valueChanged) //下拉後執行的動作
        tableView.refreshControl = refreshControl
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPosts()
        refreshControl()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postsCell", for: indexPath) as? MainPageTableViewCell
        else { return MainPageTableViewCell()}
        
        let post = posts[indexPath.row]
        
        //genderImageView
        if post.gender == "M" {
            cell.genderImageView.image = UIImage(named: "M")
        } else {
            cell.genderImageView.image = UIImage(named: "F")
        }
        
        //forumNameLabel
        cell.forumNameLabel.text = post.forumName
        
        //schoolNameLabel
        if let school = post.school {
            cell.schoolNameLabel.text = school
        } else {
            cell.schoolNameLabel.text = "匿名"
        }
        
        //articleTitleLabel
        cell.articleTitleLabel.text = post.title
        
        //articleExcerptLabel
        cell.articleExcerptLabel.text = post.excerpt

        //commentCountLabel
        cell.commentCountLabel.text = String(post.commentCount)
    
        //likeCountLabel
        cell.likeCountLabel.text = String(post.likeCount)
        
        //articleImageView
        if !post.mediaMeta.isEmpty {
            let url = URL(string: post.mediaMeta[0]!.url)
            URLSession.shared.dataTask(with: url!) { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        cell.articleImageView.image = UIImage(data: data)
                        cell.articleImageView.isHidden = false
                    }
                }
            }.resume()
        } else {
            cell.articleImageView.isHidden = true
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
