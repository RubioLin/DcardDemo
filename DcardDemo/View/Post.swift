import Foundation

struct Post: Codable {
    let gender: String
    let title: String
    let content: String
    let createdAt: String
    let commentCount: Int
    let likeCount: Int
    let forumName: String
    var department: String? //沒有的顯示判斷gender顯示男女生
    var school: String? //沒有的就顯示匿名
    let mediaMeta: [Media?]
}

struct Media: Codable {
    var url: String
    var width: Int?
    var height: Int?
}
