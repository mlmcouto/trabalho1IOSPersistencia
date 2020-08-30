//
//  PlataformaViewController.swift
//  MyGames
//
//  Created by aluno on 28/08/20.
//  Copyright © 2020 CESAR School. All rights reserved.
//

import UIKit

class ConsoleViewController: UIViewController {

    
    @IBOutlet weak var IvCover: UIImageView!
    @IBOutlet weak var LbTitle: UILabel!
    
    var console: Console?
    //var game: Game?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //LbTitle.text = console?.name
        LbTitle.text = console?.name
        
        if let image = console?.picture as? UIImage {
            IvCover.image = image
        } else {
            IvCover.image = UIImage(named: "noCoverFull")
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let vc = segue.destination as! EditConsoleViewController
        vc.console = console
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
