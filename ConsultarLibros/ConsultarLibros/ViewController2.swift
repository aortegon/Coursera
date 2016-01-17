//
//  ViewController2.swift
//  ConsultarLibros
//
//  Created by Alejandro Ortegon on 26/11/15.
//  Copyright © 2015 Alejandro Ortegon. All rights reserved.
//

import UIKit



var NumeroISBN : String?
//var resulautor : String?

class ViewController2: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var arrayAutores = [String]()
    
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var titulo: UILabel!
    
    @IBOutlet weak var TableAutores: UITableView!

    @IBOutlet weak var imgPortada: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()


        
        let url = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + NumeroISBN! as String
        let nsURL = NSURL(string: url  as String)
        let datos = NSData(contentsOfURL: nsURL!)
        
        if datos != nil {
            
            do
            {
                let msg = NSString(data: datos!, encoding: NSUTF8StringEncoding)
                if msg == "{}"{
                    let alerta = UIAlertController(title: "Coursera - OpenLibrary", message: "El ISBN no se encuentra Disponible", preferredStyle: .Alert)
                    alerta.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    self.presentViewController(alerta, animated: true, completion: nil)
                }
                else{
                
                let jsonResponse = try NSJSONSerialization.JSONObjectWithData(datos!, options: .AllowFragments)
                
      
                let dico1 = jsonResponse["ISBN:" + NumeroISBN! as String] as! NSDictionary
                
                
                let dico2 = dico1["authors"] as! NSArray
                    
                    for nAutor in dico2 {
                        if let name = nAutor["name"] as? String {
                            arrayAutores.append(name)
                        }
                    }
                
               let dico3 = dico1["title"] as! String
                
                self.titulo.text = dico3
                self.label.text = NumeroISBN! as String
                    
                    
                    var direccionPortada : String? = nil
                    //Captura de la imagen portada
                    if let portada = dico1["cover"]{
                        let diccionarioPortada = portada as! NSDictionary
                        if let portadaMediana = diccionarioPortada["medium"]{
                            direccionPortada = portadaMediana as? String
                        }
                    }
                    
                    //Muestra de los resultados
                    self.imgPortada.image = nil
                    if direccionPortada != nil {
                        cargarImagen(direccionPortada!)
                    }
                    
                }
                
            }
            catch
            {
                print("JSON error.....")
                return
            }
            
            //print(NumeroISBN!)
            
        }else{
            
            let alertaPop = UIAlertController(title: "- Consulta de Libros - ", message: "No hay Conexión a Internet, verifique e intente nuevamente", preferredStyle: UIAlertControllerStyle.Alert)
            alertaPop.addAction(UIAlertAction(title: "Continuar", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                
            }))
            
            presentViewController(alertaPop, animated: true, completion: nil)
            
        }

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayAutores.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.TableAutores.dequeueReusableCellWithIdentifier("CAutor")! as UITableViewCell
        
        let autor = arrayAutores[indexPath.row]
   
        cell.textLabel!.text = " > "  + autor as NSString as String
        
        return cell
        
    }
    
    func cargarImagen(urlString:String)
    {
        let imgURL: NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            
            if (error == nil && data != nil)
            {
                func display_image()
                {
                    self.imgPortada.image = UIImage(data: data!)
                    self.imgPortada.layer.borderWidth = 1
                }
                
                dispatch_async(dispatch_get_main_queue(), display_image)
            }
            
        }
        
        task.resume()
    }

}
