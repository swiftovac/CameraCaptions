//
//  DetailVC.swift
//  Day50Project
//
//  Created by Stefan Milenkovic on 3/23/19.
//  Copyright © 2019 Stefan Milenkovic. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    var recivedCaption: Caption?

    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        guard let caption = recivedCaption else {
            return
        }
        
        
        let path = getDocumentDirectory().appendingPathComponent(caption.image)
        title = caption.caption
        imageView.image = UIImage(contentsOfFile: path.path)
    }
    



    
    
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
        
        
    }
}
