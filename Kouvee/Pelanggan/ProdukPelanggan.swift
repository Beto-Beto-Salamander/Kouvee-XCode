//
//  ProdukPelanggan.swift
//  Kouvee
//
//  Created by Ryan Octavius on 24/03/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import UIKit

class ProdukPelanggan: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate{
 

    @IBOutlet weak var searchProdukPelanggan: UISearchBar!
    
    @IBOutlet weak var outletSort: UIButton!
    @IBOutlet weak var ProdukColl: UICollectionView!
    @IBOutlet weak var sortBy: UILabel!
    
    
    let reuseIdentifier = "produkPelangganCell"
    var Produkss = [Produk]()
    var Produks = [Produk]()
    var filtered : [Produk] = []
    var searchActive : Bool = false
    
    var isSearchBarEmpty: Bool {
      return searchProdukPelanggan.text?.isEmpty ?? true
    }
    
    private let refreshControl = UIRefreshControl()
    
    let URL_JSON = "http://kouvee.xyz/index.php/Produk"
    @IBAction func btnBack(_ sender: Any) {
        performSegue(withIdentifier: "back", sender: Any?.self)
    }
    @IBAction func btnSort(_ sender: Any) {
        let alert = UIAlertController(title: "Urutkan Berdasarkan ", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Nama", style: .default, handler: {ACTION in
            self.Produks.sort(by: { $0.nama_produk.lowercased() < $1.nama_produk.lowercased() })
            self.ProdukColl.reloadData()
             self.sortBy.text = "Nama"
        }))
        
        alert.addAction(UIAlertAction(title: "Harga ( Kecil - Besar )", style: .default, handler: {ACTION in
            self.Produks.sort(by: {$0.harga_jual.localizedStandardCompare($1.harga_jual) == .orderedAscending})
            self.ProdukColl.reloadData()
            self.sortBy.text = "Harga ( Kecil - Besar )"
        }))
        
        alert.addAction(UIAlertAction(title: "Harga ( Besar - Kecil )", style: .default, handler: {ACTION in
            self.Produks.sort(by: {$0.harga_jual.localizedStandardCompare($1.harga_jual) == .orderedDescending})
            self.ProdukColl.reloadData()
             self.sortBy.text = "Harga ( Besar - Kecil )"
        }))
        
        alert.addAction(UIAlertAction(title: "Jumlah ( Sedikit - Banyak )", style: .default, handler: {ACTION in
            self.Produks.sort(by: {$0.stock.localizedStandardCompare($1.stock) == .orderedAscending})
            self.ProdukColl.reloadData()
             self.sortBy.text = "Jumlah ( Sedikit - Banyak )"
        }))
        
        alert.addAction(UIAlertAction(title: "Jumlah ( Banyak - Sedikit )", style: .default, handler: {ACTION in
            self.Produks.sort(by: {$0.stock.localizedStandardCompare($1.stock) == .orderedDescending})
            self.ProdukColl.reloadData()
            self.sortBy.text = "Jumlah ( Banyak - Sedikit )"
        }))
        
        alert.addAction(UIAlertAction(title: "Ketersediaan", style: .default, handler: {ACTION in
            self.Produks.sort(by: { $0.delete_at_produk < $1.delete_at_produk })
            self.ProdukColl.reloadData()
             self.sortBy.text = "Ketersediaan"
        }))
        
        self.present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        getJson(urlString: URL_JSON)
        self.ProdukColl.delegate = self
        self.ProdukColl.dataSource = self
        self.ProdukColl.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshProduk(_:)), for: .valueChanged)
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        searchActive = false
        searchProdukPelanggan.delegate = self
        searchProdukPelanggan.showsCancelButton = true
        searchProdukPelanggan.placeholder = "Cari Produk"
        
        definesPresentationContext = true
        
        
        self.navigationItem.titleView = searchProdukPelanggan
        
        addShadowBtn(b: outletSort)
        addShadow(v: ProdukColl)
        
        self.sortBy.text = "Ketersediaan"
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapOccured(tap:)))
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    
    @objc func tapOccured(tap: UITapGestureRecognizer){
        searchProdukPelanggan.endEditing(true)
        searchActive = false
    }
    
    @objc private func refreshProduk(_ sender: Any) {
        DispatchQueue.main.async(execute: {
            self.Produks.removeAll()
            self.getJson(urlString: self.URL_JSON)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchActive {
            return filtered.count
        }
        else
        {
            return Produks.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! ProdukCollection
        let data: Produk
        if searchActive {
          data = filtered[indexPath.row]
        } else {
          data = Produks[indexPath.row]
        }
        if data.gambar == "DogFood"{
            cell.imgProdukPelanggan.image = UIImage(named: "DogFood")
        }else{
            let downloadURL = NSURL(string: data.gambar)!
            cell.imgProdukPelanggan.af_setImage(withURL: downloadURL as URL)
        }
        
        cell.namaProdukPelanggan.text = data.nama_produk
        
        let number = (data.harga_jual as NSString).floatValue
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.numberStyle = .currency
        let formattedNum = formatter.string(from: number as NSNumber)
        
        cell.hargaProdukPelanggan.text = formattedNum!
        cell.stockProdukPelanggan.text = "Stock : " + data.stock
        cell.imgProdukPelanggan.layer.cornerRadius = 10
        cell.imgProdukPelanggan.clipsToBounds = true
        let intMin = (data.min_stock as NSString).floatValue
        let intStock = (data.stock as NSString).floatValue
        
        if intStock <= intMin{
            cell.stok.text = "Barang Hampir Habis"
        }else{
            cell.stok.text = ""
        }
        
        if data.delete_at_produk == "0000-00-00 00:00:00" {
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
            return 10
        }
    
    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  50
        let collectionViewSize = ProdukColl.frame.size.width - padding

        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
    }*/
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchProdukPelanggan.resignFirstResponder()
        searchActive = false;
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar == searchProdukPelanggan {
            self.filtered = self.Produks.filter { (data: Produk) -> Bool in
                return data.nama_produk.lowercased().contains(searchBar.text!.lowercased())
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
            self.ProdukColl.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            self.searchActive = false
            self.ProdukColl.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
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
                        
                        let Prod = jsonObject["Data"] as? [AnyObject]
                        for pro in Prod! {
                            let p = Produk(json: pro as! [String:Any])
                            if p.gambar == p.nama_produk + ".jpg" {
                                p.gambar = "http://kouvee.xyz/upload/produk/" + p.nama_produk + ".jpg"
                                print(p.gambar)
                            }else{
                                p.gambar = "DogFood"
                            }
                            self.Produks.append(p)
                        }
                        
                        DispatchQueue.main.async(execute: {
                            self.Produkss = self.Produks
                            self.ProdukColl.reloadData()
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
    

}
