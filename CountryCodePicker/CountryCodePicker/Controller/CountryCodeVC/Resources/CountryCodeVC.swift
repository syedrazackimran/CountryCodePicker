//
//  CountryCodeVC.swift
//  CountryCodePicker
//
//  Created by Imu on 6/7/17.
//  Copyright © 2017 2ntkh. All rights reserved.
//

//MARK: Custom Delegate to pass selected Country Details

protocol CountryCodeDelegate {
    func didselectCounty(country: NSDictionary)
}

import UIKit

class CountryCodeVC: UIViewController ,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate{
    var CompleteArray = [AnyObject]()
    var FilterDataArray = [AnyObject]()
    var pathIndex : NSIndexPath?
    var delegate : CountryCodeDelegate?
    
    @IBOutlet var CountryTabel: UITableView!
    @IBOutlet var CodeSearch: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: Change json file to Dict.
        if let path = Bundle.main.path(forResource: "countryCodes", ofType: "json") {
            do {
                let jsonData = try NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe)
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) //as! NSDictionary
                    CompleteArray = (jsonResult as! [AnyObject])
                    FilterDataArray = CompleteArray
                } catch {}
            } catch {}
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
        
        cell.countryNameLbl.text = "\(data["name"] as! String)"
        cell.countryCodeLbl.text = "\(data["dial_code"] as! String)"
        cell.countryImage.image = UIImage.init(named: "\(data["code"] as! String)")
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    //MARK: SearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "\n" {
            searchBar.resignFirstResponder()
        }else{
            FilterDataArray = searchText.isEmpty ? CompleteArray : CompleteArray.filter({ (item:AnyObject) -> Bool in
                let data = String(describing: item)
                return data.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            })
            CountryTabel.reloadData()
        }
       
    }
    //MARK: TabelView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        pathIndex = indexPath as NSIndexPath
    }
    //MARK: Done Action
    @IBAction func DoneAction(_ sender: Any) {
        if pathIndex == nil {
            
        }else{
            if (self.delegate  != nil) {
                self.delegate?.didselectCounty(country: FilterDataArray[(pathIndex?.row)!] as! NSDictionary)
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
}
