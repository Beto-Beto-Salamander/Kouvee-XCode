//
//  HomePelanggan.swift
//  Kouvee
//
//  Created by Ryan Octavius on 24/03/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import UIKit
import MapKit
import AlamofireImage
class HomePelanggan: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UICollectionViewDataSource, MKMapViewDelegate {

    @IBOutlet weak var vText: UITextView!
    @IBOutlet weak var vText2: UITextView!
    @IBOutlet weak var vTentang: UIView!
    @IBOutlet weak var vVisiMisi: UIView!
    @IBOutlet weak var produkColl: UICollectionView!
    @IBOutlet weak var layananColl: UICollectionView!
    @IBOutlet weak var appleMapView: MKMapView!
    
    @IBAction func btnProduk(_ sender: Any) {
        performSegue(withIdentifier: "viewProdukPelanggan", sender: Any?.self)
    }
    
    @IBAction func btnLayanan(_ sender: Any) {
        performSegue(withIdentifier: "viewLayananPelanggan", sender: Any?.self)
    }
    
    
    @IBAction func btnLogin(_ sender: Any) {
        performSegue(withIdentifier: "loginPegawai", sender: Any?.self)
    }
    var Produks = [Produk]()
    var Layanans = [Layanan]()
    private let refreshControlP = UIRefreshControl()
    private let refreshControlL = UIRefreshControl()
    let reuseIdentifierP = "produkPelangganCell"
    let reuseIdentifierL = "layananPelangganCell"
    let URL_JSONp = "http://kouvee.xyz/index.php/Produk"
    let URL_JSONl = "http://kouvee.xyz/index.php/Layanan"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getJsonLayanan(urlString: URL_JSONl)
        getJsonProduk(urlString: URL_JSONp)
        
        produkColl.delegate = self
        produkColl.dataSource = self
        layananColl.delegate = self
        layananColl.dataSource = self
        
        //refreshControlP.addTarget(self, action: #selector(refreshP(_:)), for: .valueChanged)
        //refreshControlL.addTarget(self, action: #selector(refreshL(_:)), for: .valueChanged)
        refreshControlP.attributedTitle = NSAttributedString(string: "Tarik untuk memuat ulang")
        refreshControlL.attributedTitle = NSAttributedString(string: "Tarik untuk memuat ulang")
        produkColl.addSubview(refreshControlP)
        layananColl.addSubview(refreshControlL)
        addShadow(v: produkColl)
        addShadow(v: layananColl)
        addShadow(v: vVisiMisi)
        addShadow(v: vTentang)
        addShadowMap(v: vMap)
        RoundText(v: vText)
        RoundText(v: vText2)
        
        let initLat = -7.7761892
        let initLon = 110.3892795
        
        let initPosition = CLLocationCoordinate2DMake(initLat, initLon)
        
        let region = MKCoordinateRegion.init(center: initPosition, span: MKCoordinateSpan.init(latitudeDelta: 0.005, longitudeDelta: 0.005))
        appleMapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.title = "Jalan Moses Gatotkaca Nomor 22"
        annotation.coordinate = initPosition
        appleMapView.addAnnotation(annotation)
        
        vText.text = "Kouvee Pet Shop merupakan sebuah toko hewan yang sudah berdiri sejak tahun 2018 menyediakan  produk dan jasa layanan yang berada di Kota Yogyakarta. Kouvee Pet Shop menyediakan berbagai macam produk untuk hewan kesayangan anda seperti makanan, aksesoris,perlengkapan dan lain-lain sesuai kebutuhan hewan kesayangan anda. Selain menjual berbagai macam produk, Kouvee Pet Shop juga menyediakan jasa layanan seperti grooming dan penitipan hewan."
        vText2.text = "1.Menjadi petshop yang paling digemari dan mempunyai brand image yang kuat  di indonesia. \n2.Berupaya menjadi petshop yang rapi teratur,indah dan wangi. \n3.Berupaya menjadi petshop yang mengutamakan kepuasan pelanggan."
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var vMap: MKMapView!
    
    @objc private func refreshP(_ sender: Any) {
        DispatchQueue.main.async(execute: {
            self.Produks.removeAll()
            self.getJsonProduk(urlString: self.URL_JSONp)
        })
    }
    
    @objc private func refreshL(_ sender: Any) {
           DispatchQueue.main.async(execute: {
               self.Layanans.removeAll()
               self.getJsonLayanan(urlString: self.URL_JSONl)
           })
       }
    
    public func addShadow(v: UIView){
        v.layer.cornerRadius = 5
        v.layer.shadowColor = UIColor.lightGray.cgColor
        v.layer.shadowOffset = .zero
        v.layer.shadowOpacity = 0.4
        v.layer.shadowRadius = 5
        v.layer.shouldRasterize = true
        v.layer.rasterizationScale = true ? UIScreen.main.scale : 1
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
    
    public func addShadowMap(v: MKMapView){
        v.layer.cornerRadius = 5
        v.layer.shadowColor = UIColor.lightGray.cgColor
        v.layer.shadowOffset = .zero
        v.layer.shadowOpacity = 0.4
        v.layer.shadowRadius = 5
        v.layer.shouldRasterize = true
        v.layer.rasterizationScale = true ? UIScreen.main.scale : 1
    }
    
    public func RoundText(v: UITextView){
        v.layer.cornerRadius = 5
        v.layer.shouldRasterize = true
        v.layer.rasterizationScale = true ? UIScreen.main.scale : 1
    }
    
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.produkColl {
            return Produks.count
        }else{
            return Layanans.count 
        }
   }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.produkColl {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierP, for: indexPath as IndexPath) as! ProdukCollection
            let data: Produk
            data = Produks[indexPath.row]
            
            if data.gambar == "DogFood"{
                cell.imgProdukPelanggan.image = UIImage(named: "DogFood")
            }else{
                let downloadURL = NSURL(string: data.gambar)!
                cell.imgProdukPelanggan.af_setImage(withURL: downloadURL as URL)
            }
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
            
            addShadowCell(cell: cell)
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierL, for: indexPath as IndexPath) as! LayananCollection
            let data: Layanan
            data = Layanans[indexPath.row]
            cell.namaLayanan.text = data.nama_layanan + " " + data.jenis_hewan + " " + data.ukuran
            
            let number = (data.harga_layanan as NSString).floatValue
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "id_ID")
            formatter.numberStyle = .currency
            let formattedNum = formatter.string(from: number as NSNumber)
        
            cell.hargaLayanan.text = formattedNum!
            
            addShadowCell(cell: cell)
            if data.delete_at_layanan == "0000-00-00 00:00:00"{
                cell.tersedia.text = ""
            }else{
                cell.tersedia.text = "Tidak Tersedia"
            }
            return cell
        }
    }
    
    func addShadowCell (cell : UICollectionViewCell){
         cell.contentView.layer.cornerRadius = 5
         cell.contentView.layer.shouldRasterize = true
         cell.contentView.layer.rasterizationScale = true ? UIScreen.main.scale : 1
         cell.layer.cornerRadius = 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    fileprivate func getJsonProduk(urlString: String)
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
                            if p.gambar == p.nama_produk + ".jpg" {
                                p.gambar = "http://kouvee.xyz/upload/produk/" + p.nama_produk + ".jpg"
                                print(p.gambar)
                            }else{
                                p.gambar = "DogFood"
                            }
                            self.Produks.append(p)
                            self.Produks.sort(by: { $0.delete_at_produk < $1.delete_at_produk })
                        }
                        
                        DispatchQueue.main.async(execute: {
                            self.produkColl.reloadData()
                            self.refreshControlP.endRefreshing()
                        })
                    }
                    catch{
                        print("catch error")
                    }
                }
            }
        }.resume()
    }
    
    fileprivate func getJsonLayanan(urlString: String)
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
                        
                        let Layan = jsonObject["Data"] as? [AnyObject]
                        for lay in Layan! {
                            let l = Layanan(json: lay as! [String:Any])
                            self.Layanans.append(l)
                            self.Layanans.sort(by:{ $0.delete_at_layanan < $1.delete_at_layanan })
                        }
                        
                        DispatchQueue.main.async(execute: {
                            self.layananColl.reloadData()
                            self.refreshControlL.endRefreshing()
                        })
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

