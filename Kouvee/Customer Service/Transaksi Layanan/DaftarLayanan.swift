//
//  FetchLayanan.swift
//  Kouvee
//
//  Created by Ryan Octavius on 30/04/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import UIKit
import Alamofire
class DaftarLayanan: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{
    
    @IBOutlet weak var searchBarLayanan: UISearchBar!
    @IBOutlet weak var outletCart: UIButton!
    @IBOutlet weak var LayananColl: UICollectionView!
    @IBOutlet weak var sortBy: UILabel!
    
    
    let reuseIdentifier = "layananAdminCell"
    var TransaksiL : TransaksiLayanan?
    var DetilL = [DetilTransaksiLayanan]()
    var DetilFilter = [DetilTransaksiLayanan]()
    var Layanans = [Layanan]()
    let URL_JSON = "http://kouvee.xyz/index.php/Layanan"
    let URL_Detil = "http://kouvee.xyz/index.php/DetilTransaksiLayanan/"
    let URL_Post = "http://kouvee.xyz/index.php/DetilTransaksiLayanan"
    let URL_Trans = "http://kouvee.xyz/index.php/TransaksiLayanan/"
    private let refreshControl = UIRefreshControl()
    var qty : Int = 0
    var Total : Int = 0
    var request: Alamofire.Request? {
        didSet {
                //oldValue?.cancel()
        }
    }
    
    var filtered : [Layanan] = []
    var searchActive : Bool = false
    
    var isSearchBarEmpty: Bool {
      return searchBarLayanan.text?.isEmpty ?? true
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        performSegue(withIdentifier: "back", sender: Any?.self)
    }
    
    @IBAction func btnCart(_ sender: Any) {
        performSegue(withIdentifier: "back", sender: Any?.self)
    }
    
    @IBAction func btnAdd(_ sender: Any) {
        performSegue(withIdentifier: "AddLayananSegue", sender: Any?.self)
    }
    
    
    override func viewDidLoad() {
        getJson(urlString: URL_JSON)
        
        self.getTransaksi(urlString: self.URL_Trans + infoTransaksiLayanan.sharedInstance.lastID)
        getDetil()
        self.LayananColl.delegate = self
        self.LayananColl.dataSource = self
        self.LayananColl.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshLayanan(_:)), for: .valueChanged)
        
        searchBarLayanan.showsCancelButton = true
        searchBarLayanan.delegate = self
        searchBarLayanan.placeholder = "Cari Layanan"
        
        definesPresentationContext = true
        
        
        self.navigationItem.titleView = searchBarLayanan
    
        
        addShadow(v: LayananColl)
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @objc private func refreshLayanan(_ sender: Any) {
        DispatchQueue.main.async(execute: {
            self.qty = 0
            self.Total = 0
            self.Layanans.removeAll()
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
        cell.labelId.text = "ID Layanan : " + data.id_layanan
        cell.namaLayanan.text = data.nama_layanan + " " + data.jenis_hewan + " " + data.ukuran
        
        let number = (data.harga_layanan as NSString).floatValue
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.numberStyle = .currency
        let formattedNum = formatter.string(from: number as NSNumber)
        
        cell.hargaLayanan.text = formattedNum!
        addShadowCell(cell: cell)
        
        if data.delete_at_layanan != "0000-00-00 00:00:00"{
            cell.tersedia.text = "Tidak Tersedia"
        }else{
            cell.tersedia.text = ""
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
        if searchBar == searchBarLayanan {
            self.filtered = self.Layanans.filter { (data: Layanan) -> Bool in
                return data.nama_layanan.lowercased().contains(searchBar.text!.lowercased()) ||
                data.jenis_hewan.lowercased().contains(searchBar.text!.lowercased()) ||
                data.ukuran.lowercased().contains(searchBar.text!.lowercased()) ||
                data.id_layanan.lowercased().contains(searchBar.text!.lowercased())
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if filtered.count > 0
        {
            let l = self.filtered[indexPath.row]
            let alert = UIAlertController(title: "Masukkan Jumlah Beli", message: l.nama_layanan + " " + l.jenis_hewan + " " + l.ukuran , preferredStyle: .alert)
            alert.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = ""
                textField.keyboardType = UIKeyboardType.numberPad
            }
            alert.addAction(UIAlertAction(title: "Simpan", style: .default, handler: {ACTION in
                let textFieldJumlah = alert.textFields![0] as UITextField
                for i in self.DetilL {
                    if i.id_layanan == l.id_layanan{
                        textFieldJumlah.placeholder = i.jumlah_detil_layanan
                    }else{
                        
                    }
                }
                self.post(id_layanan: l.id_layanan,
                          jumlah_detil_layanan: textFieldJumlah.text!,
                          id_trans: infoTransaksiLayanan.sharedInstance.lastID)
            }))
            
            alert.addAction(UIAlertAction(title: "Kembali", style: .default, handler: {ACTION in
                
            }))
            
            self.present(alert,animated: true, completion: nil )
            
        }else{
            let l = self.Layanans[indexPath.row]
            let alert = UIAlertController(title: "Masukkan Jumlah Beli", message: l.nama_layanan + " " + l.jenis_hewan + " " + l.ukuran , preferredStyle: .alert)
            alert.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = ""
                textField.keyboardType = UIKeyboardType.numberPad
            }
            
            alert.addAction(UIAlertAction(title: "Simpan", style: .default, handler: {ACTION in
                let textFieldJumlah = alert.textFields![0] as UITextField
                if textFieldJumlah.text == "" || textFieldJumlah.text == "0"{
                    
                }else{
                    for i in self.DetilL {
                        if i.id_layanan == l.id_layanan{
                            textFieldJumlah.placeholder = i.jumlah_detil_layanan
                        }else{
                            
                        }
                    }
                    self.post(id_layanan: l.id_layanan,
                              jumlah_detil_layanan: textFieldJumlah.text!,
                              id_trans: infoTransaksiLayanan.sharedInstance.lastID)
                }
                
            }))
            
            alert.addAction(UIAlertAction(title: "Kembali", style: .default, handler: {ACTION in
                
            }))
            
            self.present(alert,animated: true, completion: nil )
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "back"{
           guard let VC = segue.destination as? ViewTransaksiLayanan else {return}
        self.getTransaksi(urlString: self.URL_Trans + infoTransaksiLayanan.sharedInstance.lastID)
           VC.TransaksiL = self.TransaksiL
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
                        
                        
                        
                        let Layn = jsonObject["Data"] as? [AnyObject]
                        for obj in Layn! {
                            let p = Layanan(json: obj as! [String:Any])
                            if p.delete_at_layanan == "0000-00-00 00:00:00"{
                                self.Layanans.append(p)
                            }
                        }
                        
                        DispatchQueue.main.async(execute: {
                            
                            self.LayananColl.reloadData()
                        })
                    }
                    catch{
                        print("catch error")
                    }
                }
            }
        }.resume()
    }
    
    fileprivate func post(id_layanan: String, jumlah_detil_layanan: String, id_trans: String){
    
    let parameters: [String: Any] = ["id_layanan" :id_layanan,
                                    "jumlah_detil_layanan" : jumlah_detil_layanan,
                                    "id_transaksi_layanan" : id_trans]
    self.request = Alamofire.request(URL_Post, method: .post, parameters: parameters)
        if let request = request as? DataRequest {
            request.responseString { response in
                do{
                    let data = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as! [String: Any]
                    
                    let Message = data["Message"] as! String
                    
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
                                self.qty = 0
                                self.Total = 0
                                self.getDetil()
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
    
    fileprivate func getDetil()
    {
        let url = URL(string: URL_Detil + infoTransaksiLayanan.sharedInstance.lastID)
        URLSession.shared.dataTask(with: url!){
            (data,response,err) in
            if err != nil{
                print("error", err ?? "")
            }
            else{
                if let useable = data{
                    do{
                        let jsonObject = try JSONSerialization.jsonObject(with: useable, options: .mutableContainers) as AnyObject
                        
                        
                        
                        let dl = jsonObject["Data"] as? [AnyObject]
                        if dl == nil{
                            
                        }
                        else{
                            for obj in dl! {
                                let dl = DetilTransaksiLayanan(json: obj as! [String:Any])
                                let quantity = (dl.jumlah_detil_layanan as NSString).integerValue
                                self.qty = self.qty + quantity
                                
                                let intHarga = (dl.harga_layanan as NSString).integerValue
                                let sum = quantity * intHarga
                                self.Total = self.Total + sum
                                self.DetilL.append(dl)
                            }
                            
                            DispatchQueue.main.async {
                                
                                let formatter = NumberFormatter()
                                formatter.locale = Locale(identifier: "id_ID")
                                formatter.numberStyle = .currency
                                let formattedNum = formatter.string(from: self.Total as NSNumber)
                                
                                let title = " \(self.qty) Item " + " - " + formattedNum!
                                self.outletCart.setTitle(title, for: .normal)
                                self.outletCart.layer.cornerRadius = 5
                                self.outletCart.layer.shouldRasterize = true
                                self.outletCart.layer.rasterizationScale = true ? UIScreen.main.scale : 1
                                
                                print("\(self.Total)")
                            }
                        }
                        
                        
                    }
                    catch{
                        print("catch error")
                    }
                }
            }
        }.resume()
    }
    

    fileprivate func getTransaksi(urlString: String)
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
                        
                        let tl = jsonObject["Data"] as? [AnyObject]
                        for obj in tl! {
                            let tl = TransaksiLayanan(json: obj as! [String:Any])
                            self.TransaksiL = tl
                        }
                    }
                    catch{
                        print("catch error")
                    }
                }
            }
        }.resume()
    }

}
