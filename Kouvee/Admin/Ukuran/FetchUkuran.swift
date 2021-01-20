//
//  UkuranFetch.swift
//  Kouvee
//
//  Created by Ryan Octavius on 05/04/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import UIKit

class FetchUkuran: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{
    
    @IBOutlet weak var searchBarLayanan: UISearchBar!
    @IBOutlet weak var outletSort: UIButton!
    @IBOutlet weak var UkuranColl: UICollectionView!
    @IBOutlet weak var sortBy: UILabel!
    
    
    let reuseIdentifier = "ukuranAdminCell"
    var Ukurans = [Ukuran]()
    let URL_JSON = "http://kouvee.xyz/index.php/Ukuran"
   private let refreshControl = UIRefreshControl()
    
    var filtered : [Ukuran] = []
    var searchActive : Bool = false
    
    var isSearchBarEmpty: Bool {
      return searchBarLayanan.text?.isEmpty ?? true
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        performSegue(withIdentifier: "back", sender: Any?.self)
    }
    
    @IBAction func btnAdd(_ sender: Any) {
        performSegue(withIdentifier: "AddUkuranSegue", sender: Any?.self)
    }
    
    
    @IBAction func btnSort(_ sender: Any) {
        let alert = UIAlertController(title: "Urutkan Berdasarkan ", message: "pilih salah satu :", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "ID", style: .default, handler: {ACTION in
            self.Ukurans.sort(by: {$0.id_ukuran.localizedStandardCompare($1.id_ukuran) == .orderedAscending})
            self.UkuranColl.reloadData()
            self.sortBy.text = "ID"
            
        }))
        
        alert.addAction(UIAlertAction(title: "Nama", style: .default, handler: {ACTION in
            self.Ukurans.sort(by: { $0.ukuran < $1.ukuran })
            self.UkuranColl.reloadData()
            self.sortBy.text = "Nama"
        }))
        
        alert.addAction(UIAlertAction(title: "Ketersediaan", style: .default, handler: {ACTION in
            self.Ukurans.sort(by: { $0.delete_at_ukuran < $1.delete_at_ukuran })
            self.UkuranColl.reloadData()
            self.sortBy.text = "Ketersediaan"
        }))
        self.present(alert, animated: true)
    }
    
    
    override func viewDidLoad() {
        getJson(urlString: URL_JSON)
        self.UkuranColl.delegate = self
        self.UkuranColl.dataSource = self
        self.UkuranColl.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshUkuran(_:)), for: .valueChanged)
        
        self.sortBy.text = "Ketersediaan"
        searchActive = false
        searchBarLayanan.delegate = self
        searchBarLayanan.placeholder = "Cari Ukuran"
        searchBarLayanan.showsCancelButton = true
        definesPresentationContext = true
        
        
        self.navigationItem.titleView = searchBarLayanan
    
        addShadowBtn(b: outletSort)
        addShadow(v: UkuranColl)
        super.viewDidLoad()
        
        }
    
    @objc private func refreshUkuran(_ sender: Any) {
        DispatchQueue.main.async(execute: {
            self.Ukurans.removeAll()
            self.getJson(urlString: self.URL_JSON)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchActive {
            return filtered.count
        }
        else
        {
            return Ukurans.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! UkuranCollection
        let data: Ukuran
        if searchActive {
          data = filtered[indexPath.row]
        } else {
          data = Ukurans[indexPath.row]
        }
        
        cell.namaUkuran.text = data.ukuran
        cell.labelID.text = "ID Ukuran : " + data.id_ukuran
        if data.delete_at_ukuran == "0000-00-00 00:00:00" {
            cell.tersedia.text = ""
        }else{
            cell.tersedia.text = "Tidak Tersedia"
        }
        
        addShadowCell(cell: cell)
        return cell
    }
    
    func addShadowBtn (b : UIButton){
        b.layer.cornerRadius = 6
        b.layer.shouldRasterize = true
        b.layer.rasterizationScale = true ? UIScreen.main.scale : 1
    }
    
    func addShadowCell (cell : UICollectionViewCell){
         cell.contentView.layer.cornerRadius = 10
         cell.contentView.layer.shouldRasterize = true
         cell.contentView.layer.rasterizationScale = true ? UIScreen.main.scale : 1
         cell.contentView.layer.masksToBounds = true
         cell.layer.masksToBounds = true
         cell.layer.cornerRadius = 10
    }
    
    public func addShadow(v: UICollectionView){
        v.layer.cornerRadius = 10
        v.layer.shadowColor = UIColor.lightGray.cgColor
        v.layer.shadowOffset = .zero
        v.layer.shadowOpacity = 0.4
        v.layer.shadowRadius = 5
        v.layer.shouldRasterize = true
        v.layer.rasterizationScale = true ? UIScreen.main.scale : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0.0
        }
    
    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 10.0
        }
    */
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        searchBarLayanan.resignFirstResponder()
        
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar == searchBarLayanan {
            self.filtered = self.Ukurans.filter { (data: Ukuran) -> Bool in
                return data.ukuran.lowercased().contains(searchBar.text!.lowercased()) ||
                    data.id_ukuran.lowercased().contains(searchBar.text!.lowercased())
            }
            if(filtered.count == 0){
                let alert = UIAlertController(title: "Data Tidak Ditemukan", message: "Cari Dengan Kata Kunci Lain", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {ACTION in
                    
                }))
                self.present(alert, animated: true)
                searchActive = false;
            } else {
                searchActive = true;
            }
            self.UkuranColl.reloadData()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            self.searchActive = false
            self.UkuranColl.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ViewUkuranSegue", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewUkuranSegue"{
            guard let VC = segue.destination as? ViewUkuran else {return}
            let indexPath = sender as! IndexPath
            if(filtered.count > 0){
                let Ukur = self.filtered[indexPath.row]
                VC.Ukurans = Ukur
            }else{
                let Ukur = self.Ukurans[indexPath.row]
                VC.Ukurans = Ukur
            }
            
        }
        else if segue.identifier == "AddLayananSegue"{
            guard let VC = segue.destination as? AddLayanan else {return}
            
        }
    }
    
    fileprivate func getJson(urlString: String)
    {
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!){
            (data,response,err) in
            if err != nil{
                print("error", err ?? "")
            }
            else{
                if let useable = data{
                    do{
                        let jsonObject = try JSONSerialization.jsonObject(with: useable, options: .mutableContainers) as AnyObject
                        
                        print(jsonObject)
                        
                        let Uk = jsonObject["Data"] as? [AnyObject]
                        for obj in Uk! {
                            let u = Ukuran(json: obj as! [String:Any])
                            self.Ukurans.append(u)
                            self.Ukurans.sort(by: { $0.delete_at_ukuran < $1.delete_at_ukuran })
                        }
                        
                        DispatchQueue.main.async(execute: {
                            self.UkuranColl.reloadData()
                            self.refreshControl.endRefreshing()
                        })
                    }
                    catch{
                        print("catch error")
                    }
                }
            }
        }.resume()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

