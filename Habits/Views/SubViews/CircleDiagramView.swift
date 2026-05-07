//
//  CircleDiagramView.swift
//  Habits
//
//  Created by Erik on 2026-05-07.
//

import SwiftUI

struct CircleDiagramView: View {

    let progress: Double

    private var clampedProgress: Double {
        min(max(progress, 0), 1)
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.gray.opacity(0.2))
            PieSlice(progress: clampedProgress)
                .fill(clampedProgress == 1 ? Color.green : Color.blue.opacity(0.5))
                .animation(.easeInOut, value: clampedProgress)
                

        }
        
    }
}

struct PieSlice: Shape {

    var progress: Double  // 0.0 -> 1.0

    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }
    
    func path(in rect: CGRect) -> Path {

        let center = CGPoint(
            x: rect.midX,
            y: rect.midY
        )

        let radius = min(rect.width, rect.height) / 2

        let startAngle = Angle(degrees: -90)
        let endAngle = Angle(
            degrees: -90 + (360 * progress)
        )

        var path = Path()

        path.move(to: center)

        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )

        path.closeSubpath()

        return path
    }
}

#Preview {
    CircleDiagramView(progress: 0.25)
}
