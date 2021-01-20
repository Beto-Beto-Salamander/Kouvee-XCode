//
//  DetilTransaksiLayananKasir.swift
//  Kouvee
//
//  Created by Ryan Octavius on 15/06/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import UIKit
import Alamofire
class ViewTransaksiLayananKasir: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

var request: Alamofire.Request? {
    didSet {
        //oldValue?.cancel()
    }
}
    var urlTrans = "https://kouvee.xyz/index.php/TransaksiLayanan/"
    var urlDelete = "https://kouvee.xyz/index.php/DetilTransaksiLayanan/"
    var urlPost = "https://kouvee.xyz/index.php/DetilTransaksiLayanan"
    var urlGet = "https://kouvee.xyz/index.php/DetilTransaksiLayanan/"
    var urlLayanan = "https://www.kouvee.xyz/index.php/Layanan"
    var urlEdit = "https://kouvee.xyz/index.php/DetilTransaksiLayanan/"
    var urlNota = "http://www.kouvee.xyz/index.php/CetakNota/PrintNota/"
    /*@IBAction func btnAdd(_ sender: Any) {
        performSegue(withIdentifier: "pilihLayananSegue", sender: Any?.self)
    }*/

    @IBAction func btnEdit(_ sender: Any) {
       // performSegue(withIdentifier: "editTransaksiLayananSegue", sender: Any?.self)
        let alert = UIAlertController(title: "Lakukan Pembayaran ? ", message: TransaksiL?.id_transaksi_layanan, preferredStyle: .alert)
        alert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Masukkan Diskon"
            textField.keyboardType = UIKeyboardType.numberPad
        }
        let textFieldDiskon = alert.textFields![0]
        alert.addAction(UIAlertAction(title: "Simpan", style: .default, handler: {ACTION in
            
            if textFieldDiskon.text == ""{
                self.pembayaran(id_cs: self.TransaksiL!.id_pegawai,
                                id_kasir: Info.sharedInstance.id_pegawai,
                                id_hewan: self.TransaksiL!.id_hewan,
                                diskon: "0",
                                status: "1",
                                progres: self.TransaksiL!.progres_layanan);
            }
            
            else{
                 self.pembayaran(id_cs: self.TransaksiL!.id_pegawai,
                               id_kasir: Info.sharedInstance.id_pegawai,
                               id_hewan: self.TransaksiL!.id_hewan,
                               diskon: textFieldDiskon.text!,
                               status: "1",
                               progres: self.TransaksiL!.progres_layanan);
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Batal", style: .default, handler: {ACTION in
            
        }))
        self.present(alert, animated: true)
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        performSegue(withIdentifier: "back", sender: Any?.self)
    }
    
    /*
    @IBAction func sendSMS(_ sender: Any) {
        let messageVC = MFMessageComposeViewController()
        messageVC.body = "Hai, " + TransaksiL!.nama_pelanggan +
            " " +
            " layanan yang telah anda beli dari Kouvee Pet Shop telah selesai. "
        messageVC.recipients = [TransaksiL!.phone]
        messageVC.messageComposeDelegate = self
        
        if MFMessageComposeViewController.canSendText() {
            self.present(messageVC, animated: true, completion: nil)
        }
        else{
            print("Can't send messages.")
        }
    }*/
    
    
    @IBOutlet weak var labelTanggal: UILabel!
    @IBOutlet weak var labelID: UILabel!
    @IBOutlet weak var labelNamaCS: UILabel!
    @IBOutlet weak var labelNamaKasir: UILabel!
    @IBOutlet weak var labelPelanggan: UILabel!
    @IBOutlet weak var labelSubtotal: UILabel!
    @IBOutlet weak var labelDiskon: UILabel!
    @IBOutlet weak var labelProgres: UILabel!
    @IBOutlet weak var labelTotal: UILabel!
    @IBOutlet weak var Qty: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var outletAdd: UIButton!
    @IBOutlet weak var outletSMS: UIButton!
    
    @IBOutlet weak var DetailLayananColl: UICollectionView!

    var TransaksiL : TransaksiLayanan?
    var reuseIdentifier = "DetailLayananCell"
    var Layanans = [Layanan]()
    var DetilL = [DetilTransaksiLayanan]()
    private let refreshControl = UIRefreshControl()
    var jumlah = String()
    var quantity : Int = 0

    override func viewDidLoad() {
        get(urlString: urlGet + infoTransaksiLayanan.sharedInstance.lastID)
        getTransaksi(urlString: urlTrans + infoTransaksiLayanan.sharedInstance.lastID )
        set()
        self.DetailLayananColl.delegate = self
        self.DetailLayananColl.dataSource = self
        self.DetailLayananColl.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshTransaksi(_:)), for: .valueChanged)
        addShadow(v: DetailLayananColl)
        
    }
    
    @objc private func refreshTransaksi(_ sender: Any) {
       
        DispatchQueue.main.async {
                print("test2")
                self.DetilL.removeAll()
                self.get(urlString: self.urlGet + infoTransaksiLayanan.sharedInstance.lastID)
                self.getTransaksi(urlString: self.urlTrans + infoTransaksiLayanan.sharedInstance.lastID )
                self.set()
                self.refreshControl.endRefreshing()
            }
    }

    
    func set(){
        labelID.text = "ID #" + TransaksiL!.id_transaksi_layanan
        labelNamaCS.text = TransaksiL?.nama_cs
        labelNamaKasir.text = TransaksiL?.nama_kasir
        if TransaksiL!.nama_hewan == "Non Member"{
            labelPelanggan.text = TransaksiL!.nama_pelanggan
        }
        else{
            labelPelanggan.text = TransaksiL!.nama_pelanggan + " ( " + TransaksiL!.nama_hewan + " - " + TransaksiL!.jenis_hewan + " )"
        }
        
        labelTanggal.text = TransaksiL?.tgl_transaksi_layanan
        if TransaksiL?.progres_layanan == "0"{
            labelProgres.text = "Belum Selesai"
            labelProgres.backgroundColor = UIColor.red
            outletSMS.isHidden = true
        }else{
            labelProgres.text = "Selesai"
            labelProgres.backgroundColor = UIColor.systemGreen
            outletSMS.isHidden = true
        }
        
        let number = (TransaksiL!.subtotal_transaksi_layanan as NSString).floatValue
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.numberStyle = .currency
        let formattedNum = formatter.string(from: number as NSNumber)
        
        let number2 = (TransaksiL!.total_transaksi_layanan as NSString).floatValue
        let formatter2 = NumberFormatter()
        formatter2.locale = Locale(identifier: "id_ID")
        formatter2.numberStyle = .currency
        let formattedNum2 = formatter2.string(from: number2 as NSNumber)
        
        let number3 = (TransaksiL!.diskon_layanan as NSString).floatValue
        let formatter3 = NumberFormatter()
        formatter3.locale = Locale(identifier: "id_ID")
        formatter3.numberStyle = .currency
        let formattedNum3 = formatter3.string(from: number3 as NSNumber)
        
        labelSubtotal.text = formattedNum
        labelTotal.text = formattedNum2
        labelDiskon.text = formattedNum3
        
        labelProgres.textColor = UIColor.white
        labelProgres.layer.cornerRadius = 5
        labelProgres.layer.masksToBounds = true
        labelProgres.clipsToBounds = true
        
        if TransaksiL?.status_layanan == "0"{
            labelStatus.textColor = UIColor.red
            labelStatus.text = "Belum Lunas"
            outletAdd.isHidden = true
        }else{
            labelStatus.textColor = UIColor.systemGreen
            labelStatus.text = "Lunas"
            outletAdd.isHidden = true
        }
        
        
    }
    
    func addShadowBtn (b : UIButton){
       
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DetilL.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! DetailLayananCollection
        let data: DetilTransaksiLayanan
        data = DetilL[indexPath.row]
        cell.labelNama.text = data.nama_layanan + " " + data.jenishewan + " " + data.ukuran
        cell.labelJumlah.text = data.jumlah_detil_layanan + "x"
        cell.labelJumlah.layer.backgroundColor = UIColor.systemBlue.cgColor
        cell.labelJumlah.textColor = UIColor.white
        cell.labelJumlah.layer.cornerRadius = 5
        
        
        let number = (data.harga_layanan as NSString).floatValue
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.numberStyle = .currency
        let formattedNum = formatter.string(from: number as NSNumber)
        cell.labelHargaSatuan.text = formattedNum!
        
        let intJml = (data.jumlah_detil_layanan  as NSString).floatValue
        let intHarga = (data.harga_layanan as NSString).floatValue
        let subtotal = intJml * intHarga
        
        let formatter2 = NumberFormatter()
        formatter2.locale = Locale(identifier: "id_ID")
        formatter2.numberStyle = .currency
        let formattedNum2 = formatter2.string(from: subtotal as NSNumber)
        cell.labelSubtotal.text = formattedNum2!
        
        if labelStatus.text == "Lunas"{
            cell.isUserInteractionEnabled = false
            
        }
        
        addShadowCell(cell: cell)
        
        return cell
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let l = self.DetilL[indexPath.row]
        let alert = UIAlertController(title: "Masukkan Jumlah Beli", message: l.nama_layanan + " " + l.jenishewan + " " + l.ukuran , preferredStyle: .alert)
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
            self.update(id_layanan: l.id_layanan,
                        jumlah_detil_layanan: textFieldJumlah.text!,
                        id_detiltransaksi_layanan: l.id_detiltransaksi_layanan)
        }))
        
        alert.addAction(UIAlertAction(title: "Hapus", style: .destructive, handler: {ACTION in
            let alert = UIAlertController(title: "Yakin Ingin Menghapus? ", message: nil, preferredStyle: .alert)
            alert.addAction(UIKit.UIAlertAction(title: "Ya", style: .default, handler: {(UIAlertAction) in
                let cells = collectionView.indexPathsForSelectedItems
                
                      self.delete(urlDel: self.urlDelete + l.id_detiltransaksi_layanan)
                
                
            }))
            alert.addAction(UIKit.UIAlertAction(title: "Tidak", style: .destructive, handler: {(UIAlertAction) in
                      
            }))
            
            self.present(alert,animated: true, completion: nil )
            
        }))
        
        alert.addAction(UIAlertAction(title: "Kembali", style: .default, handler: {ACTION in
            
        }))
        
        self.present(alert,animated: true, completion: nil )
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "editTransaksiLayananSegue"{
           guard let VC = segue.destination as? EditTransaksiLayanan else {return}
           VC.TransaksiL = self.TransaksiL
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
                        
                        let dl = jsonObject["Data"] as? [AnyObject]
                        if dl == nil {
                            DispatchQueue.main.async {
                                self.DetailLayananColl.reloadData()
                                self.quantity = 0
                                self.Qty.text = "Qty: " + String(self.quantity)
                            }
                        }else{
                            self.quantity = 0
                            for obj in dl! {
                                let dl = DetilTransaksiLayanan(json: obj as! [String:Any])
                                self.DetilL.append(dl)
                                let qty = ( dl.jumlah_detil_layanan as NSString ).integerValue
                                self.quantity = self.quantity + qty
                                self.DetilL.sort(by: { $0.id_detiltransaksi_layanan < $1.id_detiltransaksi_layanan })
                            }
                            DispatchQueue.main.async {
                                self.DetailLayananColl.reloadData()
                                self.Qty.text = "Qty: " + String(self.quantity)
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
    
    fileprivate func pembayaran(id_cs: String, id_kasir: String, id_hewan: String, diskon:String , status: String, progres: String){
    
        let parameters: [String: Any] = ["id_pegawai" : id_cs,
                                         "peg_id_pegawai" : id_kasir,
                                         "id_hewan" : id_hewan,
                                         "diskon_layanan" : diskon ,
                                         "status_layanan" : status,
                                         "progres_layanan" : progres]
        guard let url = URL(string: urlTrans + self.TransaksiL!.id_transaksi_layanan ) else { return }
        
    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
    request.httpBody = httpBody
        
    let session = URLSession.shared
    
    session.dataTask(with: request){ (data,response,err) in
        if let response = response{
                print(response)
            }
        if let data = data{
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                let Message = json["Message"] as! String
                print(json)
                if Message != "Data Berhasil Di Ubah" {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Gagal Mengubah Data", message: "Periksa Kembali Masukkan", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: nil))
                        self.present(alert,animated: true, completion: nil )
                        }
                }else if Message == "Data Berhasil Di Ubah" {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: Message, message: nil, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: {(UIAlertAction) in
                            guard let url = URL(string: self.urlNota + self.TransaksiL!.id_transaksi_layanan) else { return }
                            UIApplication.shared.open(url)
                        }))
                        self.present(alert,animated: true, completion: nil )
                        }
                    }

            }catch{
                print(error)
            }
            }
        }.resume()
    }


    fileprivate func update(id_layanan: String, jumlah_detil_layanan: String, id_detiltransaksi_layanan:String){
    
    let parameters: [String: Any] = ["id_layanan" :id_layanan,
                                     "jumlah_detil_layanan" : jumlah_detil_layanan]
    print("id",id_layanan)
    print("jumlah",jumlah_detil_layanan)
    print("id detil",id_detiltransaksi_layanan)
    print(urlEdit + id_detiltransaksi_layanan)
    self.request = Alamofire.request(urlEdit + id_detiltransaksi_layanan, method: .put, parameters: parameters)
        if let request = request as? DataRequest {
            request.responseString { response in
                do{
                    let data = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as! [String: Any]
                    let Message = data["Message"] as! String
                    print(data)
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
                                DispatchQueue.main.async {
                                    self.DetilL.removeAll()
                                    self.get(urlString: self.urlGet + self.TransaksiL!.id_transaksi_layanan)
                                    self.getTransaksi(urlString: self.urlTrans +  infoTransaksiLayanan.sharedInstance.lastID)
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
                                    self.DetilL.removeAll()
                                    self.get(urlString: self.urlGet + self.TransaksiL!.id_transaksi_layanan)
                                    self.getTransaksi(urlString: self.urlTrans +  infoTransaksiLayanan.sharedInstance.lastID)
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
                        
                        let tl = jsonObject["Data"] as? [AnyObject]
                        for obj in tl! {
                            let tl = TransaksiLayanan(json: obj as! [String:Any])
                            self.TransaksiL = tl
                        }
                        
                        DispatchQueue.main.async(execute: {
                            print("a")
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
