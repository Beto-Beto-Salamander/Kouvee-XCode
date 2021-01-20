//
//  ViewUkuran.swift
//  Kouvee
//
//  Created by Ryan Octavius on 06/04/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import UIKit
import Alamofire
class ViewUkuran: UIViewController {

    var request: Alamofire.Request? {
        didSet {
            //oldValue?.cancel()
        }
    }
    
    var urlDelete = "http://www.kouvee.xyz/index.php/Ukuran/"
    
    @IBAction func opsi(_ sender: Any) {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Perbarui", style: .default, handler: {ACTION in
                self.performSegue(withIdentifier: "EditUkuranSegue", sender: Any?.self)
            }))
            alert.addAction(UIAlertAction(title: "Hapus", style: .default, handler:{ ACTION in
                print("Hapus")
                let alert = UIAlertController(title: "Yakin ingin menghapus?", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ya", style: .default, handler: {ACTION in
                    self.delete(urlDel: self.urlDelete + self.Ukurans!.id_ukuran)
                    
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
        @IBOutlet weak var labelNamaPeg: UILabel!
        @IBOutlet weak var labelNama: UILabel!
        @IBOutlet weak var labelID: UILabel!
    
        var Ukurans : Ukuran?
     
        
        override func viewDidLoad() {
            super.viewDidLoad()
            labelNama.text = Ukurans?.ukuran
            labelCreate.text = Ukurans?.create_at_ukuran
            labelUpdate.text = Ukurans?.update_at_ukuran
            labelDelete.text = Ukurans?.delete_at_ukuran
            labelNamaPeg.text = Ukurans?.nama_pegawai
            labelID.text = Ukurans!.id_ukuran
            addShadowView(v: v)
            
            
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
            if segue.identifier == "EditUkuranSegue"{
                guard let VC = segue.destination as? EditUkuran else {return}
                VC.Ukurans = self.Ukurans
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
