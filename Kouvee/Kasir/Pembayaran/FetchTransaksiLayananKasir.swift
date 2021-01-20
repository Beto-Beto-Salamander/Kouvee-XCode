//
//  PembayaranLayanan.swift
//  Kouvee
//
//  Created by Ryan Octavius on 15/06/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import UIKit
import Alamofire
class FetchTransaksiLayananKasir: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{
    
    @IBOutlet weak var searchBarLayanan: UISearchBar!
    @IBOutlet weak var outletSort: UIButton!
    @IBOutlet weak var transaksiLayananColl: UICollectionView!
    @IBOutlet weak var sortBy: UILabel!
    var request: Alamofire.Request? {
        didSet {
            //oldValue?.cancel()
        }
    }
    
    let reuseIdentifier = "transaksiLayananCell"
    var TransaksiL = [TransaksiLayanan]()
    let URL_JSON = "http://kouvee.xyz/index.php/TransaksiLayanan"
    let URL_DELETE = "http://kouvee.xyz/index.php/TransaksiLayanan/"
    private let refreshControl = UIRefreshControl()
    
    var filtered : [TransaksiLayanan] = []
    var searchActive : Bool = false
    
    var isSearchBarEmpty: Bool {
      return searchBarLayanan.text?.isEmpty ?? true
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        performSegue(withIdentifier:"back", sender: Any?.self)
    }
    
    @IBAction func btnSort(_ sender: Any) {
        let alert = UIAlertController(title: "Urutkan Berdasarkan ", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Terbaru", style: .default, handler: {ACTION in
            self.TransaksiL.sort(by: {$0.indeks.localizedStandardCompare($1.indeks) == .orderedDescending})
            self.transaksiLayananColl.reloadData()
            self.sortBy.text = "Terbaru"
        }))
        
        alert.addAction(UIAlertAction(title: "ID", style: .default, handler: {ACTION in
            self.TransaksiL.sort(by: {$0.id_transaksi_layanan.localizedStandardCompare($1.id_transaksi_layanan) == .orderedAscending})
            self.transaksiLayananColl.reloadData()
            self.sortBy.text = "ID"
        }))
        
        alert.addAction(UIAlertAction(title: "Status", style: .default, handler: {ACTION in
            self.TransaksiL.sort(by: {$0.status_layanan.localizedStandardCompare($1.status_layanan) == .orderedAscending})
            self.transaksiLayananColl.reloadData()
            self.sortBy.text = "Status"
        }))
        
        alert.addAction(UIAlertAction(title: "Progres", style: .default, handler: {ACTION in
            self.TransaksiL.sort(by: {$0.progres_layanan.localizedStandardCompare($1.progres_layanan) == .orderedAscending})
            self.transaksiLayananColl.reloadData()
            self.sortBy.text = "Progres"
        }))
        self.present(alert, animated: true)
    }
    
    @IBAction func btnAdd(_ sender: Any) {
        performSegue(withIdentifier: "pilihHewanSegue", sender: Any?.self)
    }
    
    
    override func viewDidLoad() {
        getJson(urlString: URL_JSON)
        self.sortBy.text = ""
        self.transaksiLayananColl.delegate = self
        self.transaksiLayananColl.dataSource = self
        self.transaksiLayananColl.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshTransaksiProduk(_:)), for: .valueChanged)
       
        searchActive = false
        searchBarLayanan.delegate = self
        searchBarLayanan.showsCancelButton = true
        searchBarLayanan.placeholder = "Cari Transaksi Layanan"
        
        definesPresentationContext = true
        
        
        self.navigationItem.titleView = searchBarLayanan
    
        addShadowBtn(b: outletSort)
        addShadow(v: transaksiLayananColl)
        
            // Do any additional setup after loading the view.
        }
    
    
    @objc private func refreshTransaksiProduk(_ sender: Any) {
        DispatchQueue.main.async(execute: {
            self.TransaksiL.removeAll()
            self.viewDidLoad()
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
            return TransaksiL.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! TransaksiLayananCollection
        let data: TransaksiLayanan
        if searchActive {
          data = filtered[indexPath.row]
        } else {
          data = TransaksiL[indexPath.row]
        }
        
        let number = (data.total_transaksi_layanan as NSString).floatValue
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.numberStyle = .currency
        let formattedNum = formatter.string(from: number as NSNumber)
        
        let number2 = (data.diskon_layanan as NSString).floatValue
        let formatter2 = NumberFormatter()
        formatter2.locale = Locale(identifier: "id_ID")
        formatter2.numberStyle = .currency
        let formattedNum2 = formatter2.string(from: number2 as NSNumber)
        
        cell.labelID.text = "ID #" + data.id_transaksi_layanan
        cell.labelTanggal.text = data.tgl_transaksi_layanan
        cell.labelTotal.text = formattedNum!
        cell.labelDiskon.text = formattedNum2!
    
        
        
        if data.progres_layanan == "0"{
            cell.labelProgres.text = "Belum Selesai"
            cell.labelProgres.backgroundColor = UIColor.systemRed
        }else{
            cell.labelProgres.text = "Selesai"
            cell.labelProgres.backgroundColor = UIColor.systemGreen
        }
        
        if data.status_layanan == "0"{
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
            self.filtered = self.TransaksiL.filter { (data: TransaksiLayanan) -> Bool in
                return data.id_transaksi_layanan.lowercased().contains(searchBar.text!.lowercased()) ||
                    data.tgl_transaksi_layanan.lowercased().contains(searchBar.text!.lowercased())
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
            self.transaksiLayananColl.reloadData()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText == ""{
            self.searchActive = false
            self.transaksiLayananColl.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Pilih Aksi", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Lihat Detil", style: .default, handler: {(UIAlertAction) in
            
            self.performSegue(withIdentifier: "lihatDetailLayanan", sender: indexPath)
        }))
        alert.addAction(UIAlertAction(title: "Hapus", style: .destructive, handler: {(UIAlertAction) in
            let alert = UIAlertController(title: "Yakin Ingin Menghapus? ", message: nil, preferredStyle: .alert)
            alert.addAction(UIKit.UIAlertAction(title: "Ya", style: .default, handler: {(UIAlertAction) in
                      if(self.filtered.count > 0){
                          let TL = self.filtered[indexPath.row]
                          self.delete(urlDel: self.URL_DELETE + TL.id_transaksi_layanan)
                      }else{
                          let TL = self.TransaksiL[indexPath.row]
                          self.delete(urlDel: self.URL_DELETE + TL.id_transaksi_layanan)
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
        if segue.identifier == "lihatDetailLayanan"{
            guard let VC = segue.destination as? ViewTransaksiLayananKasir else {return}
            let indexPath = sender as! IndexPath
            if(filtered.count > 0){
                let TL = filtered[indexPath.row]
                infoTransaksiLayanan.sharedInstance.lastID = TL.id_transaksi_layanan
               VC.TransaksiL = TL
            }else{
                let TL = TransaksiL[indexPath.row]
                infoTransaksiLayanan.sharedInstance.lastID = TL.id_transaksi_layanan
               VC.TransaksiL = TL
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
                        
                       
                        
                        let TL = jsonObject["Data"] as? [AnyObject]
                        for obj in TL! {
                            let tl = TransaksiLayanan(json: obj as! [String:Any])
                            self.TransaksiL.append(tl)
                            self.TransaksiL.sort(by: {$0.indeks.localizedStandardCompare($1.indeks) == .orderedDescending})
                        }
                        DispatchQueue.main.async(execute: {
                            self.sortBy.text = ""
                            self.transaksiLayananColl.reloadData()
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
