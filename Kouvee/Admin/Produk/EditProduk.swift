//
//  EditProduk.swift
//  Kouvee
//
//  Created by Ryan Octavius on 16/03/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
class EditProduk: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate  {
    
    var request: Alamofire.Request? {
        didSet {
            //oldValue?.cancel()
        }
    }
    var activeTextField = UITextField()
    var click : Int = 0
    var Produks : Produk?
    var hargaBeli : String!
    var hargaJual : String!
    var nama_img : String!
    var url = "http://kouvee.xyz/index.php/Produk/"
    var fullp : String!
    @IBOutlet weak var txtNamaProduk: UITextField!
    @IBOutlet weak var txtStock: UITextField!
    @IBOutlet weak var txtMinStock: UITextField!
    @IBOutlet weak var txtHargaJual: UITextField!
    @IBOutlet weak var txtHargaBeli: UITextField!
    @IBOutlet weak var imgProduk: UIImageView!
    @IBOutlet weak var labelID: UILabel!
    @IBOutlet weak var txtSatuan: UITextField!
    @IBOutlet weak var errNama: UILabel!
    @IBOutlet weak var errSt: UILabel!
    @IBOutlet weak var errJual: UILabel!
    @IBOutlet weak var errBeli: UILabel!
    @IBOutlet weak var errGambar: UILabel!
    
    @IBAction func btnEdit(_ sender: Any) {
        if txtNamaProduk.text != ""
            && txtStock.text != ""
            && txtMinStock.text != ""
            && txtHargaJual.text != ""
            && txtHargaBeli.text != ""
            && txtSatuan.text != ""
            && imgProduk.image != nil{
                let alert = UIAlertController(title: "Ubah Data ?", message: nil , preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ (UIAlertAction) in
                    if self.hargaJual == nil{
                        self.hargaJual = self.Produks?.harga_jual.description
                    }
                    if self .hargaBeli == nil{
                        self.hargaBeli = self.Produks?.harga_beli.description
                    }
                    self.edit(nama: self.txtNamaProduk.text!,
                              id_peg: Info.sharedInstance.id_pegawai,
                              stock: self.txtStock.text!,
                              min_stock: self.txtMinStock.text!,
                              satuan: self.txtSatuan.text!,
                              beli: self.hargaBeli.description,
                              jual: self.hargaJual.description)
                }))
                alert.addAction(UIAlertAction(title: "Kembali", style: .destructive, handler: nil))
                self.present(alert,animated: true, completion: nil )
        }else{
            let alert = UIAlertController(title: "Form Invalid", message: "Semua bagian harus diisi", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(UIAlertAction) in
                if self.txtNamaProduk.text == ""{
                    self.errNama.text = "Tidak boleh kosong"
                    self.txtNamaProduk.layer.borderWidth = 1
                    self.txtNamaProduk.layer.borderColor = UIColor.red.cgColor
                }
                if self.txtStock.text == ""{
                    self.errSt.text = "Tidak boleh kosong"
                    self.txtStock.layer.borderWidth = 1
                    self.txtStock.layer.borderColor = UIColor.red.cgColor
                }
                if self.txtMinStock.text == ""{
                    self.errSt.text = "Tidak boleh kosong"
                    self.txtMinStock.layer.borderWidth = 1
                    self.txtMinStock.layer.borderColor = UIColor.red.cgColor
                }
                if self.txtSatuan.text == ""{
                    self.errSt.text = "Tidak boleh kosong"
                    self.txtSatuan.layer.borderWidth = 1
                    self.txtSatuan.layer.borderColor = UIColor.red.cgColor
                }
                if self.txtHargaBeli.text == ""{
                    self.errBeli.text = "Tidak boleh kosong"
                    self.txtHargaBeli.layer.borderWidth = 1
                    self.txtHargaBeli.layer.borderColor = UIColor.red.cgColor
                }
                if self.txtHargaJual.text == ""{
                    self.errJual.text = "Tidak boleh kosong"
                    self.txtHargaJual.layer.borderWidth = 1
                    self.txtHargaJual.layer.borderColor = UIColor.red.cgColor
                }
                if self.imgProduk.image == nil{
                    self.errGambar.text = "Tidak boleh kosong"
                    self.imgProduk.layer.borderWidth = 1
                    self.imgProduk.layer.borderColor = UIColor.red.cgColor
                }
            }))
            self.present(alert,animated: true, completion: nil )
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        performSegue(withIdentifier: "back", sender: Any?.self)
    }
    
    @IBAction func pilihGambar(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Galeri", style: .default, handler:{ ACTION in
            self.openGallery()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Kembali", style: .destructive, handler:{ ACTION in
            print("Kembali")
            
        }))
        

        self.present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let downloadURL = NSURL(string: Produks!.gambar)!
        imgProduk.af_setImage(withURL: downloadURL as URL)
        errNama.text = ""
        errSt.text = ""
        errJual.text = ""
        errBeli.text = ""
        errGambar.text = ""
        
        txtNamaProduk.text = Produks?.nama_produk
        txtStock.text = Produks?.stock.description
        txtMinStock.text = Produks?.min_stock.description
        txtHargaJual.text = Produks?.harga_jual.description
        txtHargaBeli.text = Produks?.harga_beli.description
        labelID.text = Produks!.id_produk
        txtSatuan.text = Produks!.satuan_produk
        
        txtNamaProduk.delegate = self
        txtSatuan.delegate = self
        txtHargaBeli.delegate = self
        txtHargaJual.delegate = self
        txtStock.delegate = self
        txtMinStock.delegate = self
        
        txtNamaProduk.clearsOnBeginEditing = false
        txtSatuan.clearsOnBeginEditing = false
        txtStock.clearsOnBeginEditing = false
        txtMinStock.clearsOnBeginEditing = false
        
        txtNamaProduk.addTarget(self, action: #selector(checkErr(textF:)), for: .editingChanged)
        txtStock.addTarget(self, action: #selector(checkErr(textF:)), for: .editingChanged)
        txtMinStock.addTarget(self, action: #selector(checkErr(textF:)), for: .editingChanged)
        txtSatuan.addTarget(self, action: #selector(checkErr(textF:)), for: .editingChanged)
        txtHargaBeli.addTarget(self, action: #selector(checkErr(textF:)), for: .editingChanged)
        txtHargaJual.addTarget(self, action: #selector(checkErr(textF:)), for: .editingChanged)
        txtHargaBeli.addTarget(self, action: #selector(conv(textF:)), for: .editingDidEnd)
        txtHargaJual.addTarget(self, action: #selector(conv(textF:)), for: .editingDidEnd)
        
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
        if activeTextField == txtNamaProduk ||
            activeTextField == txtStock ||
            activeTextField == txtMinStock ||
            activeTextField == txtSatuan {
            
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
        if textF == txtHargaBeli{
            hargaBeli = textF.text!
            let number = (textF.text! as NSString).floatValue
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "id_ID")
            formatter.numberStyle = .currency
            if let formattedNum = formatter.string(from: number as NSNumber) {
                txtHargaBeli.text = ("\(formattedNum)")
            }
        }else if textF == txtHargaJual{
            hargaJual = textF.text!
            let number = (textF.text! as NSString).floatValue
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "id_ID")
            formatter.numberStyle = .currency
            if let formattedNum = formatter.string(from: number as NSNumber) {
                txtHargaJual.text = ("\(formattedNum)")
            }
        }
        
    }
    
    
    @objc func checkErr (textF : UITextField){
        let t1 = txtNamaProduk!
        let t2 = txtStock!
        let t3 = txtMinStock!
        let t4 = txtHargaJual!
        let t5 = txtHargaBeli!
        let t6 = txtSatuan!
        let l1 = errNama!
        let l2 = errSt!
        let l3 = errSt!
        let l4 = errJual!
        let l5 = errBeli!
        let l6 = errSt!
        
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
        }else if textF == t6{
            if t6.text!.count == 0 {
                l6.text = "Tidak boleh kosong"
                t6.layer.borderWidth = 1
                t6.layer.borderColor = UIColor.red.cgColor
            }else{
                l6.text = ""
                t6.layer.borderWidth = 0
                t6.layer.borderColor = nil
            }
        }
        
    }
    
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerController.SourceType.camera
        self.present(imagePicker, animated: false, completion: nil)
        }
    }
    
    func openGallery(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
                   imagePicker.allowsEditing = false
                   imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                   self.present(imagePicker, animated: false, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            imgProduk.image = image
            
        }else if let pickedImage = info[.originalImage] as? UIImage{
            imgProduk.contentMode = .scaleToFill
            imgProduk.image = pickedImage
        }else{
            print("Error...")
        }
        guard let fileUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL else { return }
        print(fileUrl.lastPathComponent) // get file Name
        print(fileUrl.pathExtension)
        nama_img = fileUrl.lastPathComponent.description
        origionalImage(origionalImage: imgProduk.image)
        errGambar.text = ""
        imgProduk.layer.borderWidth = 0
        imgProduk.layer.borderColor = nil
        self.dismiss(animated: false, completion: nil)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func origionalImage(origionalImage: UIImage!) {
        let imageData = NSData(data:origionalImage.pngData()!)
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let docs: String = paths[0]

        let imageName = "Produk" + Produks!.id_produk  as String
                    //imageName can save in sqlite to load image later
        fullp = String("\(docs)/\(imageName).png")
        print(fullp!)
        let result = imageData.write(toFile: fullp, atomically: true)
        print("FILE WRITTEN SUCCESS=>:\(result)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "back"{
            guard let VC = segue.destination as? ViewProduk else {return}
            Produks?.printData()
            VC.Produks = self.Produks
             
        }
        else if segue.identifier == "produkAdd"{
            
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtStock || textField == txtMinStock || textField == txtHargaJual || textField == txtHargaBeli {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }else if textField == txtNamaProduk || textField == txtSatuan {
            let allowedCharacters = CharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
    func edit(nama:String, id_peg:String, stock: String, min_stock:String, satuan:String, beli:String, jual:String) {
      let parameters = [
        "nama_produk" : nama,
        "id_pegawai":id_peg,
        "stock":stock,
        "min_stock":min_stock,
        "satuan_produk":satuan,
        "harga_beli":beli,
        "harga_jual":jual
      ]
    self.origionalImage(origionalImage: imgProduk.image)
    let image = UIImage(contentsOfFile: self.fullp)!
            let imageData = image.jpegData(compressionQuality: 0.50)
            print("test",image, imageData!)
              Alamofire.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imageData!, withName: "gambar", fileName: "images.jpg", mimeType: "image/jpg")

                for (key, value) in parameters {
                    multipartFormData.append((value.data(using: .utf8))!, withName: key)
                }}, to: self.url + self.Produks!.id_produk, method: .post,
                    encodingCompletion: { encodingResult in
                      switch encodingResult {
                      case .success(let upload, _, _):
                        upload.response { [weak self] response in
                          guard let strongSelf = self else {
                            return
                          }
                            DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Berhasil Mengubah Data", message: nil, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: {(UIAlertAction) in
                                self!.performSegue(withIdentifier: "backs", sender: Any?.self)
                            }))
                                self!.present(alert,animated: true, completion: nil )
                            }
                        }
                      case .failure(let encodingError):
                        DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Gagal Mengubah Data", message: "Periksa Kembali Masukkan", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: nil))
                        self.present(alert,animated: true, completion: nil )
                        }
                        print("error:\(encodingError)")
                      }
              })
    
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
