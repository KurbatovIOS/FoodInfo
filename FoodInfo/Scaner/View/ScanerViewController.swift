//
//  ScanerViewController.swift
//  FoodScaner
//
//  Created by Kurbatov Artem on 19.02.2023.
//

import UIKit
import AVFoundation

class ScanerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    private lazy var codeTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Введите код"
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Искать", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(searchButtonDidTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var restartButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray2
        let tintedImage = UIImage(systemName: "arrow.counterclockwise")?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(restartButtonDidTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var scanArea: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var codeTextFieldTop = NSLayoutConstraint(item: codeTextField, attribute: .top, relatedBy: .equal, toItem: restartButton, attribute: .bottom, multiplier: 1, constant: 20)

    private lazy var isKeyboardShown = false
    
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var presenter: ScanerPresenterProtocol
    private let coreDataService: CoreDataServiceProtocol
    
    init(presenter: ScanerPresenterProtocol, coreDataService: CoreDataServiceProtocol) {
        self.presenter = presenter
        self.coreDataService = coreDataService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        presenter.delegate = self
        codeTextField.delegate = self
        setConstraints()
        setupObserver()
        addTapGesture()
       }
    
    private func addTapGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(screenDidTap))
        view.addGestureRecognizer(gesture)
    }
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(
                  self,
                  selector: #selector(self.keyboardWillShow),
                  name: UIResponder.keyboardWillShowNotification,
                  object: nil)

              NotificationCenter.default.addObserver(
                  self,
                  selector: #selector(self.keyboardWillHide),
                  name: UIResponder.keyboardWillHideNotification,
                  object: nil)
    }
    
    private func setConstraints() {
        view.addSubview(scanArea)
        view.addSubview(codeTextField)
        view.addSubview(searchButton)
        view.addSubview(restartButton)
        
        NSLayoutConstraint.activate([
            scanArea.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scanArea.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scanArea.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scanArea.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            restartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            restartButton.centerYAnchor.constraint(equalTo: scanArea.bottomAnchor),
            restartButton.widthAnchor.constraint(equalToConstant: 50),
            restartButton.heightAnchor.constraint(equalTo: restartButton.widthAnchor),
            
            codeTextFieldTop,
            codeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            codeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            codeTextField.heightAnchor.constraint(equalToConstant: 50),
            
            searchButton.topAnchor.constraint(equalTo: codeTextField.bottomAnchor, constant: 20),
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            searchButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    private func configureScaner() {
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = scanArea.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        scanArea.layer.addSublayer(previewLayer)
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    func failed() {
        presenter.showWarningAlert(title: "Сканирование не поддерживается", message: "Ваше устройство не поддерживает сканирование кодов. Пожалуйста, используйте устройство с камерой", sourceVC: self)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                self?.captureSession.startRunning()
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
        scanArea.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        restartButton.layer.cornerRadius = restartButton.frame.width / 2
        restartButton.clipsToBounds = true
        restartButton.layer.borderColor = UIColor.black.cgColor
        restartButton.layer.borderWidth = 0.5
        configureScaner()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let productCode = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            presenter.findProduct(with: productCode)
        }
    }

    @objc private func restartButtonDidTap() {
        if (captureSession?.isRunning == false) {
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                self?.captureSession.startRunning()
            }
        }
    }
    
    @objc private func searchButtonDidTap() {
        view.endEditing(true)
        guard let code = codeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !code.isEmpty else {
            let alert = AlertBuilder.shared.createWarningAlert(title: "Ошибка", message: "Поле ввода не может быть пустым")
            self.present(alert, animated: true)
            return
        }
        presenter.findProduct(with: code)
    }
    
    @objc private func screenDidTap() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        if !isKeyboardShown {
            showKeyboard()
            isKeyboardShown = true
        }
       }
       
       @objc private func keyboardWillHide(_ notification: NSNotification) {
           hideKeyboard()
           isKeyboardShown = false
       }
       
    private func showKeyboard() {
           codeTextFieldTop.constant -= 130
           self.view.layoutIfNeeded()
       }
    
    private func hideKeyboard() {
        codeTextFieldTop.constant = 20
        self.view.layoutIfNeeded()
    }
}

extension ScanerViewController: ScanerPresenterDelegate {
    func productReceived(_ product: Product) {
        presenter.loadImage(for: product) { [weak self] imageData in
            guard let imageData, let self else { return }
            let presenter = DetailsPresenter(coreDataService: self.coreDataService)
            let detailsVC = DetailsViewController(productToDisplay: product, imageData: imageData, presenter: presenter)
            self.present(detailsVC, animated: true)
        }
    }
    
    func showWarningAlert(_ code: String) {
        let alert = UIAlertController(title: "Продукт не найден", message: "Вы можете оставить запрос на его добавление", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Продолжить", style: .cancel) { _ in
            let presenter = AddRequestPresenter()
            let requestVC = AddRequestViewController(presenter: presenter, code: code)
            self.present(requestVC, animated: true)
        }
        let cancel = UIAlertAction(title: "Отменить", style: .default)
        alert.addAction(addAction)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
}

extension ScanerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
