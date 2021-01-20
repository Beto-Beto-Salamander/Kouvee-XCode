//
//  DaftarProdukPemesanan.swift
//  Kouvee
//
//  Created by Ryan Octavius on 22/05/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
class DaftarProdukPemesanan: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate{
 
    @IBOutlet weak var searchProdukPelanggan: UISearchBar!
    @IBOutlet weak var ProdukColl: UICollectionView!
    
    @IBOutlet weak var outletCart: UIButton!
    
    
    let reuseIdentifier = "produkAdminCell"
    var Pengadaan : Pemesanan?
    var DetilP = [DetilPemesanan]()
    var DetilFilter = [DetilPemesanan]()
    var Produks = [Produk]()
    var Habis = [Produk]()
    var tempP = [Produk]()
    var tempH = [Produk]()
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
    let URL_Detil = "http://kouvee.xyz/index.php/DetilPemesanan/"
    let URL_Pemesanan = "http://kouvee.xyz/index.php/Pemesanan/"
    
    
    @IBAction func btnSort(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Urutkan ( Semua Produk )", style: .default, handler: {ACTION in
            let alert = UIAlertController(title: "Urutkan Berdasar", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ID", style: .default, handler: {ACTION in
                    self.Produks = self.tempP
                    self.Produks.sort(by: {$0.id_produk.localizedStandardCompare($1.id_produk) == .orderedAscending})
                    self.ProdukColl.reloadData()
                    // self.sortBy.text = "ID"
                }))
                
                alert.addAction(UIAlertAction(title: "Nama", style: .default, handler: {ACTION in
                    self.Produks = self.tempP
                    self.Produks.sort(by: { $0.nama_produk.lowercased() < $1.nama_produk.lowercased() })
                    self.ProdukColl.reloadData()
                    // self.sortBy.text = "Nama"
                }))
                
                alert.addAction(UIAlertAction(title: "Harga ( Kecil - Besar )", style: .default, handler: {ACTION in
                    self.Produks = self.tempP
                    self.Produks.sort(by: {$0.harga_jual.localizedStandardCompare($1.harga_jual) == .orderedAscending})
                    self.ProdukColl.reloadData()
                    //self.sortBy.text = "Harga ( Kecil - Besar )"
                }))
                
                alert.addAction(UIAlertAction(title: "Harga ( Besar - Kecil )", style: .default, handler: {ACTION in
                    self.Produks = self.tempP
                    self.Produks.sort(by: {$0.harga_jual.localizedStandardCompare($1.harga_jual) == .orderedDescending})
                    self.ProdukColl.reloadData()
                    // self.sortBy.text = "Harga ( Besar - Kecil )"
                }))
                
                alert.addAction(UIAlertAction(title: "Jumlah ( Sedikit - Banyak )", style: .default, handler: {ACTION in
                    self.Produks = self.tempP
                    self.Produks.sort(by: {$0.stock.localizedStandardCompare($1.stock) == .orderedAscending})
                    self.ProdukColl.reloadData()
                    // self.sortBy.text = "Jumlah ( Sedikit - Banyak )"
                }))
                
                alert.addAction(UIAlertAction(title: "Jumlah ( Banyak - Sedikit )", style: .default, handler: {ACTION in
                    self.Produks = self.tempP
                    self.Produks.sort(by: {$0.stock.localizedStandardCompare($1.stock) == .orderedDescending})
                    self.ProdukColl.reloadData()
                   // self.sortBy.text = "Jumlah ( Banyak - Sedikit )"
                }))
                
                alert.addAction(UIAlertAction(title: "Ketersediaan", style: .default, handler: {ACTION in
                    self.Produks = self.tempP
                    self.Produks.sort(by: { $0.delete_at_produk < $1.delete_at_produk })
                    self.ProdukColl.reloadData()
                    // self.sortBy.text = "Ketersediaan"
                }))
            self.present(alert, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Tampilkan Produk Hampir Habis", style: .default, handler: {ACTION in
            self.Produks = self.Habis
            self.Produks.sort(by: { $0.nama_produk < $1.nama_produk })
            self.ProdukColl.reloadData()
            // self.sortBy.text = "Produk Hampir Habis"
        }))
        
        alert.addAction(UIAlertAction(title: "Pesan Semua Produk Yang Hampir Habis", style: .default, handler: {ACTION in
            let alert = UIAlertController(title: "Produk Akan Dipesan Sebanyak Minimal Stok", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {ACTION in
                    self.pesanSemua()
                }))
            
                alert.addAction(UIAlertAction(title: "Batal", style: .destructive, handler: {ACTION in
                    

                }))
            self.present(alert, animated: true)
        }))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        performSegue(withIdentifier: "back", sender: Any?.self)
    }
  
    @IBAction func btnCart(_ sender: Any) {
        performSegue(withIdentifier: "back", sender: Any?.self)
    }
    
    override func viewDidLoad() {
        getJson(urlString: URL_JSON)
        
        getPemesanan(urlString: URL_Pemesanan + infoPemesanan.sharedInstance.lastID)
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
            print(infoPemesanan.sharedInstance.lastID)
            let alert = UIAlertController(title: "Masukkan Jumlah Pesan", message: p.nama_produk, preferredStyle: .alert)
            
            alert.addTextField { (textField : UITextField!) -> Void in
                textField.keyboardType = UIKeyboardType.numberPad
            }
            
            let textFieldJumlah = alert.textFields![0] as UITextField
            
            if DetilFilter.count == 0{
                
            }else{
                for i in DetilFilter {
                    if i.id_produk == p.id_produk{
                        textFieldJumlah.placeholder! = i.jumlah_pesanan
                    }else{
                        textFieldJumlah.placeholder! = "0"
                    }
                }
            }
            
            alert.addAction(UIAlertAction(title: "Simpan", style: .default, handler: {ACTION in
                    self.post(id_produk: p.id_produk,
                    jumlah_pesanan: textFieldJumlah.text!,
                    id_pemesanan: infoPemesanan.sharedInstance.lastID)
                
            }))
            
            alert.addAction(UIAlertAction(title: "Kembali", style: .default, handler: {ACTION in
                
            }))
            self.present(alert, animated: true)
            
        }else{
            let p = self.Produks[indexPath.row]
            print(infoPemesanan.sharedInstance.lastID)
            let alert = UIAlertController(title: "Masukkan Jumlah Pesan", message: p.nama_produk, preferredStyle: .alert)
            
            alert.addTextField { (textField : UITextField!) -> Void in
                textField.keyboardType = UIKeyboardType.numberPad
            }
            
            let textFieldJumlah = alert.textFields![0] as UITextField
            
            if DetilFilter.count == 0{
                
            }else{
                for i in DetilFilter {
                    if i.id_produk == p.id_produk{
                        textFieldJumlah.placeholder! = i.jumlah_pesanan
                    }else{
                        textFieldJumlah.placeholder! = "0"
                    }
                }
            }
            
            alert.addAction(UIAlertAction(title: "Simpan", style: .default, handler: {ACTION in
                
                    self.post(id_produk: p.id_produk,
                    jumlah_pesanan: textFieldJumlah.text!,
                    id_pemesanan: infoPemesanan.sharedInstance.lastID)
                
            }))
            
            alert.addAction(UIAlertAction(title: "Kembali", style: .default, handler: {ACTION in
                
            }))
            self.present(alert, animated: true)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "back"{
           guard let VC = segue.destination as? ViewPemesanan else {return}
        self.getPemesanan(urlString: URL_Pemesanan + infoPemesanan.sharedInstance.lastID)
           VC.Pengadaan = self.Pengadaan
       }
    }
    
    
    func pesanSemua(){
        for i in Habis{
            self.post(id_produk: i.id_produk,
                      jumlah_pesanan: i.min_stock,
                 id_pemesanan: self.Pengadaan!.id_pemesanan)
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
                            
                            let intMin = (p.min_stock as NSString).floatValue
                            let intStock = (p.stock as NSString).floatValue
                            if p.delete_at_produk == "0000-00-00 00:00:00"{
                                if intStock <= intMin{
                                    self.Habis.append(p)
                                    print("testing",self.Habis)
                                }
                                
                                self.Produks.append(p)
                            }
                            self.setProduk()
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
    
    func setProduk(){
        DispatchQueue.main.async {
            self.tempP = self.Produks
            self.tempH = self.Habis
            self.ProdukColl.reloadData()
        }
    }
    
    fileprivate func post(id_produk: String, jumlah_pesanan: String, id_pemesanan: String){
    
    let parameters: [String: Any] = ["id_produk" :id_produk,
                                    "jumlah_pesanan" : jumlah_pesanan,
                                    "id_pemesanan" : id_pemesanan]
    
    self.request = Alamofire.request(URL_Detil, method: .post, parameters: parameters)
        if let request = request as? DataRequest {
            request.responseString { response in
                do{
                    let data = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as! [String: Any]
                    let Message = data["Message"] as! String
                    
                    if Message != "Berhasil Menambahkan Data" {
                        self.gagal()
                    }else if Message == "Berhasil Menambahkan Data" {
                        self.berhasil()
                    }
                }catch{
                    print(error)
                }
            }
        }

    }
    
    func gagal(){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Gagal Menambahkan Data Produk", message: "Periksa Kembali Masukkan", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: nil))
            self.present(alert,animated: true, completion: nil )
        }
        
    }
    
    func berhasil(){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Berhasil Menambahkan Data Produk", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: {(UIAlertAction) in
                self.qty = 0
                self.Total = 0
                self.getDetil()
            }))
            self.present(alert,animated: true, completion: nil )
        }
        
    }
    
    fileprivate func getDetil()
    {
        let url = URL(string: URL_Detil + infoPemesanan.sharedInstance.lastID)
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
                                let dp = DetilPemesanan(json: obj as! [String:Any])
                                let quantity = (dp.jumlah_pesanan as NSString).integerValue
                                self.qty = self.qty + quantity
                                
                                let intHarga = (dp.sub_total_pemesanan as NSString).integerValue
                                self.Total = self.Total + intHarga
                                
                                self.DetilP.append(dp)
                            }
                            
                            self.setCart()
                        }
                    }
                    catch{
                        print("catch error")
                    }
                }
            }
        }.resume()
    }
    
    func setCart(){
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
                        
                        let p = jsonObject["Data"] as? [AnyObject]
                        for obj in p! {
                            let P = Pemesanan(json: obj as! [String:Any])
                            self.Pengadaan = P
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
