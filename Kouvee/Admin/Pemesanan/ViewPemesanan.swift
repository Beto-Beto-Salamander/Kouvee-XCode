//
//  ViewPemesanan.swift
//  Kouvee
//
//  Created by Ryan Octavius on 22/05/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import UIKit
import Alamofire
import SafariServices
class ViewPemesanan: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPickerViewDelegate,UIPickerViewDataSource {

    var request: Alamofire.Request? {
        didSet {
            //oldValue?.cancel()
        }
    }
    var arrSupplier = [Supplier]()
    var idSupplier : String = ""
    var pickerViewSupplier = UIPickerView()
    var urlPemesanan = "http://kouvee.xyz/index.php/Pemesanan/"
    var urlDelete = "http://www.kouvee.xyz/index.php/DetilPemesanan/"
    var urlPost = "http://www.kouvee.xyz/index.php/DetilPemesanan"
    var urlGet = "http://www.kouvee.xyz/index.php/DetilPemesanan/"
    var urlProduk = "http://www.kouvee.xyz/index.php/Produk"
    var urlEdit = "http://www.kouvee.xyz/index.php/DetilPemesanan/"
    var urlSurat = "http://www.kouvee.xyz/index.php/CetakNota/printPesanan/"
    var urlSupplier = "http://www.kouvee.xyz/index.php/Supplier"
    
    @IBAction func btnAdd(_ sender: Any) {
        performSegue(withIdentifier: "pilihProdukSegue", sender: Any?.self)
    }

    @IBAction func btnEdit(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ubah Supplier", style: .default, handler: { ACTION in
            let alert = UIAlertController(title: "Pilih Supplier", message: self.Pengadaan!.id_pemesanan + "\n\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
            
            self.pickerViewSupplier.isHidden = false
            self.pickerViewSupplier.frame = CGRect(x: 5, y: 30, width: 250, height: 200)
            alert.view.addSubview(self.pickerViewSupplier)
            
            alert.addAction(UIAlertAction(title: "Selesai", style: .default, handler: {ACTION in
                self.updatePesanan(id_supplier: self.idSupplier, status_pemesanan: self.Pengadaan!.status_pemesanan)
            }))
            
            alert.addAction(UIAlertAction(title: "Batal", style: .default, handler: {ACTION in
                
            }))
            
            self.present(alert, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Ubah Status Pesanan", style: .default, handler: { ACTION in
            let alert = UIAlertController(title: "Status Pesanan", message: self.Pengadaan!.id_pemesanan, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Selesai", style: .default, handler: {ACTION in
                self.updatePesanan(id_supplier: self.Pengadaan!.id_supplier, status_pemesanan: "1")
            }))
            
            alert.addAction(UIAlertAction(title: "Belum Selesai", style: .default, handler: {ACTION in
                self.updatePesanan(id_supplier: self.Pengadaan!.id_supplier, status_pemesanan: "0")
            }))
            
            alert.addAction(UIAlertAction(title: "Batal", style: .default, handler: {ACTION in
                
            }))
            
            self.present(alert, animated: true)
        }))
        
        
        alert.addAction(UIAlertAction(title: "Batal", style: .default, handler: {ACTION in
            
        }))
        self.present(alert, animated: true)
    }

    @IBAction func btnBack(_ sender: Any) {
        performSegue(withIdentifier: "back", sender: Any?.self)
    }
    
    @IBAction func suratPemesanan(_ sender: Any) {
        guard let url = URL(string: urlSurat + self.Pengadaan!.id_pemesanan) else { return }
        UIApplication.shared.open(url)
    }
    
    
    @IBOutlet weak var labelTanggal: UILabel!
    @IBOutlet weak var labelID: UILabel!
    @IBOutlet weak var labelSupplier: UILabel!
    @IBOutlet weak var labelAlamat: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var labelTotal: UILabel!
    @IBOutlet weak var labelDatang: UILabel!
    @IBOutlet weak var Qty: UILabel!

    
    @IBOutlet weak var outletAdd: UIButton!

    @IBOutlet weak var DetailProdukColl: UICollectionView!
    private let refreshControl = UIRefreshControl()
    var Pengadaan : Pemesanan?
    var reuseIdentifier = "DetailPemesananCell"
    var Produks = [Produk]()
    var DetilP = [DetilPemesanan]()
    var jumlah = String()
    var quantity = 0
    var datang = 0

    override func viewDidLoad() {
        getSupplier(url: urlSupplier)
        pickerViewSupplier.delegate = self
        pickerViewSupplier.dataSource = self
        get(urlString: urlGet + infoPemesanan.sharedInstance.lastID )
        getJson(urlString: urlProduk)
        getPemesanan(urlString: urlPemesanan + infoPemesanan.sharedInstance.lastID )
        self.DetailProdukColl.delegate = self
        self.DetailProdukColl.dataSource = self
        self.DetailProdukColl.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshTransaksi(_:)), for: .valueChanged)
        addShadow(v: DetailProdukColl)
    }

    @objc private func refreshTransaksi(_ sender: Any) {
        DispatchQueue.main.async {
            self.DetilP.removeAll()
            self.Produks.removeAll()
            self.viewDidLoad()
            self.refreshControl.endRefreshing()
        }

    }

    func set(){
        
        labelID.text = "ID #" + Pengadaan!.id_pemesanan
        labelSupplier.text = Pengadaan!.nama_supplier
        labelAlamat.text = Pengadaan?.alamat_supplier
        labelPhone.text = "Telp. " + Pengadaan!.phone_supplier
        labelTanggal.text = Pengadaan!.tanggal_pemesanan

        
        let number2 = (Pengadaan!.total as NSString).floatValue
        let formatter2 = NumberFormatter()
        formatter2.locale = Locale(identifier: "id_ID")
        formatter2.numberStyle = .currency
        let formattedNum2 = formatter2.string(from: number2 as NSNumber)
        
        labelTotal.text = formattedNum2
    
        labelStatus.layer.cornerRadius = 5
        labelStatus.layer.masksToBounds = true
        labelStatus.clipsToBounds = true
        
        if Pengadaan?.status_pemesanan == "0"{
            labelStatus.backgroundColor = UIColor.red
            labelStatus.text = "Belum Selesai"
            outletAdd.isHidden = false
        }else{
            labelStatus.backgroundColor = UIColor.systemGreen
            labelStatus.text = "Selesai"
            outletAdd.isHidden = true
        }
        
        if DetilP.count > 0{
            if self.datang > 0 && self.Pengadaan?.status_pemesanan == "0"{
                self.labelDatang.text = "\(self.datang) barang belum datang"
            }
            else{
                self.labelDatang.text = "Semua barang sudah datang"
            }
        }
        
        else{
            self.labelDatang.text = ""
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! DetailPemesananCollection
        let data: DetilPemesanan
        data = DetilP[indexPath.row]
        cell.labelNama.text = data.nama_produk
        cell.labelJumlah.text = data.jumlah_pesanan + "x"
        cell.labelSatuan.text = data.satuan
        cell.labelJumlah.layer.backgroundColor = UIColor.systemBlue.cgColor
        cell.labelJumlah.textColor = UIColor.white
        cell.labelJumlah.layer.cornerRadius = 5
        
        let number = (data.harga_beli as NSString).floatValue
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.numberStyle = .currency
        let formattedNum = formatter.string(from: number as NSNumber)
        
        cell.labelHargaSatuan.text = formattedNum!
        
        let intJml = (data.jumlah_pesanan  as NSString).floatValue
        let intHarga = (data.harga_beli as NSString).floatValue
        let subtotal = intJml * intHarga
        
        let formatter2 = NumberFormatter()
        formatter2.locale = Locale(identifier: "id_ID")
        formatter2.numberStyle = .currency
        let formattedNum2 = formatter2.string(from: subtotal as NSNumber)
        
        cell.labelSubtotal.text = formattedNum2!
        
        if Pengadaan?.status_pemesanan == "1"{
            cell.isUserInteractionEnabled = false
        }else if Pengadaan?.status_pemesanan == "0"{
            cell.isUserInteractionEnabled = true
        }
        
        if data.datang == "0" {
            cell.btnSudah.isHidden = true
        }
        
        else if data.datang == "1"{
            cell.btnSudah.isHidden = false
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
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ubah Jumlah Pesanan", style: .default, handler: { ACTION in
            let alert = UIAlertController(title: "Masukkan Jumlah Pesan", message: p.nama_produk, preferredStyle: .alert)
            alert.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = ""
                textField.keyboardType = UIKeyboardType.numberPad
            }
            let textFieldJumlah = alert.textFields![0] as UITextField
            for i in self.DetilP {
                if i.id_produk == p.id_produk{
                    textFieldJumlah.text! = i.jumlah_pesanan
                }else{
                    
                }
            }
            alert.addAction(UIAlertAction(title: "Simpan", style: .default, handler: {ACTION in
                textFieldJumlah.resignFirstResponder()
                
                    self.update(id_produk: p.id_produk,
                        jumlah_produk: textFieldJumlah.text!,
                        id_detil: p.id_detil_pemesanan,
                        datang: p.datang)
                        
            }))
            
            alert.addAction(UIAlertAction(title: "Hapus", style: .destructive, handler: {ACTION in
                    let alert = UIAlertController(title: "Yakin Ingin Menghapus? ", message: nil, preferredStyle: .alert)
                    alert.addAction(UIKit.UIAlertAction(title: "Ya", style: .default, handler: {(UIAlertAction) in
                              self.delete(urlDel: self.urlDelete + p.id_detil_pemesanan)
                        self.DetailProdukColl.deleteItems(at: [indexPath])
                    }))
                    alert.addAction(UIKit.UIAlertAction(title: "Tidak", style: .destructive, handler: {(UIAlertAction) in
                              
                    }))
                    
                    self.present(alert,animated: true, completion: nil )
            }))
            
            alert.addAction(UIAlertAction(title: "Batal", style: .default, handler: {ACTION in
                
            }))
            
            self.present(alert,animated: true, completion: nil )
        }))
        
        alert.addAction(UIAlertAction(title: "Ubah Status Barang", style: .default, handler: { ACTION in
            let alert = UIAlertController(title: "Kedatangan Barang", message: p.nama_produk, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Sudah Datang", style: .default, handler: {ACTION in
                self.update(id_produk: p.id_produk,
                jumlah_produk: p.jumlah_pesanan,
                id_detil: p.id_detil_pemesanan,
                datang: "1")
            }))
            
            alert.addAction(UIAlertAction(title: "Belum Datang", style: .default, handler: {ACTION in
                self.update(id_produk: p.id_produk,
                jumlah_produk: p.jumlah_pesanan,
                id_detil: p.id_detil_pemesanan,
                datang: "0")
            }))
            
            alert.addAction(UIAlertAction(title: "Batal", style: .default, handler: {ACTION in
                
            }))
            
            self.present(alert, animated: true)
        }))
        
        
        alert.addAction(UIAlertAction(title: "Hapus", style: .destructive, handler: {ACTION in
            self.delete(urlDel: self.urlDelete + p.id_detil_pemesanan)
        }))
        
        alert.addAction(UIAlertAction(title: "Batal", style: .default, handler: {ACTION in
            
        }))
        self.present(alert, animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arrSupplier.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let title = self.arrSupplier[row].nama_supplier
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerViewSupplier{
            self.idSupplier = arrSupplier[row].id_supplier
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "editPemesananSegue"{
           guard let VC = segue.destination as? EditPemesanan else {return}
           VC.Pengadaan = self.Pengadaan
       }
    }
    
    fileprivate func getSupplier(url: String)
    {
        let url = URL(string: url)
        URLSession.shared.dataTask(with: url!){
            (data,response,err) in
            if err != nil{
                print("error", err ?? "")
            }
            else{
                if let useable = data{
                    do{
                        let jsonObject = try JSONSerialization.jsonObject(with: useable, options: .mutableContainers) as AnyObject
                        
                        let p = jsonObject["Data"] as? [AnyObject]
                            for obj in p! {
                                let p = Supplier(json: obj as! [String:Any])
                                
                                if p.delete_at_supplier == "0000-00-00 00:00:00"{
                                    self.arrSupplier.append(p)
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
                            self.setQtyNil()
                        }else{
                            self.quantity = 0
                            self.datang = 0
                            for obj in dp! {
                                let dp = DetilPemesanan(json: obj as! [String:Any])
                                self.DetilP.append(dp)
                                let qty = ( dp.jumlah_pesanan as NSString ).integerValue
                                self.quantity = self.quantity + qty
                                self.DetilP.sort(by: { $0.id_detil_pemesanan < $1.id_detil_pemesanan })
                                
                                if dp.datang == "0"{
                                    self.datang+=1
                                }
                            }
                            self.setQty()
                        }
                    }
                    catch{
                        print("catch error")
                    }
                }
            }
        }.resume()
    }
    
    func setQtyNil(){
        DispatchQueue.main.async {
            self.quantity = 0
            self.Qty.text = "Qty: " + String(self.quantity)
        }
        
    }
    
    func setQty(){
        DispatchQueue.main.async {
            self.Qty.text = "Qty: " + String(self.quantity)
            self.DetailProdukColl.reloadData()
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
                                
                            }else{
                                p.gambar = "DogFood"
                            }
                            
                            self.Produks.append(p)
                        }
                    }
                    catch{
                        print("catch error")
                    }
                }
            }
        }.resume()
    }

    fileprivate func update(id_produk: String, jumlah_produk: String, id_detil:String, datang: String){
    
    let parameters: [String: Any] = ["id_produk" :id_produk,
                                    "jumlah_pesanan" : jumlah_produk,
                                    "datang" : datang]
    
    self.request = Alamofire.request(urlEdit + id_detil, method: .post, parameters: parameters)
        if let request = request as? DataRequest {
            request.responseString { response in
                do{
                    let data = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as! [String: Any]
                    let Message = data["Message"] as! String
                    
                    if Message != "Data Berhasil Di Ubah" {
                        self.gagalEdit()
                    }else if Message == "Data Berhasil Di Ubah" {
                        self.berhasilEdit()
                    }
                }catch{
                    print(error)
                }
            }
        }

    }
    
    fileprivate func updatePesanan(id_supplier: String, status_pemesanan: String){
    
    let parameters: [String: Any] = ["id_supplier" :id_supplier,
                                    "status_pemesanan" : status_pemesanan]
    
        self.request = Alamofire.request(urlPemesanan + Pengadaan!.id_pemesanan, method: .post, parameters: parameters)
        if let request = request as? DataRequest {
            request.responseString { response in
                do{
                    let data = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as! [String: Any]
                    let Message = data["Message"] as! String
                    
                    if Message != "Data Berhasil Di Ubah" {
                        self.gagalEdit()
                    }else if Message == "Data Berhasil Di Ubah" {
                        self.berhasilEdit()
                    }
                }catch{
                    print(error)
                }
            }
        }

    }
    
    func gagalEdit(){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Gagal Mengubah Data Pemesanan", message: "Periksa Kembali Masukkan", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: nil))
            self.present(alert,animated: true, completion: nil )
        }
        
    }
    
    func berhasilEdit(){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Data Pemesanan Berhasil Di Ubah", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: {(UIAlertAction) in
                self.setDetil()
            }))
            self.present(alert,animated: true, completion: nil )
        }
        
        
    }
    
    func setDetil(){
        DispatchQueue.main.async {
            self.DetilP.removeAll()
            self.get(urlString: self.urlGet + self.Pengadaan!.id_pemesanan)
            self.getPemesanan(urlString: self.urlPemesanan +  infoPemesanan.sharedInstance.lastID)
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
                    self.gagalDelete()
                }else if Message == "Data Berhasil Di Hapus" {
                    self.berhasilDelete()
                }
            }catch{
                print(error)
            }
        }
    }

}
    
    func gagalDelete(){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Gagal Menghapus Data Pemesanan", message: "Periksa Kembali Masukkan", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: nil))
            self.present(alert,animated: true, completion: nil )
        }
        
    }
    
    func berhasilDelete(){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Data Pemesanan Berhasil Di Ubah", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: {(UIAlertAction) in
                self.setDetil()
            }))
            self.present(alert,animated: true, completion: nil )
        }
    }

fileprivate func getPemesanan(urlString: String)
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
                        let tp = Pemesanan(json: obj as! [String:Any])
                        self.Pengadaan = tp
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
