//
//  TermsandconditionViewController.swift
//  Vox
//
//  Created by Skander Thabet on 19/5/2022.
//

import UIKit
import WebKit

class TermsandconditionViewController: UIViewController {

    @IBOutlet weak var webview: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        var myURL: URL!
                myURL = URL(string: "https://www.freeprivacypolicy.com/live/7ad54379-f367-419d-8bb2-f2c25359a46e")
                let myRequest = URLRequest(url: myURL!)
                webview.load(myRequest)
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

extension TermsandconditionViewController {
    static func sharedInstance() -> TermsandconditionViewController {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "TermsandconditionViewController") as! TermsandconditionViewController
        
    }
}
