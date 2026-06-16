//
//  profileSetup.swift
//  Astra
//
//  Created by Riboldi  on 15/02/26.
//

import SwiftUI

@available(iOS 26.0, *)
struct ProfileSetupView: View {
	
	@ObservedObject var profileManager: ProfileManager
	@Environment(\.dismiss) var dismiss
	@Environment(\.colorScheme) var colorScheme
	
	@State private var currentStep = 1
	private let totalSteps = 4
	
	// Temporary state for editing
	@State private var gpa: String = ""
	@State private var sat: String = ""
	@State private var act: String = ""
	@State private var income: String = ""
	@State private var budget: String = ""
	@State private var isFirstGen = false
	@State private var mustHaveScholarships = false
	@State private var selectedPrograms: Set<String> = []
	@State private var selectedLocations: Set<String> = []
	@State private var selectedTags: Set<String> = []
	@State private var campusSize: String = ""
	
	var body: some View {
		ZStack {
			// Background
			LinearGradient(
				colors: colorScheme == .dark ? [
					Color.black,
					Color(red: 0.05, green: 0.1, blue: 0.15),
					Color.black
				] : [
					Color(red: 0.95, green: 0.97, blue: 1.0),
					Color.white,
					Color(red: 0.90, green: 0.95, blue: 1.0)
				],
				startPoint: .topLeading,
				endPoint: .bottomTrailing
			)
			.ignoresSafeArea()
			
			VStack(spacing: 0) {
				// Header
				header
				
				// Progress bar
				progressBar
				
				// Content
				ScrollView {
					VStack(spacing: 24) {
						switch currentStep {
						case 1:
							academicsStep
						case 2:
							financialStep
						case 3:
							programsStep
						case 4:
							preferencesStep
						default:
							academicsStep
						}
					}
					.padding(.horizontal, 24)
					.padding(.vertical, 32)
				}
				
				// Navigation buttons
				navigationButtons
			}
		}
		.onAppear(perform: loadProfile)
	}
	
	// MARK: - Header
	
	private var header: some View {
		HStack {
			if currentStep > 1 {
				Button(action: {
					withAnimation {
						currentStep -= 1
					}
				}) {
					Image(systemName: "chevron.left")
						.font(.system(size: 20, weight: .semibold))
						.foregroundColor(Color.Accent)
				}
			}
			
			Spacer()
			
			VStack(spacing: 4) {
				Text("Build Your Profile")
					.font(.system(size: 24, weight: .bold, design: .rounded))
					.foregroundStyle(
						LinearGradient(
							colors: [Color.Accent, Color.Primary],
							startPoint: .leading,
							endPoint: .trailing
						)
					)
				
				Text("Step \(currentStep) of \(totalSteps)")
					.font(.system(size: 14, weight: .medium))
					.foregroundColor(.secondary)
			}
			
			Spacer()
			
			Button("Skip") {
				saveAndDismiss()
			}
			.font(.system(size: 16, weight: .semibold))
			.foregroundColor(Color.Accent)
		}
		.padding(.horizontal, 24)
		.padding(.vertical, 16)
	}
	
	// MARK: - Progress Bar
	
	private var progressBar: some View {
		GeometryReader { geometry in
			ZStack(alignment: .leading) {
				Rectangle()
					.fill(Color.gray.opacity(0.2))
					.frame(height: 4)
				
				Rectangle()
					.fill(
						LinearGradient(
							colors: [Color.Accent, Color.Primary],
							startPoint: .leading,
							endPoint: .trailing
						)
					)
					.frame(width: geometry.size.width * (Double(currentStep) / Double(totalSteps)), height: 4)
					.animation(.spring(response: 0.4, dampingFraction: 0.7), value: currentStep)
			}
		}
		.frame(height: 4)
	}
	
	// MARK: - Step 1: Academics
	
	private var academicsStep: some View {
		VStack(alignment: .leading, spacing: 24) {
			stepTitle(
				icon: "graduationcap.fill",
				title: "Academic Profile",
				subtitle: "Tell us about your academic achievements"
			)
			
			FormField(
				icon: "chart.line.uptrend.xyaxis",
				title: "GPA",
				placeholder: "3.8",
				text: $gpa,
				keyboardType: .decimalPad
			)
			
			FormField(
				icon: "doc.text.fill",
				title: "SAT Score",
				placeholder: "1450",
				text: $sat,
				keyboardType: .numberPad
			)
			
			FormField(
				icon: "doc.text.fill",
				title: "ACT Score",
				placeholder: "32",
				text: $act,
				keyboardType: .numberPad
			)
			
			Toggle(isOn: $isFirstGen) {
				HStack(spacing: 12) {
					Image(systemName: "person.fill")
						.font(.system(size: 20))
						.foregroundColor(Color.Accent)
						.frame(width: 40, height: 40)
						.background(
							Circle()
								.fill(Color.Accent.opacity(0.15))
						)
					
					VStack(alignment: .leading, spacing: 4) {
						Text("First-Generation Student")
							.font(.system(size: 16, weight: .semibold))
						Text("Neither parent has a 4-year degree")
							.font(.system(size: 13, weight: .medium))
							.foregroundColor(.secondary)
					}
				}
			}
			.tint(Color.Accent)
			.padding(16)
			.background(
				RoundedRectangle(cornerRadius: 16)
					.fill(.ultraThinMaterial)
			)
		}
	}
	
	// MARK: - Step 2: Financial
	
	private var financialStep: some View {
		VStack(alignment: .leading, spacing: 24) {
			stepTitle(
				icon: "dollarsign.circle.fill",
				title: "Financial Information",
				subtitle: "Help us find affordable options"
			)
			
			FormField(
				icon: "house.fill",
				title: "Household Income",
				placeholder: "75000",
				text: $income,
				keyboardType: .numberPad
			)
			
			FormField(
				icon: "creditcard.fill",
				title: "Maximum Budget (per year)",
				placeholder: "50000",
				text: $budget,
				keyboardType: .numberPad
			)
			
			Toggle(isOn: $mustHaveScholarships) {
				HStack(spacing: 12) {
					Image(systemName: "graduationcap.fill")
						.font(.system(size: 20))
						.foregroundColor(Color.Accent)
						.frame(width: 40, height: 40)
						.background(
							Circle()
								.fill(Color.Accent.opacity(0.15))
						)
					
					VStack(alignment: .leading, spacing: 4) {
						Text("I Require a Scholarship")
							.font(.system(size: 16, weight: .semibold))
						Text("Only show universities with scholarships")
							.font(.system(size: 13, weight: .medium))
							.foregroundColor(.secondary)
					}
				}
			}
			.tint(Color.Accent)
			.padding(16)
			.background(
				RoundedRectangle(cornerRadius: 16)
					.fill(.ultraThinMaterial)
			)
			
			InfoBox(
				icon: "lock.shield.fill",
				text: "Your financial information is private and stored securely on your device only."
			)
		}
	}
	
	// MARK: - Step 3: Programs
	
	private var programsStep: some View {
		VStack(alignment: .leading, spacing: 24) {
			stepTitle(
				icon: "book.fill",
				title: "Programs of Interest",
				subtitle: "What do you want to study?"
			)
			
			Text("Select up to 3 programs")
				.font(.system(size: 14, weight: .medium))
				.foregroundColor(.secondary)
			
			FlowLayout(spacing: 12) {
				ForEach(ProfileOptions.programs, id: \.self) { program in
					SelectableChip(
						title: program,
						isSelected: selectedPrograms.contains(program)
					) {
						if selectedPrograms.contains(program) {
							selectedPrograms.remove(program)
						} else if selectedPrograms.count < 3 {
							selectedPrograms.insert(program)
						}
					}
				}
			}
		}
	}
	
	// MARK: - Step 4: Preferences
	
	private var preferencesStep: some View {
		VStack(alignment: .leading, spacing: 32) {
			stepTitle(
				icon: "star.fill",
				title: "Your Preferences",
				subtitle: "What matters most to you?"
			)
			
			// Locations
			VStack(alignment: .leading, spacing: 12) {
				Text("Preferred Locations")
					.font(.system(size: 16, weight: .bold))
				
				FlowLayout(spacing: 12) {
					ForEach(ProfileOptions.locations, id: \.self) { location in
						SelectableChip(
							title: location,
							isSelected: selectedLocations.contains(location)
						) {
							if selectedLocations.contains(location) {
								selectedLocations.remove(location)
							} else {
								selectedLocations.insert(location)
							}
						}
					}
				}
			}
			
			// Campus Size
			VStack(alignment: .leading, spacing: 12) {
				Text("Campus Size")
					.font(.system(size: 16, weight: .bold))
				
				VStack(spacing: 8) {
					ForEach(ProfileOptions.campusSizes, id: \.self) { size in
						
						
						Button(action: {
							campusSize = size
						}) {
							HStack {
								Text(size)
									.font(.system(size: 15, weight: .medium))
									.foregroundColor(.primary)
								
								Spacer()
								
								if campusSize == size {
									Image(systemName: "checkmark.circle.fill")
										.foregroundColor(Color.Accent)
								}
							}
							.padding(12)
							.background(
								RoundedRectangle(cornerRadius: 12)
									.fill(campusSize == size ? Color.Accent.opacity(0.15) : Color.gray.opacity(0.1))
									// Changed .ultraThinMaterial to Color.gray.opacity(0.1)
							)
						}
						
					}
				}
			}
			
			// Tags
			VStack(alignment: .leading, spacing: 12) {
				Text("Characteristics")
					.font(.system(size: 16, weight: .bold))
				
				FlowLayout(spacing: 12) {
					ForEach(ProfileOptions.tags, id: \.self) { tag in
						SelectableChip(
							title: tag,
							isSelected: selectedTags.contains(tag)
						) {
							if selectedTags.contains(tag) {
								selectedTags.remove(tag)
							} else {
								selectedTags.insert(tag)
							}
						}
					}
				}
			}
		}
	}
	
	// MARK: - Navigation Buttons
	
	private var navigationButtons: some View {
		HStack(spacing: 16) {
			if currentStep < totalSteps {
				Button(action: {
					withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
						currentStep += 1
					}
				}) {
					HStack {
						Text("Continue")
							.font(.system(size: 18, weight: .bold))
						Image(systemName: "arrow.right")
					}
					.foregroundColor(.white)
					.frame(maxWidth: .infinity)
					.padding(.vertical, 16)
					.background(
						LinearGradient(
							colors: [Color.Accent, Color.Primary],
							startPoint: .leading,
							endPoint: .trailing
						)
					)
					.cornerRadius(16)
				}
			} else {
				Button(action: saveAndDismiss) {
					HStack {
						Text("Complete Profile")
							.font(.system(size: 18, weight: .bold))
						Image(systemName: "checkmark")
					}
					.foregroundColor(.white)
					.frame(maxWidth: .infinity)
					.padding(.vertical, 16)
					.background(
						LinearGradient(
							colors: [Color.green, Color.green.opacity(0.8)],
							startPoint: .leading,
							endPoint: .trailing
						)
					)
					.cornerRadius(16)
				}
			}
		}
		.padding(.horizontal, 24)
		.padding(.vertical, 16)
		.background(.ultraThinMaterial)
	}
	
	// MARK: - Helper Views
	
	private func stepTitle(icon: String, title: String, subtitle: String) -> some View {
		HStack(spacing: 16) {
			Image(systemName: icon)
				.font(.system(size: 30))
				.foregroundStyle(
					LinearGradient(
						colors: [Color.Accent, Color.Primary],
						startPoint: .topLeading,
						endPoint: .bottomTrailing
					)
				)
			
			VStack(alignment: .leading, spacing: 4) {
				Text(title)
					.font(.system(size: 24, weight: .bold, design: .rounded))
				
				Text(subtitle)
					.font(.system(size: 14, weight: .medium))
					.foregroundColor(.secondary)
			}
		}
	}
	
	// MARK: - Functions
	
	private func loadProfile() {
		let profile = profileManager.profile
		gpa = String(profile.gpa)
		sat = String(profile.sat)
		act = String(profile.act)
		income = String(Int(profile.householdIncome))
		budget = profile.maxBudget != nil ? String(Int(profile.maxBudget!)) : ""
		isFirstGen = profile.isFirstGeneration
		mustHaveScholarships = profile.mustHaveScholarships
		selectedPrograms = Set(profile.interestedPrograms)
		selectedLocations = Set(profile.preferredLocations)
		selectedTags = Set(profile.preferredTags)
		campusSize = profile.campusSizePreference ?? ""
	}
	
	private func saveAndDismiss() {
		profileManager.profile = UserProfile(
			gpa: Double(gpa) ?? 3.5,
			sat: Int(sat) ?? 1200,
			act: Int(act) ?? 25,
			householdIncome: Double(income) ?? 75000,
			maxBudget: budget.isEmpty ? nil : Double(budget),
			isFirstGeneration: isFirstGen,
			interestedPrograms: Array(selectedPrograms),
			preferredLocations: Array(selectedLocations),
			preferredTags: Array(selectedTags),
			campusSizePreference: campusSize.isEmpty ? nil : campusSize,
			mustHaveScholarships: mustHaveScholarships
		)
		
		dismiss()
	}
}

// MARK: - Form Field Component

struct FormField: View {
	let icon: String
	let title: String
	let placeholder: String
	@Binding var text: String
	var keyboardType: UIKeyboardType = .default
	
	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			HStack(spacing: 8) {
				Image(systemName: icon)
					.foregroundColor(Color.Accent)
				Text(title)
					.font(.system(size: 14, weight: .semibold))
			}
			
			TextField(placeholder, text: $text)
				.keyboardType(keyboardType)
				.font(.system(size: 16, weight: .medium))
				.padding(16)
				.background(
					RoundedRectangle(cornerRadius: 12)
						.fill(.ultraThinMaterial)
				)
		}
	}
}

// MARK: - Selectable Chip Component

struct SelectableChip: View {
	let title: String
	let isSelected: Bool
	let action: () -> Void
	
	var body: some View {
		Button(action: action) {
			Text(title)
				.font(.system(size: 14, weight: .semibold))
				.foregroundColor(isSelected ? .white : .primary)
				.padding(.horizontal, 16)
				.padding(.vertical, 10)
				.background(
					Capsule()
						.fill(isSelected ?
							LinearGradient(
								colors: [Color.Accent, Color.Primary],
								startPoint: .leading,
								endPoint: .trailing
							) :
							LinearGradient(
								colors: [Color.gray.opacity(0.15), Color.gray.opacity(0.15)],
								startPoint: .leading,
								endPoint: .trailing
							)
						)
				)
		}
		.buttonStyle(ScaleButtonStyle())
	}
}

// MARK: - Info Box Component

struct InfoBox: View {
	let icon: String
	let text: String
	
	var body: some View {
		HStack(spacing: 12) {
			Image(systemName: icon)
				.font(.system(size: 16))
				.foregroundColor(Color.Accent)
			
			Text(text)
				.font(.system(size: 13, weight: .medium))
				.foregroundColor(.secondary)
				.multilineTextAlignment(.leading)
		}
		.padding(16)
		.background(
			RoundedRectangle(cornerRadius: 12)
				.fill(Color.Accent.opacity(0.1))
		)
	}
}

@available(iOS 26.0, *)
#Preview {
	ProfileSetupView(profileManager: ProfileManager())
}
