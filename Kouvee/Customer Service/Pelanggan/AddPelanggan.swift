//
//  AddPelanggan.swift
//  Kouvee
//
//  Created by Ryan Octavius on 08/04/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import UIKit
import Alamofire
class AddPelanggan: UIViewController ,UITextFieldDelegate {
    var request: Alamofire.Request? {
           didSet {
                   //oldValue?.cancel()
           }
       }
    var Pelanggans : Pelanggan?
    var activeTextField = UITextField()
    var urlPelanggan = "http://www.kouvee.xyz/index.php/Pelanggan"
    var pickerTgl = UIDatePicker()
    @IBOutlet weak var txtNama: UITextField!
    @IBOutlet weak var txtAlamat: UITextField!
    @IBOutlet weak var txtNomor: UITextField!
    @IBOutlet weak var txtTanggal: UITextField!
    
    @IBOutlet weak var errNama: UILabel!
    @IBOutlet weak var errAlamat: UILabel!
    @IBOutlet weak var errNomor: UILabel!
    @IBOutlet weak var errTgl: UILabel!
    
    
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
                let alert = UIAlertController(title: "Simpan Data ?", message: nil , preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (UIAlertAction) in
                    
                    self.post(nama: self.txtNama.text!,
                              alamat: self.txtAlamat.text!,
                              nomor: self.txtNomor.text!,
                              tanggal: self.txtTanggal.text!,
                              id_pegawai: Info.sharedInstance.id_pegawai)
                    self.performSegue(withIdentifier: "back", sender: Any?.self)
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
                if self.txtTanggal.text == ""{
                    self.errTgl.text = "Tidak boleh kosong"
                    self.txtTanggal.layer.borderWidth = 1
                    self.txtTanggal.layer.borderColor = UIColor.red.cgColor
                }
            }))
            self.present(alert,animated: true, completion: nil )
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtTanggal.delegate = self
        txtNomor.delegate = self
        txtNama.delegate = self
        txtAlamat.delegate = self
        
        pickerTgl.datePickerMode = .date
        pickerTgl.addTarget(self, action: #selector(dateChanged(datePicker: )), for: .valueChanged)
        
        errNama.text = ""
        errAlamat.text = ""
        errNomor.text = ""
        errTgl.text = ""
        
        txtNama.clearsOnBeginEditing = false
        txtNomor.clearsOnBeginEditing = false
        txtTanggal.clearsOnBeginEditing = false
        txtAlamat.clearsOnBeginEditing = false
        txtTanggal.clearsOnBeginEditing = false
        
        txtNama.addTarget(self, action: #selector(checkErr(textF:)), for: .editingChanged)
        txtNomor.addTarget(self, action: #selector(checkErr(textF:)), for: .editingChanged)
        txtAlamat.addTarget(self, action: #selector(checkErr(textF:)), for: .editingChanged)
        txtTanggal.addTarget(self, action: #selector(checkErr(textF:)), for: .editingChanged)
        
        pickerTgl.isHidden = true
        
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
            activeTextField == txtTanggal {
            
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
        let t4 = txtTanggal!
        let l1 = errNama!
        let l2 = errAlamat!
        let l3 = errNomor!
        let l4 = errTgl!
        
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
        }else if textF == t4{
            if t4.text!.count == 0 {
                l4.text = "Tidak boleh kosong"
                t4.layer.borderWidth = 1
                t4.layer.borderColor = UIColor.red.cgColor
            }else{
                l4.text = ""
                t4.layer.borderWidth = 0
                t4.layer.borderColor = nil
            }
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "back"{
            guard let VC = segue.destination as? FetchPelanggan else {return}
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtNomor {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }else if textField == txtNama {
           let allowedCharacters = CharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
           let characterSet = CharacterSet(charactersIn: string)
           return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtTanggal {
        let alert = UIAlertController(title: "Tanggal Lahir", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        pickerTgl.isHidden = false
        pickerTgl.frame = CGRect(x: 5, y: 35, width: 250, height: 200)
        alert.view.addSubview(pickerTgl)
            alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: { (UIAlertAction) in
                self.dateChanged(datePicker: self.pickerTgl)
            }))
            self.present(alert,animated: true, completion: nil )
        }
        return true
    }
    
    @objc func dateChanged(datePicker : UIDatePicker){
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd"
      txtTanggal.text = formatter.string(from: pickerTgl.date)
      self.view.endEditing(true)
    }
    
    fileprivate func post(nama: String, alamat: String, nomor: String, tanggal: String, id_pegawai: String){

        let parameters: [String: Any] = ["nama_pelanggan" :nama,
                                         "alamat_pelanggan" : alamat,
                                         "phone_pelanggan" : nomor,
                                         "tgl_lahir_pelanggan" : tanggal,
                                         "id_pegawai" :id_pegawai]

        self.request = Alamofire.request(urlPelanggan, method: .post, parameters: parameters)
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
