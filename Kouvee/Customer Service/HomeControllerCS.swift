//
//  HomeControllerCS.swift
//  Kouvee
//
//  Created by Ryan Octavius on 08/04/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import UIKit

class HomeControllerCS: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var Label = [String]()
    var Gambar = [String]()
    var LabelTrans = [String]()
    var GambarTrans = [String]()
    
    var reuseIdentifierData = "dataCell"
    var reuseIdentifierTrans = "transaksiCell"
    
    @IBOutlet weak var dataColl: UICollectionView!
    @IBOutlet weak var transColl: UICollectionView!
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
        Label = ["Pelanggan","Hewan"]
        Gambar = ["dog-seatting","animal"]
        LabelTrans = ["Produk","Layanan"]
        GambarTrans = ["Transaksi Produk","Transaksi Layanan"]
        
        labelID.text = Info.sharedInstance.id_pegawai
        labelNama.text =  Info.sharedInstance.nama_pegawai
        labelJabatan.text =  Info.sharedInstance.jabatan
        
        transColl.delegate = self
        transColl.dataSource = self
        transColl.reloadData()
        addShadow(v: transColl)
        
        dataColl.delegate = self
        dataColl.dataSource = self
        dataColl.reloadData()
        addShadow(v: dataColl)
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == dataColl{
            return self.Label.count
        }else{
            return self.LabelTrans.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == dataColl{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierData, for: indexPath as IndexPath) as! DataCollection
            
            let dataLabel = Label[indexPath.row]
            cell.labelData.text = dataLabel
            
            let dataImg = Gambar[indexPath.row]
            cell.imgData.image = UIImage(named: dataImg)
            
            addShadowCell(c: cell)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierTrans, for: indexPath as IndexPath) as! TransaksiCollection
            
            let transLabel = LabelTrans[indexPath.row]
            cell.labelTrans.text = transLabel
            
            let transImg = GambarTrans[indexPath.row]
            cell.imgTrans.image = UIImage(named: transImg)
            
            addShadowCell(c: cell)
            return cell
        }
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
        if collectionView == dataColl {
            let segueIdentifier = Label[indexPath.row]
            self.performSegue(withIdentifier: segueIdentifier , sender: indexPath)
        }else{
            let segueIdentifier = LabelTrans[indexPath.row]
            self.performSegue(withIdentifier: segueIdentifier , sender: indexPath)
        }
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

