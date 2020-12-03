//
//  ViewController.swift
//  SysMindDemo
//
//  Created by veerendra Pratap Singh on 03/12/20.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableview:UITableView!
    var arr = [Marvels]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        arr = DataBaseHelper.shareInstance.fetchData()
        tableview.reloadData()
    }
    
    //MARK:- Button Actions
    @IBAction func btnAdd (_ sender:UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddMarvelsVCSID") as! AddMarvelsVC
         navigationController?.pushViewController(vc, animated: true)
    }
}

//============================= UITableView Delegate and DataSource =======================

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellRID", for: indexPath) as! cellClass
        cell.lblName.text = arr[indexPath.row].name
        cell.lblDesc.text = arr[indexPath.row].desc
        cell.imageShow.image = UIImage(data: arr[indexPath.row].image!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let rightAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(self.arr[indexPath.row])
            self.arr.remove(at: indexPath.row)
            do {
                try context.save()
                print("Data Saved")
                self.arr = DataBaseHelper.shareInstance.fetchData()
                self.tableview.reloadData()
            } catch {
                print(error.localizedDescription)
            }
            success(true)
        })
        
        rightAction.backgroundColor = UIColor.red
        return UISwipeActionsConfiguration(actions: [rightAction])
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

//========================= UITableViewCell Class ===========================================
class cellClass: UITableViewCell {
    @IBOutlet weak var imageShow:UIImageView!
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblDesc:UILabel!
    @IBOutlet weak var viewMain:UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewMain.layer.shadowColor = UIColor.lightGray.cgColor
        viewMain.layer.shadowOpacity = 1
        viewMain.layer.shadowOffset = CGSize.zero
        viewMain.layer.shadowRadius = 5
        viewMain.layer.cornerRadius = 8
        imageShow.layer.cornerRadius = 8
    }
}
