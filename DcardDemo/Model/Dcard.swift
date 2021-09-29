import Foundation

struct Dcard: Codable {
    let id: Int
    let title: String
    let excerpt: String
    let commentCount: Int
    let likeCount: Int
    let forumName: String
    let gender: String
    let school: String?
    let mediaMeta: [MediaMeta?]
}

struct MediaMeta: Codable {
    let url: String
}
