import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        guard let country = countryTextField.text,
              let phoneNumber = phoneNumberTextField.text else {
            return
        }
        
        let phoneNumberWithCountryCode = "\(country)\(phoneNumber)"
        
        makePhoneNumberAPICall(phoneNumber: phoneNumberWithCountryCode)
    }
    func makePhoneNumberAPICall(phoneNumber: String) {
        guard let url = URL(string: "https://app.aisle.co/V1/users/phone_number_login") else {
            return
        }
        
        let parameters: [String: Any] = ["number": phoneNumber]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            // Handle JSON serialization error
            print("JSON serialization error:", error)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    // Handle success response and navigate to Screen2
                    DispatchQueue.main.async {
                        self.navigateToScreen2(withPhoneNumber: phoneNumber)
                    }
                } catch {
                    // Handle JSON parsing error
                    print("JSON parsing error:", error)
                }
            } else if let error = error {
                // Handle network error
                print("Network error:", error)
            }
        }
        task.resume()
    }
    func navigateToScreen2(withPhoneNumber phoneNumber: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let screen2VC = storyboard.instantiateViewController(withIdentifier: "Screen2ViewController") as? Screen2ViewController {
            screen2VC.phoneNumber = phoneNumber
            navigationController?.pushViewController(screen2VC, animated: true)
        }
    }
    func configureCountryTextField() {
        countryTextField.frame = CGRect(x: 31, y: 194, width: 64, height: 36)
        countryTextField.text = "+91"
        configureTextField(countryTextField)
    }
    
    func configurePhoneNumberTextField() {
        phoneNumberTextField.frame = CGRect(x: 103, y: 194, width: 147, height: 36)
        phoneNumberTextField.text = nil
        configureTextField(phoneNumberTextField)
    }
    
    func configureTextField(_ textField: UITextField) {
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.backgroundColor = UIColor(hex: "#C4C4C4")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Create and configure "Get OTP" label
        let getOtpLabel = UILabel()
        getOtpLabel.text = "Get OTP"
        getOtpLabel.frame = CGRect(x: 30, y: 80, width: 73, height: 22)
        getOtpLabel.font = UIFont(name: "Inter", size: 18)
        getOtpLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        // Set other properties like text color, alignment, etc.
        
        // Create and configure "Enter Your Phone Number" label
        let enterPhoneNumberLabel = UILabel()
        enterPhoneNumberLabel.text = "Enter Your\nPhone Number"
        enterPhoneNumberLabel.numberOfLines = 0
        enterPhoneNumberLabel.frame = CGRect(x: 30, y: 110, width: 220, height: 72)
        enterPhoneNumberLabel.font = UIFont(name: "Inter", size: 30)
        enterPhoneNumberLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        // Set other properties like text color, alignment, etc.
        
        // Add labels to the view
        view.addSubview(getOtpLabel)
        view.addSubview(enterPhoneNumberLabel)
        let continueButton = UIButton(type: .system)
        continueButton.frame = CGRect(x: 32, y: 249, width: 96, height: 40)
        continueButton.setTitle("Continue", for: .normal)
        continueButton.backgroundColor = UIColor(hex: "#F9CB10")
        continueButton.setTitleColor(UIColor.white, for: .normal)
        continueButton.layer.cornerRadius = 20
        continueButton.addTarget(self, action: #selector(continueButtonTapped(_:)), for: .touchUpInside)
        self.view.addSubview(continueButton)
        configureCountryTextField()
        configurePhoneNumberTextField()
    }
}
extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
