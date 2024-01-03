//
//  BMICalcultorViewController.swift
//  BMICalcultor
//
//  Created by 조유진 on 1/3/24.
//

import UIKit

class BMICalcultorViewController: UIViewController {
    @IBOutlet weak var appTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var personImageView: UIImageView!
    
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var randomCalculateButton: UIButton!
    
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var showBMIButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        designLabel(appTitleLabel, 
                    text: "BMI Calculator",
                    font: .systemFont(ofSize: 24, weight: .heavy),
                    textColor: .black,
                    numberOfLines: 1)
        designLabel(descriptionLabel, 
                    text: "당신의 BMI 지수를 알려드릴게요.",
                    font: .systemFont(ofSize: 14),
                    textColor: .black,
                    numberOfLines: 2)
        designLabel(heightLabel, 
                    text: "키가 어떻게 되시나요?",
                    font: .systemFont(ofSize: 14),
                    textColor: .black,
                    numberOfLines: 1)
        designLabel(weightLabel, 
                    text: "몸무게는 어떻게 되시나요?",
                    font: .systemFont(ofSize: 14),
                    textColor: .black,
                    numberOfLines: 1)
        
        designImageView(personImageView,
                        image: UIImage(named: "person"),
                        contentMode: .scaleToFill)
        
        designTextField(heightTextField,
                        placeHolder: "키를 입력하세요",
                        keyboardType: .decimalPad,
                        isSecure: false)
        designTextField(weightTextField, 
                        placeHolder: "몸무게를 입력하세요",
                        keyboardType: .decimalPad,
                        isSecure: false)
        
        designButton(randomCalculateButton,
                     title: "랜덤으로 BMI 계산하기",
                     titleColor: .red,
                     backgroundColor: .clear,
                     cornerRadius: nil)
        
        designButton(showBMIButton,
                     title: "결과 확인",
                     titleColor: .white,
                     backgroundColor: .purple,
                     cornerRadius: 12)
    }

    
    @IBAction func randomBmiClicked(_ sender: UIButton) {
        let randomHeight = getRandomHeightDouble()
        let randomWeight = getRandomWeightDouble()
        
        heightTextField.text = String(format: "%.2f", randomHeight)
        weightTextField.text = (String(format: "%.2f", randomWeight))
    }
    
    // 결과 확인 버튼 클릭했을 때
    @IBAction func showResultButtonClicked(_ sender: UIButton) {
        let heightString = heightTextField.text
        let weightString = weightTextField.text
        
        print("Okay")
        
        // 1. 공백 검사
        guard let height = heightString else {
            alertMessage(title: "공백이 있습니다.", message: "키를 입력해주세요.", alertType: .alert)
            return
        }
        
        guard let weight = weightString else {
            alertMessage(title: "공백이 있습니다.", message: "몸무게를 입력해주세요.", alertType: .alert)
            return
        }
        
        print("Okay2")
        
        // 2. 빈칸 제거
        let trimHeight = height.components(separatedBy: [" "]).joined()
        let trimWeight = weight.components(separatedBy: [" "]).joined()
//        let trimWeight = weight.trimmingCharacters(in: [" "])
        
        print("Okay3")
        
        // 3. 문자이면 오류처리
        guard let doubleHeight = Double(trimHeight) else {
            alertMessage(title: "입력 오류", message: "숫자를 입력해주세요.", alertType: .alert)
            return
        }
        guard let doubleWeight = Double(trimWeight) else {
            alertMessage(title: "입력 오류", message: "숫자를 입력해주세요.", alertType: .alert)
            return
        }
        
        print("Okay4")
        
        // 4. 키 / 몸무게 범위 처리
        if isHeightSafeRange(height: doubleHeight) != true {
            alertMessage(title: "잘못된 범위 입력", message: "키에 대해 올바른 범위를 입력해주세요.(120cm~210cm)", alertType: .alert)
            return
        }
        if isWeightSafeRange(weight: doubleWeight) != true{
            alertMessage(title: "잘못된 범위 입력", message: "몸무게에 대해 올바른 범위를 입력해주세요.(30kg~200kg)", alertType: .alert)
            return
        }
        
        print("Okay5")
        
        let bmiResult = calculateBMI(height: doubleHeight, weight: doubleWeight)
        print(bmiResult)
        
        self.alertMessage(title: "BMI 계산 결과", message: "당신의 BMI는 \(bmiResult) 입니다.", alertType: .alert)
        heightTextField.text = ""
        weightTextField.text = ""
    }
    
    // 키 범위 확인
    func isHeightSafeRange(height: Double) -> Bool {
        if height > 120 && height < 210 {
            return true
        } else {
            return false
        }
    }
    
    // 몸무게 범위 확인
    func isWeightSafeRange(weight: Double) -> Bool {
        if weight > 30 && weight < 200 {
            return true
        } else {
            return false
        }
    }
    
    // Alert 띄우기
    func alertMessage(title: String?, message: String?, alertType: UIAlertController.Style) {
        let alert =  UIAlertController(title: title, message: message, preferredStyle: alertType)
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(confirmAction)
        present(alert, animated: true)
    }
    
    // 뷰를 클릭했을 때 키보드 내리기
    @IBAction func didTapView(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // BMI 계산
    func calculateBMI(height: Double, weight: Double) -> Double {
        let dotHeight = height / 100
        let result = weight / (dotHeight * dotHeight)
        print("BMI 계산 결과\(result)")
        return result
    }
    
    // 랜덤 키 가져오기
    func getRandomHeightDouble() -> Double {
        let randomHeight = Double.random(in: 120...210)
        return randomHeight
    }
    
    // 랜덤 몸무게 가져오기
    func getRandomWeightDouble() -> Double {
        let randomWeight = Double.random(in: 30...200)
        return randomWeight
    }
    
    // 이미지뷰 디자인
    func designImageView(_ imageView: UIImageView, image: UIImage?, contentMode: UIView.ContentMode) {
        imageView.image = image
        imageView.contentMode = contentMode
    }

    // 레이블 디자인
    func designLabel(_ label: UILabel, text: String, font: UIFont, textColor: UIColor, numberOfLines: Int) {
        label.text = text
        label.font = font
        label.textColor = textColor
        label.numberOfLines = numberOfLines
    }
    
    // 텍스트필드 디자인
    func designTextField(_ textField: UITextField, placeHolder: String?, keyboardType: UIKeyboardType, isSecure: Bool) {
        guard let placeHolder = placeHolder else { return }
        textField.placeholder = placeHolder
        textField.keyboardType = keyboardType
        textField.isSecureTextEntry = isSecure
        
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 12
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.layer.borderWidth = 1
    }
    
    // 버튼 디자인
    func designButton(_ button: UIButton, title: String, titleColor: UIColor, backgroundColor: UIColor?, cornerRadius: CGFloat?) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        
        guard let backgroundColor = backgroundColor else { return }
        button.backgroundColor = backgroundColor
       
        
        guard let cornerRadius = cornerRadius else { return }
        button.clipsToBounds = true
        button.layer.cornerRadius = cornerRadius
    }
}

