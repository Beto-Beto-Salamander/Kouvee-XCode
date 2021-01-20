//
//  FetchHewan.swift
//  Kouvee
//
//  Created by Ryan Octavius on 08/04/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import UIKit

class FetchHewan: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{
    
    @IBOutlet weak var searchBarLayanan: UISearchBar!
    @IBOutlet weak var outletSort: UIButton!
    @IBOutlet weak var HewanColl: UICollectionView!
    @IBOutlet weak var sortBy: UILabel!
    
    
    let reuseIdentifier = "hewanCSCell"
    var Hewans = [Hewan]()
    let URL_JSON = "http://kouvee.xyz/index.php/Hewan"
   private let refreshControl = UIRefreshControl()
    
    var filtered : [Hewan] = []
    var searchActive : Bool = false
    
    var isSearchBarEmpty: Bool {
      return searchBarLayanan.text?.isEmpty ?? true
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        performSegue(withIdentifier: "back", sender: Any?.self)
    }
    
    @IBAction func btnSort(_ sender: Any) {
        let alert = UIAlertController(title: "Urutkan Berdasarkan ", message: nil, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "ID", style: .default, handler: {ACTION in
            self.Hewans.sort(by: {$0.id_hewan.localizedStandardCompare($1.id_hewan) == .orderedAscending})
            self.HewanColl.reloadData()
            self.sortBy.text = "ID"
        }))
        
        alert.addAction(UIAlertAction(title: "Nama Hewan", style: .default, handler: {ACTION in
            self.Hewans.sort(by: { $0.nama_hewan.lowercased() < $1.nama_hewan.lowercased() })
            self.HewanColl.reloadData()
            self.sortBy.text = "Nama Hewan"
        }))
        
        alert.addAction(UIAlertAction(title: "Nama Pelanggan", style: .default, handler: {ACTION in
            self.Hewans.sort(by: { $0.nama_pelanggan.lowercased() < $1.nama_pelanggan.lowercased() })
            self.HewanColl.reloadData()
            self.sortBy.text = "Nama Pelanggan"
        }))
        
        alert.addAction(UIAlertAction(title: "Ketersediaan", style: .default, handler: {ACTION in
            self.Hewans.sort(by: { $0.delete_at_hewan < $1.delete_at_hewan })
            self.HewanColl.reloadData()
            self.sortBy.text = "Ketersediaan"
        }))
        self.present(alert, animated: true)
    }
    
    @IBAction func btnAdd(_ sender: Any) {
        performSegue(withIdentifier: "AddHewanSegue", sender: Any?.self)
    }
    
    
    override func viewDidLoad() {
        getJson(urlString: URL_JSON)
        self.HewanColl.delegate = self
        self.HewanColl.dataSource = self
        self.HewanColl.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshHewan(_:)), for: .valueChanged)
        
        self.sortBy.text = "Ketersediaan"
        searchActive = false
        searchBarLayanan.delegate = self
        searchBarLayanan.showsCancelButton = true
        searchBarLayanan.placeholder = "Cari Hewan"
        
        definesPresentationContext = true
        
        
        self.navigationItem.titleView = searchBarLayanan
    
        addShadowBtn(b: outletSort)
        addShadow(v: HewanColl)
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @objc private func refreshHewan(_ sender: Any) {
        DispatchQueue.main.async(execute: {
            self.Hewans.removeAll()
            self.getJson(urlString: self.URL_JSON)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchActive {
            return filtered.count
        }
        else
        {
            return Hewans.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! HewanCollection
        let data: Hewan
        if searchActive {
          data = filtered[indexPath.row]
        } else {
          data = Hewans[indexPath.row]
        }
        
        cell.labelNama.text = data.nama_hewan
        cell.labelTanggal.text = data.tgl_lahir_hewan
        cell.labelJenis.text = data.jenishewan
        cell.labelPelanggan.text = data.nama_pelanggan
        cell.labelID.text = "ID Hewan: " + data.id_hewan
        addShadowCell(cell: cell)
        
        if data.delete_at_hewan != "0000-00-00 00:00:00"{
            cell.labelTersedia.text = "Tidak Tersedia"
        }else{
            cell.labelTersedia.text = ""
        }
        return cell
    }
    
    func inactive(c: UICollectionViewCell){
        c.layer.backgroundColor = UIColor.lightGray.cgColor
        c.contentView.layer.backgroundColor = UIColor.lightGray.cgColor
        c.contentView.layer.masksToBounds = true
        c.layer.masksToBounds = true
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 10.0
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
        if searchBar == searchBarLayanan  {
            self.filtered = self.Hewans.filter { (data: Hewan) -> Bool in
                return data.nama_hewan.lowercased().contains(searchBar.text!.lowercased()) ||
                    data.nama_pelanggan.lowercased().contains(searchBar.text!.lowercased()) ||
                    data.jenishewan.lowercased().contains(searchBar.text!.lowercased()) ||
                    data.id_hewan.lowercased().contains(searchBar.text!.lowercased())
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
            self.HewanColl.reloadData()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText == ""{
            self.searchActive = false
            self.HewanColl.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ViewHewanSegue", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewHewanSegue"{
            guard let VC = segue.destination as? ViewHewan else {return}
            let indexPath = sender as! IndexPath
            if filtered.count > 0 {
                let Pet = filtered[indexPath.row]
                VC.Hewans = Pet
            }else{
                let Pet = Hewans[indexPath.row]
                VC.Hewans = Pet
            }
            
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
                        
                        let Pet = jsonObject["Data"] as? [AnyObject]
                        for obj in Pet! {
                            let p = Hewan(json: obj as! [String:Any])
                            self.Hewans.append(p)
                            self.Hewans.sort(by: { $0.delete_at_hewan < $1.delete_at_hewan })
                        }
                        
                        DispatchQueue.main.async(execute: {
                            self.HewanColl.reloadData()
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
