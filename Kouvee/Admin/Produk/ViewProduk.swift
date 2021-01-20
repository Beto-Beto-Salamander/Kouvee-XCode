//
//  ViewProduk.swift
//  Kouvee
//
//  Created by Ryan Octavius on 11/03/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
class ViewProduk: UIViewController {
    var request: Alamofire.Request? {
        didSet {
            //oldValue?.cancel()
        }
    }

    var urlDelete = "http://www.kouvee.xyz/index.php/Produk/"
    
    @IBAction func opsi(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Perbarui", style: .default, handler: {ACTION in
            self.performSegue(withIdentifier: "EditProdukSegue", sender: Any?.self)
        }))
        alert.addAction(UIAlertAction(title: "Hapus", style: .default, handler:{ ACTION in
            
            let alert = UIAlertController(title: "Yakin ingin menghapus?", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ya", style: .default, handler: {ACTION in
                self.delete(urlDel: self.urlDelete + self.Produks!.id_produk)
            }))
            alert.addAction(UIAlertAction(title: "Kembali", style: .destructive, handler: { ACTION in
                
            }))
            self.present(alert, animated: true)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Kembali", style: .destructive, handler:{ ACTION in
            print("Kembali")
        }))

        self.present(alert, animated: true)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        performSegue(withIdentifier: "back", sender: Any?.self)
    }
    
    @IBOutlet weak var v: UIView!
    @IBOutlet weak var imgProduk: UIImageView!
    @IBOutlet weak var labelDelete: UILabel!
    @IBOutlet weak var labelUpdate: UILabel!
    @IBOutlet weak var labelCreate: UILabel!
    @IBOutlet weak var labelHarga: UILabel!
    @IBOutlet weak var labelMinStock: UILabel!
    @IBOutlet weak var labelStock: UILabel!
    @IBOutlet weak var labelNamaPeg: UILabel!
    @IBOutlet weak var labelNama: UILabel!
    @IBOutlet weak var labelID: UILabel!
    @IBOutlet weak var labelSatuan: UILabel!
    
    var Produks : Produk?
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addShadowView(v: v)
        addShadowImg(img: imgProduk)
        
        if Produks!.gambar.contains(".jpg") && Produks!.gambar != "default.jpg"{
            let downloadURL = NSURL(string: Produks!.gambar)!
            imgProduk.af_setImage(withURL: downloadURL as URL)
        }else{
            imgProduk.image = UIImage(named: "DogFood")
        }
        
        
        labelNama.text = Produks?.nama_produk
        labelNamaPeg.text = Produks?.nama_pegawai
        labelStock.text = Produks?.stock
        labelMinStock.text = Produks?.min_stock
        labelSatuan.text = Produks?.satuan_produk
        let Str1 = Produks!.harga_jual
        let Str2 = Produks!.harga_beli
        
        let number1 = (Str1 as NSString).floatValue
        let formatter1 = NumberFormatter()
        formatter1.locale = Locale(identifier: "id_ID")
        formatter1.numberStyle = .currency
        let formattedNum1 = formatter1.string(from: number1 as NSNumber)
        
        let number2 = (Str2 as NSString).floatValue
        let formatter2 = NumberFormatter()
        formatter2.locale = Locale(identifier: "id_ID")
        formatter2.numberStyle = .currency
        let formattedNum2 = formatter2.string(from: number2 as NSNumber)
         
        let Con = formattedNum1! + " / " + formattedNum2!
        labelHarga.text = Con
        labelCreate.text = Produks?.create_at_produk
        labelUpdate.text = Produks?.update_at_produk
        labelDelete.text = Produks?.delete_at_produk
        labelID.text = Produks!.id_produk + " "
        // Do any additional setup after loading the view.
    }
    
    func addShadowView (v : UIView){
        v.layer.cornerRadius = 6
        v.layer.shadowColor = UIColor.lightGray.cgColor
        v.layer.shadowOffset = .zero
        v.layer.shadowOpacity = 0.4
        v.layer.shadowRadius = 9
        v.layer.shouldRasterize = true
        v.layer.rasterizationScale = true ? UIScreen.main.scale : 1
    }
    
    func addShadowBtn (b : UIButton){
       
    }
    
    func addShadowImg (img : UIImageView){
         img.layer.cornerRadius = 6
         img.layer.shadowColor = UIColor.lightGray.cgColor
         img.layer.shadowOffset = CGSize(width: 3, height: 3)
         img.layer.shadowOpacity = 0.7
         img.layer.shadowRadius = 3
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditProdukSegue"{
            guard let VC = segue.destination as? EditProduk else {return}
            VC.Produks = self.Produks
             
        }
        else if segue.identifier == "produkAdd"{
            
        }
    }
    
    fileprivate func delete(urlDel : String){
    self.request = Alamofire.request(urlDel, method: .delete, parameters: nil)
        if let request = request as? DataRequest {
            request.responseString { response in
                do{
                    let data = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as! [String: Any]
                    let Message = data["Message"] as! String
                    print(data)
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
                                self.performSegue(withIdentifier: "back", sender: Any?.self)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
