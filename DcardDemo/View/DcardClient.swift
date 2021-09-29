import Foundation

class DcardClient {
    
    static let shard = DcardClient()
    
    func fetchPost(urlString: String, completionHandler: @escaping ([Dcard]?) -> Void) {
        let url = URL(string: urlString)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data {
                do {
                    let post = try jsonDecoder.decode([Dcard].self, from: data)
                    completionHandler(post)
                } catch {
                    completionHandler(nil)
                }
            }
        }
        task.resume()
    }
    
    func fetchContent(urlString: String, completionHandler: @escaping (Post?) -> Void) {
        let url = URL(string: urlString)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data {
                do {
                    let content = try jsonDecoder.decode(Post.self, from: data)
                    completionHandler(content)
                } catch {
                    completionHandler(nil)
                }
            }
        }
        task.resume()
    }
    
    func fetchComments(urlString: String, completionHandler: @escaping ([Comments]?) -> Void) {
        let url = URL(string: urlString)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data {
                do {
                    let comment = try jsonDecoder.decode([Comments].self, from: data)
                    completionHandler(comment)
                } catch {
                    completionHandler(nil)
                }
            }
        }
        task.resume()
    }
}


