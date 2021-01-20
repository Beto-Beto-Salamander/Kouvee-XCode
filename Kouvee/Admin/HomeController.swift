//
//  HomeController.swift
//  Kouvee
//
//  Created by Ryan Octavius on 10/03/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import UIKit
import UserNotifications

class HomeController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UNUserNotificationCenterDelegate {
    
    var LabelData = ["Produk","Layanan","Jenis Hewan","Ukuran","Supplier","Pegawai"]
    var GambarData = ["dog-dish","saloon","pet-hotel","meter","delivery-package","pegawai"]
    var LabelLaporan = ["Bulanan","Tahunan"]
    var GambarLaporan = ["bulan","tahun"]
    
    var LabelPemesanan = ["Pemesanan"]
    var GambarPemesanan = ["shopping"]
    
    var jml : Int = 0
    var reuseIdentifierData = "dataCell"
    var reuseIdentifierPemesanan = "pemesananCell"
    var reuseIdentifierLaporan = "laporanCell"
    var url = "http://kouvee.xyz/index.php/Produk"
    
    @IBOutlet weak var pemesananColl: UICollectionView!
    @IBOutlet weak var dataColl: UICollectionView!
    @IBOutlet weak var laporanColl: UICollectionView!
    @IBOutlet weak var labelID: UILabel!
    @IBOutlet weak var labelNama: UILabel!
    @IBOutlet weak var labelJabatan: UILabel!
    var id_pegawai  = Info.sharedInstance.id_pegawai
    var nama_pegawai = Info.sharedInstance.nama_pegawai
    
    @IBOutlet weak var outletKeluar: UIButton!
    @IBAction func btnKeluar(_ sender: Any) {
        let alert = UIAlertController(title: "Keluar ?", message: nil, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ya", style: .default, handler: {ACTION in
            Info.sharedInstance.id_pegawai = ""
            Info.sharedInstance.nama_pegawai = ""
            self.performSegue(withIdentifier: "keluar", sender: Any?.self)
        }))
        
        alert.addAction(UIAlertAction(title: "Kembali", style: .destructive, handler: {ACTION in
            
        }))
        
        self.present(alert, animated: true)
        
    }
    
    override func viewDidLoad() {
        
        getJson(urlString: url)
        
        dataColl.delegate = self
        dataColl.dataSource = self
        dataColl.reloadData()
        
        pemesananColl.delegate = self
        pemesananColl.dataSource = self
        pemesananColl.reloadData()
        
        laporanColl.delegate = self
        laporanColl.dataSource = self
        laporanColl.reloadData()
        
        addShadow(v: dataColl)
        
        labelID.text = Info.sharedInstance.id_pegawai
        labelNama.text = Info.sharedInstance.nama_pegawai
        labelJabatan.text = Info.sharedInstance.jabatan
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func notif(jumlah: Int){
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 30, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = "Ada \(jumlah) Produk Yang Akan Habis"
        content.body = "Segera Lakukan Pengadaan"
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: "Stok Habis", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == dataColl {
            return self.LabelData.count
        }else if collectionView == pemesananColl{
            return self.LabelPemesanan.count
        }else{
            return self.LabelLaporan.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == dataColl{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierData, for: indexPath as IndexPath) as! DataCollection
            
            let dataLabel = LabelData[indexPath.row]
            cell.labelData.text = dataLabel
            
            let dataImg = GambarData[indexPath.row]
            cell.imgData.image = UIImage(named: dataImg)
            
            addShadowCell(c: cell)
            
            return cell
        }else if collectionView == pemesananColl{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierPemesanan, for: indexPath as IndexPath) as! PemesananCollectionAdmin
            
            let dataLabel = LabelPemesanan[indexPath.row]
            cell.labelTrans.text = dataLabel
            
            let dataImg = GambarPemesanan[indexPath.row]
            cell.imgTrans.image = UIImage(named: dataImg)
            
            addShadowCell(c: cell)
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierLaporan, for: indexPath as IndexPath) as! LaporanCollectionAdmin
            
            let dataLabel = LabelLaporan[indexPath.row]
            cell.labelLap.text = dataLabel
            
            let dataImg = GambarLaporan[indexPath.row]
            cell.imgLap.image = UIImage(named: dataImg)
            
            addShadowCell(c: cell)
            
            return cell
        }
        
    }
    
    func addShadowView (v : UIView){
        
    }
    
    func addShadowBtn (b : UIButton){
        b.layer.cornerRadius = 6
        b.layer.shadowColor = UIColor.systemBlue.cgColor
        b.layer.shadowOffset = .zero
        b.layer.shadowOpacity = 0.2
        b.layer.shadowRadius = 4
        b.layer.shouldRasterize = true
        b.layer.rasterizationScale = true ? UIScreen.main.scale : 1
    }
    
    func addShadowCell (c : UICollectionViewCell){
         c.layer.cornerRadius = 10
         c.layer.shadowColor = UIColor.lightGray.cgColor
         c.layer.shadowOffset = .zero
         c.layer.shadowOpacity = 0.4
         c.layer.shadowRadius = 5
         c.layer.shouldRasterize = true
         c.layer.rasterizationScale = true ? UIScreen.main.scale : 1
         
       // self.dataColl.contentInset = UIEdgeInsets(top: 10, left: 0, bottom:0, right:0)
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
            return 0.0
        }
   /* func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: self.dataColl.bounds.width - 20, height: self.dataColl.bounds.height/5 )
        }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 10.0
        }
    */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == dataColl{
            let segueIdentifier = LabelData[indexPath.row]
            self.performSegue(withIdentifier: segueIdentifier , sender: indexPath)
        }else if collectionView == pemesananColl{
            let segueIdentifier = LabelPemesanan[indexPath.row]
            self.performSegue(withIdentifier: segueIdentifier , sender: indexPath)
        }else{
            let segueIdentifier = LabelLaporan[indexPath.row]
            self.performSegue(withIdentifier: segueIdentifier , sender: indexPath)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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
                            let intMin = (p.min_stock as NSString).floatValue
                            let intStock = (p.stock as NSString).floatValue
                            if intStock <= intMin{
                                self.jml += 1
                                print("test",self.jml)
                            }
                        }
                        if self.jml > 0{
                            self.notif(jumlah: self.jml)
                        }
                    }
                    catch{
                        print("catch error")
                    }
                }
            }
        }.resume()
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
