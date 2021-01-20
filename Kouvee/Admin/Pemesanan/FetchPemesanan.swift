//
//  FetchPemesanan.swift
//  Kouvee
//
//  Created by Ryan Octavius on 22/05/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import UIKit
import Alamofire
class FetchPemesanan: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{
    
    @IBOutlet weak var searchBarLayanan: UISearchBar!
    @IBOutlet weak var outletSort: UIButton!
    @IBOutlet weak var PemesananColl: UICollectionView!
    @IBOutlet weak var sortBy: UILabel!
    
    var request: Alamofire.Request? {
        didSet {
            //oldValue?.cancel()
        }
    }
    
    let reuseIdentifier = "pemesananCell"
    var Pengadaan = [Pemesanan]()
    let URL_JSON = "http://kouvee.xyz/index.php/Pemesanan"
   private let refreshControl = UIRefreshControl()
    let URL_DELETE = "http://kouvee.xyz/index.php/Pemesanan/"
    
    var filtered : [Pemesanan] = []
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
            self.Pengadaan.sort(by: {$0.indeks.localizedStandardCompare($1.indeks) == .orderedDescending})
            self.PemesananColl.reloadData()
            self.sortBy.text = "Terbaru"
        }))
        
        alert.addAction(UIAlertAction(title: "ID", style: .default, handler: {ACTION in
            self.Pengadaan.sort(by: {$0.id_pemesanan.localizedStandardCompare($1.id_pemesanan) == .orderedAscending})
            self.PemesananColl.reloadData()
            self.sortBy.text = "ID"
        }))
        
        alert.addAction(UIAlertAction(title: "Status", style: .default, handler: {ACTION in
            self.Pengadaan.sort(by: {$0.status_pemesanan.localizedStandardCompare($1.status_pemesanan) == .orderedAscending})
            self.PemesananColl.reloadData()
            self.sortBy.text = "Status"
        }))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func btnAdd(_ sender: Any) {
        performSegue(withIdentifier: "pilihSupplierSegue", sender: Any?.self)
    }
    
    
    override func viewDidLoad() {
        getJson(urlString: URL_JSON)
        self.sortBy.text = ""
        self.PemesananColl.delegate = self
        self.PemesananColl.dataSource = self
        self.PemesananColl.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshTransaksiProduk(_:)), for: .valueChanged)
        
        searchActive = false
        searchBarLayanan.delegate = self
        searchBarLayanan.showsCancelButton = true
        searchBarLayanan.placeholder = "Cari Pemesanan"
        
        definesPresentationContext = true
        
        
        self.navigationItem.titleView = searchBarLayanan
    
        addShadowBtn(b: outletSort)
        addShadow(v: PemesananColl)
        
            // Do any additional setup after loading the view.
        }
    
    
    @objc private func refreshTransaksiProduk(_ sender: Any) {
        DispatchQueue.main.async {
            self.Pengadaan.removeAll()
            self.viewDidLoad()
            self.sortBy.text = ""
            self.refreshControl.endRefreshing()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchActive {
            return filtered.count
        }
        else
        {
            return Pengadaan.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! PemesananCollection
        let data: Pemesanan
        if searchActive {
          data = filtered[indexPath.row]
        } else {
          data = Pengadaan[indexPath.row]
        }
        
        let number = (data.total as NSString).floatValue
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.numberStyle = .currency
        let formattedNum = formatter.string(from: number as NSNumber)
        
        cell.labelSupplier.text = data.nama_supplier
        cell.labelID.text = "ID #" + data.id_pemesanan
        cell.labelTanggal.text = data.tanggal_pemesanan
        cell.labelTotal.text = formattedNum!
        
        if data.status_pemesanan == "0"{
            cell.labelStatus.text = "Belum Selesai"
            cell.labelStatus.textColor = UIColor.systemRed
        }else{
            cell.labelStatus.text = "Selesai"
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
            self.filtered = self.Pengadaan.filter { (data: Pemesanan) -> Bool in
                return data.id_pemesanan.lowercased().contains(searchBar.text!.lowercased()) ||
                    data.tanggal_pemesanan.lowercased().contains(searchBar.text!.lowercased())
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
            self.PemesananColl.reloadData()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText == ""{
            self.searchActive = false
            self.PemesananColl.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Pilih Aksi", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Lihat Detil", style: .default, handler: {(UIAlertAction) in
            self.performSegue(withIdentifier: "lihatDetailPemesanan", sender: indexPath)
        }))
        alert.addAction(UIAlertAction(title: "Hapus", style: .destructive, handler: {(UIAlertAction) in
            
            let alert = UIAlertController(title: "Yakin Ingin Menghapus? ", message: nil, preferredStyle: .alert)
            alert.addAction(UIKit.UIAlertAction(title: "Ya", style: .default, handler: {(UIAlertAction) in
                      if(self.filtered.count > 0){
                          let P = self.filtered[indexPath.row]
                          self.delete(urlDel: self.URL_DELETE + P.id_pemesanan)
                      }else{
                          let P = self.Pengadaan[indexPath.row]
                          self.delete(urlDel: self.URL_DELETE + P.id_pemesanan)
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
        if segue.identifier == "lihatDetailPemesanan"{
            guard let VC = segue.destination as? ViewPemesanan else {return}
            let indexPath = sender as! IndexPath
            if(filtered.count > 0){
                let P = filtered[indexPath.row]
                infoPemesanan.sharedInstance.lastID = P.id_pemesanan
                VC.Pengadaan = P
            }else{
                let P = Pengadaan[indexPath.row]
                infoPemesanan.sharedInstance.lastID = P.id_pemesanan
                VC.Pengadaan = P
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
                        
                        
                        
                        let P = jsonObject["Data"] as? [AnyObject]
                        for obj in P! {
                            let p = Pemesanan(json: obj as! [String:Any])
                            self.Pengadaan.append(p)
                            self.Pengadaan.sort(by: {$0.indeks.localizedStandardCompare($1.indeks) == .orderedDescending})
                            
                        }
                        self.setView()
                    }
                    catch{
                        print("catch error")
                    }
                }
            }
        }.resume()
    }
    
    func setView(){
        DispatchQueue.main.async {
            self.sortBy.text = ""
            self.PemesananColl.reloadData()
        }
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
