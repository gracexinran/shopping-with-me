//
//  GoogleTableViewController.swift
//  Capstone
//
//  Created by Xinran Che on 1/14/20.
//  Copyright © 2020 Xinran Che. All rights reserved.
//

import UIKit
import SafariServices

class GoogleTableViewController: UITableViewController {
    var searchTerm:String = ""
    var start:Int = 1
    var searchResults = [SearchResult]()
//    {
//        didSet {
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
//    }

    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    var progressView = UIView()
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var loadAnimator: UIActivityIndicatorView!
    @IBOutlet weak var loadMoreButton: UIButton!
    @IBOutlet weak var message: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        bottomView.isHidden = true
        startLoadingView()
        message.text = "LOADING..."
        
        let googleSearchRequest = GoogleSearchRequest(searchTerm:searchTerm, start:start)
        googleSearchRequest.getSearchResults { [weak self] result in
            DispatchQueue.main.async {
                self?.stopLoadingView()
            }
            switch result {
            case .failure(let error):
                DispatchQueue.main.async{
                    self?.message.text = error.localizedDescription
                }
                print(error.localizedDescription)
            case .success(let searchResults):
                self?.searchResults = searchResults
                DispatchQueue.main.async{
                    self?.tableView.reloadData()
                    self?.bottomView.isHidden = false
                    self?.message.text = "Google Search Results"
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            if self.activityIndicator.isAnimating{
                self.stopLoadingView()
                self.message.text = "Error! No available data! Check your internet connection!"
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchResults.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GoogleTableViewCell

        cell.cellLabel.text = searchResults[indexPath.row].source
        cell.cellTitle.text = searchResults[indexPath.row].title
        let imageURL = URL(string: searchResults[indexPath.row].image)
        if let data = try? Data(contentsOf: imageURL!) {
            cell.cellImage.image = UIImage(data: data)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let safari = SFSafariViewController(url: URL(string: searchResults[indexPath.row].link)! as URL)
        present(safari, animated: true, completion: nil)
    }

    @IBAction func loadMore(_ sender: Any) {
        start = start + 10
        
        loadAnimator.startAnimating()
        view.isUserInteractionEnabled = false
        
        loadMoreButton.setTitle("LOADING...", for: .normal)
        let googleSearchRequest = GoogleSearchRequest(searchTerm:searchTerm, start:start)
        googleSearchRequest.getSearchResults { [weak self] result in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self?.stopLoadingAnimator()
            }
            switch result {
            case .failure(let error):
                DispatchQueue.main.async{
                    self?.start = 11
                    self?.loadMoreButton.setTitle("ERROR! RELOAD?", for: .normal)
                    self?.message.text = error.localizedDescription
                }
                print(error.localizedDescription)
                
            case .success(let searchResults):
                self?.searchResults += searchResults
                DispatchQueue.main.async{
                    self?.tableView.reloadData()
                    if self!.start >= 31 {
                        self?.loadMoreButton.isEnabled = false
                        self?.loadMoreButton.setTitle("NO MORE", for: .normal)
                    } else {
                        self?.loadMoreButton.setTitle("LOAD MORE", for: .normal)
                    }
                    self?.message.text = "Google Search Results"
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            if self.loadAnimator.isAnimating{
                self.stopLoadingAnimator()
                self.start = 11
                self.loadMoreButton.setTitle("ERROR! RELOAD?", for: .normal)
                self.message.text = "Error! No available data! Check your internet connection!"
            }
        }
    }
    
    func startLoadingView(){
        progressView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        progressView.center = view.center
        progressView.backgroundColor = UIColor.init(red: 210.0/255.0, green: 210.0/255.0, blue: 210.0/255.0, alpha: 1.0)
        progressView.clipsToBounds = true
        progressView.layer.cornerRadius = 10

        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.center = CGPoint(x: progressView.bounds.width / 2, y: progressView.bounds.height / 2)

        progressView.addSubview(activityIndicator)
        view.addSubview(progressView)
        
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
    }

    func stopLoadingView(){
        activityIndicator.stopAnimating()
        progressView.removeFromSuperview()
        view.isUserInteractionEnabled = true
    }
    
    func stopLoadingAnimator(){
         loadAnimator.stopAnimating()
         view.isUserInteractionEnabled = true
    }
}
