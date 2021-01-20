//
//  ViewController.swift
//  Kouvee
//
//  Created by Ryan Octavius on 09/03/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import UIKit

class LogIn: UIViewController, UITextFieldDelegate {

    var Pegawais : Pegawai? = nil
    var activeTextField = UITextField()
    @IBOutlet weak var v: UIView!
    @IBOutlet weak var txtNama: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var errNama: UILabel!
    @IBOutlet weak var errPass: UILabel!
    
    let URL_JSON = "http://kouvee.xyz/index.php/Pegawai/"
    
    @IBAction func btnBack(_ sender: Any) {
        performSegue(withIdentifier: "back", sender: Any?.self)
    }
    
    @IBAction func btnMasuk(_ sender: Any) {
        self.getJson(urlString: URL_JSON + txtNama.text!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errNama.text = ""
        errPass.text = ""
        
        txtNama.delegate = self
        txtPassword.delegate = self
        
        txtNama.addTarget(self, action: #selector(checkErr(textF:)), for: .editingChanged)
        txtPassword.addTarget(self, action: #selector(checkErr(textF:)), for: .editingChanged)
        
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapOccured(tap:)))
        view.addGestureRecognizer(tap)
        
        addShadow(v: v)
    }
    
    @objc func tapOccured(tap: UITapGestureRecognizer){
        activeTextField.endEditing(true)
    }
    
    @objc func keyboardDidShow(notification: Notification) {
        if activeTextField == txtNama{
            
        }
        else{
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= 145
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if view.frame.origin.y != 0{
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
        let t2 = txtPassword!
        let l1 = errNama!
        let l2 = errPass!
        
        if textF == t1{
            if t1.text!.count == 0 {
                l1.text = "Tidak Boleh Kosong"
                t1.layer.borderWidth = 1
                t1.layer.borderColor = UIColor.red.cgColor
            }else{
                l1.text = ""
                t1.layer.borderWidth = 0
                t1.layer.borderColor = nil
            }
        }else if textF == t2{
            if t2.text!.count == 0 {
                l2.text = "Tidak Boleh Kosong"
                t2.layer.borderWidth = 1
                t2.layer.borderColor = UIColor.red.cgColor
            }else{
                l2.text = ""
                t2.layer.borderWidth = 0
                t2.layer.borderColor = nil
            }
        }
    }
    
    func verify(){
        DispatchQueue.main.async(execute: {
            if self.txtNama.text! != "" && self.txtPassword.text! != ""{
                if self.txtPassword.text! == self.Pegawais?.password{
                        let alert = UIAlertController(title: "Selamat Datang " + self.Pegawais!.nama_pegawai, message: "Role: " + self.Pegawais!.jabatan, preferredStyle: .alert)

                        alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: {ACTION in
                            Info.sharedInstance.nama_pegawai = self.Pegawais!.nama_pegawai
                            Info.sharedInstance.id_pegawai = self.Pegawais!.id_pegawai
                            Info.sharedInstance.jabatan = self.Pegawais!.jabatan
                            if self.Pegawais!.jabatan == "Admin"{
                                self.performSegue(withIdentifier: "masukAdmin", sender: Any?.self)
                            }
                            else if self.Pegawais!.jabatan == "CS"{
                                self.performSegue(withIdentifier: "masukCS", sender: Any?.self)
                            }
                            else if self.Pegawais!.jabatan == "Kasir"{
                                self.performSegue(withIdentifier: "masukKasir", sender: Any?.self)
                                
                            }
                        }))
                        self.present(alert, animated: true)
                }
                else{
                    let alert = UIAlertController(title: "Invalid Login" , message: "Password Salah", preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "Kembali", style: .default, handler: {ACTION in
                        self.errPass.text = "Password Salah"
                        self.txtPassword.layer.borderWidth = 1
                        self.txtPassword.layer.borderColor = UIColor.red.cgColor
                    }))
                    self.present(alert, animated: true)
                }
            }else{
                let alert = UIAlertController(title: "Invalid Login" , message: "Nama Pegawai dan Password harus diisi", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Kembali", style: .default, handler: {ACTION in
                    if self.txtNama.text == ""{
                        self.txtNama.layer.borderWidth = 1
                        self.txtNama.layer.borderColor = UIColor.red.cgColor
                        self.errNama.text = "Tidak Boleh Kosong"
                    }
                    if self.txtPassword.text == ""{
                        self.txtPassword.layer.borderWidth = 1
                        self.txtPassword.layer.borderColor = UIColor.red.cgColor
                        self.errPass.text = "Tidak Boleh Kosong"
                    }
                    
                    
                }))
                self.present(alert, animated: true)
            }
                
        })
    }
    
    func addShadow(v : UIView){
         v.layer.cornerRadius = 10
         v.layer.shadowColor = UIColor.lightGray.cgColor
         v.layer.shadowOffset = .zero
         v.layer.shadowOpacity = 0.4
         v.layer.shadowRadius = 5
         v.layer.shouldRasterize = true
         v.layer.rasterizationScale = true ? UIScreen.main.scale : 1
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
                        
                            let Peg = jsonObject["Data"] as? [AnyObject]
                            if Peg == nil {
                                DispatchQueue.main.async {
                                    let alert = UIAlertController(title: "Invalid Login" , message: "Nama Pegawai Tidak Ditemukan", preferredStyle: .alert)

                                    alert.addAction(UIAlertAction(title: "Kembali", style: .default, handler: {ACTION in
                                        self.errNama.text = "Nama Pegawai Tidak Ditemukan"
                                        self.txtNama.layer.borderWidth = 1
                                        self.txtNama.layer.borderColor = UIColor.red.cgColor
                                    }))
                                    self.present(alert, animated: true)
                                }
                            }else{
                                for pro in Peg! {
                                let p = Pegawai(json: pro as! [String:Any])
                                self.Pegawais = p
                                self.Pegawais?.printData()
                                self.verify()
                            }
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

