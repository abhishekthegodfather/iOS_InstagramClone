//
//  SearchViewController.swift
//  InstagramApp
//
//  Created by Cubastion on 12/04/23.
//  Copyright © 2023 Abhishek Biswas. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var searchController : UISearchController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCollectionView()
        prepareSearchController()
    }
    
    lazy var posts : [Post] = {
        let model = Model()
        return model.postList
    }()
    
    func prepareCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchCollectionViewCell.nib(), forCellWithReuseIdentifier: SearchCollectionViewCell.cellId)
    }
    
    func prepareSearchController(){
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController?.obscuresBackgroundDuringPresentation = true
        self.searchController?.searchBar.showsCancelButton = false
        
        // finding text field
        if let subViews = self.searchController?.searchBar.subviews {
            for subView in subViews {
                for item in subView.subviews {
                    if let txtField = item as? UITextField {
                        txtField.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 0.93)
                        txtField.textAlignment = .center
                        txtField.placeholder = "Search"
                    }
                }
            }
        }
        
        self.searchController?.dimsBackgroundDuringPresentation = false
        self.searchController?.definesPresentationContext = true
        self.searchController?.hidesNavigationBarDuringPresentation = false
        
        let searchBarContainer = CustomSearchController(customSearchController: self.searchController?.searchBar ?? UISearchBar())
        searchBarContainer.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        self.navigationItem.titleView = searchBarContainer
    }
}


extension SearchViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.cellId, for: indexPath) as? SearchCollectionViewCell
        cell?.searchImageView.image = posts[indexPath.row].postImage
        return cell ?? UICollectionViewCell()
    }
}
