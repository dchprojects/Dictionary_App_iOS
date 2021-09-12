//
//  AuthenticationViewController.swift
//  MyDictionary_App_Swift
//
//  Created Dmytro Chumakov on 12.08.2021.

import UIKit

final class AuthenticationViewController: BaseAuthViewController {
    
    fileprivate let presenter: AuthenticationPresenterInputProtocol
    
    fileprivate let backButtonSize: CGSize = .init(width: 40, height: 40)
    fileprivate let backButton: UIButton = {
        let button: UIButton = .init()
        button.setImage(MDAppStyling.Image.back_white_arrow.image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate let loginLabel: UILabel = {
        let label: UILabel = .init()
        label.font = MDAppStyling.Font.MyriadProSemiBold.font(ofSize: 34)
        label.text = KeysForTranslate.login.localized
        label.textColor = MDAppStyling.Color.md_White_0_Light_Appearence.color()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate static let nicknameTextFieldHeight: CGFloat = 48
    fileprivate static let nicknameTextFieldTopOffset: CGFloat = 24
    fileprivate static let nicknameTextFieldLeftOffset: CGFloat = 16
    fileprivate static let nicknameTextFieldRightOffset: CGFloat = 16
    fileprivate let nicknameTextField: MDTextFieldWithToolBar = {
        let textField: MDTextFieldWithToolBar = .init(frame: newFrameForNicknameTextField(navBarHeight: defaultNavigationBarViewHeight),
                                                      keyboardToolbar: .init())
        textField.placeholder = KeysForTranslate.nickname.localized
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.textAlignment = .left
        textField.clearButtonMode = .whileEditing
        textField.font = MDAppStyling.Font.MyriadProItalic.font(ofSize: 17)
        textField.textColor = MDAppStyling.Color.md_Black_1_Light_Appearence.color()
        textField.returnKeyType = .next
        textField.tag = AuthTextFieldTag.nickname.rawValue
        textField.backgroundColor = MDAppStyling.Color.md_White_0_Light_Appearence.color()
        return textField
    }()
    
    init(presenter: AuthenticationPresenterInputProtocol) {
        self.presenter = presenter
        super.init()
        updateBackgroundImage(MDAppStyling.Image.background_typography_1.image)
    }
    
    deinit {
        debugPrint(#function, Self.self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        addViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addConstraints()
        roundOffEdges()
    }
    
}

// MARK: - AuthenticationPresenterOutputProtocol
extension AuthenticationViewController: AuthenticationPresenterOutputProtocol {
    
    func makePasswordFieldActive() {
        
    }
    
    func hideKeyboard() {
        self.hideKeyboardFunc()
    }
    
    func showValidationError(_ error: Error) {
        UIAlertController.showAlertWithOkAction(title: KeysForTranslate.error.localized,
                                                message: error.localizedDescription,
                                                presenter: self)
    }
    
}

// MARK: - Add Views
fileprivate extension AuthenticationViewController {
    
    func addViews() {
        addLoginLabel()
        addBackButton()
        addNicknameTextField()
    }
    
    func addLoginLabel() {
        view.addSubview(loginLabel)
    }
    
    func addBackButton() {
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        view.addSubview(backButton)
    }
    
    func addNicknameTextField() {
        nicknameTextField.delegate = presenter.textFieldDelegate
        nicknameTextField.addTarget(self, action: #selector(nicknameTextFieldEditingDidChangeAction), for: .editingChanged)
        view.addSubview(nicknameTextField)
    }
    
}

// MARK: - Add Constraints
fileprivate extension AuthenticationViewController {
    
    func addConstraints() {
        addLoginLabelConstraints()
        addBackButtonConstraints()
    }
    
    func addLoginLabelConstraints() {
        
        NSLayoutConstraint.addEqualLeftConstraintAndActivate(item: self.loginLabel,
                                                             toItem: self.navigationBarView,
                                                             constant: 16)
        
        NSLayoutConstraint.addEqualRightConstraintAndActivate(item: self.loginLabel,
                                                              toItem: self.navigationBarView,
                                                              constant: -16)
        
        NSLayoutConstraint.addEqualBottomConstraintAndActivate(item: self.loginLabel,
                                                               toItem: self.navigationBarView,
                                                               constant: -16)
        
    }
    
    func addBackButtonConstraints() {
        
        NSLayoutConstraint.addEqualConstraintAndActivate(item: self.backButton,
                                                         attribute: .bottom,
                                                         toItem: self.loginLabel,
                                                         attribute: .top,
                                                         constant: -16)
        
        NSLayoutConstraint.addEqualLeftConstraintAndActivate(item: self.backButton,
                                                             toItem: self.navigationBarView,
                                                             constant: 18)
        
    }
    
}

// MARK: - Configure UI
fileprivate extension AuthenticationViewController {
    
    func configureUI() {
        configureAppearance(fromAppearanceType: Appearance.current.appearanceType)
        updateFrame()
        dropShadow()
    }
    
}

// MARK: - Update Frame
fileprivate extension AuthenticationViewController {
    
    func updateFrame() {
        updateNicknameTextFieldFrame()
    }
    
    func updateNicknameTextFieldFrame() {
        UIView.animate(withDuration: .zero) {
            self.nicknameTextField.frame = Self.newFrameForNicknameTextField(navBarHeight: MDConstants.NavigationBar.heightPlusStatusBarHeight(fromNavigationController: self.navigationController))
            self.view.layoutSubviews()
            self.viewDidLayoutSubviews()
        }
    }
    
}

// MARK: - Drop Shadow
fileprivate extension AuthenticationViewController {
    
    func dropShadow() {
        dropShadowNicknameTextField()
    }
    
    func dropShadowNicknameTextField() {
        nicknameTextField.dropShadow(color: MDAppStyling.Color.md_Shadow_0_Light_Appearence.color(0.5),
                                     offSet: .init(width: 2, height: 4),
                                     radius: 15)
    }
    
}

// MARK: - Round Off Edges
fileprivate extension AuthenticationViewController {
    
    func roundOffEdges() {
        nicknameTextFieldRoundOffEdges()
    }
    
    func nicknameTextFieldRoundOffEdges() {
        nicknameTextField.layer.cornerRadius = 10
    }
    
}

// MARK: - Actions
fileprivate extension AuthenticationViewController {
    
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nicknameTextFieldEditingDidChangeAction() {
        presenter.nicknameTextFieldEditingDidChangeAction(nicknameTextField.text)
    }
    
}

// MARK: - Hide Keyboard
fileprivate extension AuthenticationViewController {
    
    func hideKeyboardFunc() {
        self.view.endEditing(true)
    }
    
}

// MARK: - New Frame
fileprivate extension AuthenticationViewController {
    
    static func newFrameForNicknameTextField(navBarHeight: CGFloat) -> CGRect {
        return .init(origin: .init(x: nicknameTextFieldLeftOffset,
                                   y: navBarHeight + nicknameTextFieldTopOffset),
                     size: .init(width: MDConstants.Screen.width - (nicknameTextFieldLeftOffset + nicknameTextFieldRightOffset),
                                 height: nicknameTextFieldHeight))
    }
    
}
