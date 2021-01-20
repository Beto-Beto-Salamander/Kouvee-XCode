//
//  LayananPelanggan.swift
//  Kouvee
//
//  Created by Ryan Octavius on 24/03/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import UIKit
class LayananPelanggan: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{
    
    @IBOutlet weak var searchBarLayanan: UISearchBar!
    @IBOutlet weak var outletSort: UIButton!
    @IBOutlet weak var LayananColl: UICollectionView!
    @IBOutlet weak var sortBy: UILabel!
    
    
    let reuseIdentifier = "layananPelangganCell"
    var Layanans = [Layanan]()
    let URL_JSON = "http://kouvee.xyz/index.php/Layanan"
   private let refreshControl = UIRefreshControl()
    
    var filtered : [Layanan] = []
    var searchActive : Bool = false
    
    var isSearchBarEmpty: Bool {
      return searchBarLayanan.text?.isEmpty ?? true
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        performSegue(withIdentifier: "back", sender: Any?.self)
    }
    
    @IBAction func btnSort(_ sender: Any) {
        let alert = UIAlertController(title: "Urutkan Berdasarkan ", message: nil, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Nama", style: .default, handler: {ACTION in
            self.Layanans.sort(by: { $0.nama_layanan.lowercased() < $1.nama_layanan.lowercased() })
            self.LayananColl.reloadData()
            self.sortBy.text = "Nama"
        }))
        
        alert.addAction(UIAlertAction(title: "Harga ( Kecil - Besar )", style: .default, handler: {ACTION in
            self.Layanans.sort(by: {$0.harga_layanan.localizedStandardCompare($1.harga_layanan) == .orderedAscending})
            self.LayananColl.reloadData()
            self.sortBy.text = "Harga ( Kecil - Besar )"
        }))
        
        alert.addAction(UIAlertAction(title: "Harga ( Besar - Kecil )", style: .default, handler: {ACTION in
            self.Layanans.sort(by: {$0.harga_layanan.localizedStandardCompare($1.harga_layanan) == .orderedDescending})
            self.LayananColl.reloadData()
            self.sortBy.text = "Harga ( Besar - Kecil )"
        }))
        
        alert.addAction(UIAlertAction(title: "Ketersediaan", style: .default, handler: {ACTION in
            self.Layanans.sort(by: { $0.delete_at_layanan < $1.delete_at_layanan })
            self.LayananColl.reloadData()
            self.sortBy.text = "Ketersediaan"
        }))
        self.present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        getJson(urlString: URL_JSON)
        self.LayananColl.delegate = self
        self.LayananColl.dataSource = self
        self.LayananColl.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshLayanan(_:)), for: .valueChanged)
        
        self.sortBy.text = "Ketersediaan"
        searchActive = false
        searchBarLayanan.delegate = self
        searchBarLayanan.showsCancelButton = true
        searchBarLayanan.placeholder = "Cari Layanan"
        
        definesPresentationContext = true
        
        
        self.navigationItem.titleView = searchBarLayanan
    
        addShadowBtn(b: outletSort)
        addShadow(v: LayananColl)
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapOccured(tap:)))
            view.addGestureRecognizer(tap)

            // Do any additional setup after loading the view.
    }
        
    @objc func tapOccured(tap: UITapGestureRecognizer){
            searchBarLayanan.endEditing(true)
            searchActive = false
    }
    
    @objc private func refreshLayanan(_ sender: Any) {
        self.Layanans.removeAll()
        
        DispatchQueue.main.async(execute: {
            self.getJson(urlString: self.URL_JSON)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchActive {
            return filtered.count
        }
        else
        {
            return Layanans.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! LayananCollection
        let data: Layanan
        if searchActive {
          data = filtered[indexPath.row]
        } else {
          data = Layanans[indexPath.row]
        }
        cell.namaLayanan.text = data.nama_layanan + " " + data.jenis_hewan + " " + data.ukuran
        
        let number = (data.harga_layanan as NSString).floatValue
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.numberStyle = .currency
        let formattedNum = formatter.string(from: number as NSNumber)
        
        cell.hargaLayanan.text = formattedNum
        if data.delete_at_layanan == "0000-00-00 00:00:00" {
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
        if searchBar == searchBarLayanan {
            self.filtered = self.Layanans.filter { (data: Layanan) -> Bool in
                return data.nama_layanan.lowercased().contains(searchBar.text!.lowercased()) || data.jenis_hewan.lowercased().contains(searchBar.text!.lowercased()) ||
                    data.ukuran.lowercased().contains(searchBar.text!.lowercased())
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
            self.LayananColl.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            self.searchActive = false
            self.LayananColl.reloadData()
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
                        
                        let Layn = jsonObject["Data"] as? [AnyObject]
                        for obj in Layn! {
                            let p = Layanan(json: obj as! [String:Any])
                            self.Layanans.append(p)
                            self.Layanans.sort(by: { $0.delete_at_layanan < $1.delete_at_layanan })
                        }
                        
                        DispatchQueue.main.async(execute: {
                            self.LayananColl.reloadData()
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
