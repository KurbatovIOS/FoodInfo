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
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setConstraints()
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
            
            codeTextField.topAnchor.constraint(equalTo: restartButton.bottomAnchor, constant: 20),
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
        let alert = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
    }
    
    func found(code: String) {
        print(code)
        let product = Product(code: UUID().uuidString, title: "Маффин Три шоколада «Русская нива»", ingredients: "Сахар, масло растительное подсолнечное, продукт яичный, вода питьевая, мука пшеничная хлебопекарная высшего сорта, начинка кремовая шоколадная нетермостабильная (сироп глюкозно-фруктозный, вода питьевая, сахар, шоколад (какао тертое, сахар, масло какао, молочный жир, эмульгатор - лецитин подсолнечника, ароматизатор), масло растительное кокосовое, сыворотка сухая молочная подсырная, стабилизатор Е1442, какао-порошок, консервант - сорбат калия, регулятор кислотности - лимонная кислота, ароматизатор), глицерин, какао-порошок алкализованный, шоколад белый (сахар, сухое цельное молоко, масло какао, сухое обезжиренное молоко, эмульгатор - лецитин соевый, ароматизатор), глазурь шоколадная молочная (сахар, сухое цельное молоко, масло какао, какао тертое, сухая молочная сыворотка, сухое обезжиренное молоко, лецитин соевый, ароматизатор), дрожжи хлебопекарные сухие дезактивированные, соль, загуститель Е1422", imageURL: nil)
        let detailsVC = DetailsViewController(productToDisplay: product, dumbImageName: "maffin")
        present(detailsVC, animated: true)
    }
    
    @objc private func restartButtonDidTap() {
        if (captureSession?.isRunning == false) {
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                self?.captureSession.startRunning()
            }
        }
    }
    
    @objc private func searchButtonDidTap() {
        let requestVC = AddRequestViewController()
        present(requestVC, animated: true)
    }
}