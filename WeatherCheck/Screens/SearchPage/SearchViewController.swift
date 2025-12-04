//
//  SearchViewController.swift
//  WeatherCheck
//
//  Created by Pranay Barua on 02/12/25.
//

import UIKit

class SearchViewController: UIViewController,XIBed {

    @IBOutlet weak var BGImgView: UIImageView!
    @IBOutlet weak var headingLabel: UILabel!
    
    @IBOutlet weak var searchUiView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    
    @IBOutlet weak var tableViewParentView: UIView!
    @IBOutlet weak var recentSearchTableView: UITableView!
    @IBOutlet weak var tableViewHeightConst: NSLayoutConstraint!
    
    var completion: ((String)->())? = nil
    
    private let recentSearchesKey = "recentSearchesKey"
    private var recentSearches: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadSetup()
    }
    
    func loadSetup(){
        recentSearchTableView.delegate = self
        recentSearchTableView.dataSource = self
        
        searchUiView.layer.cornerRadius = 15
        searchUiView.layer.masksToBounds = true
        searchTextField.delegate = self
        
        tableViewParentView.layer.cornerRadius = 15
        tableViewParentView.layer.masksToBounds = true
        
        recentSearchTableView.register(searchTableViewCell.nib(), forCellReuseIdentifier: searchTableViewCell.identifier)
        
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search for city or place",
            attributes: [
                .foregroundColor: UIColor.white.withAlphaComponent(0.6),
                .font: UIFont.systemFont(ofSize: 16, weight: .medium)
            ]
        )
        
        searchTextField.textColor = .white
        searchTextField.tintColor = .white 
        
        recentSearches = UserDefaults.standard.stringArray(forKey: recentSearchesKey) ?? []
        tableViewHeightConst.constant = CGFloat(recentSearches.count * 50)
        recentSearchTableView.reloadData()
    }
    
    private func saveRecentSearch(_ city: String) {
        let trimmed = city.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.isEmpty == false else { return }
        
        // Remove if it already exists (so it can be moved to top)
        if let index = recentSearches.firstIndex(where: { $0.caseInsensitiveCompare(trimmed) == .orderedSame }) {
            recentSearches.remove(at: index)
        }
        
        // Insert at top (most recent first)
        recentSearches.insert(trimmed, at: 0)

        if recentSearches.count > 5 {
            recentSearches = Array(recentSearches.prefix(5))
        }
        
        // Save to UserDefaults
        UserDefaults.standard.set(recentSearches, forKey: recentSearchesKey)
        
        // Refresh table
        recentSearchTableView.reloadData()
    }
}

//MARK: - UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {
    
    @IBAction func searchBtnTapped(_ sender: Any) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Search for city"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            saveRecentSearch(city)
            self.completion?(city)
            self.navigationController?.popViewController(animated: false)
        }
        searchTextField.text = ""
        
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchTableViewCell.identifier, for: indexPath) as! searchTableViewCell
        cell.selectionStyle = .none
        let city = recentSearches[indexPath.row]
        cell.textLabel?.text = city
        cell.textLabel?.textColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let city = recentSearches[indexPath.row]
        completion?(city)
        navigationController?.popViewController(animated: false)
    }
    
}


