//
//  DetailViewController.swift
//  Assignment2_Step2
//
//  Created by Timotin Ion on 2/5/19.
//  Copyright © 2019 Timotin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
 
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var lblAuthor : UILabel!
    @IBOutlet weak var tvDescription : UITextView!
    @IBOutlet weak var lblPublished : UILabel!
    @IBOutlet weak var tvContent : UITextView!
    @IBOutlet weak var activityIn: UIActivityIndicatorView!
    var imgUrl = ""
    var name = ""
    var author = ""
    var descrition = ""
    var published = ""
    var content = ""
    var urlToPost = ""


    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = name
        activityIn.startAnimating()
        activityIn.isHidden = false
        
        lblTitle.text = "Title: " + name
        lblAuthor.text = "Author: " + author
        tvDescription.text = "Description: " + descrition
        lblPublished.text = "Published: " + published
        tvContent.text = "Content: "+content
        
        imgView.loadImageUsingCacheWithURLString(imgUrl, placeHolder: nil){ (bool) in
            self.activityIn.isHidden = true
            self.activityIn.stopAnimating()
        }
        
    }
    
    @IBAction func watchPostBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let objViewController = UIApplication.topViewController()!
        let vc = storyboard.instantiateViewController(withIdentifier: "PageViewControllerID") as? PageViewController
        vc?.url = urlToPost
        objViewController.navigationController?.pushViewController(vc!, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
