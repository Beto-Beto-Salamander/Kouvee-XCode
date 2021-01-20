//
//  DaftarSupplier.swift
//  Kouvee
//
//  Created by Ryan Octavius on 22/05/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import UIKit
import Alamofire
class DaftarSupplier: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{
    
    @IBOutlet weak var searchBarLayanan: UISearchBar!
    @IBOutlet weak var outletSort: UIButton!
    @IBOutlet weak var SupplierColl: UICollectionView!
    @IBOutlet weak var sortBy: UILabel!
    
    var request: Alamofire.Request? {
        didSet {
                //oldValue?.cancel()
        }
    }
    
    let reuseIdentifier = "supplierAdminCell"
    var Suppliers = [Supplier]()
    let URL_JSON = "http://kouvee.xyz/index.php/Supplier"
    let URL_Pemesanan = "http://kouvee.xyz/index.php/Pemesanan"
   private let refreshControl = UIRefreshControl()
    
    var filtered : [Supplier] = []
    var searchActive : Bool = false
    
    var isSearchBarEmpty: Bool {
      return searchBarLayanan.text?.isEmpty ?? true
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        performSegue(withIdentifier: "back", sender: Any?.self)
    }
    
    @IBAction func btnAdd(_ sender: Any) {
        Info.sharedInstance.status = "Pemesanan"
        performSegue(withIdentifier: "AddSupplierSegue", sender: Any?.self)
    }
    
    
    @IBAction func btnSort(_ sender: Any) {
        let alert = UIAlertController(title: "Urutkan Berdasarkan ", message: nil, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "ID", style: .default, handler: {ACTION in
            self.Suppliers.sort(by: {$0.id_supplier.localizedStandardCompare($1.id_supplier) == .orderedAscending})
            self.SupplierColl.reloadData()
            self.sortBy.text = "ID"
        }))
        
        alert.addAction(UIAlertAction(title: "Nama", style: .default, handler: {ACTION in
            self.Suppliers.sort(by: { $0.nama_supplier.lowercased() < $1.nama_supplier.lowercased() })
            self.SupplierColl.reloadData()
            self.sortBy.text = "Nama"
        }))
        
        self.present(alert, animated: true)
    }
    
    
    override func viewDidLoad() {
        getJson(urlString: URL_JSON)
        self.SupplierColl.delegate = self
        self.SupplierColl.dataSource = self
        self.SupplierColl.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshSupplier(_:)), for: .valueChanged)
        
        self.sortBy.text = ""
        searchActive = false
        searchBarLayanan.showsCancelButton = true
        searchBarLayanan.delegate = self
        searchBarLayanan.placeholder = "Cari Supplier"
        
        definesPresentationContext = true
        
        
        self.navigationItem.titleView = searchBarLayanan
    
        addShadowBtn(b: outletSort)
        addShadow(v: SupplierColl)
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @objc private func refreshSupplier(_ sender: Any) {
        DispatchQueue.main.async {
            self.Suppliers.removeAll()
            self.getJson(urlString: self.URL_JSON)
            self.refreshControl.endRefreshing()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchActive {
            return filtered.count
        }
        else
        {
            return Suppliers.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! SupplierCollection
        let data: Supplier
        if searchActive {
          data = filtered[indexPath.row]
        } else {
          data = Suppliers[indexPath.row]
        }
        
        cell.namaSupplier.text = data.nama_supplier
        cell.alamatSupplier.text = data.alamat_supplier
        cell.telpSupplier.text = data.phone_supplier
        cell.labelId.text = "ID Supplier : " + data.id_supplier
        if data.delete_at_supplier == "0000-00-00 00:00:00" {
            cell.tersedia.text = ""
        }else{
            cell.tersedia.text = "Tidak Tersedia"
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
         cell.contentView.layer.cornerRadius = 10
         cell.contentView.layer.shouldRasterize = true
         cell.contentView.layer.rasterizationScale = true ? UIScreen.main.scale : 1
         cell.contentView.layer.masksToBounds = true
         cell.layer.masksToBounds = true
         cell.layer.cornerRadius = 10
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
    
    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 10.0
        }
    */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(filtered.count > 0){
            let Supp = filtered[indexPath.row]
            infoPemesanan.sharedInstance.id_supplier = Supp.id_supplier
            infoPemesanan.sharedInstance.nama_supplier = Supp.nama_supplier
            self.post()
            
        }else{
            let Supp = Suppliers[indexPath.row]
            infoPemesanan.sharedInstance.id_supplier = Supp.id_supplier
            infoPemesanan.sharedInstance.nama_supplier = Supp.nama_supplier
            self.post()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewSupplierSegue"{
            guard let VC = segue.destination as? ViewSupplier else {return}
            let indexPath = sender as! IndexPath
            if(filtered.count > 0){
                let Supp = self.filtered[indexPath.row]
                VC.Suppliers = Supp
            }else{
                let Supp = self.Suppliers[indexPath.row]
                VC.Suppliers = Supp
            }
        }
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
            self.filtered = self.Suppliers.filter { (data: Supplier) -> Bool in
                return data.nama_supplier.lowercased().contains(searchBar.text!.lowercased()) ||
                    data.alamat_supplier.lowercased().contains(searchBar.text!.lowercased()) ||
                    data.phone_supplier.lowercased().contains(searchBar.text!.lowercased()) ||
                    data.id_supplier.lowercased().contains(searchBar.text!.lowercased())
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
            self.SupplierColl.reloadData()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            self.searchActive = false
            self.SupplierColl.reloadData()
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
                        
                        print(jsonObject)
                        
                        let Supp = jsonObject["Data"] as? [AnyObject]
                        for obj in Supp! {
                            let s = Supplier(json: obj as! [String:Any])
                            if s.delete_at_supplier == "0000-00-00 00:00:00"{
                                self.Suppliers.append(s)
                            }
                        }
                        
                        DispatchQueue.main.async(execute: {
                            self.sortBy.text = ""
                            self.SupplierColl.reloadData()
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
    
        let parameters: [String: Any] = ["id_supplier" :infoPemesanan.sharedInstance.id_supplier]
    
    self.request = Alamofire.request(URL_Pemesanan, method: .post, parameters: parameters)
        if let request = request as? DataRequest {
            request.responseString { response in
                do{
                    let data = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as! [String: Any]
                    let Message = data["Message"] as! String
                    print(data)
                    if Message != "Berhasil" {
                        self.gagal()
                    }else if Message == "Berhasil" {
                        self.berhasil()
                    }
                }catch{
                    print(error)
                }
            }
        }

    }
    
    func berhasil(){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Berhasil Menambahkan Data Pemesanan", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: {(UIAlertAction) in
                self.getJson(urlString: self.URL_JSON)
                self.performSegue(withIdentifier: "back", sender: Any?.self)
            }))
            self.present(alert,animated: true, completion: nil )
        }
    }
    
    func gagal(){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Gagal Menambahkan Data Pemesanan", message: "Periksa Kembali Masukkan", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: nil))
            self.present(alert,animated: true, completion: nil )
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
