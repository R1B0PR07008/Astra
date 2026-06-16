//
//  apptour.swift
//  Astra
//
//  Created by Riboldi  on 15/02/26.
//

import SwiftUI

// MARK: - Tour Step Model

struct TourStep: Identifiable {
	let id = UUID()
	let title: String
	let message: String
	let highlightArea: HighlightArea
	let action: (() -> Void)?
	
	enum HighlightArea {
		case profileButton
		case matchScore
		case review
		case universityCard
		case heartButton
		case plusButton
		case expandCard
		case matchesTab
		case documentsTab
		case fullScreen
		case none
	}
	
	init(title: String, message: String, highlightArea: HighlightArea = .none, action: (() -> Void)? = nil) {
		self.title = title
		self.message = message
		self.highlightArea = highlightArea
		self.action = action
	}
}

// MARK: - App Tour Manager

class AppTourManager: ObservableObject {
	@Published var isShowingTour = false
	@Published var currentStepIndex = 0
	@Published var hasCompletedTour: Bool {
		didSet {
			UserDefaults.standard.set(hasCompletedTour, forKey: "hasCompletedAppTour")
		}
	}
	
	let tourSteps: [TourStep]
	
	init() {
		self.hasCompletedTour = UserDefaults.standard.bool(forKey: "hasCompletedAppTour")
		
		self.tourSteps = [
			// Step 1: Welcome
			TourStep(
				title: "Welcome to Astra! 🎓",
				message: "I'm Matias, and I built this app because as a soon to be high-school grad, choosing the right university is very important. Yet, this desition is increadebly hard with so many options available. That's where Astra comes in! I know how overwhelming it can be, so let me show you how Astra makes it easier.",
				highlightArea: .fullScreen
			),
			
			// Step 2: Smart Recommendations
			TourStep(
				title: "Smart Recommendations",
				message: "Universities are ranked just for YOU based on your academics, budget, and preferences. The higher the match percentage, the better the fit!",
				highlightArea: .matchScore
			),
			
			// Step 3: Safety/Target/Reach
			TourStep(
				title: "Know Your Chances",
				message: "Each university is labeled as Safety (very likely), Target (good chance), or Reach (competitive). This helps you build a balanced college list.",
				highlightArea: .universityCard
			),
			
			// Step 4: Tap to Expand
			TourStep(
				title: "Learn More",
				message: "Tap any university card to see WHY it matches you. You'll get personalized reasons based on your profile. Plus, you can get more, in depth, information about the university by pressing the blue button.",
				highlightArea: .expandCard
			),
			
			TourStep(
				title: "Read Reviews",
				message: "It is important to know what past or even present students think about the university. Because of this, if you tap on the review summary you can get more, in depth, reviews of the university.",
				highlightArea: .review
			),
			
			// Step 5: Favorite Universities
			TourStep(
				title: "Save Your Favorites ❤️",
				message: "Tap the heart to save universities you love. They'll appear in your Matches tab.",
				highlightArea: .heartButton
			),
			
			// Step 6: Add to List
			TourStep(
				title: "Build Your List",
				message: "Tap the plus button to add universities to your application list. Track all your choices in one place.",
				highlightArea: .plusButton
			),
			
			// Step 7: Matches Tab
			TourStep(
				title: "Your Matches",
				message: "See all your favorited and added universities here. Filter by favorites, added, or view all together.",
				highlightArea: .matchesTab
			),
			
			// Step 8: Documents
			TourStep(
				title: "Upload Documents",
				message: "Keep all your application materials organized - transcripts, essays, recommendation letters, and more.",
				highlightArea: .documentsTab
			),
			
			// Step 9: Profile
			TourStep(
				title: "Update Your Profile",
				message: "Tap the profile icon anytime to update your GPA, test scores, budget, or preferences. Universities will re-rank automatically!",
				highlightArea: .profileButton
			),
			
			// Step 10: Final
			TourStep(
				title: "You're All Set! 🎉",
				message: "Start swiping through universities and find your perfect match. Remember: this decision will shape your future, but you've got this!",
				highlightArea: .fullScreen
			)
		]
	}
	
	var currentStep: TourStep {
		tourSteps[currentStepIndex]
	}
	
	var isLastStep: Bool {
		currentStepIndex == tourSteps.count - 1
	}
	
	func nextStep() {
		if currentStepIndex < tourSteps.count - 1 {
			withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
				currentStepIndex += 1
				currentStep.action?()
			}
		} else {
			completeTour()
		}
	}
	
	func previousStep() {
		if currentStepIndex > 0 {
			withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
				currentStepIndex -= 1
			}
		}
	}
	
	func skipTour() {
		completeTour()
	}
	
	func startTour() {
		currentStepIndex = 0
		isShowingTour = true
	}
	
	private func completeTour() {
		withAnimation(.easeOut(duration: 0.3)) {
			isShowingTour = false
			hasCompletedTour = true
		}
	}
	
	func resetTour() {
		hasCompletedTour = false
		currentStepIndex = 0
	}
}

// MARK: - App Tour Overlay

struct AppTourOverlay: View {
	@ObservedObject var tourManager: AppTourManager
	@Environment(\.colorScheme) var colorScheme
	
	var body: some View {
		ZStack {
			// Dimmed background
			Color.black.opacity(0.7)
				.ignoresSafeArea()
				.onTapGesture {
					// Prevent dismissal on background tap
				}
			
			// Highlight area (optional spotlight effect)
			if tourManager.currentStep.highlightArea != .fullScreen &&
			   tourManager.currentStep.highlightArea != .none {
				highlightSpotlight
			}
			
			// Tour content card
			VStack {
				Spacer()
				
				tourCard
					.padding(.horizontal, 24)
					.padding(.bottom, 310)
					.transition(.move(edge: .bottom).combined(with: .opacity))
			}
		}
	}
	
	// MARK: - Highlight Spotlight
	
	private var highlightSpotlight: some View {
		GeometryReader { geometry in
			let spotlightFrame = getSpotlightFrame(for: tourManager.currentStep.highlightArea, in: geometry)
			
			ZStack {
				// Create a "hole" effect
				Rectangle()
					.fill(Color.clear)
					.frame(width: spotlightFrame.width, height: spotlightFrame.height)
					.position(x: spotlightFrame.midX, y: spotlightFrame.midY)
					.overlay(
						RoundedRectangle(cornerRadius: 20)
							.stroke(Color.Accent, lineWidth: 3)
							.frame(width: spotlightFrame.width, height: spotlightFrame.height)
							.position(x: spotlightFrame.midX, y: spotlightFrame.midY)
							.shadow(color: Color.Accent.opacity(0.5), radius: 20, x: 0, y: 0)
					)
			}
		}
		.allowsHitTesting(false)
	}
	
	private func getSpotlightFrame(for area: TourStep.HighlightArea, in geometry: GeometryProxy) -> CGRect {
		let screenWidth = geometry.size.width
		let screenHeight = geometry.size.height
		
		switch area {
		case .profileButton:
			return CGRect(x: screenWidth - 103, y: 730, width: 60, height: 60)
		case .matchScore:
			return CGRect(x: 20, y: 476, width: 135, height: 40)
		case .review:
			return CGRect(x: 19, y: 665, width: 93, height: 40)
		case .universityCard:
			return CGRect(x: 156.5, y: 475.5, width: 75, height: 40)
		case .heartButton:
			return CGRect(x: screenWidth - 70, y: 565, width: 60, height: 60)
		case .plusButton:
			return CGRect(x: screenWidth - 70, y: 626, width: 60, height: 60)
		case .expandCard:
			return CGRect(x: 10, y: screenHeight - 260, width: screenWidth - 100, height: 200)
		case .matchesTab:
			return CGRect(x: screenWidth - 275, y: 730, width: 60, height: 60)
		case .documentsTab:
			return CGRect(x: screenWidth - 195, y: 730, width: 70, height: 60)
		case .fullScreen, .none:
			return CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
		}
	}
	
	// MARK: - Tour Card
	
	private var tourCard: some View {
		VStack(spacing: 20) {
			// Progress indicator
			HStack(spacing: 8) {
				ForEach(0..<tourManager.tourSteps.count, id: \.self) { index in
					Circle()
						.fill(index == tourManager.currentStepIndex ? Color.Accent : Color.gray.opacity(0.3))
						.frame(width: 8, height: 8)
						.scaleEffect(index == tourManager.currentStepIndex ? 1.2 : 1.0)
						.animation(.spring(response: 0.3, dampingFraction: 0.6), value: tourManager.currentStepIndex)
				}
			}
			.padding(.top, 8)
			
			// Title
			Text(tourManager.currentStep.title)
				.font(.system(size: 26, weight: .bold, design: .rounded))
				.foregroundColor(.primary)
				.multilineTextAlignment(.center)
			
			// Message
			Text(tourManager.currentStep.message)
				.font(.system(size: 16, weight: .medium))
				.foregroundColor(.primary.opacity(0.9))
				.multilineTextAlignment(.center)
				.lineSpacing(4)
				.padding(.horizontal, 8)
			
			// Buttons
			HStack(spacing: 12) {
				// Skip button
				if !tourManager.isLastStep {
					Button(action: {
						tourManager.skipTour()
					}) {
						Text("Skip")
							.font(.system(size: 16, weight: .semibold))
							.foregroundColor(.secondary)
							.padding(.vertical, 12)
							.frame(maxWidth: .infinity)
					}
				}
				
				// Back button (if not first step)
				if tourManager.currentStepIndex > 0 {
					Button(action: {
						tourManager.previousStep()
					}) {
						HStack {
							Image(systemName: "chevron.left")
							Text("Back")
						}
						.font(.system(size: 16, weight: .semibold))
						.foregroundColor(Color.Accent)
						.padding(.vertical, 12)
						.frame(maxWidth: .infinity)
						.background(
							RoundedRectangle(cornerRadius: 12)
								.stroke(Color.Accent, lineWidth: 2)
						)
					}
				}
				
				// Next/Finish button
				Button(action: {
					tourManager.nextStep()
				}) {
					HStack {
						Text(tourManager.isLastStep ? "Get Started" : "Next")
						if !tourManager.isLastStep {
							Image(systemName: "chevron.right")
						}
					}
					.font(.system(size: 16, weight: .bold))
					.foregroundColor(.white)
					.padding(.vertical, 12)
					.frame(maxWidth: .infinity)
					.background(
						LinearGradient(
							colors: [Color.Accent, Color.Primary],
							startPoint: .leading,
							endPoint: .trailing
						)
					)
					.cornerRadius(12)
				}
			}
			.padding(.top, 8)
		}
		.padding(24)
		.background(
			RoundedRectangle(cornerRadius: 24)
				.fill(.ultraThinMaterial)
				.shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
		)
	}
}

// MARK: - View Extension for Easy Integration

extension View {
	func appTour(_ tourManager: AppTourManager) -> some View {
		ZStack {
			self
			
			if tourManager.isShowingTour {
				AppTourOverlay(tourManager: tourManager)
					.transition(.opacity)
			}
		}
	}
}

// MARK: - Settings Row for Replaying Tour

struct TourSettingsRow: View {
	@ObservedObject var tourManager: AppTourManager
	
	var body: some View {
		Button(action: {
			tourManager.resetTour()
			tourManager.startTour()
		}) {
			HStack {
				Image(systemName: "questionmark.circle.fill")
					.font(.system(size: 24))
					.foregroundStyle(
						LinearGradient(
							colors: [Color.Accent, Color.Primary],
							startPoint: .topLeading,
							endPoint: .bottomTrailing
						)
					)
				
				VStack(alignment: .leading, spacing: 4) {
					Text("Replay Tour")
						.font(.system(size: 16, weight: .semibold))
						.foregroundColor(.primary)
					
					Text("See the app tour again")
						.font(.system(size: 13, weight: .medium))
						.foregroundColor(.secondary)
				}
				
				Spacer()
				
				Image(systemName: "chevron.right")
					.foregroundColor(.secondary)
			}
			.padding(16)
			.background(
				RoundedRectangle(cornerRadius: 16)
					.fill(.ultraThinMaterial)
			)
		}
		.buttonStyle(PlainButtonStyle())
	}
}

// MARK: - Preview

#Preview {
	ZStack {
		Color.gray.ignoresSafeArea()
		
		AppTourOverlay(tourManager: AppTourManager())
	}
}
