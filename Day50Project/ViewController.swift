//
//  ViewController.swift
//  Day50Project
//
//  Created by Stefan Milenkovic on 3/23/19.
//  Copyright © 2019 Stefan Milenkovic. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    var captions = [Caption]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        title = "Captions"
        navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(openCamera))
        
        
        
        let defaults = UserDefaults.standard
        
        if let savedData = defaults.object(forKey: "caption") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do{
                captions = try jsonDecoder.decode([Caption].self, from: savedData)
                
            }catch {
                print("eroor loading data")
            }
        }
        
    }
    
    
    
    
    @objc func openCamera() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
        
        
        
        
    }
    
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else {return}
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 1.0) {
            try? jpegData.write(to: imagePath)
        }
        
        dismiss(animated: true, completion: nil)
        
        // show caption input
        let ac = UIAlertController(title: "Caption", message: "Enter caption", preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Add caption", style: .default) { [weak self, weak ac] _ in
            
            guard let caption = ac?.textFields?[0].text else {return}
            
            let newCaption = Caption(caption: caption, image: imageName)
            self?.captions.append(newCaption)
            
            self?.save()
            self?.tableView.reloadData()
            
            
            
        })
        
        
        present(ac, animated: true, completion: nil)
        
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return captions.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let caption = captions[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "captionCell", for: indexPath)
        
        cell.textLabel?.text = caption.caption
        let path = getDocumentDirectory().appendingPathComponent(caption.image)
        cell.imageView?.image = UIImage(contentsOfFile: path.path)
        
        
        return cell
        
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCaption = captions[indexPath.row]
        
        if  let vc = storyboard?.instantiateViewController(withIdentifier: "detailVC") as? DetailVC{
            vc.recivedCaption = selectedCaption
            navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    
    func save() {
        
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(captions) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "caption")
        }
        
        
        
    }


}

