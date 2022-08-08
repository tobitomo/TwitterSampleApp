//
//  HomeViewController.swift
//  TwitterSampleApp
//
//  Created by Tomoko Tobita on 2022/08/04.
//

import Foundation
import UIKit
import RealmSwift

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBAction func addButton(_ sender: UIButton) {
        transitionToNewPostView()
    }
    
    var messageDataList: [MessageDataModel] = []
    
    //日付表示変更
    var dateFormat: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年M月d日 H:mm"
        return dateFormatter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.backButtonTitle = ""
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        configureButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setMessageData()
        tableView.reloadData()
    }

    //ツイートを表示
    func setMessageData() {
        let realm = try! Realm()
        let result = realm.objects(MessageDataModel.self)
        messageDataList = Array(result)
        messageDataList.reverse()
        
    }
    
    //addButtonの装飾
    func configureButton() {
        addButton.layer.cornerRadius = addButton.bounds.width / 2
    }
    
    //addButtonタップ時に新規投稿作成画面へ遷移
    func transitionToNewPostView() {
        let stortboard = UIStoryboard(name: "NewPostViewController",bundle: nil)
        guard let newPostViewController = stortboard.instantiateInitialViewController() as? NewPostViewController else { return }
        newPostViewController.delegate = self
        present(newPostViewController, animated: true)
    }
}
    

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageDataList.count
       }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomTableViewCell
        let messageDataModel: MessageDataModel = messageDataList[indexPath.row]
        cell.name.text = messageDataModel.user
        cell.message.text = messageDataModel.text
        cell.recordDate.text  = dateFormat.string(from: messageDataModel.recordDate)
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    //セルタップ時にDetailViewControllerへ画面遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailViewController = storyboard.instantiateViewController(identifier:  "DetailViewController") as! DetailViewController
        // 配列からインデックス番号でタップされたセルのデータを受け取り、detailViewController.configureにデータを渡している
        let messageData = messageDataList[indexPath.row]
        detailViewController.configure(message: messageData)
        tableView.deselectRow(at: indexPath, animated: true) //選択状態解除
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
    
extension HomeViewController: NewPostViewControllerDelegate {
    func recordUpdate() {
        setMessageData()
        tableView.reloadData()
    }
}
