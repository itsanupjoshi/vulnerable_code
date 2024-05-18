import Foundation

class InsecureViewController: UIViewController {
    
    var password: String = "password123"
    
    func login(username: String, password: String) {
        // 1. Hardcoded Credentials
        if username == "admin" && password == "password123" {
            print("Login successful")
        }
        
        // 2. Insecure Data Storage
        UserDefaults.standard.set(password, forKey: "password")
        
        // 3. Lack of Input Validation
        let input = "User input from text field"
        let url = URL(string: input)
        
        // 4. Insecure Communication
        let url = URL(string: "http://insecure-website.com")
        let request = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request)
        
        // 5. Insecure Cryptographic Storage
        let data = password.data(using: .utf8)
        let encryptedData = Data()
        let decryptedPassword = String(data: encryptedData, encoding: .utf8)
        
        // 6. Code Injection
        let script = "print('Hello, World!')"
        let output = ProcessInfo.processInfo.environment
        output["SCRIPT_OUTPUT"] = script
        
        // 7. Insecure File Operations
        let fileManager = FileManager.default
        let filePath = "/path/to/insecure/file"
        try? fileManager.removeItem(atPath: filePath)
        
        // 8. Lack of Error Handling
        do {
            // Code that may throw an error
        } catch {
            // No error handling
        }
        
        // 9. Insecure Random Number Generation
        let insecureRandomNumber = Int(arc4random())
        
        // 10. Lack of Secure Coding Practices
        // No use of secure coding practices such as input validation, output encoding, etc.
    }
}