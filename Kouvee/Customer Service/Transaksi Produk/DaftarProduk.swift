//
//  DaftarProduk.swift
//  Kouvee
//
//  Created by Ryan Octavius on 24/04/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
class DaftarProduk: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate{
 
    @IBOutlet weak var searchProdukPelanggan: UISearchBar!
    @IBOutlet weak var ProdukColl: UICollectionView!
    
    @IBOutlet weak var outletCart: UIButton!
    
    
    let reuseIdentifier = "produkAdminCell"
    var TransaksiP : TransaksiProduk?
    var DetilP = [DetilTransaksiProduk]()
    var DetilFilter = [DetilTransaksiProduk]()
    var Produks = [Produk]()
    var filtered : [Produk] = []
    var searchActive : Bool = false
    var end : Bool = false
    var qty : Int = 0
    var Total : Int = 0
    var isSearchBarEmpty: Bool {
      return searchProdukPelanggan.text?.isEmpty ?? true
    }
    
    var request: Alamofire.Request? {
        didSet {
                //oldValue?.cancel()
        }
    }
    
    private let refreshControl = UIRefreshControl()
    
    let URL_JSON = "http://kouvee.xyz/index.php/Produk"
    let URL_Detil = "http://kouvee.xyz/index.php/DetilTransaksiProduk/"
    let URL_Transaksi = "http://kouvee.xyz/index.php/TransaksiProduk/"
    @IBAction func btnBack(_ sender: Any) {
        performSegue(withIdentifier: "back", sender: Any?.self)
    }
  
    @IBAction func btnCart(_ sender: Any) {
        performSegue(withIdentifier: "back", sender: Any?.self)
    }
    
    override func viewDidLoad() {
        getJson(urlString: URL_JSON)
        
        getTransaksi(urlString: URL_Transaksi + infoTransaksiProduk.sharedInstance.lastID)
        getDetil()
        print(infoTransaksiProduk.sharedInstance.lastID)
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
        addShadow(v: ProdukColl)
       
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @objc private func refreshProduk(_ sender: Any) {
        DispatchQueue.main.async(execute: {
            self.Total = 0
            self.qty = 0
            self.DetilP.removeAll()
            self.Produks.removeAll()
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
        cell.ID.text = "ID : " + data.id_produk
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
        
        if intStock <= 0 {
            cell.isUserInteractionEnabled = false
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
        filtered.removeAll()
        searchProdukPelanggan.resignFirstResponder()
        searchActive = false;
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar == searchProdukPelanggan {
            self.filtered = self.Produks.filter { (data: Produk) -> Bool in
                return data.nama_produk.lowercased().contains(searchBar.text!.lowercased()) || data.id_produk.lowercased().contains(searchBar.text!.lowercased())
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if filtered.count > 0 {
            let p = self.filtered[indexPath.row]
            print(infoTransaksiProduk.sharedInstance.lastID)
            let alert = UIAlertController(title: "Masukkan Jumlah Beli", message: p.nama_produk, preferredStyle: .alert)
            
            alert.addTextField { (textField : UITextField!) -> Void in
                textField.keyboardType = UIKeyboardType.numberPad
            }
            
            let textFieldJumlah = alert.textFields![0] as UITextField
            
            if DetilFilter.count == 0{
                
            }else{
                for i in DetilFilter {
                    if i.id_produk == p.id_produk{
                        textFieldJumlah.placeholder! = i.jumlah_produk
                    }else{
                        textFieldJumlah.placeholder! = "0"
                    }
                }
            }
            
            alert.addAction(UIAlertAction(title: "Simpan", style: .default, handler: {ACTION in
                
                let intJumlah = ( textFieldJumlah.text! as NSString).integerValue
                let intStock = ( p.stock as NSString).integerValue
                if intJumlah>intStock{
                    let alert = UIAlertController(title: "Jumlah Beli Tidak Valid", message: "Stock: " + p.stock, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: {ACTION in
                    }))
                    self.present(alert, animated: true)
                }else{
                    self.post(id_produk: p.id_produk,
                    jumlah_produk: textFieldJumlah.text!,
                    id_trans: infoTransaksiProduk.sharedInstance.lastID)
                    DispatchQueue.main.async(execute: {
                        self.Produks.removeAll()
                        self.getJson(urlString: self.URL_JSON)
                    })
                }
                
            }))
            
            alert.addAction(UIAlertAction(title: "Kembali", style: .default, handler: {ACTION in
                
            }))
            self.present(alert, animated: true)
            
        }else{
            let p = self.Produks[indexPath.row]
            print(infoTransaksiProduk.sharedInstance.lastID)
            let alert = UIAlertController(title: "Masukkan Jumlah Beli", message: p.nama_produk, preferredStyle: .alert)
            
            alert.addTextField { (textField : UITextField!) -> Void in
                textField.keyboardType = UIKeyboardType.numberPad
            }
            
            let textFieldJumlah = alert.textFields![0] as UITextField
            
            if DetilFilter.count == 0{
                
            }else{
                for i in DetilFilter {
                    if i.id_produk == p.id_produk{
                        textFieldJumlah.placeholder! = i.jumlah_produk
                    }else{
                        textFieldJumlah.placeholder! = "0"
                    }
                }
            }
            
            alert.addAction(UIAlertAction(title: "Simpan", style: .default, handler: {ACTION in
                
                let intJumlah = ( textFieldJumlah.text! as NSString).integerValue
                let intStock = ( p.stock as NSString).integerValue
                if intJumlah>intStock{
                    let alert = UIAlertController(title: "Jumlah Beli Tidak Valid", message: "Stock: " + p.stock, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: {ACTION in
                    }))
                    self.present(alert, animated: true)
                }else{
                    self.post(id_produk: p.id_produk,
                    jumlah_produk: textFieldJumlah.text!,
                    id_trans: infoTransaksiProduk.sharedInstance.lastID)
                }
                
            }))
            
            alert.addAction(UIAlertAction(title: "Kembali", style: .default, handler: {ACTION in
                
            }))
            self.present(alert, animated: true)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "back"{
           guard let VC = segue.destination as? ViewTransaksiProduk else {return}
        self.getTransaksi(urlString: URL_Transaksi + infoTransaksiProduk.sharedInstance.lastID)
           VC.TransaksiP = self.TransaksiP
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
                        
                        
                        
                        let Prod = jsonObject["Data"] as? [AnyObject]
                        for pro in Prod! {
                            let p = Produk(json: pro as! [String:Any])
                            if p.gambar == p.nama_produk + ".jpg" {
                                p.gambar = "http://kouvee.xyz/upload/produk/" + p.nama_produk + ".jpg"
                                print(p.gambar)
                            }else{
                                p.gambar = "DogFood"
                            }
                            
                            if p.delete_at_produk == "0000-00-00 00:00:00"{
                                self.Produks.append(p)
                            }
                            DispatchQueue.main.async(execute: {
                                self.ProdukColl.reloadData()
                            })
                            self.Produks.sort(by: { $0.id_produk < $1.id_produk })
                        }
                        
                        
                    }
                    catch{
                        print("catch error")
                    }
                }
            }
        }.resume()
    }
    
    fileprivate func post(id_produk: String, jumlah_produk: String, id_trans: String){
    
    let parameters: [String: Any] = ["id_produk" :id_produk,
                                    "jumlah_produk" : jumlah_produk,
                                    "id_transaksi_produk" : id_trans]
    
    self.request = Alamofire.request(URL_Detil, method: .post, parameters: parameters)
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
        let url = URL(string: URL_Detil + infoTransaksiProduk.sharedInstance.lastID)
        URLSession.shared.dataTask(with: url!){
            (data,response,err) in
            if err != nil{
                print("error", err ?? "")
            }
            else{
                if let useable = data{
                    do{
                        let jsonObject = try JSONSerialization.jsonObject(with: useable, options: .mutableContainers) as AnyObject
                        
                        
                        
                        let dp = jsonObject["Data"] as? [AnyObject]
                        if dp == nil {
                            
                        }else{
                            for obj in dp! {
                                let dp = DetilTransaksiProduk(json: obj as! [String:Any])
                                let quantity = (dp.jumlah_produk as NSString).integerValue
                                self.qty = self.qty + quantity
                                
                                let intHarga = (dp.harga_jual as NSString).integerValue
                                let sum = quantity * intHarga
                                self.Total = self.Total + sum
                                
                                self.DetilP.append(dp)
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
                        
                        let tp = jsonObject["Data"] as? [AnyObject]
                        for obj in tp! {
                            let tp = TransaksiProduk(json: obj as! [String:Any])
                            self.TransaksiP = tp
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
