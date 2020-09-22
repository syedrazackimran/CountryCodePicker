//
//  CountryCodeVC.swift
//  CountryCodePicker
//
//  Created by Imu on 6/7/17.
//  Copyright © 2017 2ntkh. All rights reserved.
//

//MARK: Custom Delegate to pass selected Country Details

protocol CountryCodeDelegate: class {
    func didselectCounty(country: [String:String])
}

import UIKit

class CountryCodeVC: UIViewController {
    
    private var completeArray = [[String:String]]() //used for all data
    private var filterDataArray = [[String:String]]() //filtered data to show
    
    weak var delegate: CountryCodeDelegate?
    
    @IBOutlet var countryTabelView: UITableView!
    @IBOutlet var codeSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchingDataFromLocal()
    }
    
    private func fetchingDataFromLocal() {
        //MARK: Change json file to Dict.
        if let path = Bundle.main.path(forResource: jsonFileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let totalArray = json as? [[String: String]] {
                    completeArray = totalArray
                    filterDataArray = totalArray
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    
    
    
    //MARK: Done Action
    @IBAction func DoneAction(_ sender: Any) {
        if self.delegate  != nil {
            if let indexPath = self.countryTabelView.indexPathForSelectedRow {
                self.delegate?.didselectCounty(country: filterDataArray[indexPath.row])
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}


extension CountryCodeVC: UITableViewDelegate, UITableViewDataSource {
    
    
    //MARK: TabelView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CountryCodeCell = tableView.dequeueReusableCell(withIdentifier: "CountryCodeCell", for: indexPath) as! CountryCodeCell
        let data = filterDataArray[indexPath.row]
        if let countryName = data["name"],
           let dialCode = data["dial_code"],
           let countryCode = data["code"] {
            cell.countryNameLbl.text = countryName
            cell.countryCodeLbl.text = dialCode
            cell.countryImage.image = UIImage(named: countryCode)
        }
        cell.selectionStyle = .none
        return cell
    }

}

extension CountryCodeVC: UISearchBarDelegate {
    //MARK: SearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "\n" {
            searchBar.resignFirstResponder()
        }else{
            filterDataArray = searchText.isEmpty ? completeArray : completeArray.filter({ (item:[String:String]) -> Bool in
                let data = String(describing: item)
                return data.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            })
            countryTabelView.reloadData()
        }
    }
}
