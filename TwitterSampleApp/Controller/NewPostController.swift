//
//  NewPostController.swift
//  TwitterSampleApp
//
//  Created by Tomoko Tobita on 2022/08/04.
//

import Foundation
import UIKit
import RealmSwift

protocol NewPostViewControllerDelegate {
    func recordUpdate()
}

class NewPostViewController: UIViewController {
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var detaileView: UITextView!
    fileprivate var maxWordCount: Int = 140
    
    @IBOutlet weak var textLength: UILabel!
    @IBOutlet weak var CancelButton: UIButton!
    @IBAction func CancelButton(_ sender: UIButton) {
        cancelButton()
    }
    @IBOutlet weak var PostButton: UIButton!
    @IBAction func PostButton(_ sender: UIButton) {
        postButton()
    }
    
    var messageData = MessageDataModel()
    var delegate: NewPostViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.detaileView.delegate = self
        setDoneButton()
        //ツイート入力枠線の幅
        detaileView.layer.borderWidth = 1.5
        //枠線を丸める
        detaileView.layer.cornerRadius = 20.0
        detaileView.layer.masksToBounds = true
        configureButton()
    }
    
    //キーボードの閉じるボタン追加
    @objc func tapDoneButton() {
        view.endEditing(true)
    }
    
    func setDoneButton() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        let commitButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapDoneButton))
        toolBar.items = [commitButton]
        detaileView.inputAccessoryView = toolBar
    }
    
    //ボタンの装飾
    func configureButton() {
        PostButton.layer.cornerRadius = 10
        CancelButton.layer.cornerRadius = 10
    }
    
    //つぶやきボタン
    func postButton() {
        let realm = try! Realm()
        try! realm.write {
            if let name = userTextField.text {
                messageData.user = name
            }
            if let message = detaileView.text {
                messageData.text = message
            }
            messageData.recordDate = Date()
            realm.add(messageData)
        }
        delegate?.recordUpdate()
        dismiss(animated: true)
    }
    
    //やめるボタン
    func cancelButton() {
        dismiss(animated: true)
    }
}

extension NewPostViewController: UITextViewDelegate {
    //文字数の制限
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return detaileView.text.count + (text.count - range.length) <= maxWordCount
    }
    //残りの文字数表示
    func textViewDidChange(_ textView: UITextView) {
        self.textLength.text = "\(maxWordCount - detaileView.text.count)"
    }
}
