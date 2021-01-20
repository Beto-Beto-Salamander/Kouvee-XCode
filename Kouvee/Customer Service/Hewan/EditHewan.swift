//
//  EditHewan.swift
//  Kouvee
//
//  Created by Ryan Octavius on 08/04/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import UIKit
import Alamofire
class EditHewan: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    var activeTextField = UITextField()
    var request: Alamofire.Request? {
        didSet {
                //oldValue?.cancel()
        }
    }
    var Hewans : Hewan?
    var Jenishewans : JenisHewan?
    var Pelanggans : Pelanggan?
    var idJenis : String?
    var idPelanggan : String?
    var arrJenis = [JenisHewan]()
    var arrPelanggan = [Pelanggan]()
    var urlPelanggan = "http://www.kouvee.xyz/index.php/Pelanggan"
    var urlHewan = "http://www.kouvee.xyz/index.php/Hewan/"
    var urlJenis = "http://www.kouvee.xyz/index.php/JenisHewan"
    var pickerPelanggan = UIPickerView()
    var pickerViewJenis = UIPickerView()
    var pickerTgl = UIDatePicker()
    
    @IBOutlet weak var txtNama: UITextField!
    @IBOutlet weak var txtTanggal: UITextField!
    @IBOutlet weak var txtJenis: UITextField!
    @IBOutlet weak var txtPelanggan: UITextField!
    @IBOutlet weak var labelID: UILabel!
    @IBOutlet weak var errNama: UILabel!
    @IBOutlet weak var errJenis: UILabel!
    @IBOutlet weak var errCust: UILabel!
    @IBOutlet weak var errTgl: UILabel!
    
   
    @IBAction func btnBack(_ sender: Any) {
        performSegue(withIdentifier: "back", sender: Any?.self)
    }

    @IBAction func btnSubmit(_ sender: Any) {
        if txtNama.text != "" && txtTanggal.text != "" && txtJenis.text != "" && txtPelanggan.text != "" {
                let alert = UIAlertController(title: "Ubah Data ?", message: nil , preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (UIAlertAction) in
                    if self.idJenis == nil{
                        self.idJenis = self.Hewans?.id_jenishewan
                    }
                    if self.idPelanggan == nil{
                        self.idPelanggan = self.Hewans?.id_pelanggan
                    }
                    self.edit(nama: self.txtNama.text!,
                              id_jenis: self.idJenis!,
                              id_pelanggan: self.idPelanggan!,
                              tanggal: self.txtTanggal.text!,
                              id_pegawai: Info.sharedInstance.id_pegawai)
                }))
                alert.addAction(UIAlertAction(title: "Kembali", style: .destructive, handler: nil))
                self.present(alert,animated: true, completion: nil )
        }else{
            let alert = UIAlertController(title: "Form Invalid", message: "Semua bagian harus diisi", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{(UIAlertAction) in
                if self.txtNama.text == ""{
                    self.errNama.text = "Tidak boleh kosong"
                    self.txtNama.layer.borderWidth = 1
                    self.txtNama.layer.borderColor = UIColor.red.cgColor
                }
                if self.txtTanggal.text == ""{
                    self.errTgl.text = "Tidak boleh kosong"
                    self.txtTanggal.layer.borderWidth = 1
                    self.txtTanggal.layer.borderColor = UIColor.red.cgColor
                }
                if self.txtJenis.text == ""{
                    self.errJenis.text = "Tidak boleh kosong"
                    self.txtJenis.layer.borderWidth = 1
                    self.txtJenis.layer.borderColor = UIColor.red.cgColor
                }
                if self.txtPelanggan.text == ""{
                    self.errCust.text = "Tidak boleh kosong"
                    self.txtPelanggan.layer.borderWidth = 1
                    self.txtPelanggan.layer.borderColor = UIColor.red.cgColor
                }
            }))
            self.present(alert,animated: true, completion: nil )
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPelanggan(urlString: urlPelanggan)
        getJenis(urlString: urlJenis)
        txtNama.delegate = self
        txtJenis.delegate = self
        txtTanggal.delegate = self
        txtPelanggan.delegate = self
        pickerTgl.datePickerMode = .date
        pickerTgl.addTarget(self, action: #selector(AddHewan.dateChanged(datePicker: )), for: .valueChanged)
        
        errNama.text = ""
        errTgl.text = ""
        errJenis.text = ""
        errCust.text = ""
        
        txtNama.addTarget(self, action: #selector(checkErr(textF:)), for: .editingChanged)
        txtTanggal.addTarget(self, action: #selector(checkErr(textF:)), for: .editingChanged)
        txtJenis.addTarget(self, action: #selector(checkErr(textF:)), for: .editingChanged)
        txtPelanggan.addTarget(self, action: #selector(checkErr(textF:)), for: .editingChanged)
        
        pickerViewJenis.delegate=self
        pickerViewJenis.dataSource=self
        pickerPelanggan.delegate=self
        pickerPelanggan.dataSource=self
        
        pickerTgl.isHidden = true
        pickerViewJenis.isHidden = true
        pickerPelanggan.isHidden = true
        
        txtNama.clearsOnBeginEditing = false
        txtJenis.clearsOnBeginEditing = false
        txtTanggal.clearsOnBeginEditing = false
        txtPelanggan.clearsOnBeginEditing = false
        
        txtNama.text = Hewans?.nama_hewan
        txtJenis.text = Hewans?.jenishewan
        txtTanggal.text = Hewans?.tgl_lahir_hewan
        txtPelanggan.text = Hewans?.nama_pelanggan
        labelID.text = Hewans!.id_hewan
        
        
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
            activeTextField == txtJenis ||
            activeTextField == txtPelanggan {
            
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
        let t2 = txtPelanggan!
        let t3 = txtJenis!
        let t4 = txtTanggal!
        let l1 = errNama!
        let l2 = errCust!
        let l3 = errJenis!
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == pickerViewJenis{
            return 1
        }else{
            return 1
        }
    }


    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerViewJenis{
            return self.arrJenis.count
        }else{
            return self.arrPelanggan.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int)-> String? {
        if pickerView == pickerViewJenis{
            let title = self.arrJenis[row].id_jenishewan + ". " + self.arrJenis[row].jenishewan
            return title
        }else{
            let title = self.arrPelanggan[row].id_pelanggan + ". " + self.arrPelanggan[row].nama_pelanggan
            return title
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == pickerViewJenis{
            txtJenis.text = arrJenis[row].jenishewan
            self.idJenis = arrJenis[row].id_jenishewan
            errJenis.text = ""
            txtJenis.layer.borderWidth = 0
            txtJenis.layer.borderColor = nil
        }else{
            txtPelanggan.text = arrPelanggan[row].nama_pelanggan
            self.idPelanggan = arrPelanggan[row].id_pelanggan
            errCust.text = ""
            txtPelanggan.layer.borderWidth = 0
            txtPelanggan.layer.borderColor = nil
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "back"{
            guard let VC = segue.destination as? ViewHewan else {return}
            VC.Hewans = self.Hewans
             
        }
        else if segue.identifier == "produkAdd"{
            
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtNama {
           let allowedCharacters = CharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ")
           let characterSet = CharacterSet(charactersIn: string)
           return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtJenis {
            
            let alert = UIAlertController(title: "Jenis Hewan", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
            pickerTgl.isHidden = true
            pickerPelanggan.isHidden = true
            pickerViewJenis.isHidden = false
            pickerViewJenis.frame = CGRect(x: 5, y: 30, width: 250, height: 200)
            alert.view.addSubview(pickerViewJenis)
                
                alert.addAction(UIAlertAction(title: "Urutkan ID", style: .default, handler: { (UIAlertAction) in
                    self.arrJenis.sort(by: { $0.id_jenishewan.localizedStandardCompare($1.id_jenishewan) == .orderedAscending})
                    self.pickerViewJenis.reloadAllComponents()
                    self.present(alert,animated: true, completion: nil )
                }))
                alert.addAction(UIAlertAction(title: "Urutkan Jenis", style: .default, handler: { (UIAlertAction) in
                    self.arrJenis.sort(by: { $0.jenishewan.lowercased() < $1.jenishewan.lowercased() })
                    self.pickerViewJenis.reloadAllComponents()
                    self.present(alert,animated: true, completion: nil )
                }))
                alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: nil))
                self.present(alert,animated: true, completion: nil )
            
        }else if textField == txtTanggal {
            let alert = UIAlertController(title: "Tanggal Lahir", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
            pickerViewJenis.isHidden = true
            pickerPelanggan.isHidden = true
            pickerTgl.isHidden = false
            pickerTgl.frame = CGRect(x: 5, y: 35, width: 250, height: 200)
            alert.view.addSubview(pickerTgl)
                
            alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: {(UIAlertAction) in
                    self.dateChanged(datePicker: self.pickerTgl)
            }))
            
            self.present(alert,animated: true, completion: nil )
            
        }else if textField == txtPelanggan{
            let alert = UIAlertController(title: "Pelanggan", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
            pickerTgl.isHidden = true
            pickerPelanggan.isHidden = false
            pickerViewJenis.isHidden = true
            pickerPelanggan.frame = CGRect(x: 5, y: 30, width: 250, height: 200)
            alert.view.addSubview(pickerPelanggan)
                
            alert.addAction(UIAlertAction(title: "Urutkan ID", style: .default, handler: { (UIAlertAction) in
                    self.arrPelanggan.sort(by: { $0.id_pelanggan.localizedStandardCompare($1.id_pelanggan) == .orderedAscending })
                    self.pickerPelanggan.reloadAllComponents()
                    self.present(alert,animated: true, completion: nil )
            }))
            alert.addAction(UIAlertAction(title: "Urutkan Nama", style: .default, handler: { (UIAlertAction) in
                self.arrPelanggan.sort(by: { $0.nama_pelanggan.lowercased() < $1.nama_pelanggan.lowercased() })
                    self.pickerPelanggan.reloadAllComponents()
                    self.present(alert,animated: true, completion: nil )
                
            }))
            alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: nil))
            self.present(alert,animated: true, completion: nil )
        }
        return true
    }
    
    @objc func dateChanged(datePicker : UIDatePicker){
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd"
      txtTanggal.text = formatter.string(from: pickerTgl.date)
      errTgl.text = ""
      txtTanggal.layer.borderWidth = 0
      txtTanggal.layer.borderColor = nil
      self.view.endEditing(true)
    }

    fileprivate func getJenis(urlString: String)
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
                        
                        let Jenis = jsonObject["Data"] as? [AnyObject]
                        for obj in Jenis! {
                            let j = JenisHewan(json: obj as! [String:Any])
                            self.arrJenis.append(j)
                            self.arrJenis.sort(by: { $0.jenishewan < $1.jenishewan })
                            DispatchQueue.main.async {
                                self.pickerViewJenis.reloadAllComponents()
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
    
    fileprivate func getPelanggan(urlString: String)
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
                        
                        let Cust = jsonObject["Data"] as? [AnyObject]
                        for obj in Cust! {
                            let p = Pelanggan(json: obj as! [String:Any])
                            self.arrPelanggan.append(p)
                            self.arrPelanggan.sort(by: { $0.nama_pelanggan < $1.nama_pelanggan })
                            DispatchQueue.main.async {
                                self.pickerViewJenis.reloadAllComponents()
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
    
    
    fileprivate func edit(nama: String, id_jenis: String, id_pelanggan: String, tanggal:String , id_pegawai: String){
    
    let parameters: [String: Any] = ["nama_hewan" :nama,
                                     "id_jenishewan" : id_jenis,
                                     "id_pelanggan" : id_pelanggan,
                                     "tgl_lahir_hewan" : tanggal ,
                                     "id_pegawai" :id_pegawai]
    
    guard let url = URL(string: urlHewan + self.Hewans!.id_hewan ) else { return }
        
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
