//
//  CountryCodeVC.swift
//  CountryCodePicker
//
//  Created by Imu on 6/7/17.
//  Copyright © 2017 Imran. All rights reserved.
//

//MARK: Custom Delegate to pass selected Country Details

protocol CountryCodeDelegate: class {
    /// DidSelecCountry Delegate
    /// - Parameter model: Countries Response Model Struct
    func didselectCounty(model: CountriesResponseModelElement)
}

import UIKit

class CountryCodeVC: UIViewController {
    
    private var completeArray = CountriesResponseModel() //used for all data
    private var filterDataArray = CountriesResponseModel() //filtered data to show
    
    weak var delegate: CountryCodeDelegate?
    
    @IBOutlet var countryTabelView: UITableView! {
        didSet {
            countryTabelView.keyboardDismissMode = .onDrag
        }
    }
    @IBOutlet var codeSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchingDataFromLocal()
    }
    
    //MARK: Change json file to Dict.
    private func fetchingDataFromLocal() {
        Helper.fetchDataFromBundle { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let responseModel):
                strongSelf.completeArray = responseModel
                strongSelf.filterDataArray = responseModel
            case .failure(let error):
                print("ERROR:\(error)")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    
    
    
    //MARK: Done Action
    @IBAction func DoneAction(_ sender: UIButton) {
        codeSearchBar.resignFirstResponder()
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            if strongSelf.delegate  != nil {
                if let indexPath = strongSelf.countryTabelView.indexPathForSelectedRow {
                    strongSelf.delegate?.didselectCounty(model: strongSelf.filterDataArray[indexPath.row])
                    strongSelf.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}

//MARK: UITabelViewDelegate and DataSource
extension CountryCodeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: CountryCodeCell = tableView.dequeueReusableCell(withIdentifier: CountryCodeCell.cellIdentifier,
                                                                        for: indexPath) as? CountryCodeCell else {
            return .init()
        }
        let responseModel = filterDataArray[indexPath.row]
        cell.set(with: responseModel)
        cell.selectionStyle = .none
        return cell
    }
    
}

//MARK: SearchBar Delegate
extension CountryCodeVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterDataArray = searchText.isEmpty ? completeArray : completeArray.filter({ $0.code.contains(searchText) ||
            $0.dialCode.contains(searchText) ||
            $0.name.lowercased().contains(searchText.lowercased())
        })
        countryTabelView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if range.location == 0 && text == " " {
            return false
        }
        return true
    }
}
