//
//  FetchTransaksiProduk.swift
//  Kouvee
//
//  Created by Ryan Octavius on 24/04/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import UIKit
import Alamofire
class FetchTransaksiProduk: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{
    
    @IBOutlet weak var searchBarLayanan: UISearchBar!
    @IBOutlet weak var outletSort: UIButton!
    @IBOutlet weak var transaksiProdukColl: UICollectionView!
    @IBOutlet weak var sortBy: UILabel!
    
    var request: Alamofire.Request? {
        didSet {
            //oldValue?.cancel()
        }
    }
    
    let reuseIdentifier = "transaksiProdukCell"
    var TransaksiP = [TransaksiProduk]()
    let URL_JSON = "http://kouvee.xyz/index.php/TransaksiProduk"
   private let refreshControl = UIRefreshControl()
    let URL_DELETE = "http://kouvee.xyz/index.php/TransaksiProduk/"
    
    var filtered : [TransaksiProduk] = []
    var searchActive : Bool = false
    
    var isSearchBarEmpty: Bool {
      return searchBarLayanan.text?.isEmpty ?? true
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        performSegue(withIdentifier: "back", sender: Any?.self)
    }
    
    @IBAction func btnSort(_ sender: Any) {
        let alert = UIAlertController(title: "Urutkan Berdasarkan ", message: nil, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Terbaru", style: .default, handler: {ACTION in
            self.TransaksiP.sort(by: {$0.indeks.localizedStandardCompare($1.indeks) == .orderedDescending})
            self.transaksiProdukColl.reloadData()
            self.sortBy.text = "Terbaru"
        }))
        
        alert.addAction(UIAlertAction(title: "ID", style: .default, handler: {ACTION in
            self.TransaksiP.sort(by: {$0.id_transaksi_produk.localizedStandardCompare($1.id_transaksi_produk) == .orderedAscending})
            self.transaksiProdukColl.reloadData()
            self.sortBy.text = "ID"
        }))
        
        alert.addAction(UIAlertAction(title: "Status", style: .default, handler: {ACTION in
            self.TransaksiP.sort(by: {$0.status_transaksi_produk.localizedStandardCompare($1.status_transaksi_produk) == .orderedAscending})
            self.transaksiProdukColl.reloadData()
            self.sortBy.text = "Status"
        }))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func btnAdd(_ sender: Any) {
        performSegue(withIdentifier: "pilihHewanSegue", sender: Any?.self)
    }
    
    
    override func viewDidLoad() {
        getJson(urlString: URL_JSON)
        self.sortBy.text = ""
        self.transaksiProdukColl.delegate = self
        self.transaksiProdukColl.dataSource = self
        self.transaksiProdukColl.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshTransaksiProduk(_:)), for: .valueChanged)
        
        searchActive = false
        searchBarLayanan.delegate = self
        searchBarLayanan.showsCancelButton = true
        searchBarLayanan.placeholder = "Cari Transaksi Produk"
        
        definesPresentationContext = true
        
        
        self.navigationItem.titleView = searchBarLayanan
    
        addShadowBtn(b: outletSort)
        addShadow(v: transaksiProdukColl)
        
            // Do any additional setup after loading the view.
        }
    
    
    @objc private func refreshTransaksiProduk(_ sender: Any) {
        DispatchQueue.main.async(execute: {
            print("1")
            self.TransaksiP.removeAll()
            print("2")
            self.viewDidLoad()
            print("3")
            self.sortBy.text = ""
            self.refreshControl.endRefreshing()
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchActive {
            return filtered.count
        }
        else
        {
            return TransaksiP.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! TransaksiProdukCollection
        let data: TransaksiProduk
        if searchActive {
          data = filtered[indexPath.row]
        } else {
          data = TransaksiP[indexPath.row]
        }
        
        let number = (data.total_transaksi_produk as NSString).floatValue
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.numberStyle = .currency
        let formattedNum = formatter.string(from: number as NSNumber)
        
        let number2 = (data.diskon_produk as NSString).floatValue
        let formatter2 = NumberFormatter()
        formatter2.locale = Locale(identifier: "id_ID")
        formatter2.numberStyle = .currency
        let formattedNum2 = formatter2.string(from: number2 as NSNumber)
        
        cell.labelID.text = "ID #" + data.id_transaksi_produk
        cell.labelTanggal.text = data.tgl_transaksi
        cell.labelTotal.text = formattedNum!
        cell.labelDiskon.text = formattedNum2!
        
        
        if data.status_transaksi_produk == "0"{
            cell.labelStatus.text = "Belum Lunas"
            cell.labelStatus.textColor = UIColor.systemRed
        }else{
            cell.labelStatus.text = "Lunas"
            cell.labelStatus.textColor = UIColor.systemGreen
        }
        
        addShadowCell(cell: cell)
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
         cell.contentView.layer.cornerRadius = 5
         cell.contentView.layer.shouldRasterize = true
         cell.contentView.layer.rasterizationScale = true ? UIScreen.main.scale : 1
         cell.contentView.layer.masksToBounds = true
         cell.layer.masksToBounds = true
         cell.layer.cornerRadius = 5
    }
    
    public func addShadow(v: UICollectionView){
        v.layer.cornerRadius = 5
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
            self.filtered = self.TransaksiP.filter { (data: TransaksiProduk) -> Bool in
                return data.id_transaksi_produk.lowercased().contains(searchBar.text!.lowercased()) ||
                    data.tgl_transaksi.lowercased().contains(searchBar.text!.lowercased())
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
            self.transaksiProdukColl.reloadData()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText == ""{
            self.searchActive = false
            self.transaksiProdukColl.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Pilih Aksi", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Lihat Detil", style: .default, handler: {(UIAlertAction) in
            self.performSegue(withIdentifier: "lihatDetailProduk", sender: indexPath)
        }))
        alert.addAction(UIAlertAction(title: "Hapus", style: .destructive, handler: {(UIAlertAction) in
            
            let alert = UIAlertController(title: "Yakin Ingin Menghapus? ", message: nil, preferredStyle: .alert)
            alert.addAction(UIKit.UIAlertAction(title: "Ya", style: .default, handler: {(UIAlertAction) in
                      if(self.filtered.count > 0){
                          let TP = self.filtered[indexPath.row]
                          self.delete(urlDel: self.URL_DELETE + TP.id_transaksi_produk)
                      }else{
                          let TP = self.TransaksiP[indexPath.row]
                          self.delete(urlDel: self.URL_DELETE + TP.id_transaksi_produk)
                      }
            }))
            alert.addAction(UIKit.UIAlertAction(title: "Tidak", style: .destructive, handler: {(UIAlertAction) in
                      
            }))
                
            self.present(alert,animated: true, completion: nil )
            
        }))
        alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: {(UIAlertAction) in
            
        }))
        self.present(alert,animated: true, completion: nil )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "lihatDetailProduk"{
            guard let VC = segue.destination as? ViewTransaksiProduk else {return}
            let indexPath = sender as! IndexPath
            if(filtered.count > 0){
                let TP = filtered[indexPath.row]
                infoTransaksiProduk.sharedInstance.lastID = TP.id_transaksi_produk
                VC.TransaksiP = TP
            }else{
                let TP = TransaksiP[indexPath.row]
                infoTransaksiProduk.sharedInstance.lastID = TP.id_transaksi_produk
                VC.TransaksiP = TP
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
                        
                        
                        
                        let TP = jsonObject["Data"] as? [AnyObject]
                        for obj in TP! {
                            let tp = TransaksiProduk(json: obj as! [String:Any])
                            self.TransaksiP.append(tp)
                            self.TransaksiP.sort(by: {$0.indeks.localizedStandardCompare($1.indeks) == .orderedDescending})
                            
                        }
                        DispatchQueue.main.async(execute: {
                            self.sortBy.text = ""
                            self.transaksiProdukColl.reloadData()
                        })
                    }
                    catch{
                        print("catch error")
                    }
                }
            }
        }.resume()
    }
    
    fileprivate func delete(urlDel : String){
    self.request = Alamofire.request(urlDel, method: .delete, parameters: nil)
        if let request = request as? DataRequest {
            request.responseString { response in
                do{
                    let data = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as! [String: Any]
                    let Message = data["Message"] as! String
                    
                    if Message != "Data Berhasil Di Hapus" {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Gagal Menghapus Data", message: nil, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: nil))
                            self.present(alert,animated: true, completion: nil )
                            }
                    }else if Message == "Data Berhasil Di Hapus" {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: Message, message: nil, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: {(UIAlertAction) in
                            }))
                            self.present(alert,animated: true, completion: nil )
                            }
                    }
                }catch{
                    print(error)
                }
            }
        }

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
