//
//  TestViewController.swift
//  FitMatte
//
//  Created by Emre Simsek on 13.10.2025.
//
import UIKit

final class TestViewController: UIViewController {
    
    // 1. GÖLGE VE KÖŞE YUVARLATMAYI TAŞIYAN CONTAINER VIEW
        let cardContainerView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .white // Kartın arka plan rengi
            
            // Gölge Ayarları
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOffset = CGSize(width: 0, height: 5)
            view.layer.shadowOpacity = 0.2
            view.layer.shadowRadius = 8
            view.layer.masksToBounds = false // Gölgenin görünmesi için
            view.layer.cornerRadius = 12 // Köşe yuvarlatma (Dış)
            return view
        }()
        
        // 2. RESİM (IMAGE VIEW)
        let imageView: UIImageView = {
            let imageView = UIImageView(image: .motivation)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFill
            // **ÖNEMLİ:** Resmin, Card Container'ın yuvarlak köşelerine sığması için kırpılması gerekir.
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 12 // Köşe yuvarlatma (İç)
            return imageView
        }()
        
        // 3. MOTİVASYON YAZISI (Önceki Cevaptaki Gibi)
        let quoteLabel: UILabel = {
            let label = UILabel()
            label.text = "Discipline is doing it even when you don't feel like it."
            // ... (Stil ayarları: beyaz, bold, center, vb.)
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            label.textAlignment = .left
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(cardContainerView)
        cardContainerView.addSubview(imageView)
        cardContainerView.addSubview(quoteLabel)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        cardContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        cardContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        cardContainerView.widthAnchor.constraint(equalTo: view.widthAnchor),
        cardContainerView.heightAnchor.constraint(equalToConstant: 250),
        imageView.topAnchor.constraint(equalTo: cardContainerView.topAnchor),
        imageView.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor),
        imageView.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor),
        imageView.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor),
        quoteLabel.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor, constant: -16),
        quoteLabel.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 16),
        quoteLabel.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -16)
        
        ])
    }
}

extension TestViewController {
    private func configureMotivationCard(){
       
        
    }
}


#Preview
{
    TestViewController()
}
