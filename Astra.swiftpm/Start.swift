//
//  Start.swift
//  Astra
//
//  Created by Riboldi  on 15/02/26.
//

import SwiftUI

struct Start: View {
	
	private let accentColor = Color(red: 0.2, green: 0.6, blue: 0.9)
	private let backgroundColor = Color(UIColor.systemBackground)
	private let cardColor = Color(UIColor.secondarySystemBackground)
	
	var body: some View {
		VStack {
			Text("Welcome to Astra")
				.font(.system(size: 34, weight: .bold, design: .rounded))
				.foregroundColor(accentColor)
			
			Spacer()
				.frame(height: 20)
			
			VStack(alignment: .leading, spacing: 12) {
				Text("Hello, My name is Matias Riboldi. I am an 18 year-old student about to finish High-School. Thus, one of the most important decisions of my life is getting close, ")
					.font(.system(size: 15, weight: .semibold))
					.foregroundColor(Color.black.opacity(0.8))
				+ Text("What university should I go to?")
					.font(.system(size: 15, weight: .bold))
					.foregroundColor(Color.Accent)
			}
			.multilineTextAlignment(.leading)
			
			Spacer()
				.frame(height: 20)
			
		
			Text("Choosing Universities is one of the most important steps in your academic journey. Yet, at the same time, one of the hardest. Because of this I created Astra.")
				.font(.system(size: 15, weight: .semibold))
				.foregroundColor(Color.black.opacity(0.8))
		}
		.padding(20)
	}
}

#Preview {
	Start()
}
