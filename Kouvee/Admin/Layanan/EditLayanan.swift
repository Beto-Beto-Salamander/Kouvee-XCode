//
//  EditLayanan.swift
//  Kouvee
//
//  Created by Ryan Octavius on 06/04/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import UIKit

class EditLayanan: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate {
    
    var arrUkuran = [Ukuran]()
    var arrJenis = [JenisHewan]()
    var pickerViewUkuran = UIPickerView()
    var pickerViewJenis = UIPickerView()
    var activeTextField = UITextField()
    
    var Layanans : Layanan?
    var Jenishewans : JenisHewan?
    var Ukurans : Ukuran?
        
    var harga : String?
    var idJenis : String?
    var idUkuran : String?
    
    var urlJenis = "http://www.kouvee.xyz/index.php/JenisHewan"
    var urlUkuran = "http://www.kouvee.xyz/index.php/Ukuran"
    var urlIDJenis = "http://www.kouvee.xyz/index.php/JenisHewan/"
    var urlIDUkuran = "http://www.kouvee.xyz/index.php/Ukuran/"
    var urlLayanan = "http://www.kouvee.xyz/index.php/Layanan/"
    
   
    
        @IBOutlet weak var txtNamaLayanan: UITextField!
        @IBOutlet weak var txtIDJenishewan: UITextField!
        @IBOutlet weak var txtIDUkuran: UITextField!
        @IBOutlet weak var txtHarga: UITextField!
        @IBOutlet weak var labelID: UILabel!
        @IBOutlet weak var errNama: UILabel!
        @IBOutlet weak var errHarga: UILabel!
        @IBOutlet weak var errJenis: UILabel!
        @IBOutlet weak var errUkuran: UILabel!
        @IBOutlet weak var outletSubmit: UIButton!
        @IBOutlet weak var outletTekan: UILabel!
    
        @IBAction func btnBack(_ sender: Any) {
            performSegue(withIdentifier: "back", sender: Any?.self)
        }
    
        @IBAction func btnSubmit(_ sender: Any) {
            if txtNamaLayanan.text != ""
                && txtIDJenishewan.text != ""
                && txtIDUkuran.text != ""
                && txtHarga.text != "" {
                    let alert = UIAlertController(title: "Ubah Data ?", message: nil , preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (UIAlertAction) in
                        if self.idJenis == nil{
                            self.idJenis = self.Layanans?.id_jenishewan
                        }
                        if self.idUkuran == nil{
                            self.idUkuran = self.Layanans?.id_ukuran
                        }
                        self.edit(id_ukuran: self.idUkuran!,
                                  id_jenishewan: self.idJenis!,
                                  id_pegawai: Info.sharedInstance.id_pegawai,
                                  harga_layanan: self.txtHarga.text!,
                                  nama_layanan: self.txtNamaLayanan.text!)
                    }))
                    alert.addAction(UIAlertAction(title: "Kembali", style: .destructive, handler: nil))
                    self.present(alert,animated: true, completion: nil )
            }else{
                let alert = UIAlertController(title: "Form Invalid", message: "Semua bagian harus diisi", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(UIAlertAction) in
                    if self.txtNamaLayanan.text == ""{
                        self.errNama.text = "Tidak boleh kosong"
                        self.txtNamaLayanan.layer.borderWidth = 1
                        self.txtNamaLayanan.layer.borderColor = UIColor.red.cgColor
                    }
                    if self.txtIDJenishewan.text == ""{
                        self.errJenis.text = "Tidak boleh kosong"
                        self.txtIDJenishewan.layer.borderWidth = 1
                        self.txtIDJenishewan.layer.borderColor = UIColor.red.cgColor
                    }
                    if self.txtIDUkuran.text == ""{
                        self.errUkuran.text = "Tidak boleh kosong"
                        self.txtIDUkuran.layer.borderWidth = 1
                        self.txtIDUkuran.layer.borderColor = UIColor.red.cgColor
                    }
                    if self.txtHarga.text == ""{
                        self.errHarga.text = "Tidak boleh kosong"
                        self.txtHarga.layer.borderWidth = 1
                        self.txtHarga.layer.borderColor = UIColor.red.cgColor
                    }
                }))
                self.present(alert,animated: true, completion: nil )
            }
        }
    
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            getJenis(urlString: urlJenis)
            getUkuran(urlString: urlUkuran)
            getIDjenis(url: urlIDJenis + Layanans!.jenis_hewan)
            getIDukuran(url: urlIDUkuran + Layanans!.ukuran)
            
            pickerViewUkuran.delegate = self
            pickerViewUkuran.dataSource = self
            pickerViewJenis.delegate = self
            pickerViewUkuran.dataSource = self
            
            pickerViewUkuran.isHidden = true
            pickerViewJenis.isHidden = true
            
            txtNamaLayanan.delegate = self
            txtIDJenishewan.delegate = self
            txtIDUkuran.delegate = self
            txtHarga.delegate = self
            
            errNama.text = ""
            errHarga.text = ""
            errJenis.text = ""
            errUkuran.text = ""
            
            txtNamaLayanan.clearsOnBeginEditing = false
            txtIDJenishewan.clearsOnBeginEditing = false
            txtIDUkuran.clearsOnBeginEditing = false
            
            txtNamaLayanan.text = Layanans?.nama_layanan
            txtHarga.text = Layanans?.harga_layanan.description
            labelID.text = Layanans!.id_layanan
            txtIDUkuran.text = Layanans?.ukuran
            txtIDJenishewan.text = Layanans?.jenis_hewan
            
            txtNamaLayanan.addTarget(self, action: #selector(checkErr(textF:)), for: .editingChanged)
            txtHarga.addTarget(self, action: #selector(checkErr(textF:)), for: .editingChanged)
            txtIDJenishewan.addTarget(self, action: #selector(checkErr(textF:)), for: .editingChanged)
            txtIDUkuran.addTarget(self, action: #selector(checkErr(textF:)), for: .editingChanged)
            txtHarga.addTarget(self, action: #selector(conv(textF:)), for: .editingDidEnd)
            
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
            if activeTextField == txtNamaLayanan ||
                activeTextField == txtIDJenishewan ||
                activeTextField == txtIDUkuran {
                
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
    
        @objc func conv (textF: UITextField){
            if textF == txtHarga{
                harga = textF.text!
                let number = (textF.text! as NSString).floatValue
                let formatter = NumberFormatter()
                formatter.locale = Locale(identifier: "id_ID") // Change this to another locale if you want to force a specific locale, otherwise this is redundant as the current locale is the default already
                formatter.numberStyle = .currency
                if let formattedNum = formatter.string(from: number as NSNumber) {
                    txtHarga.text = ("\(formattedNum)")
                }
            }
            
        }
    
        @objc func checkErr (textF : UITextField){
            let t1 = txtNamaLayanan!
            let t2 = txtHarga!
            let t3 = txtIDUkuran!
            let t4 = txtIDJenishewan!
            let l1 = errNama!
            let l2 = errHarga!
            let l3 = errUkuran!
            let l4 = errJenis!
            
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
                guard let VC = segue.destination as? ViewLayanan else {return}
                VC.Layanans = self.Layanans
                 
            }
            else if segue.identifier == "produkAdd"{
                
            }
        }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == pickerViewJenis {
            return 1
        }else{
            return 1
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerViewJenis{
            return self.arrJenis.count
        }
        else{
            return self.arrUkuran.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int)-> String? {
        if pickerView == pickerViewJenis{
            let title = self.arrJenis[row].id_jenishewan + ". " + self.arrJenis[row].jenishewan
            return title
        }
        else{
            let title = self.arrUkuran[row].id_ukuran + ". " + self.arrUkuran[row].ukuran
            return title
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == pickerViewJenis{
            txtIDJenishewan.text = arrJenis[row].jenishewan
            self.idJenis = arrJenis[row].id_jenishewan
            errJenis.text = ""
            txtIDJenishewan.layer.borderWidth = 0
            txtIDJenishewan.layer.borderColor = nil
        }
        else{
            txtIDUkuran.text = arrUkuran[row].ukuran
            self.idUkuran = arrUkuran[row].id_ukuran
            errUkuran.text = ""
            txtIDUkuran.layer.borderWidth = 0
            txtIDUkuran.layer.borderColor = nil
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtIDJenishewan {
            print("pertama")
            let alert = UIAlertController(title: "Jenis Hewan", message: "\n\n\n\n\n\n", preferredStyle: .alert)
            pickerViewUkuran.isHidden = true
            pickerViewJenis.isHidden = false
            pickerViewJenis.frame = CGRect(x: 5, y: 30, width: 250, height: 140)
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
            
        }else if textField == txtIDUkuran {
            let alert = UIAlertController(title: "Ukuran", message: "\n\n\n\n\n\n", preferredStyle: .alert)
            pickerViewJenis.isHidden = true
            pickerViewUkuran.isHidden = false
            pickerViewUkuran.frame = CGRect(x: 5, y: 30, width: 250, height: 140)
            alert.view.addSubview(pickerViewUkuran)
                
                alert.addAction(UIAlertAction(title: "Urutkan ID", style: .default, handler: { (UIAlertAction) in
                        self.arrUkuran.sort(by: { $0.id_ukuran.localizedStandardCompare($1.id_ukuran) == .orderedAscending})
                        self.pickerViewUkuran.reloadAllComponents()
                        self.present(alert,animated: true, completion: nil )
                    }))
                
                    alert.addAction(UIAlertAction(title: "Urutkan Ukuran", style: .default, handler: { (UIAlertAction) in
                        self.arrUkuran.sort(by: { $0.ukuran.lowercased() < $1.ukuran.lowercased() })
                         self.pickerViewUkuran.reloadAllComponents()
                         self.present(alert,animated: true, completion: nil )
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: nil))
                self.present(alert,animated: true, completion: nil )
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtHarga {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }else if textField == txtNamaLayanan{
            let allowedCharacters = CharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
        
    fileprivate func getIDjenis(url: String) {
        let url = URL(string: url)
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
                            if Jenis == nil {
                                print("Tidak ditemukan")
                            }
                            else{
                                for j in Jenis! {
                                    let j = JenisHewan(json: j as! [String:Any])
                                    self.Jenishewans = j
                                    DispatchQueue.main.async {
                                        self.txtIDJenishewan.text = self.Jenishewans?.jenishewan
                                    }
                                    self.Jenishewans?.printData()
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
    
    fileprivate func getIDukuran(url: String){
    let url = URL(string: url)
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
                        
                        let Ukur = jsonObject["Data"] as? [AnyObject]
                        if Ukur == nil {
                            print("Tidak ditemukan")
                        }
                        else{
                            for u in Ukur! {
                                let u = Ukuran(json: u as! [String:Any])
                                self.Ukurans = u
                                DispatchQueue.main.async {
                                    self.txtIDUkuran.text = self.Ukurans?.ukuran
                                }
                                self.Ukurans?.printData()
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
    
    fileprivate func getUkuran(urlString: String)
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
                        
                        let Uk = jsonObject["Data"] as? [AnyObject]
                        for obj in Uk! {
                            let u = Ukuran(json: obj as! [String:Any])
                            self.arrUkuran.append(u)
                            self.arrUkuran.sort(by: { $0.ukuran < $1.ukuran })
                            DispatchQueue.main.async {
                                self.pickerViewUkuran.reloadAllComponents()
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
    
    fileprivate func edit(id_ukuran: String, id_jenishewan: String, id_pegawai: String, harga_layanan: String, nama_layanan:String ){
        
        let parameters: [String: Any] = ["id_ukuran" :id_ukuran ,"id_jenishewan": id_jenishewan, "id_pegawai" :id_pegawai, "harga_layanan" : harga_layanan, "nama_layanan" : nama_layanan]
        
        guard let url = URL(string: urlLayanan + self.Layanans!.id_layanan ) else { return }
            
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
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: Any]
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
                            let alert = UIAlertController(title: "Data Berhasil Di Ubah", message: nil, preferredStyle: .alert)
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

        /*
        // MARK: - Navigation

        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
        }
        */
