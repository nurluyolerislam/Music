//
//  OnboardingViewModel.swift
//  Music
//
//  Created by Yaşar Duman on 9.11.2023.
//


import Foundation
import UIKit

final class OnboardingViewModel {
    let sliderData: [OnboardingItemModel] = [
        OnboardingItemModel(color: .onboardingDarkBackground,
                            title: "Explore Music",
                            text: "It's time to dive into the world of music! Our app brings you an extensive music catalog. Search for your favorite artists' songs or explore different genres. Find the music you want quickly and start listening right away.", animationName: "a2"),
        
        OnboardingItemModel(color: .onboardingDarkBackground,
                            title: "Save Your Favorites",
                            text: "Instantly save the songs that resonate with you! Create your personalized collection of favorite songs. Enjoy revisiting these songs whenever you like.",
                            animationName: "a1"),
        
        OnboardingItemModel(color: .onboardingDarkBackground,
                            title: "Personalize Your Experience", text: "Tailor your music journey! Explore various settings and discover how to make the most out of our app. Customize your listening experience to suit your tastes.",
                            animationName: "a2"),
    ]
}
