//
//  EditSupplier.swift
//  Kouvee
//
//  Created by Ryan Octavius on 06/04/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import UIKit

class EditSupplier: UIViewController ,UITextFieldDelegate {

 var Suppliers : Supplier?
 var activeTextField = UITextField()
 var urlSupplier = "http://www.kouvee.xyz/index.php/Supplier/"

     @IBOutlet weak var txtNama: UITextField!
     @IBOutlet weak var txtAlamat: UITextField!
     @IBOutlet weak var txtNomor: UITextField!
     @IBOutlet weak var labelID: UILabel!
     @IBOutlet weak var errNama: UILabel!
     @IBOutlet weak var errAlamat: UILabel!
     @IBOutlet weak var errNomor: UILabel!
     
    
     @IBAction func btnBack(_ sender: Any) {
         performSegue(withIdentifier: "back", sender: Any?.self)
     }
 
     @IBAction func btnSubmit(_ sender: Any) {
        if txtNama.text != "" && txtNomor.text != "" && txtAlamat.text != "" {
             if txtNomor.text!.count != 12{
                 let alert = UIAlertController(title: "Form Invalid", message: "Nomor Telepon Harus 12 Digit", preferredStyle: .alert)
                     alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: {(UIAlertAction) in
                         self.errNomor.text = "Nomor Telepon Harus 12 Digit"
                         self.txtNomor.layer.borderWidth = 1
                         self.txtNomor.layer.borderColor = UIColor.red.cgColor
                     }))
                     self.present(alert,animated: true, completion: nil )
             }else{
                 let alert = UIAlertController(title: "Ubah Data ?", message: nil , preferredStyle: .alert)
                 alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (UIAlertAction) in
                     
                    self.edit(namasupplier: self.txtNama.text!,             alamat: self.txtAlamat.text!,
                              nomor : self.txtNomor.text! , id_pegawai: Info.sharedInstance.id_pegawai)
                     self.performSegue(withIdentifier: "backs", sender: Any?.self)
                 }))
                 alert.addAction(UIAlertAction(title: "Kembali", style: .destructive, handler: nil))
                 self.present(alert,animated: true, completion: nil )
             }
         }else{
             let alert = UIAlertController(title: "Form Invalid", message: "Semua bagian harus diisi", preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(UIAlertAction) in
                if self.txtNama.text == ""{
                    self.errNama.text = "Tidak boleh kosong"
                    self.txtNama.layer.borderWidth = 1
                    self.txtNama.layer.borderColor = UIColor.red.cgColor
                }
                if self.txtNomor.text == ""{
                    self.errNomor.text = "Tidak boleh kosong"
                    self.txtNomor.layer.borderWidth = 1
                    self.txtNomor.layer.borderColor = UIColor.red.cgColor
                }
                if self.txtAlamat.text == ""{
                    self.errAlamat.text = "Tidak boleh kosong"
                    self.txtAlamat.layer.borderWidth = 1
                    self.txtAlamat.layer.borderColor = UIColor.red.cgColor
                }
                }))
             self.present(alert,animated: true, completion: nil )
         }
     }
 
     
     override func viewDidLoad() {
         super.viewDidLoad()
        
         
         txtNama.text = Suppliers?.nama_supplier
         txtAlamat.text = Suppliers?.alamat_supplier
         txtNomor.text = Suppliers?.phone_supplier
         labelID.text = Suppliers!.id_supplier
        
         txtNomor.delegate = self
         txtNama.delegate = self
         txtAlamat.delegate = self
        
         txtNama.clearsOnBeginEditing = false
         txtNomor.clearsOnBeginEditing = false
         txtAlamat.clearsOnBeginEditing = false
        
         txtNama.addTarget(self, action: #selector(checkErr(textF:)), for: .editingChanged)
         txtAlamat.addTarget(self, action: #selector(checkErr(textF:)), for: .editingChanged)
         txtNomor.addTarget(self, action: #selector(checkErr(textF:)), for: .editingChanged)
        
          errNama.text = ""
          errAlamat.text = ""
          errNomor.text = ""
        
          let center: NotificationCenter = NotificationCenter.default
          center.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
          center.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
          
          let tap = UITapGestureRecognizer(target: self, action: #selector(tapOccured(tap:)))
          view.addGestureRecognizer(tap)
        
         // Do any additional setup after loading the view.
     }
    
    @objc func tapOccured(tap: UITapGestureRecognizer){
        activeTextField.endEditing(true)
    }
    
    @objc func keyboardDidShow(notification: Notification) {
        if activeTextField == txtNama ||
            activeTextField == txtAlamat {
            
        }
        else{
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= 145
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if view.frame.origin.y != 0 {
            self.view.frame.origin.y += 145
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
     
    @objc func checkErr (textF : UITextField){
        let t1 = txtNama!
        let t2 = txtAlamat!
        let t3 = txtNomor!
        let l1 = errNama!
        let l2 = errAlamat!
        let l3 = errNomor!
        
        if textF == t1{
            if t1.text!.count == 0 {
                l1.text = "Tidak boleh kosong"
                t1.layer.borderWidth = 1
                t1.layer.borderColor = UIColor.red.cgColor
            }else{
                l1.text = ""
                t1.layer.borderWidth = 0
                t1.layer.borderColor = nil
            }
        }else if textF == t2{
            if t2.text!.count == 0 {
                l2.text = "Tidak boleh kosong"
                t2.layer.borderWidth = 1
                t2.layer.borderColor = UIColor.red.cgColor
            }else{
                l2.text = ""
                t2.layer.borderWidth = 0
                t2.layer.borderColor = nil
            }
        }else if textF == t3{
            if t3.text!.count == 0 {
                l3.text = "Tidak boleh kosong"
                t3.layer.borderWidth = 1
                t3.layer.borderColor = UIColor.red.cgColor
            }else{
                l3.text = ""
                t3.layer.borderWidth = 0
                t3.layer.borderColor = nil
            }
        }
    }
     
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "back"{
             guard let VC = segue.destination as? ViewSupplier else {return}
             VC.Suppliers = self.Suppliers
              
         }
         else if segue.identifier == "produkAdd"{
             
         }
     }
 
 func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
     if textField == txtNomor {
         let allowedCharacters = CharacterSet(charactersIn:"0123456789")
         let characterSet = CharacterSet(charactersIn: string)
         return allowedCharacters.isSuperset(of: characterSet)
     }
     else if textField == txtNama {
        let allowedCharacters = CharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
     }
     return true
 }
 
    fileprivate func edit(namasupplier: String, alamat: String, nomor: String, id_pegawai: String){
     
     let parameters: [String: Any] = ["nama_supplier" :namasupplier,
                                      "alamat_supplier" : alamat,
                                      "phone_supplier" : nomor,
                                      "id_pegawai" :id_pegawai]
     
     guard let url = URL(string: urlSupplier + self.Suppliers!.id_supplier ) else { return }
         
     var request = URLRequest(url: url)
     request.httpMethod = "PUT"
     request.addValue("application/json", forHTTPHeaderField: "Content-Type")
     guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
     request.httpBody = httpBody
         
     let session = URLSession.shared
     
     session.dataTask(with: request){ (data,response,err) in
         if let response = response{
                 print(response)
             }
         if let data = data{
             do{
                 let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                 let Message = json["Message"] as! String
                 print(json)
                 if Message != "Data Berhasil Di Ubah" {
                     DispatchQueue.main.async {
                         let alert = UIAlertController(title: "Gagal Mengubah Data", message: "Periksa Kembali Masukkan", preferredStyle: .alert)
                         alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: nil))
                         self.present(alert,animated: true, completion: nil )
                         }
                 }else if Message == "Data Berhasil Di Ubah" {
                     DispatchQueue.main.async {
                         let alert = UIAlertController(title: Message, message: nil, preferredStyle: .alert)
                         alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: {(UIAlertAction) in
                             self.performSegue(withIdentifier: "backs", sender: Any?.self)
                         }))
                         self.present(alert,animated: true, completion: nil )
                         }
                 }

             }catch{
                 print(error)
             }
             }
         }.resume()
     }
 }
