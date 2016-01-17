//
//  ViewController.swift
//  ConsultarLibros
//
//  Created by Alejandro Ortegon on 25/11/15.
//  Copyright © 2015 Alejandro Ortegon. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var TextISBN: UITextField!
    
    @IBOutlet weak var resultado: UITextView!
    
    
    
    @IBAction func aceptar(sender: UIButton) {
        
        
        let url = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + TextISBN.text!
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
                    
                    if self.TextISBN.text != "" {
                        NumeroISBN = TextISBN.text
                        
                        performSegueWithIdentifier("pasardato", sender: sender)
                        
                    }
                    else{
                        let alertaPop = UIAlertController(title: " Coursera - OpenLibrary ", message: "Digite el Número de ISBN a Buscar", preferredStyle: UIAlertControllerStyle.Alert)
                        alertaPop.addAction(UIAlertAction(title: "Continuar", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                            
                        }))
                        
                        presentViewController(alertaPop, animated: true, completion: nil)
                    }
                }

                
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

