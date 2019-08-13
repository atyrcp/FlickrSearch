//
//  SearchView.swift
//  iOSDemoApp
//
//  Created by alien on 2019/8/12.
//  Copyright © 2019 z. All rights reserved.
//

import UIKit
//自訂的 xib 檔
class SearchView: UIView, NibNameProtocol {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var searchKeywordTextField: UITextField!
    @IBOutlet weak var searchAmountTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    private func customSetup() {
        translatesAutoresizingMaskIntoConstraints = false
        Bundle.main.loadNibNamed(SearchView.nibName(), owner: self, options: nil)
        addSubview(contentView)
        searchButton.isEnabled = false
        searchButton.backgroundColor = .gray
        searchAmountTextField.delegate = self
        searchKeywordTextField.delegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = self.bounds
    }
    
    override var intrinsicContentSize: CGSize {
        let height = stackView.bounds.height
        let width = stackView.bounds.width
        return CGSize(width: width, height: height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customSetup()
    }
}

extension SearchView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //設定輸入的內容不正確時無法搜尋:
    //兩個搜尋欄任一為空時
    //數量搜尋欄不為數字時
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var updatedText = ""
        
        if let text = textField.text, let textRange = Range(range, in: text) {
            updatedText = text.replacingCharacters(in: textRange, with: string)
        }
        
        if textField == searchAmountTextField {
            
            let amount = Int(updatedText)
            if amount != nil && searchKeywordTextField.text != "" {
                searchButton.isEnabled = true
                searchButton.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            } else {
                searchButton.isEnabled = false
                searchButton.backgroundColor = .gray
            }
            
        } else if textField == searchKeywordTextField {
            
            let amount = Int(searchAmountTextField.text!)
            if amount != nil && updatedText != "" {
                searchButton.isEnabled = true
                searchButton.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            } else {
                searchButton.isEnabled = false
                searchButton.backgroundColor = .gray
            }
            
        } else {
            
            searchButton.isEnabled = false
            searchButton.backgroundColor = .gray
        }
        return true
    }
}
