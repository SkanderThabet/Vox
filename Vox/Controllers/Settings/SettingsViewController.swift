import UIKit

class SettingsViewController: UIViewController {
    
    @IBAction func termActionBtn(_ sender: Any) {
        let TermsVC = TermsandconditionViewController.sharedInstance()
        self.navigationController?.pushViewController(TermsVC, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        // Do any additional setup after loading the view.
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SettingsViewController {
    static func sharedInstance() -> SettingsViewController {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        
    }
}
