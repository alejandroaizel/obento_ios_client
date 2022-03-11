//
//  OnboardingViewController.swift
//  Obento
//
//  Created by Alejandro Aizel Boto on 6/3/22.
//

import UIKit

class OnboardingViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var skipButton: UIButton!
    
    var slides: [OnboardingSlide] = []
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            
            if currentPage == slides.count - 1 {
                nextBtn.isHidden = false
                skipButton.isHidden = true
            } else {
                nextBtn.isHidden = true
                skipButton.isHidden = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey: "completedOnboarding") {
            let controller = storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: false, completion: nil)
        }

        slides = [
        OnboardingSlide(
            title: "¡Bienvenido/a!",
            description: "Empieza a llevar un mejor estilo de vida y descubre tu pasión por la cocina",
            image: UIImage(named: "onboarding_illustration_1")!
        ),
        OnboardingSlide(
            title: "No hay excusas.",
            description: "¿Falta de tiempo? ¿De dinero? ¿De ganas? Déjanos ocuparnos de eso. Con Oberto podrás generar menús semanales en base a tus preferencias.",
            image: UIImage(named: "onboarding_illustration_2")!
        ),
        OnboardingSlide(
            title: "Mejor conocido",
            description: "En Oberto podrás añadir tus propias recetas ¡sacando una foto! Completa unas pequeñas preguntas y tendrás tu receta lista.",
            image: UIImage(named: "onboarding_illustration_3")!
        ),
        OnboardingSlide(
            title: "Compartir es vivir",
            description: "Si crees que tu menú o una receta podría venirle bien a algún conocido solo tienes que compartírsela.",
            image: UIImage(named: "onboarding_illustration_4")!
        ),
        ]
    }
    
    @IBAction func nextButtonClick(_ sender: Any) {
        if currentPage == slides.count - 1 {
            UserDefaults.standard.set(true, forKey: "completedOnboarding")
            UserDefaults.standard.synchronize()
            
            let controller = storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .flipHorizontal
            present(controller, animated: true, completion: nil)
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    @IBAction func skipButtonClick(_ sender: Any) {
        currentPage = slides.count - 1
        
        let indexPath = IndexPath(item: currentPage, section: 0)
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
        
        cell.setup(slides[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
}

extension UIApplication {
    class func isFirstLaunch() -> Bool {
        if !UserDefaults.standard.bool(forKey: "completedOnboarding") {
            UserDefaults.standard.set(true, forKey: "completedOnboarding")
            UserDefaults.standard.synchronize()
            
            return true
        }
        
        return false
    }
}
