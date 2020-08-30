//
//  EditPlataformaViewController.swift
//  MyGames
//
//  Created by aluno on 28/08/20.
//  Copyright © 2020 CESAR School. All rights reserved.
//

import UIKit
import Photos

class EditConsoleViewController: UIViewController {
   
    @IBOutlet weak var textTitleAddConsole: UITextField!
    @IBOutlet weak var btnAddImageConsole: UIButton!
    @IBOutlet weak var imageConsole: UIImageView!
    @IBOutlet weak var btnAddConsole: UIButton!
    
    
    var console: Console?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         ConsolesManager.shared.loadConsoles(with: context)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
                super.viewWillAppear(animated)
                // precisamos saber se estamos CRIANDO algo NOVO ou editando algo existente.
                // Faremos essa lógica aqui.
                prepareDataLayout()
            }
            
            func prepareDataLayout() {
                if console != nil {
                    title = "Editar Console"
                    btnAddConsole.setTitle("ALTERAR", for: .normal)
                    textTitleAddConsole.text = console?.name
                    imageConsole.image = console?.picture as? UIImage
                    if console?.picture != nil {
                    btnAddImageConsole.setTitle(nil, for: .normal)
                    }
                }
            }
    
    
    @IBAction func AddEditConsole(_ sender: Any) {

        if console == nil {
          console = Console(context: context)
        }
        console?.name = textTitleAddConsole.text
        console?.picture = imageConsole.image
        do {
           try context.save()
        } catch {
           print(error.localizedDescription)
        }
        // Back na navigation
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addEditImageConsole(_ sender: Any) {
        
        let alert = UIAlertController(title: "Selecinar capa", message: "De onde você quer escolher a imagem?", preferredStyle: .actionSheet)
               
                let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default, handler: {(action: UIAlertAction) in
                    self.selectPicture(sourceType: .photoLibrary)
                })
                alert.addAction(libraryAction)
               
                let photosAction = UIAlertAction(title: "Album de fotos", style: .default, handler: {(action: UIAlertAction) in
                    self.selectPicture(sourceType: .savedPhotosAlbum)
                })
                alert.addAction(photosAction)
               
                let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
               
                present(alert, animated: true, completion: nil)
    }
    
    
    func selectPicture(sourceType: UIImagePickerController.SourceType) {
       
        //Photos
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                   
                    self.chooseImageFromLibrary(sourceType: sourceType)
                   
                } else {
                   
                    print("unauthorized -- TODO message")
                }
            })
        } else if photos == .authorized {
           
            self.chooseImageFromLibrary(sourceType: sourceType)
        }
    }
    
    
    
    func chooseImageFromLibrary(sourceType: UIImagePickerController.SourceType) {
        
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = sourceType
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.navigationBar.tintColor = UIColor(named: "main")
            
            self.present(imagePicker, animated: true, completion: nil)
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

}




extension EditConsoleViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // tip. implementando os 2 protocols o evento sera notificando apos user selecionar a imagem
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //fechar janela
        self.resignFirstResponder()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            // ImageView won't update with new image
            // bug fixed: https://stackoverflow.com/questions/42703795/imageview-wont-update-with-new-image
            DispatchQueue.main.async {
                self.imageConsole.image = pickedImage
                self.imageConsole.setNeedsDisplay()
                self.btnAddImageConsole.setTitle(nil, for: .normal)
                self.btnAddImageConsole.setNeedsDisplay()
            }
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
