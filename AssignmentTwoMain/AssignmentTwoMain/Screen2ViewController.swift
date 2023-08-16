import UIKit
class Screen2ViewController: UIViewController {
    var phoneNumber: String?
    private var countryCodeLabel: UILabel!
    private var phoneNumberLabel: UILabel!
    private var countdownLabel: UILabel!
    private var enterOTPLabel: UILabel!
    @IBOutlet weak var otpTextField: UITextField!
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        guard let otp = otpTextField.text else {
            return
        }
        
        makeOTPAPICall(otp: otp)
    }
    
    func makeOTPAPICall(otp: String) {
        guard let url = URL(string: "https://app.aisle.co/V1/users/verify_otp") else {
            return
        }
        
        guard let phoneNumber = phoneNumber else {
            return
        }
        
        let parameters: [String: Any] = ["number": phoneNumber, "otp": otp]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            // Handle JSON serialization error
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    // Handle success response and get auth token
                    print("Response JSON on screen2:",responseJSON)
                    if let authToken = responseJSON?["token"] as? String {
                        DispatchQueue.main.async {
                            self.navigateToScreen3(authToken: authToken)
                        }
                    } else {
                        // Handle missing auth token
                        print("Missing auth token in response on Screen2")
                    }
                } catch {
                    // Handle JSON parsing error
                    print("JSON parsing error on Screen2:",error)
                }
            } else if let error = error {
                // Handle network error
                print("Network Error on screen2:", error)
            }
        }
        task.resume()
    }
    
    func navigateToScreen3(authToken: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let screen3VC = storyboard.instantiateViewController(withIdentifier: "Screen3ViewController") as? Screen3ViewController {
            screen3VC.authToken = authToken
            navigationController?.pushViewController(screen3VC, animated: true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create and configure country code label
        
        otpTextField.frame = CGRect(x: 31, y: 204, width: 78, height: 36)
        otpTextField.text = nil
        view.addSubview(otpTextField)
        countryCodeLabel = UILabel()
        countryCodeLabel.frame = CGRect(x: 30, y: 80, width: 152, height: 22)
        countryCodeLabel.font = UIFont(name: "Inter", size: 18)
        countryCodeLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        countryCodeLabel.textColor = UIColor.black
        countryCodeLabel.textAlignment = .left
        view.addSubview(countryCodeLabel)
        
        // Create and configure phone number label
        phoneNumberLabel = UILabel()
        phoneNumberLabel.frame = CGRect(x: 30, y: 110, width: 152, height: 22)
        phoneNumberLabel.font = UIFont(name: "Inter", size: 18)
        phoneNumberLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        phoneNumberLabel.textColor = UIColor.black
        phoneNumberLabel.textAlignment = .left
        view.addSubview(phoneNumberLabel)
        // Create and configure "Enter The OTP" label
        enterOTPLabel = UILabel()
        enterOTPLabel.frame = CGRect(x: 30, y: 140, width: 144, height: 72)
        enterOTPLabel.font = UIFont(name: "Inter", size: 30)
        enterOTPLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        enterOTPLabel.textColor = UIColor.black
        enterOTPLabel.textAlignment = .left
        enterOTPLabel.numberOfLines = 0
        enterOTPLabel.text = "Enter The OTP"
        
        view.addSubview(enterOTPLabel)
        countdownLabel = UILabel()
        countdownLabel.frame = CGRect(x: 140, y: 290, width: 42, height: 17)
        countdownLabel.font = UIFont(name: "Inter", size: 12) // Adjust font size as needed
        countdownLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        countdownLabel.textColor = UIColor.black
        countdownLabel.textAlignment = .left
        countdownLabel.text = "00:59" // Initial countdown value
        view.addSubview(countdownLabel)
        let continueButton = UIButton(type: .system)
        continueButton.frame = CGRect(x: 32, y: 279, width: 96, height: 40)
        continueButton.setTitle("Continue", for: .normal)
        continueButton.backgroundColor = UIColor(hex: "#F9CB10")
        continueButton.setTitleColor(UIColor.white, for: .normal)
        continueButton.layer.cornerRadius = 20
        continueButton.addTarget(self, action: #selector(continueButtonTapped(_:)), for: .touchUpInside)
        self.view.addSubview(continueButton)
        
        configureUI()
        startCountdown()
    }
    func configureUI() {
        // Set country code and phone number labels
        if let phoneNumber = phoneNumber {
            let countryCode = phoneNumber.prefix(3) // Assuming the country code is the first 3 digits
            countryCodeLabel.text = String(countryCode)
            let actualPhoneNumber = phoneNumber.suffix(phoneNumber.count - 3)
            phoneNumberLabel.text = String(actualPhoneNumber)
        }
        
        // Configure OTP text field
        otpTextField.layer.cornerRadius = 8
        otpTextField.layer.borderWidth = 1
        otpTextField.layer.borderColor = UIColor(hex: "#C4C4C4").cgColor
    }
    
    func startCountdown() {
        // Assuming you have a timerLabel to display the countdown
        var countdown = 59
        let countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            self?.countdownLabel.text = String(format: "%02d:%02d", countdown / 60, countdown % 60)
            countdown -= 1
            if countdown < 0 {
                timer.invalidate()
            }
        }
        countdownTimer.fire()
    }
}
