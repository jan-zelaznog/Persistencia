//
//  DataManager.swift
//  Persist
//
//  Created by Ángel González on 01/04/22.
//

import Foundation

enum PersistenceType:Int {
    case userDefaults
    case pListFile
    case jsonFile
}

class DataManager: NSObject {
    /********** IMPLEMENTACION DEL PATRÓN SINGLETON  ********/
    // se instancía la instancia única que va a ser compartida durante toda la aplicación
    static let instance = DataManager()
    var dictPlist = [String:String]()
    var dictJson = [String:String]()
    
    // se sobreescribe el constructor como privado, para evitar la instanciacion
    private override init() {
        super.init()
        cargaArchivos()
    }
    /******************/
    
    func guarda(llave:String, valor:String, tipo:PersistenceType) -> Bool {
        var resultado = false
        if tipo == .userDefaults {
            resultado = guardaEnUD(llave, valor:valor)
        }
        else if tipo == .pListFile {
            resultado = guardaEnPL(llave, valor:valor)
        }
        else {
            resultado = guardaEnJSON(llave, valor:valor)
        }
        
        return resultado
    }
    
    func guardaEnPL (_ llave:String, valor:String) -> Bool {
        // lo asignamos al diccionario que está en memoria
        dictPlist[llave] = valor
        // actualizar el archivo, con el nuevo contenido
        // a) volvemos a buscar la carpeta documents
        let carpetaDocuments = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        // b) completamos la ruta al archivo, agregando el nombre y extension
        let rutaAlPlist = carpetaDocuments + "/persist.plist"
        do {
            // c) convertir el diccionario a bytes
            let bytes = try PropertyListSerialization.data(fromPropertyList: dictPlist, format:.xml, options:0)
            let url = URL(fileURLWithPath: rutaAlPlist)
            try bytes.write(to:url)
            return true
        }
        catch {
            // algo fallo
            print (error.localizedDescription)
        }
        return false
    }
    
    func guardaEnJSON (_ llave:String, valor:String) -> Bool {
        // lo asignamos al diccionario que está en memoria
        dictJson[llave] = valor
        // actualizar el archivo, con el nuevo contenido
        // a) volvemos a buscar la carpeta documents
        let carpetaDocuments = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        // b) completamos la ruta al archivo, agregando el nombre y extension
        let rutaAlJSON = carpetaDocuments + "/persist.json"
        do {
            // c) convertir el diccionario a bytes
            let bytes = try JSONSerialization.data(withJSONObject: dictJson, options:.prettyPrinted)
            let url = URL(fileURLWithPath: rutaAlJSON)
            try bytes.write(to:url)
            return true
        }
        catch {
            // algo fallo
            print (error.localizedDescription)
        }
        return false
    }
    
    func guardaEnUD (_ llave:String, valor:String) -> Bool {
        // El diccionario UserDefaults sirve para guardar las preferencias del usuario, piensa como las cookies de los navegadores de internet
        // el diccionario compartido para todas las aplicaciones
        // compartido no significa que la información sea visible entre aplicaciones, a menos que, cree mi propio diccionario
        let ud = UserDefaults.standard
        // asignamos una llave, para guardar el valor.
        ud.set(valor, forKey: llave)
        // para guardar la info:
        ud.synchronize()
        return true
    }
    
    // Para trabajar con archivos tenemos tres ubicaciones:
    // 1. Resources.- Se refiere a los archivos que se agregan al paquete de la App
    // Bundle.main.url(forResource: "edo-mun", withExtension: "plist") {
    //
    // 2. Documents.- Es una carpeta que se crea cuando se instala el App, y es de R/W
    // Esta carpeta se respalda a iCloud (si el usuario tiene esta opción habilitada)
    // Si se tienen archivos MUY grandes, es preferible no ponerlos en Documents
    // let carpetaDocuments = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    //
    // 3. Library.- Es una carpeta que se crea cuando se instala el App, y es de R/W
    // Esta carpeta NO se respalda a iCloud
    // let carpetaDocuments = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0] as String
    // en estos diccionarios vamos a mantener en memoria, el contenido de los archivos
    
    func cargaArchivos() {
        // buscar los archivos si es que existen, y recuperar la info que ya esté guardada
        // a) buscar la carpeta documents. La funcion devuelve un arreglo, por eso utilizamos [0]
        let carpetaDocuments = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        // b) completamos la ruta al archivo, agregando el nombre y extension
        let rutaAlPlist = carpetaDocuments + "/persist.plist"
        // c) validamos si el archivo ya existe, utilizando el objeto FileManager
        if FileManager.default.fileExists(atPath: rutaAlPlist) {
            // d) si el archivo ya existe, leemos su contenido para inicializar el diccionario
            let url = URL(fileURLWithPath: rutaAlPlist)
            do {
                let bytes = try Data(contentsOf: url)
                let tmp = try PropertyListSerialization.propertyList(from: bytes, options: .mutableContainers, format:nil)
                dictPlist = tmp as! [String:String]
            }
            catch {
                // manejar el error
                print (error.localizedDescription)
            }
        }
        let rutaAlJson = carpetaDocuments + "/persist.json"
        // c) validamos si el archivo ya existe, utilizando el objeto FileManager
        if FileManager.default.fileExists(atPath: rutaAlJson) {
            // d) si el archivo ya existe, leemos su contenido para inicializar el diccionario
            let url = URL(fileURLWithPath: rutaAlJson)
            do {
                let bytes = try Data(contentsOf: url)
                let tmp = try JSONSerialization.jsonObject(with: bytes, options: .allowFragments)
                    dictJson = tmp as! [String:String]
            }
            catch {
                // manejar el error
                print (error.localizedDescription)
            }
        }
    }
}
