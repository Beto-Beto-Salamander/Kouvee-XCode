//
//  HomeControllerKasir.swift
//  Kouvee
//
//  Created by Ryan Octavius on 16/06/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import UIKit

class HomeControllerKasir: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var Label = [String]()
    var Gambar = [String]()
    
    var reuseIdentifierBayar = "pembayaranCell"
    
    @IBOutlet weak var bayarColl: UICollectionView!
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
        Label = ["Produk","Layanan"]
        Gambar = ["Transaksi Produk","Transaksi Layanan"]
        
        
        labelID.text = Info.sharedInstance.id_pegawai
        labelNama.text =  Info.sharedInstance.nama_pegawai
        labelJabatan.text =  Info.sharedInstance.jabatan
        
        bayarColl.delegate = self
        bayarColl.dataSource = self
        bayarColl.reloadData()
        addShadow(v: bayarColl)
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.Label.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierBayar, for: indexPath as IndexPath) as! PembayaranCollection
            
            let dataLabel = Label[indexPath.row]
            cell.label.text = dataLabel
            
            let dataImg = Gambar[indexPath.row]
            cell.img.image = UIImage(named: dataImg)
            
            addShadowCell(c: cell)
            return cell
    }

    func addShadowCell (c : UICollectionViewCell){
         c.layer.cornerRadius = 5
         c.layer.shadowColor = UIColor.lightGray.cgColor
         c.layer.shadowOffset = .zero
         c.layer.shadowOpacity = 0.4
         c.layer.shadowRadius = 5
         c.layer.shouldRasterize = true
         c.layer.rasterizationScale = true ? UIScreen.main.scale : 1
         
       // self.dataColl.contentInset = UIEdgeInsets(top: 10, left: 0, bottom:0, right:0)
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
   /* func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: self.dataColl.bounds.width - 20, height: self.dataColl.bounds.height/5 )
        }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 10.0
        }
    */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let segueIdentifier = Label[indexPath.row]
            self.performSegue(withIdentifier: segueIdentifier , sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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
