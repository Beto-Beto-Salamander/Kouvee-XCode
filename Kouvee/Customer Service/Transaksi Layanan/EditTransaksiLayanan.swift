//
//  EditTransaksiLayanan.swift
//  Kouvee
//
//  Created by Ryan Octavius on 30/04/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import UIKit
import Alamofire
class EditTransaksiLayanan: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var activeTextField = UITextField()
    var request: Alamofire.Request? {
        didSet {
                //oldValue?.cancel()
        }
    }
    var TransaksiL : TransaksiLayanan?
    var CS : Pegawai?
    var Kasir : Pegawai?
    var Hewans : Hewan?
    var idCS : String?
    var idKasir : String?
    var idHewan : String?
    var progres : String?
    var idProgres : String?
    var arrCS = [Pegawai]()
    var arrKasir = [Pegawai]()
    var arrHewan = [Hewan]()
    var arrProgres = ["Belum Selesai", "Selesai"]
    var urlPegawai = "http://www.kouvee.xyz/index.php/Pegawai"
    var urlTransaksi = "http://www.kouvee.xyz/index.php/TransaksiLayanan/"
    var urlHewan = "http://www.kouvee.xyz/index.php/Hewan/"
    var pickerCS = UIPickerView()
    var pickerKasir = UIPickerView()
    var pickerHewan = UIPickerView()
    var pickerProgres = UIPickerView()
    
    @IBOutlet weak var txtCS: UITextField!
    @IBOutlet weak var txtKasir: UITextField!
    @IBOutlet weak var txtHewan: UITextField!
    @IBOutlet weak var txtProgres: UITextField!
    @IBOutlet weak var labelID: UILabel!
    
    @IBOutlet weak var errCS: UILabel!
    @IBOutlet weak var errKasir: UILabel!
    @IBOutlet weak var errHewan: UILabel!
    @IBOutlet weak var errProgres: UILabel!
    
    
    @IBAction func btnSelesai(_ sender: Any) {
        if txtCS.text != "" && txtKasir.text != "" && txtHewan.text != "" {
                let alert = UIAlertController(title: "Ubah Data ?", message: nil , preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (UIAlertAction) in
                    if self.idCS == nil{
                        self.idCS = self.TransaksiL?.id_pegawai
                    }
                    if self.idKasir == nil{
                        self.idKasir = self.TransaksiL?.peg_id_pegawai
                    }
                    if self.idHewan == nil{
                        self.idHewan = self.TransaksiL?.id_hewan
                    }
                    if self.idProgres == nil{
                        self.idProgres = self.TransaksiL?.progres_layanan
                    }
                    
                    self.edit(id_cs: self.idCS!,
                              id_kasir: self.idKasir!,
                              id_hewan: self.idHewan!,
                              diskon: self.TransaksiL!.diskon_layanan,
                              status: self.TransaksiL!.status_layanan,
                              progres: self.idProgres!)
                }))
                alert.addAction(UIAlertAction(title: "Kembali", style: .destructive, handler: nil))
                self.present(alert,animated: true, completion: nil )
        }else{
            let alert = UIAlertController(title: "Form Invalid", message: "Semua bagian harus diisi", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{(UIAlertAction) in
                if self.txtCS.text == ""{
                    self.errCS.text = "Tidak boleh kosong"
                    self.txtCS.layer.borderWidth = 1
                    self.txtCS.layer.borderColor = UIColor.red.cgColor
                }
                if self.txtKasir.text == ""{
                    self.errKasir.text = "Tidak boleh kosong"
                    self.txtKasir.layer.borderWidth = 1
                    self.txtKasir.layer.borderColor = UIColor.red.cgColor
                }
                if self.txtHewan.text == ""{
                    self.errHewan.text = "Tidak boleh kosong"
                    self.txtHewan.layer.borderWidth = 1
                    self.txtHewan.layer.borderColor = UIColor.red.cgColor
                }
                if self.txtProgres.text == ""{
                    self.errProgres.text = "Tidak boleh kosong"
                    self.txtProgres.layer.borderWidth = 1
                    self.txtProgres.layer.borderColor = UIColor.red.cgColor
                }
            }))
            self.present(alert,animated: true, completion: nil )
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        performSegue(withIdentifier: "back", sender: Any?.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getHewan(urlString: urlHewan)
        getPegawai(urlString: urlPegawai)
        
        labelID.text = TransaksiL?.id_transaksi_layanan
        
        txtCS.delegate = self
        txtKasir.delegate = self
        txtHewan.delegate = self
        txtProgres.delegate = self
       
        errCS.text = ""
        errKasir.text = ""
        errHewan.text = ""
        errProgres.text = ""
        
        txtCS.addTarget(self, action: #selector(checkErr(textF:)), for: .editingChanged)
        txtKasir.addTarget(self, action: #selector(checkErr(textF:)), for: .editingChanged)
        txtHewan.addTarget(self, action: #selector(checkErr(textF:)), for: .editingChanged)
        txtProgres.addTarget(self, action: #selector(checkErr(textF:)), for: .editingChanged)
    
        
        pickerCS.delegate = self
        pickerCS.dataSource = self
        pickerKasir.delegate = self
        pickerKasir.dataSource = self
        pickerHewan.delegate = self
        pickerHewan.dataSource = self
        pickerProgres.delegate = self
        pickerProgres.dataSource = self
        
        pickerCS.isHidden = true
        pickerKasir.isHidden = true
        pickerHewan.isHidden = true
        pickerProgres.isHidden = true
        
        txtCS.clearsOnBeginEditing = false
        txtKasir.clearsOnBeginEditing = false
        txtHewan.clearsOnBeginEditing = false
        txtProgres.clearsOnBeginEditing = false
        
        txtCS.text = TransaksiL?.nama_cs
        txtKasir.text = TransaksiL?.nama_kasir
        txtHewan.text = TransaksiL?.nama_hewan
        
        if TransaksiL?.progres_layanan == "0"{
            txtProgres.text = "Belum Selesai"
        }else{
            txtProgres.text = "Selesai"
        }
        
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
        if activeTextField == txtCS ||
            activeTextField == txtKasir  {
            
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
        let t1 = txtCS!
        let t2 = txtKasir!
        let t3 = txtHewan!
        let t4 = txtProgres!
        let l1 = errCS!
        let l2 = errKasir!
        let l3 = errHewan!
        let l4 = errProgres!
        
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
        return 1
    }


    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerCS{
            return self.arrCS.count
        }else if pickerView == pickerKasir{
            return self.arrKasir.count
        }else if pickerView == pickerHewan{
            return self.arrHewan.count
        }else{
            return self.arrProgres.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int)-> String? {
        if pickerView == pickerCS{
            let title = self.arrCS[row].id_pegawai + ". " + self.arrCS[row].nama_pegawai
            return title
        }else if pickerView == pickerKasir{
            let title = self.arrKasir[row].id_pegawai + ". " + self.arrKasir[row].nama_pegawai
            return title
        }else if pickerView == pickerHewan{
            let title = self.arrHewan[row].id_hewan + ". " + self.arrHewan[row].nama_hewan
            return title
        }else{
            let title = self.arrProgres[row]
            return title
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == pickerCS{
            txtCS.text = arrCS[row].nama_pegawai
            self.idCS = arrCS[row].id_pegawai
            errCS.text = ""
            txtCS.layer.borderWidth = 0
            txtCS.layer.borderColor = nil
        }else if pickerView == pickerKasir{
            txtKasir.text = arrKasir[row].nama_pegawai
            self.idKasir = arrKasir[row].id_pegawai
            errKasir.text = ""
            txtKasir.layer.borderWidth = 0
            txtKasir.layer.borderColor = nil
        }else if pickerView == pickerHewan{
            txtHewan.text = arrHewan[row].nama_hewan
            self.idHewan = arrHewan[row].id_hewan
            errHewan.text = ""
            txtHewan.layer.borderWidth = 0
            txtHewan.layer.borderColor = nil
        }else{
            txtProgres.text = arrProgres[row]
            if txtProgres.text == "Belum Selesai"{
                self.idProgres = "0"
            }else{
                self.idProgres = "1"
            }
            errProgres.text = ""
            txtProgres.layer.borderWidth = 0
            txtProgres.layer.borderColor = nil
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "back"{
            guard let VC = segue.destination as? ViewTransaksiLayanan else {return}
            self.getTransaksi(urlString: urlTransaksi + self.TransaksiL!.id_transaksi_layanan)
            infoTransaksiLayanan.sharedInstance.lastID = TransaksiL!.id_transaksi_layanan
            VC.TransaksiL = self.TransaksiL
            
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtCS {
            
            let alert = UIAlertController(title: "Pilih CS", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
            pickerHewan.isHidden = true
            pickerKasir.isHidden = true
            pickerCS.isHidden = false
            pickerProgres.isHidden = true
            pickerCS.frame = CGRect(x: 5, y: 30, width: 250, height: 200)
            alert.view.addSubview(pickerCS)
                
                alert.addAction(UIAlertAction(title: "Urutkan ID", style: .default, handler: { (UIAlertAction) in
                    self.arrCS.sort(by: { $0.id_pegawai.localizedStandardCompare($1.id_pegawai) == .orderedAscending})
                    self.pickerCS.reloadAllComponents()
                    self.present(alert,animated: true, completion: nil )
                }))
                alert.addAction(UIAlertAction(title: "Urutkan Nama", style: .default, handler: { (UIAlertAction) in
                    self.arrCS.sort(by: { $0.nama_pegawai.localizedStandardCompare($1.nama_pegawai) == .orderedAscending})
                    self.pickerCS.reloadAllComponents()
                    self.present(alert,animated: true, completion: nil )
                }))
                alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: nil))
                self.present(alert,animated: true, completion: nil )
            
        }else if textField == txtKasir {
            let alert = UIAlertController(title: "Pilih Kasir", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
            pickerHewan.isHidden = true
            pickerKasir.isHidden = false
            pickerCS.isHidden = true
            pickerProgres.isHidden = true
            pickerKasir.frame = CGRect(x: 5, y: 30, width: 250, height: 200)
            alert.view.addSubview(pickerKasir)
                
                alert.addAction(UIAlertAction(title: "Urutkan ID", style: .default, handler: { (UIAlertAction) in
                    self.arrKasir.sort(by: { $0.id_pegawai.localizedStandardCompare($1.id_pegawai) == .orderedAscending})
                    self.pickerKasir.reloadAllComponents()
                    self.present(alert,animated: true, completion: nil )
                }))
                alert.addAction(UIAlertAction(title: "Urutkan Nama", style: .default, handler: { (UIAlertAction) in
                    self.arrKasir.sort(by: { $0.nama_pegawai.localizedStandardCompare($1.nama_pegawai) == .orderedAscending})
                    self.pickerKasir.reloadAllComponents()
                    self.present(alert,animated: true, completion: nil )
                }))
                alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: nil))
                self.present(alert,animated: true, completion: nil )
            
        }else if textField == txtHewan{
            let alert = UIAlertController(title: "Pilih Hewan", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
            pickerHewan.isHidden = false
            pickerKasir.isHidden = true
            pickerCS.isHidden = true
            pickerProgres.isHidden = true
            pickerHewan.frame = CGRect(x: 5, y: 30, width: 250, height: 200)
            alert.view.addSubview(pickerHewan)
                
                alert.addAction(UIAlertAction(title: "Urutkan ID", style: .default, handler: { (UIAlertAction) in
                    self.arrHewan.sort(by: { $0.id_hewan.localizedStandardCompare($1.id_hewan) == .orderedAscending})
                    self.pickerHewan.reloadAllComponents()
                    self.present(alert,animated: true, completion: nil )
                }))
                alert.addAction(UIAlertAction(title: "Urutkan Nama", style: .default, handler: { (UIAlertAction) in
                    self.arrHewan.sort(by: { $0.nama_hewan.localizedStandardCompare($1.nama_hewan) == .orderedAscending})
                    self.pickerHewan.reloadAllComponents()
                    self.present(alert,animated: true, completion: nil )
                }))
                alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: nil))
                self.present(alert,animated: true, completion: nil )
        }else if textField == txtProgres{
            let alert = UIAlertController(title: "Progres Layanan", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
            pickerHewan.isHidden = true
            pickerKasir.isHidden = true
            pickerCS.isHidden = true
            pickerProgres.isHidden = false
            pickerProgres.frame = CGRect(x: 5, y: 30, width: 250, height: 200)
            alert.view.addSubview(pickerProgres)
                
                alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: nil))
                self.present(alert,animated: true, completion: nil )
        }
        return true
    }
    
    fileprivate func getPegawai(urlString: String)
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
                        
                        let data = jsonObject["Data"] as? [AnyObject]
                        for obj in data! {
                            let d = Pegawai(json: obj as! [String:Any])
                            if d.jabatan == "CS"{
                                self.arrCS.append(d)
                            }else if d.jabatan == "Kasir"{
                                 self.arrKasir.append(d)
                            }
                           
                            DispatchQueue.main.async {
                                self.pickerKasir.reloadAllComponents()
                                self.pickerCS.reloadAllComponents()
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
    
    fileprivate func getHewan(urlString: String)
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
                        
                        let data = jsonObject["Data"] as? [AnyObject]
                        for obj in data! {
                            let d = Hewan(json: obj as! [String:Any])
                            if d.delete_at_hewan == "0000-00-00 00:00:00"{
                                 self.arrHewan.append(d)
                            }
                            
                            DispatchQueue.main.async {
                                self.pickerHewan.reloadAllComponents()
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
    
    fileprivate func edit(id_cs: String, id_kasir: String, id_hewan: String, diskon:String , status: String, progres: String){
    
        let parameters: [String: Any] = ["id_pegawai" : id_cs,
                                         "peg_id_pegawai" : id_kasir,
                                         "id_hewan" : id_hewan,
                                         "diskon_layanan" : diskon ,
                                         "status_layanan" : status ,
                                         "progres_layanan" : progres]
        print(id_cs)
        print(id_kasir)
        print(id_hewan)
        print(diskon)
        print(status)
        print(progres)
        guard let url = URL(string: urlTransaksi + self.TransaksiL!.id_transaksi_layanan ) else { return }
        
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
                            self.performSegue(withIdentifier: "back", sender: Any?.self)
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
    
    fileprivate func getTransaksi(urlString: String)
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
                        
                        let data = jsonObject["Data"] as? [AnyObject]
                        for obj in data! {
                            let d = TransaksiLayanan(json: obj as! [String:Any])
                            self.TransaksiL = d
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
