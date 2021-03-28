//
//  VaccinePermissionViewController.swift
//  QRCodeApp
//
//  Created by Elif Basak  Yildirim on 27.03.2021.
//

import UIKit

class VaccinePermissionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var todoTableView: UITableView!
    var asi_id : Int = 0
    //let todos = ["walk dog","wash the car"]
    var todos = [ Todo(title:"Herkese Görünür",isMarked:false),Todo(title:"Yalnızca Arkadaslara Görünür",isMarked:false)]
    override func viewDidLoad() {
        super.viewDidLoad()
        todoTableView.delegate = self
        todoTableView.dataSource = self
        todoTableView.separatorStyle = .none
        // Do any additional setup after loading the view.
    }

    //backende veri atılacak kısım backende hangi aşıya hangi izinler olduğu söylenmeli.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = todoTableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! TodoCell
        let todo = todos[indexPath.row]
        cell.checkmarkImageView.image = UIImage(named: "unmark")
        cell.taskLabel.text = todo.title
        cell.checkmarkImageView.image = todo.isMarked == true ? UIImage(named:"mark") : UIImage(named: "unmark")
        
        //cell.textLabel?.text = self.choosen_friends[indexPath.row]["vaccine"] as! String
        //cell.textLabel?.text="basak"
        print("deneme")
       // print(self.choosen_friends[indexPath.row]["vaccine"])
    
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? TodoCell else {return }
        var todo = todos[indexPath.row]
        todo.isMarked = !todo.isMarked
        todos.remove(at: indexPath.row)
        todos.insert(todo, at: indexPath.row)
        cell.checkmarkImageView.image = todo.isMarked == true ? UIImage(named:"mark") : UIImage(named: "unmark")
    }
    
    
    @IBAction func save_permission(_ sender: Any) { //id elimizde mevcut o id li aşıya gerekli isteği göndericez backende
        var perm_1=todos[0]
        var perm_2=todos[1]
        if (perm_1.isMarked == true)
        {
            print("herkese açık")
        }else{
            print("herkese açık degil")
        }
        if (perm_2.isMarked == true)
        {
            print("arkadaslara açık")
        }else{
            print("arkadaslara açık degil")
        }
        //print(asi_id)
       // performSegue(withIdentifier: "toMyvac", sender: nil)
        
        let alert = UIAlertController(title: "Kaydedildi !", message: "İzinler Başarılı Bir Şekilde Kaydedildi",preferredStyle: UIAlertController.Style.alert )
        let okButton = UIAlertAction(title : "Tamam", style: UIAlertAction.Style.default) { (UIAlertAction )in
            print("yeey")
            
        }
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
