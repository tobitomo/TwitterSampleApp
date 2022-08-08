//
//  DetaileViewController.swift
//  TwitterSampleApp
//
//  Created by Tomoko Tobita on 2022/08/04.
//

import Foundation
import UIKit
import RealmSwift

protocol DetailViewControllerDelegate {
    func recordUpdate()
}

class DetailViewController : UIViewController {
    @IBOutlet weak var messageView: UITextView!
    fileprivate var maxWordCount: Int = 140
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var DeleteButton: UIButton!
    @IBAction func DeleteButton(_ sender: UIButton) {
        deleteButton()
    }
    @IBOutlet weak var SaveButton: UIButton!
    @IBAction func SaveButton(_ sender: UIButton) {
        saveButton()
    }
    
    var messageData = MessageDataModel()
    var delegate : DetailViewControllerDelegate?
    
    //日付表示変更
    var dateFormat: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年M月d日 H:mm"
        return dateFormatter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayData()
        setDoneButton()
        configureButton()
        messageView.delegate = self
    }
    
    //ツイートデータをhomeから受け取る
    func configure(message: MessageDataModel) {
        messageData = message
    }
    
    //画面に表示するデータ
    func displayData() {
        messageView.text = messageData.text
        navigationItem.title = dateFormat.string(from: messageData.recordDate)
    }
    
    //キーボードの閉じるボタン追加
    @objc func tapDoneButton() {
        view.endEditing(true)
    }
    
    func setDoneButton() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        let commitButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapDoneButton))
        toolBar.items = [commitButton]
        messageView.inputAccessoryView = toolBar
    }
    
    //ボタンの装飾
    func configureButton() {
        DeleteButton.layer.cornerRadius = 15
        SaveButton.layer.cornerRadius = 15
    }
    
    //テキストの編集があったら保存する
    func saveButton() {
        let realm = try! Realm()
        try! realm.write {
            if let addMessage = messageView.text {
                messageData.text = addMessage
            }
            realm.add(messageData)
        }
        navigationController?.popViewController(animated: true)
    }
    
    //取得中のデータ削除
    func deleteButton() {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(messageData)
        }
        delegate?.recordUpdate()
        navigationController?.popViewController(animated: true)
    }
}

extension DetailViewController: UITextViewDelegate {
    //文字数の制限
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return messageView.text.count + (text.count - range.length) <= maxWordCount
    }
    //残りの文字数表示
    func textViewDidChange(_ textView: UITextView) {
        self.textLabel.text = "現在の文字数：\(messageView.text.count) / \(maxWordCount)"
    }
}
