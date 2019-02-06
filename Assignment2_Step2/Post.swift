//
//  Post.swift
//  Assignment2_Step2
//
//  Created by Timotin Ion on 2/4/19.
//  Copyright © 2019 Timotin. All rights reserved.
//

import Foundation

struct Post {
    let title:String
    let description:String
    let author:String
    let url:String
    let urlToImage:String
    let publishedAt:String
    let content:String
    
    enum SerializationError:Error{
        case missing(String)
        case invalid(String, Any)
    }
    
    init(json: [String:Any]) throws{
        guard let author = json["author"] as? String else { throw  SerializationError.missing("Author is missing")}
        
        guard let title =  json["title"] as? String else { throw SerializationError.missing("Title is missing!")
        }
        guard let description =  json["description"] as? String else { throw SerializationError.missing("description is missing!")
        }
        guard let url =  json["url"] as? String else { throw SerializationError.missing("url is missing!")
        }
        guard let urlToImage =  json["urlToImage"] as? String else { throw SerializationError.missing("Url to image is missing!")
        }
        guard let publishedAt =  json["publishedAt"] as? String else { throw SerializationError.missing("Published date is missing!")
        }
        guard let content =  json["content"] as? String else { throw SerializationError.missing("Content is missing!")
        }
        
        self.author = author
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
    }
    
    static let basePathToAPI = "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=24f5571d936546aba55c5a50b3cc791a"
    
    static func hotPost (completion:@escaping([Post]) -> ()){
        let request = URLRequest(url:URL(string:basePathToAPI)!)

        let task = URLSession.shared.dataTask(with: request) {
            (data:Data?, response:URLResponse?, error:Error?) in

            var postArray:[Post] = []
            if let data = data {
                do{
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let articles = json["articles"] as? [[String:Any]] {
                           // DispatchQueue.main.async {
                            for article in articles {
                                if let postObject = try? Post(json: article){
                                    postArray.append(postObject)
                                }
                            }
                           // }
                        }
                    }
                }
                catch{
                    print(error.localizedDescription)
                }
            }
            completion(postArray)
        }
        
        task.resume()
        
    }
    
    
    
}
