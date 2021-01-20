//
//  FetchJenisHewan.swift
//  Kouvee
//
//  Created by Ryan Octavius on 05/04/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import UIKit

class FetchJenisHewan: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{
    
    @IBOutlet weak var searchBarLayanan: UISearchBar!
    @IBOutlet weak var outletSort: UIButton!
    @IBOutlet weak var JenisHewanColl: UICollectionView!
    @IBOutlet weak var sortBy: UILabel!
    
    
    let reuseIdentifier = "jenishewanAdminCell"
    var JenisHewans = [JenisHewan]()
    let URL_JSON = "http://kouvee.xyz/index.php/JenisHewan"
   private let refreshControl = UIRefreshControl()
    
    var filtered : [JenisHewan] = []
    var searchActive : Bool = false
    
    var isSearchBarEmpty: Bool {
      return searchBarLayanan.text?.isEmpty ?? true
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        performSegue(withIdentifier: "back", sender: Any?.self)
    }
    
    @IBAction func btnAdd(_ sender: Any) {
        performSegue(withIdentifier: "AddJenishewanSegue", sender: Any?.self)
    }
    
    
    @IBAction func btnSort(_ sender: Any) {
        let alert = UIAlertController(title: "Urutkan Berdasarkan ", message: nil , preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "ID", style: .default, handler: {ACTION in
            self.JenisHewans.sort(by: {$0.id_jenishewan.localizedStandardCompare($1.id_jenishewan) == .orderedAscending})
            self.JenisHewanColl.reloadData()
            self.sortBy.text = "ID"
        }))
        
        alert.addAction(UIAlertAction(title: "Nama", style: .default, handler: {ACTION in
            self.JenisHewans.sort(by: { $0.jenishewan < $1.jenishewan })
            self.JenisHewanColl.reloadData()
            self.sortBy.text = "Nama"
        }))
        
        alert.addAction(UIAlertAction(title: "Ketersediaan", style: .default, handler: {ACTION in
            self.JenisHewans.sort(by: { $0.delete_at_jhewan < $1.delete_at_jhewan })
            self.JenisHewanColl.reloadData()
            self.sortBy.text = "Ketersediaan"
        }))
        self.present(alert, animated: true)
    }
    
    
    override func viewDidLoad() {
        getJson(urlString: URL_JSON)
        self.JenisHewanColl.delegate = self
        self.JenisHewanColl.dataSource = self
        self.JenisHewanColl.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshJenisHewan(_:)), for: .valueChanged)
        
        self.sortBy.text = "Ketersediaan"
        searchActive = false
        searchBarLayanan.delegate = self
        searchBarLayanan.showsCancelButton = true
        searchBarLayanan.placeholder = "Cari Jenis Hewan"
        
        definesPresentationContext = true
        
        
        self.navigationItem.titleView = searchBarLayanan
    
        addShadowBtn(b: outletSort)
        addShadow(v: JenisHewanColl)
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @objc private func refreshJenisHewan(_ sender: Any) {
        DispatchQueue.main.async(execute: {
            self.JenisHewans.removeAll()
            self.getJson(urlString: self.URL_JSON)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchActive {
            return filtered.count
        }
        else
        {
            return JenisHewans.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! JenisHewanCollection
        let data: JenisHewan
        if searchActive {
          data = filtered[indexPath.row]
        } else {
          data = JenisHewans[indexPath.row]
        }
        
        cell.namaJenisHewan.text = data.jenishewan
        cell.labelId.text = "ID Jenis Hewan : " + data.id_jenishewan
        if data.delete_at_jhewan == "0000-00-00 00:00:00" {
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ViewJenishewanSegue", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewJenishewanSegue"{
            guard let VC = segue.destination as? ViewJenishewan else {return}
            let indexPath = sender as! IndexPath
            if(filtered.count > 0){
                let JS = self.filtered[indexPath.row]
                VC.Jenishewans = JS
            }else{
                let JS = self.JenisHewans[indexPath.row]
                VC.Jenishewans = JS
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarLayanan.resignFirstResponder()
        searchActive = false;
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar == searchBarLayanan {
            self.filtered = self.JenisHewans.filter { (data: JenisHewan) -> Bool in
                return data.jenishewan.lowercased().contains(searchBar.text!.lowercased()) ||
                    data.id_jenishewan.lowercased().contains(searchBar.text!.lowercased())
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
            self.JenisHewanColl.reloadData()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText == ""{
            self.searchActive = false
            self.JenisHewanColl.reloadData()
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
                        
                        let Jenis = jsonObject["Data"] as? [AnyObject]
                        for obj in Jenis! {
                            let j = JenisHewan(json: obj as! [String:Any])
                            self.JenisHewans.append(j)
                            self.JenisHewans.sort(by: { $0.delete_at_jhewan < $1.delete_at_jhewan })
                        }
                        
                        DispatchQueue.main.async(execute: {
                            self.JenisHewanColl.reloadData()
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

