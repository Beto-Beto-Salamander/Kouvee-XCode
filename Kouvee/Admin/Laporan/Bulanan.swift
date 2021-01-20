//
//  Bulanan.swift
//  Kouvee
//
//  Created by Ryan Octavius on 15/06/20.
//  Copyright © 2020 Ryan. All rights reserved.
//

import UIKit

class Bulanan: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    var arrBulan = [Bulan]()
    var arrTahun = [Tahun]()
    var Th : String?
    var Bl : String?
    var Laporan : String?
    var urlTahun = "http://www.kouvee.xyz/index.php/Lap/"
    var urlLaporan = "http://kouvee.xyz/index.php/Laporan/"
    var urlBulan = "http://www.kouvee.xyz/index.php/LapBulan/"
    var arrLaporan = ["Pendapatan","Pengadaan"]
    @IBOutlet weak var pickerLaporan: UIPickerView!
    @IBOutlet weak var txtTahun: UITextField!
    @IBOutlet weak var txtBulan: UITextField!
    var pickerTahun = UIPickerView()
    var pickerBulan = UIPickerView()
    
    @IBAction func btnCetak(_ sender: Any) {
        if Laporan == "Pendapatan" {
            guard let url = URL(string: urlLaporan + "printLaporanPendapatanBulan/" + txtTahun.text! + "/" + txtBulan.text! ) else { return }
            UIApplication.shared.open(url)
        }else if Laporan == "Pengadaan" {
            guard let url = URL(string: urlLaporan + "printLaporanPengadaanBulan/" + txtTahun.text! + "/" + txtBulan.text!) else { return }
            UIApplication.shared.open(url)
        }
        
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.performSegue(withIdentifier: "back", sender: Any?.self)
    }
    
    
    override func viewDidLoad() {
        
        txtTahun.delegate = self
        txtBulan.delegate = self
        
        pickerLaporan.dataSource = self
        pickerLaporan.delegate = self
        
        pickerTahun.delegate = self
        pickerTahun.dataSource = self
        
        pickerBulan.delegate = self
        pickerBulan.dataSource = self
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerTahun{
            return arrTahun.count
        }
        else if pickerView == pickerBulan{
            return arrBulan.count
        }
        else{
            return arrLaporan.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerTahun{
            return arrTahun[row].thn
        }
        else if pickerView == pickerBulan{
            return arrBulan[row].bln
        }
        else{
            return arrLaporan[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerTahun{
            Th = arrTahun[row].thn
            txtTahun.text = Th
        }
        else if pickerView == pickerBulan{
            Bl = arrBulan[row].bln
            txtBulan.text = Bl
        }
        else{
            Laporan = arrLaporan[row]
            txtTahun.text = ""
            txtBulan.text = ""
            arrTahun.removeAll()
            arrBulan.removeAll()
            pickerTahun.reloadAllComponents()
            pickerBulan.reloadAllComponents()
            getTahun(Laporan: Laporan!)
            getBulan(Laporan: Laporan!)
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtTahun {
            
            let alert = UIAlertController(title: "Pilih Tahun", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)

            pickerTahun.frame = CGRect(x: 5, y: 30, width: 250, height: 200)
            alert.view.addSubview(pickerTahun)
                
            alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: {(UIAlertAction) in
                if self.arrTahun.count == 1 {
                    self.Th = self.arrTahun[0].thn
                    self.txtTahun.text = self.Th
                }
            }))
            self.present(alert,animated: true, completion: nil )
            
        }
        if textField == txtBulan {
            
            let alert = UIAlertController(title: "Pilih Bulan", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)

            
            pickerBulan.frame = CGRect(x: 5, y: 30, width: 250, height: 200)
            alert.view.addSubview(pickerBulan)
                
            alert.addAction(UIAlertAction(title: "Tutup", style: .default, handler: {(UIAlertAction) in
                if self.arrBulan.count == 1 {
                    self.Bl = self.arrBulan[0].bln
                    self.txtBulan.text = self.Bl
                }
            }))
            self.present(alert,animated: true, completion: nil )
            
        }
        
        
        return true
    }
    
    
    
    fileprivate func getTahun(Laporan: String){
        let url = URL(string: urlTahun + Laporan)
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
                        
                        let t = jsonObject["Data"] as? [AnyObject]
                        for obj in t! {
                            let t = Tahun(json: obj as! [String:Any])
                            self.arrTahun.append(t)
                        }
                        
                        DispatchQueue.main.async(execute: {
                            self.pickerTahun.reloadAllComponents()
                        })
                    }
                    catch{
                        print("catch error")
                    }
                }
            }
        }.resume()
    }
    
    fileprivate func getBulan(Laporan: String){
        let url = URL(string: urlBulan + Laporan)
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
                        
                        let b = jsonObject["Data"] as? [AnyObject]
                        for obj in b! {
                            let b = Bulan(json: obj as! [String:Any])
                            self.arrBulan.append(b)
                        }
                        
                        DispatchQueue.main.async(execute: {
                            self.pickerBulan.reloadAllComponents()
                        })
                    }
                    catch{
                        print("catch error")
                    }
                }
            }
        }.resume()
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
