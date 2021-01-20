//
//  ViewLayanan.swift
//  Kouvee
//
//  Created by Ryan Octavius on 06/04/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import UIKit
import Alamofire
class ViewLayanan: UIViewController {

    var request: Alamofire.Request? {
        didSet {
            //oldValue?.cancel()
        }
    }
    
    var urlDelete = "http://www.kouvee.xyz/index.php/Layanan/"
    
    @IBAction func opsi(_ sender: Any) {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Perbarui", style: .default, handler: {ACTION in
                self.performSegue(withIdentifier: "EditLayananSegue", sender: Any?.self)
            }))
            alert.addAction(UIAlertAction(title: "Hapus", style: .default, handler:{ ACTION in
                print("Hapus")
                let alert = UIAlertController(title: "Yakin ingin menghapus?", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ya", style: .default, handler: {ACTION in
                    self.delete(urlDel: self.urlDelete + self.Layanans!.id_layanan)
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
        @IBOutlet weak var labelDelete: UILabel!
        @IBOutlet weak var labelUpdate: UILabel!
        @IBOutlet weak var labelCreate: UILabel!
        @IBOutlet weak var labelHarga: UILabel!
        @IBOutlet weak var labelNamaPeg: UILabel!
        @IBOutlet weak var labelNama: UILabel!
        @IBOutlet weak var labelJenis: UILabel!
        @IBOutlet weak var labelUkuran: UILabel!
        @IBOutlet weak var labelID: UILabel!
    
        var Layanans : Layanan?
     
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            addShadowView(v: v)
            labelJenis.text = Layanans?.jenis_hewan
            labelUkuran.text = Layanans?.ukuran
            labelNama.text = Layanans?.nama_layanan
            labelNamaPeg.text = Layanans?.nama_pegawai
            
            let number = (Layanans!.harga_layanan as NSString).floatValue
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "id_ID")
            formatter.numberStyle = .currency
            let formattedNum = formatter.string(from: number as NSNumber)
            
            labelHarga.text = formattedNum!
            
            labelCreate.text = Layanans?.create_at_layanan
            labelUpdate.text = Layanans?.update_at_layanan
            labelDelete.text = Layanans?.delete_at_layanan
            labelID.text = Layanans!.id_layanan
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
        
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "EditLayananSegue"{
                guard let VC = segue.destination as? EditLayanan else {return}
                VC.Layanans = self.Layanans
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
    }

        /*
        // MARK: - Navigation

        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
        }
        */

