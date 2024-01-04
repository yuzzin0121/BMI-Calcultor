//
//  BMICalcultorViewController.swift
//  BMICalcultor
//
//  Created by 조유진 on 1/3/24.
//

import UIKit

enum Status: String {
    case normal = "정상"
    case obesity = "비만"
    case highObesity = "고도비만"
}

class BMICalcultorViewController: UIViewController {
    @IBOutlet weak var appTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var personImageView: UIImageView!
    
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var randomCalculateButton: UIButton!
    
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var showBMIButton: UIButton!
    @IBOutlet weak var resetUserButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        designLabel(appTitleLabel, 
                    text: "BMI Calculator",
                    font: .systemFont(ofSize: 24, weight: .heavy))
        
        
        designLabel(nicknameLabel, 
                    text: "닉네임이 어떻게 되시나요?")
        
        designLabel(heightLabel,
                    text: "키가 어떻게 되시나요?")
        
        designLabel(weightLabel,
                    text: "몸무게는 어떻게 되시나요?")
        
        designImageView(personImageView,
                        image: UIImage(named: "person"),
                        contentMode: .scaleToFill)
        
        if let nickname = UserDefaults.standard.string(forKey: "myNickname"){
            print(nickname)
            designLabel(descriptionLabel,
                        text: "\(nickname)님의 BMI 지수를 알려드릴게요.",
                        numberOfLines: 2)
            designTextField(nicknameTextField,
                            text: nickname,
                            placeHolder: "닉네임을 입력하세요",
                            keyboardType: .default)
        } else {
            print("닉네임 없음")
            designLabel(descriptionLabel,
                        text: "당신의 BMI 지수를 알려드릴게요.",
                        numberOfLines: 2)
            designTextField(nicknameTextField,
                            text: nil,
                            placeHolder: "닉네임을 입력하세요",
                            keyboardType: .default)
        }
        
        let myHeight = UserDefaults.standard.double(forKey: "myHeight")
        
        if myHeight == 0.0 {
            designTextField(heightTextField,
                            placeHolder: "키를 입력하세요")
        } else {
            designTextField(heightTextField,
                            text: String(myHeight),
                            placeHolder: "키를 입력하세요")
        }
        
                        
        
        let myWeight = UserDefaults.standard.double(forKey: "myWeight")
        
        if myWeight == 0.0 {
            designTextField(weightTextField,
                            placeHolder: "몸무게를 입력하세요")
        } else {
            designTextField(weightTextField,
                            text: String(myWeight),
                            placeHolder: "몸무게를 입력하세요")
        }
        
        
        designButton(randomCalculateButton,
                     title: "랜덤으로 BMI 계산하기",
                     titleColor: .red,
                     backgroundColor: .clear,
                     cornerRadius: nil)
        
        designButton(showBMIButton,
                     title: "결과 확인",
                     backgroundColor: .purple)
        
        designButton(resetUserButton, 
                     title: "내 정보 리셋하기",
                     backgroundColor: .darkGray)
    }

    // 랜덤 BMI 버튼 클릭했을 때
    @IBAction func randomBmiClicked(_ sender: UIButton) {
        let randomHeight = getRandomValue(min: 120, max: 200)
        let randomWeight = getRandomValue(min: 30, max: 200)
        
        heightTextField.text = String(format: "%.2f", randomHeight)
        weightTextField.text = (String(format: "%.2f", randomWeight))
    }
    
    // 결과 확인 버튼 클릭했을 때
    @IBAction func showResultButtonClicked(_ sender: UIButton) {
        let nicknameString = nicknameTextField.text
        let heightString = heightTextField.text
        let weightString = weightTextField.text
        
        // 1. 공백 검사
        guard let nickname = nicknameString, let height = heightString, let weight = weightString else {
            alertMessage(title: "공백이 있습니다.", message: "모든 내용을 입력해주세요.", alertType: .alert)
            return
        }
        
        // 2. 빈칸 제거
        let trimNickname = nickname.components(separatedBy: [" "]).joined()
        let trimHeight = height.components(separatedBy: [" "]).joined()
        let trimWeight = weight.components(separatedBy: [" "]).joined()
//        let trimWeight = weight.trimmingCharacters(in: [" "])
        
        // 3. 문자이면 오류처리
        guard let doubleHeight = Double(trimHeight), let doubleWeight = Double(trimWeight) else {
            alertMessage(title: "입력 오류", message: "숫자를 입력해주세요.", alertType: .alert)
            return
        }
        
        // 4. 키 / 몸무게 범위 처리
        if isHeightSafeRange(height: doubleHeight) != true {
            alertMessage(title: "잘못된 범위 입력", message: "키에 대해 올바른 범위를 입력해주세요.(120cm~210cm)", alertType: .alert)
            return
        }
        if isWeightSafeRange(weight: doubleWeight) != true{
            alertMessage(title: "잘못된 범위 입력", message: "몸무게에 대해 올바른 범위를 입력해주세요.(30kg~200kg)", alertType: .alert)
            return
        }
        
        // UserDefaults에 저장하기
        UserDefaults.standard.set(trimNickname, forKey: "myNickname")
        UserDefaults.standard.set(doubleHeight, forKey: "myHeight")
        UserDefaults.standard.set(doubleWeight, forKey: "myWeight")
        
        let bmi = calculateBMI(height: doubleHeight, weight: doubleWeight)
        print(bmi)
        
        let bmiResult = String(format: "%.2f", bmi)
        
        let totalResult = getBMIResult(bmi: bmi)
        
        self.alertMessage(title: "BMI 계산 결과", message: "\(trimNickname)님의 BMI는 \(bmiResult)으로, \(totalResult)입니다.", alertType: .alert)
    }
    
    func getBMIResult(bmi: Double) -> String {
        switch bmi {
        case 1...25:
            return Status.normal.rawValue
        case 25..<30:
            return Status.obesity.rawValue
        case 30...:
            return Status.highObesity.rawValue
        default:
            return Status.normal.rawValue
        }
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

    // BMI 계산
    func calculateBMI(height: Double, weight: Double) -> Double {
        let dotHeight = height / 100
        let result = weight / (dotHeight * dotHeight)
        print("BMI 계산 결과\(result)")
        return result
    }
    
    // MARK: - 랜덤
    
    // 랜덤 값 가져오기
    func getRandomValue(min: Double, max: Double) -> Double {
        let randomValue = Double.random(in: min...max)
        return randomValue
    }
    
    // 뷰를 클릭했을 때 키보드 내리기
    @IBAction func didTapView(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - 디자인
    
    // 이미지뷰 디자인
    func designImageView(_ imageView: UIImageView, image: UIImage?, contentMode: UIView.ContentMode) {
        imageView.image = image
        imageView.contentMode = contentMode
    }

    // 레이블 디자인
    func designLabel(_ label: UILabel, text: String? = nil, font: UIFont = UIFont.systemFont(ofSize: 14), textColor: UIColor = .black, numberOfLines: Int = 1) {
        guard let text = text else { return }
        label.text = text
        label.font = font
        label.textColor = textColor
        label.numberOfLines = numberOfLines
    }
    
    // 텍스트필드 디자인
    func designTextField(_ textField: UITextField, text: String? = nil, placeHolder: String?, keyboardType: UIKeyboardType = .decimalPad, isSecure: Bool = false) {
        print("텍스트필드 디자인")
        if let text = text {
            textField.text = text
        }
        
        if let placeHolder = placeHolder {
            textField.placeholder = placeHolder
        }
        textField.keyboardType = keyboardType
        textField.isSecureTextEntry = isSecure
        
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 12
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.layer.borderWidth = 1
    }
    
    // 버튼 디자인
    func designButton(_ button: UIButton, title: String, titleColor: UIColor = .white, backgroundColor: UIColor?, cornerRadius: CGFloat? = 12) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        
        guard let backgroundColor = backgroundColor else { return }
        button.backgroundColor = backgroundColor
       
        
        guard let cornerRadius = cornerRadius else { return }
        button.clipsToBounds = true
        button.layer.cornerRadius = cornerRadius
    }
}


