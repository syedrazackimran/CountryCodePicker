//
//  CountryCodeVC.swift
//  CountryCodePicker
//
//  Created by Imu on 6/7/17.
//  Copyright © 2017 2ntkh. All rights reserved.
//

//MARK: Custom Delegate to pass selected Country Details

protocol CountryCodeDelegate:NSObjectProtocol {
    func didselectCounty(country: [String:String])
}

import UIKit

class CountryCodeVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    private var CompleteArray = [[String:String]]()
    private var FilterDataArray = [[String:String]]()
    private var pathIndex: IndexPath?
    weak var delegate: CountryCodeDelegate?
    
    @IBOutlet var CountryTabel: UITableView!
    @IBOutlet var CodeSearch: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: Change json file to Dict.
        if let path = Bundle.main.path(forResource: "countryCodes", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let totalArray = json as? [[String: String]] {
                    CompleteArray = totalArray
                    FilterDataArray = CompleteArray
                }
            } catch let error { print(error.localizedDescription) }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FilterDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CountryCodeCell = tableView.dequeueReusableCell(withIdentifier: "CountryCodeCell", for: indexPath) as! CountryCodeCell
        let data = FilterDataArray[indexPath.row]
        cell.countryNameLbl.text = data["name"]
        cell.countryCodeLbl.text = data["dial_code"]
        cell.countryImage.image = UIImage.init(named: data["code"] ?? "")
        cell.selectionStyle = .none
        return cell
    }
    
    //MARK: SearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "\n" {
            searchBar.resignFirstResponder()
        }else{
            FilterDataArray = searchText.isEmpty ? CompleteArray : CompleteArray.filter({ (item:[String:String]) -> Bool in
                let data = String(describing: item)
                return data.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            })
            CountryTabel.reloadData()
        }
       
    }
    //MARK: TabelView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pathIndex = indexPath
    }
    //MARK: Done Action
    @IBAction func DoneAction(_ sender: Any) {
        if self.delegate  != nil {
            if let indexPath = pathIndex {
                self.delegate?.didselectCounty(country: FilterDataArray[indexPath.row])
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
