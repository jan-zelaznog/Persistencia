//
//  ViewController.swift
//  Persist
//
//  Created by Ángel González on 01/04/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var lblKey: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var txtKey: UITextField!
    @IBOutlet weak var txtValue: UITextField!
    @IBOutlet weak var swPlist: UISwitch!
    @IBOutlet weak var swJson: UISwitch!
    @IBOutlet weak var swUserD: UISwitch!
    @IBOutlet weak var btnGuardar: UIButton!
    
    @IBAction func btnGuardarTouch(_ sender: Any) {
        var tipo = PersistenceType.pListFile
        if swUserD.isOn {
            tipo = PersistenceType.userDefaults
        }
        else if swJson.isOn {
            tipo = PersistenceType.jsonFile
        }
        var mensaje = "Ocurrió un error al tratar de guardar la información"
        if DataManager.instance.guarda(llave: txtKey.text!, valor:txtValue.text!, tipo:tipo) {
            mensaje = "Se guardó la información correctamente"
        }
        let ac = UIAlertController(title: "RESULTADO", message: mensaje, preferredStyle: .alert)
        let aa = UIAlertAction(title: "ok", style: .default, handler: nil)
        ac.addAction(aa)
        self.present(ac, animated:true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        swJson.isOn = false
        swPlist.isOn = false
        btnGuardar.isEnabled = false
        lblKey.text = NSLocalizedString("texto1", comment: "")
    }
    
    @IBAction func swChange(_ sender: UISwitch) {
        let val = sender.isOn
        if (val) {
            if sender.isEqual(swPlist) {
                swJson.isOn = !val
                swUserD.isOn = !val
            }
            else if sender.isEqual(swJson) {
                swPlist.isOn = !val
                swUserD.isOn = !val
            }
            else {
                swPlist.isOn = !val
                swJson.isOn = !val
            }
        }
        else {
            swPlist.isOn = true
            swJson.isOn = false
            swUserD.isOn = false
        }
    }
    
    @IBAction func textFieldChange(_ textField: UITextField) {
        // Se invoca cuando un cuadro de texto cambia su valor
        var text1:String?
        let text2 = textField.text
        if textField.isEqual(txtKey) {
            text1 = txtValue.text
        }
        else {
            text1 = txtKey.text
        }
        btnGuardar.isEnabled = (text1 != "" && text2 != "")
    }
}

