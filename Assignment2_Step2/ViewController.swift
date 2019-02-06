//
//  ViewController.swift
//  Assignment2_Step2
//
//  Created by Timotin Ion on 2/4/19.
//  Copyright © 2019 Timotin. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout:layout)
        cv.backgroundColor = .clear
        return cv
    }()
    
    let imageCellId = "imageCellId"
    var postArray:[Post] = []
    var searchedPosts:[Post] = []
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
        
        Post.hotPost { (results:[Post]) in
            self.postArray = results
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        self.setUpView()
        
    }

    func setUpView(){
        collectionView.delegate = self
        collectionView.dataSource = self;
        
        collectionView.register(ImagesCell.self, forCellWithReuseIdentifier: imageCellId)
        
        view.addSubview(collectionView)
        collectionView.setAnchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 150, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellId, for: indexPath) as! ImagesCell
        if isSearching {
            cell.posts = searchedPosts
        }else{
            cell.posts = postArray
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: view.frame.width, height: view.frame.height/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)

    }

}


class ImagesCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    var posts: [Post]? {
        didSet{
            collectionView.reloadData()
        }
    }
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 30
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        return cv
    }()
    
    override init(frame: CGRect){
        super.init(frame:frame)
        setUp()
    }
    
    let cellId = "cellId"
    func setUp() {
        backgroundColor = .clear
        setCellShadow()
        addSubview(collectionView)
        collectionView.setAnchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        collectionView.delegate = self;
        collectionView.dataSource = self
        collectionView.register(IconCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for:indexPath) as! IconCell
        if (posts?.count ?? 0) > 0 {
            if let post = posts?[indexPath.item]{
                cell.titleLabel.text = post.title
                cell.authorLabel.text = post.author
                cell.imageView.loadImageUsingCacheWithURLString(post.urlToImage, placeHolder: nil){ (bool) in
                    //                //perform actions if needed
                }
            }
        } else {
            print("No objects, array empty")
        }
        return cell
    }
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("was pressed \(indexPath.item)")
        let objViewController = UIApplication.topViewController()!
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewControllerID") as? DetailViewController
       
        if let post = posts?[indexPath.item]{
            vc?.name = post.title
            vc?.author = post.author
            vc?.imgUrl = post.urlToImage
            vc?.descrition = post.description
            vc?.published = post.publishedAt
            vc?.content = post.content
            vc?.urlToPost = post.url
        }
        objViewController.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: frame.height - 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) has not been implemented")
    }
    
    private class IconCell: UICollectionViewCell{
        let authorLabel : UILabel = {
            let lbl = UILabel()
            lbl.contentMode = .scaleAspectFit
            lbl.clipsToBounds = false
            lbl.textColor = .darkGray
            lbl.font = UIFont (name: "Helvetica Neue", size: 18)
            lbl.textAlignment = NSTextAlignment.center
            return lbl
        }()
        
        let titleLabel : UILabel = {
            let lbl = UILabel()
            lbl.contentMode = .scaleAspectFit
            lbl.clipsToBounds = false
            lbl.textColor = .black
            lbl.font = UIFont (name: "Helvetica Neue", size: 12)
            lbl.numberOfLines = 0
            return lbl
        }()
        
        let imageView : UIImageView = {
            let iv = UIImageView()
            iv.contentMode  = .scaleAspectFit
            iv.clipsToBounds = true
            iv.layer.cornerRadius = 15
            return iv
        }()
        
        override init(frame: CGRect){
            super.init(frame:frame)
            setUp()
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder) has not been implemented")
        }
        
        func setUp() {
            backgroundColor = .clear
            setCellShadow()
            addSubview(titleLabel)
            addSubview(authorLabel)
            addSubview(imageView)
           
            authorLabel.setAnchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom:0 , paddingRight: 0)
            titleLabel.setAnchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 10, paddingBottom:0 , paddingRight: 10)
            imageView.setAnchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        }
    }
    
    
}

extension ViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true;
        searchedPosts = postArray.filter({ (post : Post) -> Bool in
                return post.title.lowercased().contains(searchText.lowercased())
            
        })
    
        isSearching = true
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false;
        searchBar.text = ""
        collectionView.reloadData()
        searchBar.showsCancelButton = false
        self.view.endEditing(true)
    }
}

