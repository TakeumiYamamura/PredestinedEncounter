import UIKit
import Parse
import AlamofireImage
import Alamofire


class MessageListTableViewController: UITableViewController {
    let userManger = UserManager.sharedInstance
    var refresh: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        userManger.fetchUsers { () -> Void in
            self.tableView.reloadData()
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(UINib(nibName: "MessageListTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageListTableViewCell")
        
        self.refresh = UIRefreshControl()
        self.refresh.attributedTitle = NSAttributedString(string: "Loading...")
        self.refresh.addTarget(self, action: "pullToRefresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refresh)
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "multiple25.png"))

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userManger.users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MessageListTableViewCell", forIndexPath: indexPath) as! MessageListTableViewCell
        let user = userManger.users[indexPath.row]
        let imageUrl = NSURL(string: user.image)
        let imageData = NSData(contentsOfURL: imageUrl!)
        cell.listImageview.image = UIImage(data: imageData!)
        cell.listImageview.layer.cornerRadius = cell.listImageview.frame.size.width / 2
        cell.listName.text = user.username
        cell.listText.text = String(user.age)
        cell.listImageview.contentMode = UIViewContentMode.ScaleAspectFill
        cell.listImageview.clipsToBounds = true
        return cell
    }
    
    func pullToRefresh(){
        self.tableView.reloadData()
        self.refresh.endRefreshing()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showMessageViewController",sender: nil)
    }
    @IBAction func tapBackButton(sender: UIButton) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }

}
