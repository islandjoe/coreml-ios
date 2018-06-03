import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var genderLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()
    nameTextField.delegate = self
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    return true
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}

