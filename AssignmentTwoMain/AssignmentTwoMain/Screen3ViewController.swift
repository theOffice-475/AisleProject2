import UIKit

class Screen3ViewController: UIViewController {
    var authToken: String?
    var profileData: [String: Any]?
    private var tabBar: UITabBar!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var interestedLabel: UILabel!
    @IBOutlet weak var premiumLabel: UILabel!
    @IBOutlet weak var personalLabel: UILabel!
    @IBOutlet weak var upgradeButton: UIButton!
    @IBOutlet weak var blurredImageView1: UIImageView!
    @IBOutlet weak var blurredImageView2: UIImageView!
    @IBOutlet weak var discoverButton: UIButton!
    @IBOutlet weak var notesButton: UIButton!
    @IBOutlet weak var matchesButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let authToken = authToken {
            makeNotesAPICall(authToken: authToken)
        }
        configureUI()
        tabBar = UITabBar()
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        tabBar.backgroundColor = UIColor.white
        view.addSubview(tabBar)
        // Position the tab bar at the bottom
        NSLayoutConstraint.activate([
            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -10),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -26),
            tabBar.heightAnchor.constraint(equalToConstant: 71),
        ])
        configureTabBarItems()
        self.premiumLabel.textColor = UIColor.gray
        self.premiumLabel.alpha = 0.6
    }
    
    func configureUI() {
        if let font = UIFont(name: "Gilroy-Bold", size: 18) {
            self.personalLabel.font = font
        }
        self.nameLabel.text = "Meena"
        self.ageLabel.text = "23";
        self.profileImageView.image = UIImage(named: "photo3")
        self.profileImageView.backgroundColor = UIColor.lightGray
        self.profileImageView.contentMode = .scaleAspectFill
        self.profileImageView.widthAnchor.constraint(equalToConstant: 383).isActive = true
        self.profileImageView.heightAnchor.constraint(equalToConstant: 572).isActive = true
        self.profileImageView.setContentHuggingPriority(.required, for: .vertical)
        self.profileImageView.setContentHuggingPriority(.required, for: .horizontal)
        let blurredImage2Frame = CGRect(x: -10, y: -32, width: 223, height: 334)
        self.blurredImageView2.frame = blurredImage2Frame
        self.blurredImageView1.backgroundColor = UIColor.lightGray
        self.blurredImageView2.backgroundColor = UIColor.lightGray
        // Set up layout for blurredImageView1
        let blurredImageView1Width: CGFloat = 395
        let blurredImageView1Height: CGFloat = 263
        let blurredImageView1Top: CGFloat = 565
        let blurredImageView1Left: CGFloat = -110
        
        let blurredImageView1Frame = CGRect(x: blurredImageView1Left,
                                            y: blurredImageView1Top,
                                            width: blurredImageView1Width,
                                            height: blurredImageView1Height)
        
        self.blurredImageView1.frame = blurredImageView1Frame
        self.blurredImageView1.image = UIImage(named: "photo1")
        self.blurredImageView1.contentMode = .scaleToFill
        self.blurredImageView2.contentMode = .scaleToFill
        self.blurredImageView2.image = UIImage(named: "photo2")
    }
    
    func makeNotesAPICall(authToken: String) {
        guard let url = URL(string: "https://app.aisle.co/V1/users/test_profile_list") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                // Handle success response
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    self.profileData = responseJSON
                } catch {
                    // Handle JSON parsing error
                    print("JSON parsing error On Screen3:",error)
                }
            } else if let error = error {
                // Handle network error
                print("Network Error on Screen 3:", error)
            }
        }
        task.resume()
    }
    func configureTabBarItems() {
        let discoverItem = UITabBarItem(title: nil, image: UIImage(named: "discover2")?.withRenderingMode(.alwaysOriginal), tag: 0)
        let notesItem = UITabBarItem(title: nil, image: UIImage(named: "notes2")?.withRenderingMode(.alwaysOriginal), tag: 1)
        let matchesItem = UITabBarItem(title: nil, image: UIImage(named: "matches2")?.withRenderingMode(.alwaysOriginal), tag: 2)
        let profileItem = UITabBarItem(title: nil, image: UIImage(named: "profile2")?.withRenderingMode(.alwaysOriginal), tag: 3)
        
        // Configure the tab bar items' insets based on your provided layout values
        discoverItem.imageInsets = UIEdgeInsets(top: 12, left: 64, bottom: 0, right: 0)
        notesItem.imageInsets = UIEdgeInsets(top: 13.88671875, left: 24.375, bottom: 0, right: 0)
        matchesItem.imageInsets = UIEdgeInsets(top: 14, left: 24.37, bottom: 0, right: 0)
        profileItem.imageInsets = UIEdgeInsets(top: 2, left: 24.37, bottom: 0, right: 0)
        
        // Add the text labels to the notes and matches items
        notesItem.badgeValue = "9"
        notesItem.badgeColor = .red
        notesItem.setBadgeTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11, weight: .bold)], for: .normal)
        
        matchesItem.badgeValue = "50+"
        matchesItem.badgeColor = .red
        matchesItem.setBadgeTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11, weight: .bold)], for: .normal)
        
        // Set the tab bar items
        tabBar.items = [discoverItem, notesItem, matchesItem, profileItem]}
}
