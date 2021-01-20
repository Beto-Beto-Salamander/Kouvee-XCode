//
//  ViewTransaksiProduk.swift
//  Kouvee
//
//  Created by Ryan Octavius on 24/04/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import UIKit
import Alamofire
class ViewTransaksiProduk: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var request: Alamofire.Request? {
        didSet {
            //oldValue?.cancel()
        }
    }
        var urlTrans = "http://kouvee.xyz/index.php/TransaksiProduk/"
        var urlDelete = "http://www.kouvee.xyz/index.php/DetilTransaksiProduk/"
        var urlPost = "http://www.kouvee.xyz/index.php/DetilTransaksiProduk"
        var urlGet = "http://www.kouvee.xyz/index.php/DetilTransaksiProduk/"
        var urlProduk = "http://www.kouvee.xyz/index.php/Produk"
        var urlEdit = "http://www.kouvee.xyz/index.php/DetilTransaksiProduk/"
    
        @IBAction func btnAdd(_ sender: Any) {
            performSegue(withIdentifier: "pilihProdukSegue", sender: Any?.self)
        }
    
        @IBAction func btnSelesai(_ sender: Any) {
            performSegue(withIdentifier: "editTransaksiProdukSegue", sender: Any?.self)
        }
    
        @IBAction func btnBack(_ sender: Any) {
            performSegue(withIdentifier: "back", sender: Any?.self)
        }
        
        @IBOutlet weak var labelTanggal: UILabel!
        @IBOutlet weak var labelID: UILabel!
        @IBOutlet weak var labelCS: UILabel!
        @IBOutlet weak var labelKasir: UILabel!
        @IBOutlet weak var labelStatus: UILabel!
        @IBOutlet weak var labelPelanggan: UILabel!
        @IBOutlet weak var labelSubtotal: UILabel!
        @IBOutlet weak var labelDiskon: UILabel!
        @IBOutlet weak var labelTotal: UILabel!
        @IBOutlet weak var Qty: UILabel!
    
        
        @IBOutlet weak var outletAdd: UIButton!
    
        @IBOutlet weak var DetailProdukColl: UICollectionView!
        private let refreshControl = UIRefreshControl()
        var TransaksiP : TransaksiProduk?
        var reuseIdentifier = "DetailProdukCell"
        var Produks = [Produk]()
        var DetilP = [DetilTransaksiProduk]()
        var jumlah = String()
        var quantity = 0
    
        override func viewDidLoad() {
            get(urlString: urlGet + infoTransaksiProduk.sharedInstance.lastID )
            getJson(urlString: urlProduk)
            getTransaksi(urlString: urlTrans + infoTransaksiProduk.sharedInstance.lastID )
            self.DetailProdukColl.delegate = self
            self.DetailProdukColl.dataSource = self
            self.DetailProdukColl.addSubview(refreshControl)
            refreshControl.addTarget(self, action: #selector(refreshTransaksi(_:)), for: .valueChanged)
            addShadow(v: DetailProdukColl)
        }
    
        @objc private func refreshTransaksi(_ sender: Any) {
            DispatchQueue.main.async(execute: {
                self.DetilP.removeAll()
                self.Produks.removeAll()
                self.viewDidLoad()
                self.refreshControl.endRefreshing()
            })
        }
    
        func set(){
            
            labelID.text = "ID #" + TransaksiP!.id_transaksi_produk
            labelCS.text = TransaksiP?.nama_cs
            labelKasir.text = TransaksiP?.nama_kasir
            if TransaksiP?.nama_hewan == "Non Member"{
                labelPelanggan.text = TransaksiP!.nama_pelanggan 
            }
            else{
                labelPelanggan.text = TransaksiP!.nama_pelanggan + " ( " + TransaksiP!.nama_hewan + " - " + TransaksiP!.jenis_hewan + " )"
            }
            labelTanggal.text = TransaksiP?.tgl_transaksi
            
            let number = (TransaksiP!.subtotal_transaksi_produk as NSString).floatValue
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "id_ID")
            formatter.numberStyle = .currency
            let formattedNum = formatter.string(from: number as NSNumber)
            
            let number2 = (TransaksiP!.total_transaksi_produk as NSString).floatValue
            let formatter2 = NumberFormatter()
            formatter2.locale = Locale(identifier: "id_ID")
            formatter2.numberStyle = .currency
            let formattedNum2 = formatter2.string(from: number2 as NSNumber)
            
            let number3 = (TransaksiP!.diskon_produk as NSString).floatValue
            let formatter3 = NumberFormatter()
            formatter3.locale = Locale(identifier: "id_ID")
            formatter3.numberStyle = .currency
            let formattedNum3 = formatter3.string(from: number3 as NSNumber)
            
            labelSubtotal.text = formattedNum
            labelTotal.text = formattedNum2
            labelDiskon.text = formattedNum3
            
            
            if TransaksiP?.status_transaksi_produk == "0"{
                labelStatus.textColor = UIColor.red
                labelStatus.text = "Belum Lunas"
            }else{
                labelStatus.textColor = UIColor.systemGreen
                labelStatus.text = "Lunas"
                outletAdd.isHidden = true
            }
            
            
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
        
        func addShadowBtn (b : UIButton){
           
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return DetilP.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! DetailProdukCollection
            let data: DetilTransaksiProduk
            data = DetilP[indexPath.row]
            cell.labelNama.text = data.nama_produk
            cell.labelJumlah.text = data.jumlah_produk + "x"
            
            cell.labelJumlah.layer.backgroundColor = UIColor.systemBlue.cgColor
            cell.labelJumlah.textColor = UIColor.white
            cell.labelJumlah.layer.cornerRadius = 5
            
            let number = (data.harga_jual as NSString).floatValue
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "id_ID")
            formatter.numberStyle = .currency
            let formattedNum = formatter.string(from: number as NSNumber)
            
            cell.labelHargaSatuan.text = formattedNum!
            
            let intJml = (data.jumlah_produk  as NSString).floatValue
            let intHarga = (data.harga_jual as NSString).floatValue
            let subtotal = intJml * intHarga
            
            let formatter2 = NumberFormatter()
            formatter2.locale = Locale(identifier: "id_ID")
            formatter2.numberStyle = .currency
            let formattedNum2 = formatter2.string(from: subtotal as NSNumber)
            
            cell.labelSubtotal.text = formattedNum2!
            
            if TransaksiP?.status_transaksi_produk == "1"{
                cell.isUserInteractionEnabled = false
            }
            addShadowCell(cell: cell)
            return cell
        }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 10
        }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let p = self.DetilP[indexPath.row]
            let alert = UIAlertController(title: "Masukkan Jumlah Beli", message: p.nama_produk, preferredStyle: .alert)
            alert.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = ""
                textField.keyboardType = UIKeyboardType.numberPad
            }
            let textFieldJumlah = alert.textFields![0]
            for i in DetilP {
                if i.id_produk == p.id_produk{
                    textFieldJumlah.text! = i.jumlah_produk
                }else{
                    
                }
            }
            alert.addAction(UIAlertAction(title: "Simpan", style: .default, handler: {ACTION in
                textFieldJumlah.resignFirstResponder()
                let intJumlah = ( textFieldJumlah.text! as NSString).integerValue
                
                for i in self.Produks {
                    if i.id_produk == p.id_produk{
                        let intStock = ( i.stock as NSString).integerValue
                        if intJumlah>intStock{
                            let alert = UIAlertController(title: "Jumlah Beli Tidak Valid", message: "Stock: " + i.stock, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: {ACTION in
                            }))
                            self.present(alert, animated: true)
                        }else{
                            self.update(id_produk: p.id_produk,
                                    jumlah_produk: textFieldJumlah.text!,
                                    id_detil: p.id_detil_transaksi)
                        }
                    }
                }
                
            }))
            
            alert.addAction(UIAlertAction(title: "Hapus", style: .destructive, handler: {ACTION in
                    let alert = UIAlertController(title: "Yakin Ingin Menghapus? ", message: nil, preferredStyle: .alert)
                    alert.addAction(UIKit.UIAlertAction(title: "Ya", style: .default, handler: {(UIAlertAction) in
                              self.delete(urlDel: self.urlDelete + p.id_detil_transaksi)
                        self.DetailProdukColl.deleteItems(at: [indexPath])
                    }))
                    alert.addAction(UIKit.UIAlertAction(title: "Tidak", style: .destructive, handler: {(UIAlertAction) in
                              
                    }))
                    
                    self.present(alert,animated: true, completion: nil )
            }))
            
            alert.addAction(UIAlertAction(title: "Batal", style: .default, handler: {ACTION in
                
            }))
            self.present(alert, animated: true)
        }
        
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?){
            if segue.identifier == "editTransaksiProdukSegue"{
                guard let VC = segue.destination as? EditTransaksiProduk else {return}
                VC.TransaksiP = self.TransaksiP
            }
           
        }
    
        fileprivate func get(urlString: String)
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
                            
                            let dp = jsonObject["Data"] as? [AnyObject]
                            if dp == nil {
                                DispatchQueue.main.async {
                                    self.quantity = 0
                                    self.Qty.text = "Qty: " + String(self.quantity)
                                }
                            }else{
                                self.quantity = 0
                                for obj in dp! {
                                    let dp = DetilTransaksiProduk(json: obj as! [String:Any])
                                    self.DetilP.append(dp)
                                    let qty = ( dp.jumlah_produk as NSString ).integerValue
                                    self.quantity = self.quantity + qty
                                    self.DetilP.sort(by: { $0.id_detil_transaksi < $1.id_detil_transaksi })
                                }
                                DispatchQueue.main.async {
                                    self.Qty.text = "Qty: " + String(self.quantity)
                                     self.DetailProdukColl.reloadData()
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
                                    
                                }else{
                                    p.gambar = "DogFood"
                                }
                                
                                self.Produks.append(p)
                                self.Produks.sort(by: { $0.delete_at_produk < $1.delete_at_produk })
                            }
                        }
                        catch{
                            print("catch error")
                        }
                    }
                }
            }.resume()
        }
    
    fileprivate func update(id_produk: String, jumlah_produk: String, id_detil:String){
        
        let parameters: [String: Any] = ["id_produk" :id_produk,
                                        "jumlah_produk" : jumlah_produk]
        
        self.request = Alamofire.request(urlEdit + id_detil, method: .put, parameters: parameters)
            if let request = request as? DataRequest {
                request.responseString { response in
                    do{
                        let data = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as! [String: Any]
                        let Message = data["Message"] as! String
                        
                        if Message != "Data Berhasil Di Ubah" {
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Gagal Mengubah Data Transaksi", message: "Periksa Kembali Masukkan", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: nil))
                                self.present(alert,animated: true, completion: nil )
                                }
                        }else if Message == "Data Berhasil Di Ubah" {
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Data Transaksi Berhasil Di Ubah", message: nil, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: {(UIAlertAction) in
                                }))
                                self.present(alert,animated: true, completion: nil )
                                }
                            DispatchQueue.main.async {
                                self.DetilP.removeAll()
                                self.get(urlString: self.urlGet + self.TransaksiP!.id_transaksi_produk)
                                self.getTransaksi(urlString: self.urlTrans +  infoTransaksiProduk.sharedInstance.lastID)
                            }
                            
                            }
                    }catch{
                        print(error)
                    }
                }
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
                                DispatchQueue.main.async {
                                    self.DetilP.removeAll()
                                    self.get(urlString: self.urlGet + self.TransaksiP!.id_transaksi_produk)
                                    self.getTransaksi(urlString: self.urlTrans +  infoTransaksiProduk.sharedInstance.lastID)
                                }
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
                        DispatchQueue.main.async(execute: {
                            self.set()
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
