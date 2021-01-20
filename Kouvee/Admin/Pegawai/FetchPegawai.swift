//
//  FetchPegawai.swift
//  Kouvee
//
//  Created by Ryan Octavius on 15/06/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import UIKit

class FetchPegawai: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{
    
    @IBOutlet weak var searchBarLayanan: UISearchBar!
    @IBOutlet weak var outletSort: UIButton!
    @IBOutlet weak var PegawaiColl: UICollectionView!
    @IBOutlet weak var sortBy: UILabel!
    
    
    let reuseIdentifier = "pegawaiAdminCell"
    var Employee = [Pegawai]()
    let URL_JSON = "http://kouvee.xyz/index.php/Pegawai"
   private let refreshControl = UIRefreshControl()
    
    var filtered : [Pegawai] = []
    var searchActive : Bool = false
    
    var isSearchBarEmpty: Bool {
      return searchBarLayanan.text?.isEmpty ?? true
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        performSegue(withIdentifier: "back", sender: Any?.self)
    }
    
    @IBAction func btnAdd(_ sender: Any) {
        performSegue(withIdentifier: "AddPegawaiSegue", sender: Any?.self)
    }
    
    
    @IBAction func btnSort(_ sender: Any) {
        let alert = UIAlertController(title: "Urutkan Berdasarkan ", message: nil, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "ID", style: .default, handler: {ACTION in
            self.Employee.sort(by: {$0.id_pegawai.localizedStandardCompare($1.id_pegawai) == .orderedAscending})
            self.PegawaiColl.reloadData()
            self.sortBy.text = "ID"
        }))
        
        alert.addAction(UIAlertAction(title: "Nama", style: .default, handler: {ACTION in
            self.Employee.sort(by: { $0.nama_pegawai.lowercased() < $1.nama_pegawai.lowercased() })
            self.PegawaiColl.reloadData()
            self.sortBy.text = "Nama"
        }))
        
        alert.addAction(UIAlertAction(title: "Jabatan", style: .default, handler: {ACTION in
            self.Employee.sort(by: { $0.jabatan < $1.jabatan })
            self.PegawaiColl.reloadData()
            self.sortBy.text = "Ketersediaan"
        }))
        self.present(alert, animated: true)
    }
    
    
    override func viewDidLoad() {
        getJson(urlString: URL_JSON)
        self.PegawaiColl.delegate = self
        self.PegawaiColl.dataSource = self
        self.PegawaiColl.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshSupplier(_:)), for: .valueChanged)
        
        self.sortBy.text = "Ketersediaan"
        searchActive = false
        searchBarLayanan.showsCancelButton = true
        searchBarLayanan.delegate = self
        searchBarLayanan.placeholder = "Cari Supplier"
        
        definesPresentationContext = true
        
        
        self.navigationItem.titleView = searchBarLayanan
    
        addShadowBtn(b: outletSort)
        addShadow(v: PegawaiColl)
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @objc private func refreshSupplier(_ sender: Any) {
        DispatchQueue.main.async(execute: {
            self.Employee.removeAll()
            self.getJson(urlString: self.URL_JSON)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchActive {
            return filtered.count
        }
        else
        {
            return Employee.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! PegawaiCollection
        let data: Pegawai
        if searchActive {
          data = filtered[indexPath.row]
        } else {
          data = Employee[indexPath.row]
        }
        
        cell.namaPegawai.text = data.nama_pegawai
        cell.alamatPegawai.text = data.alamat_pegawai
        cell.telpPegawai.text = data.phone_pegawai
        cell.labelId.text = "ID Pegawai : " + data.id_pegawai
        cell.jabatan.text = data.jabatan
        
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
        performSegue(withIdentifier: "ViewPegawaiSegue", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewPegawaiSegue"{
            guard let VC = segue.destination as? ViewPegawai else {return}
            let indexPath = sender as! IndexPath
            if(filtered.count > 0){
                let Supp = self.filtered[indexPath.row]
                VC.Employee = Supp
            }else{
                let Supp = self.Employee[indexPath.row]
                VC.Employee = Supp
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
            self.filtered = self.Employee.filter { (data: Pegawai) -> Bool in
                return data.nama_pegawai.lowercased().contains(searchBar.text!.lowercased()) ||
                    data.alamat_pegawai.lowercased().contains(searchBar.text!.lowercased()) ||
                    data.phone_pegawai.lowercased().contains(searchBar.text!.lowercased()) ||
                    data.id_pegawai.lowercased().contains(searchBar.text!.lowercased()) ||
                    data.jabatan.lowercased().contains(searchBar.text!.lowercased())
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
            self.PegawaiColl.reloadData()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            self.searchActive = false
            self.PegawaiColl.reloadData()
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
                        
                        let Emp = jsonObject["Data"] as? [AnyObject]
                        for obj in Emp! {
                            let e = Pegawai(json: obj as! [String:Any])
                            self.Employee.append(e)
                            self.Employee.sort(by: {$0.id_pegawai.localizedStandardCompare($1.id_pegawai) == .orderedAscending})
                        }
                        
                        DispatchQueue.main.async(execute: {
                            self.PegawaiColl.reloadData()
                            self.refreshControl.endRefreshing()
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
