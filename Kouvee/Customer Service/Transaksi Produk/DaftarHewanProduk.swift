//
//  DaftarHewan.swift
//  Kouvee
//
//  Created by Ryan Octavius on 24/04/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import UIKit
import Alamofire
class DaftarHewanProduk: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{
    
    @IBOutlet weak var searchBarLayanan: UISearchBar!
    @IBOutlet weak var outletSort: UIButton!
    @IBOutlet weak var HewanColl: UICollectionView!
    @IBOutlet weak var sortBy: UILabel!
    
    var request: Alamofire.Request? {
        didSet {
                //oldValue?.cancel()
        }
    }
    var Hewans = [Hewan]()
    var filtered : [Hewan] = []
    var TransaksiP = [TransaksiProduk]()
    var searchActive : Bool = false
    var isSearchBarEmpty: Bool {
      return searchBarLayanan.text?.isEmpty ?? true
    }
    
    let URL_JSON = "http://kouvee.xyz/index.php/Hewan"
    let URL_Transaksi = "http://kouvee.xyz/index.php/TransaksiProduk"
    let reuseIdentifier = "hewanCSCell"
    private let refreshControl = UIRefreshControl()
    
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
        Info.sharedInstance.status = "produk"
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
            self.viewDidLoad()
            self.refreshControl.endRefreshing()
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
        if(filtered.count > 0){
            let Hewan = filtered[indexPath.row]
            infoTransaksiProduk.sharedInstance.id_hewan = Hewan.id_hewan
            infoTransaksiProduk.sharedInstance.nama_hewan = Hewan.nama_hewan
            infoTransaksiProduk.sharedInstance.id_pelanggan = Hewan.id_pelanggan
            infoTransaksiProduk.sharedInstance.nama_pelanggan = Hewan.nama_pelanggan
            infoTransaksiProduk.sharedInstance.id_pegawai = Info.sharedInstance.id_pegawai
            infoTransaksiProduk.sharedInstance.nama_pegawai = Info.sharedInstance.nama_pegawai
            self.post()
            
        }else{
            let Hewan = Hewans[indexPath.row]
            infoTransaksiProduk.sharedInstance.id_hewan = Hewan.id_hewan
            infoTransaksiProduk.sharedInstance.nama_hewan = Hewan.nama_hewan
            infoTransaksiProduk.sharedInstance.id_pelanggan = Hewan.id_pelanggan
            infoTransaksiProduk.sharedInstance.nama_pelanggan = Hewan.nama_pelanggan
            infoTransaksiProduk.sharedInstance.id_pegawai = Info.sharedInstance.id_pegawai
            infoTransaksiProduk.sharedInstance.nama_pegawai = Info.sharedInstance.nama_pegawai
            self.post()
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
                        
                        
                        
                        let Pet = jsonObject["Data"] as? [AnyObject]
                        for obj in Pet! {
                            let p = Hewan(json: obj as! [String:Any])
                            if p.delete_at_hewan == "0000-00-00 00:00:00"{
                                self.Hewans.append(p)
                            }
                            self.Hewans.sort(by: { $0.delete_at_hewan < $1.delete_at_hewan })
                            
                        }
                        
                        DispatchQueue.main.async(execute: {
                            self.HewanColl.reloadData()
                            self.sortBy.text = ""
                            
                        })
                    }
                    catch{
                        print("catch error")
                    }
                }
            }
        }.resume()
    }
    
    fileprivate func post(){
    
        let parameters: [String: Any] = ["id_pegawai" :infoTransaksiProduk.sharedInstance.id_pegawai,
                                    "id_hewan" : infoTransaksiProduk.sharedInstance.id_hewan,
                                    "peg_id_pegawai" : "4"]
    
    self.request = Alamofire.request(URL_Transaksi, method: .post, parameters: parameters)
        if let request = request as? DataRequest {
            request.responseString { response in
                do{
                    let data = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as! [String: Any]
                    let Message = data["Message"] as! String
                    print(data)
                    if Message != "Berhasil Menambahkan Data" {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Gagal Menambahkan Data Transaksi", message: "Periksa Kembali Masukkan", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: nil))
                            self.present(alert,animated: true, completion: nil )
                            }
                    }else if Message == "Berhasil Menambahkan Data" {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Berhasil Menambahkan Data Transaksi", message: nil, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: {(UIAlertAction) in
                                self.get()
                                self.performSegue(withIdentifier: "back", sender: Any?.self)
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
    
    fileprivate func get()
    {
        let url = URL(string: URL_Transaksi)
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
                        
                        let tp = jsonObject["Data"] as? [AnyObject]
                        for obj in tp! {
                            let tp = TransaksiProduk(json: obj as! [String:Any])
                            self.TransaksiP.append(tp)
                        }
                        self.TransaksiP.sort(by: {$0.indeks.localizedStandardCompare($1.indeks) == .orderedDescending})
                        infoTransaksiProduk.sharedInstance.lastID = self.TransaksiP[0].id_transaksi_produk
                        print("lllllll",infoTransaksiProduk.sharedInstance.lastID)
                    }
                    catch{
                        print("catch error")
                    }
                }
            }
        }.resume()
    }

}
