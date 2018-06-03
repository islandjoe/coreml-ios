import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var genderLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()
    nameTextField.delegate = self
  }

  func features(_ string: String) -> [String: Double] {
    guard !string.isEmpty else { return [:] }
    
    let string = string.lowercased()
    var keys: [String] = []
    
    keys.append("firstLetter1=\(string.prefix(1))")
    keys.append("firstLetter2=\(string.prefix(2))")
    keys.append("firstLetter3=\(string.prefix(3))")
    
    keys.append("lastLetter1=\(string.suffix(1))")
    keys.append("lastLetter2=\(string.suffix(2))")
    keys.append("lastLetter3=\(string.suffix(3))")
    
    let empty: [String: Double] = [:]
    return keys.reduce(empty) { (result, key) -> [String: Double] in
      var result = result
      result[key] = 1.0
      
      return result
    }
  
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    return true
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}

