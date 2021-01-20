//
//  AddJenishewan.swift
//  Kouvee
//
//  Created by Ryan Octavius on 06/04/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import UIKit
import Alamofire
class AddJenishewan: UIViewController , UITextFieldDelegate {

    var request: Alamofire.Request? {
        didSet {
                //oldValue?.cancel()
        }
    }
    
 var Jenishewans : JenisHewan?
 var activeTextField = UITextField()
 var urlJenis = "http://www.kouvee.xyz/index.php/JenisHewan"

     @IBOutlet weak var txtNamaJenis: UITextField!
     @IBOutlet weak var errNama: UILabel!
     @IBAction func btnBack(_ sender: Any) {
         performSegue(withIdentifier: "back", sender: Any?.self)
     }
 
     @IBAction func btnSubmit(_ sender: Any) {
         if txtNamaJenis.text != "" {
             if txtNamaJenis.text!.count <= 3{
                 let alert = UIAlertController(title: "Form Invalid", message: "Panjang karakter minimal 3 untuk nama", preferredStyle: .alert)
                     alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                     self.present(alert,animated: true, completion: nil )
             }else{
                 let alert = UIAlertController(title: "Simpan Data ?", message: nil , preferredStyle: .alert)
                 alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (UIAlertAction) in
                     
                    self.post(jenishewan: self.txtNamaJenis.text!, id_pegawai: Info.sharedInstance.id_pegawai)
                 }))
                 alert.addAction(UIAlertAction(title: "Kembali", style: .destructive, handler: nil))
                 self.present(alert,animated: true, completion: nil )
             }
         }else{
             let alert = UIAlertController(title: "Form Invalid", message: "Semua bagian harus diisi", preferredStyle: .alert)
             alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(UIAlertAction) in
                if self.txtNamaJenis.text == ""{
                    self.errNama.text = "Tidak boleh kosong"
                    self.txtNamaJenis.layer.borderWidth = 1
                    self.txtNamaJenis.layer.borderColor = UIColor.red.cgColor
                }
             }))
             self.present(alert,animated: true, completion: nil )
         }
     }
 
     
     override func viewDidLoad() {
         super.viewDidLoad()
        
         txtNamaJenis.delegate = self
        
         txtNamaJenis.addTarget(self, action: #selector(checkErr(textF:)), for: .editingChanged)
        
         txtNamaJenis.clearsOnBeginEditing = false
        
         errNama.text = ""
        
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
        if view.frame.origin.y == 0{
            self.view.frame.origin.y -= 145
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
        let t1 = txtNamaJenis!
        let l1 = errNama!
        
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
        }
    }
     
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "back"{
             guard let VC = segue.destination as? FetchJenisHewan else {return}
           
              
         }
         else if segue.identifier == "produkAdd"{
             
         }
     }
 
 func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
     if textField == txtNamaJenis {
         let allowedCharacters = CharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
         let characterSet = CharacterSet(charactersIn: string)
         return allowedCharacters.isSuperset(of: characterSet)
     }
     return true
 }
    
 fileprivate func post(jenishewan: String, id_pegawai: String){
     
     let parameters: [String: Any] = ["jenishewan" :jenishewan, "id_pegawai" :id_pegawai]
     print("inijenis",jenishewan)
    print("inipeg",id_pegawai)
     self.request = Alamofire.request(urlJenis, method: .post, parameters: parameters)
         if let request = request as? DataRequest {
             request.responseString { response in
                 do{
                     let data = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as! [String: Any]
                     let Message = data["Message"] as! String
                     print(data)
                     if Message != "Berhasil" {
                         DispatchQueue.main.async {
                             let alert = UIAlertController(title: "Gagal Menambahkan Data", message: "Periksa Kembali Masukkan", preferredStyle: .alert)
                             alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: nil))
                             self.present(alert,animated: true, completion: nil )
                             }
                     }else if Message == "Berhasil" {
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
