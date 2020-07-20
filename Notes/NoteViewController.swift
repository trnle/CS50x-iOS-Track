//
//  NoteViewController.swift
//  Notes
//
//  Created by Tran Le on 7/20/20.
//  Copyright © 2020 Tran. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {
    var note: Note!
    
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set text equal to notes contents
        textView.text = note.contents
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // change note object
        note.contents = textView.text
        // save note
        NoteManager.main.save(note: note)
    }
}
