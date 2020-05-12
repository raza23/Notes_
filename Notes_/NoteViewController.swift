//
//  NoteViewController.swift
//  Notes_
//
//  Created by Raza Shareef on 5/12/20.
//  Copyright © 2020 raza_s. All rights reserved.
//

import Foundation
import UIKit

class NoteViewController: UIViewController {
    var note: Note!
    
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = note.contents
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        note.contents = textView.text
        NoteManager.main.save(note: note)
        
    }
    
}
