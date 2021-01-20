//
//  AddPegawai.swift
//  Kouvee
//
//  Created by Ryan Octavius on 15/06/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import UIKit
import Alamofire
class AddPegawai: UIViewController ,UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource {
    var request: Alamofire.Request? {
           didSet {
                   //oldValue?.cancel()
           }
       }
var arrJabatan = ["Admin","CS","Kasir"]
var pickerJabatan = UIPickerView()
var pickerTgl = UIDatePicker()
var Employee : Pegawai?
var activeTextField = UITextField()
var urlPegawai = "http://www.kouvee.xyz/index.php/Pegawai"

    @IBOutlet weak var txtNama: UITextField!
    @IBOutlet weak var txtAlamat: UITextField!
    @IBOutlet weak var txtNomor: UITextField!
    @IBOutlet weak var txtTanggal: UITextField!
    @IBOutlet weak var txtJabatan: UITextField!
    @IBOutlet weak var errNama: UILabel!
    @IBOutlet weak var errAlamat: UILabel!
    @IBOutlet weak var errNomor: UILabel!
    @IBOutlet weak var errTanggal: UILabel!
    @IBOutlet weak var errJabatan: UILabel!
    
    @IBAction func btnBack(_ sender: Any) {
        performSegue(withIdentifier: "back", sender: Any?.self)
    }

    @IBAction func btnSubmit(_ sender: Any) {
        if txtNama.text != "" && txtNomor.text != "" && txtAlamat.text != "" && txtTanggal.text != "" && txtJabatan.text != "" {
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
                              tgl: self.txtTanggal.text!,
                              jabatan: self.txtJabatan.text!)
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
                    self.errTanggal.text = "Tidak boleh kosong"
                    self.txtTanggal.layer.borderWidth = 1
                    self.txtTanggal.layer.borderColor = UIColor.red.cgColor
                }
                if self.txtJabatan.text == ""{
                    self.errJabatan.text = "Tidak boleh kosong"
                    self.txtJabatan.layer.borderWidth = 1
                    self.txtJabatan.layer.borderColor = UIColor.red.cgColor
                }
            }))
            self.present(alert,animated: true, completion: nil )
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerTgl.datePickerMode = .date
        pickerTgl.addTarget(self, action: #selector(AddPegawai.dateChanged(datePicker: )), for: .valueChanged)
        
        pickerJabatan.dataSource = self
        pickerJabatan.delegate = self
        
        txtNomor.delegate = self
        txtNama.delegate = self
        txtAlamat.delegate = self
        txtTanggal.delegate = self
        txtJabatan.delegate = self
        
        txtNama.clearsOnBeginEditing = false
        txtNomor.clearsOnBeginEditing = false
        txtAlamat.clearsOnBeginEditing = false
        txtTanggal.clearsOnBeginEditing = false
        txtJabatan.clearsOnBeginEditing = false
        
        
        txtNama.addTarget(self, action: #selector(checkErr(textF:)), for: .editingChanged)
        txtAlamat.addTarget(self, action: #selector(checkErr(textF:)), for: .editingChanged)
        txtNomor.addTarget(self, action: #selector(checkErr(textF:)), for: .editingChanged)
        txtTanggal.addTarget(self, action: #selector(checkErr(textF:)), for: .editingChanged)
        txtJabatan.addTarget(self, action: #selector(checkErr(textF:)), for: .editingChanged)
        errNama.text = ""
        errAlamat.text = ""
        errNomor.text = ""
        errTanggal.text = ""
        errJabatan.text = ""
        
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }


    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arrJabatan.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int)-> String? {
        return self.arrJabatan[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
            txtJabatan.text = arrJabatan[row]
            errJabatan.text = ""
            txtJabatan.layer.borderWidth = 0
            txtJabatan.layer.borderColor = nil
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
        let t5 = txtJabatan!
        let l1 = errNama!
        let l2 = errAlamat!
        let l3 = errNomor!
        let l4 = errTanggal!
        let l5 = errJabatan!
        
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
        }else if textF == t5{
            if t5.text!.count == 0 {
                l5.text = "Tidak boleh kosong"
                t5.layer.borderWidth = 1
                t5.layer.borderColor = UIColor.red.cgColor
            }else{
                l5.text = ""
                t5.layer.borderWidth = 0
                t5.layer.borderColor = nil
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "back"{
            guard let VC = segue.destination as? FetchPegawai else {return}
           
             
        }
        else if segue.identifier == "produkAdd"{
            
        }
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtJabatan {
            
            let alert = UIAlertController(title: "Jabatan", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
            pickerTgl.isHidden = true
            pickerJabatan.isHidden = false
            pickerJabatan.frame = CGRect(x: 5, y: 30, width: 250, height: 200)
            alert.view.addSubview(pickerJabatan)
                
            alert.addAction(UIAlertAction(title: "Tutup", style: .destructive, handler: nil))
            self.present(alert,animated: true, completion: nil )
            
        }else if textField == txtTanggal {
            let alert = UIAlertController(title: "Tanggal Lahir", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
            pickerJabatan.isHidden = true
            pickerTgl.isHidden = false
            pickerTgl.frame = CGRect(x: 5, y: 35, width: 250, height: 200)
            alert.view.addSubview(pickerTgl)
                
            alert.addAction(UIAlertAction(title: "Tutup", style: .destructive, handler: {(UIAlertAction) in
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
      errTanggal.text = ""
      txtTanggal.layer.borderWidth = 0
      txtTanggal.layer.borderColor = nil
      self.view.endEditing(true)
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
    
    fileprivate func post(nama: String, alamat: String, nomor: String, tgl : String, jabatan: String){
    
    let parameters: [String: Any] = ["nama_pegawai" :nama,
    "alamat_pegawai" : alamat,
    "phone_pegawai" : nomor,
    "tgl_lahir_pegawai" : tgl,
    "jabatan" : jabatan
    ]
    
    self.request = Alamofire.request(urlPegawai, method: .post, parameters: parameters)
        if let request = request as? DataRequest {
            request.responseString { response in
                do{
                    let data = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as! [String: Any]
                    let Message = data["Message"] as! String
                    print(data)
                    if Message != "Berhasil Menambahkan Data" {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Gagal Menambahkan Data", message: "Periksa Kembali Masukkan", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: nil))
                            self.present(alert,animated: true, completion: nil )
                            }
                    }else if Message == "Berhasil Menambahkan Data" {
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
