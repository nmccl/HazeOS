////
////  WeatherIllustration.swift
////  Haze
////
////  Canvas-drawn flat illustrations — one per condition.
////  Design language: single accent colour, horizontal-stripe motif,
////  editorial/woodblock print aesthetic.
////
////  The stripe cutout technique: draw background-coloured horizontal lines
////  over the filled shape. Since the canvas sits on top of a matching
////  background colour, the lines read as transparent gaps.
////
//
//import SwiftUI
//
//struct WeatherIllustration: View {
//    let condition: AppWeatherCondition
//
//    private var accent: Color { condition.accentColor }
//    private var bg:     Color { condition.backgroundColor }
//
//    var body: some View {
//        Canvas { ctx, size in
//            switch condition {
//            case .clear:        drawSun(&ctx, size: size)
//            case .cloudy:       drawCloud(&ctx, size: size)
//            case .rainy:        drawRain(&ctx, size: size)
//            case .snowy:        drawSnow(&ctx, size: size)
//            case .thunderstorm: drawThunder(&ctx, size: size)
//            case .foggy:        drawFog(&ctx, size: size)
//            case .hazy:         drawHaze(&ctx, size: size)
//            }
//        }
//        .frame(width: 240, height: 272)
//    }
//
//    // MARK: - Clear / Sunny
//    // Circle + horizontal stripe cuts through lower half + tapering reflection
//    // lines + V-shaped birds — mirrors the reference's Japanese sun motif.
//
//    private func drawSun(_ ctx: inout GraphicsContext, size: CGSize) {
//        let cx = size.width  / 2
//        let cy = size.height * 0.44
//        let r: CGFloat = 74
//
//        // Solid sun circle
//        let sunRect = CGRect(x: cx - r, y: cy - r, width: r * 2, height: r * 2)
//        ctx.fill(Circle().path(in: sunRect), with: .color(accent))
//
//        // Horizontal bg-coloured stripes through lower half — create the
//        // characteristic banded look that also reads as water reflections.
//        for i in 0..<6 {
//            let y = cy + CGFloat(i) * 14 + 6
//            var line = Path()
//            line.move(to:    CGPoint(x: cx - r - 4, y: y))
//            line.addLine(to: CGPoint(x: cx + r + 4, y: y))
//            ctx.stroke(line, with: .color(bg), lineWidth: 8)
//        }
//
//        // Tapering reflection lines below the circle
//        for i in 0..<5 {
//            let fi   = CGFloat(i)
//            let lw   = r * 2.0 * (1.0 - fi * 0.15)
//            let y    = cy + r + 14 + fi * 14
//            let rect = CGRect(x: cx - lw / 2, y: y, width: lw, height: 3)
//            ctx.fill(RoundedRectangle(cornerRadius: 1.5).path(in: rect),
//                     with: .color(accent.opacity(1.0 - Double(i) * 0.16)))
//        }
//
//        // Birds — loose formation of V-shaped quadratic curves
//        let birds: [(CGFloat, CGFloat, CGFloat)] = [
//            (cx + 26, cy - r - 28, 10),
//            (cx + 50, cy - r - 44, 8),
//            (cx + 72, cy - r - 35, 7),
//            (cx -  8, cy - r - 20, 9),
//        ]
//        for (bx, by, span) in birds {
//            var b = Path()
//            b.move(to: CGPoint(x: bx - span,       y: by + span * 0.3))
//            b.addQuadCurve(to: CGPoint(x: bx,       y: by),
//                           control: CGPoint(x: bx - span * 0.5, y: by - span * 0.45))
//            b.addQuadCurve(to: CGPoint(x: bx + span, y: by + span * 0.3),
//                           control: CGPoint(x: bx + span * 0.5, y: by - span * 0.45))
//            ctx.stroke(b, with: .color(accent), lineWidth: 1.6)
//        }
//    }
//
//    // MARK: - Cloud silhouette (shared by cloudy, rainy, thunderstorm)
//
//    private func cloudPath(cx: CGFloat, cy: CGFloat, scale: CGFloat = 1.0) -> Path {
//        let s = scale
//        var p = Path()
//        p.addEllipse(in: CGRect(x: cx - 74*s, y: cy - 10*s, width: 148*s, height: 60*s))
//        p.addEllipse(in: CGRect(x: cx - 88*s, y: cy - 38*s, width: 74*s,  height: 74*s))
//        p.addEllipse(in: CGRect(x: cx - 22*s, y: cy - 56*s, width: 80*s,  height: 80*s))
//        p.addEllipse(in: CGRect(x: cx + 16*s, y: cy - 42*s, width: 62*s,  height: 62*s))
//        return p
//    }
//
//    // MARK: - Cloudy
//    // Solid cloud + same stripe motif as the sun — keeps the visual language coherent.
//
//    private func drawCloud(_ ctx: inout GraphicsContext, size: CGSize) {
//        let cx = size.width  / 2
//        let cy = size.height * 0.44
//        let cloud = cloudPath(cx: cx, cy: cy)
//        ctx.fill(cloud, with: .color(accent))
//
//        // Horizontal stripe cuts through the cloud
//        for i in 0..<5 {
//            let y = cy - 10 + CGFloat(i) * 15
//            var line = Path()
//            line.move(to:    CGPoint(x: cx - 100, y: y))
//            line.addLine(to: CGPoint(x: cx + 100, y: y))
//            ctx.stroke(line, with: .color(bg), lineWidth: 9)
//        }
//    }
//
//    // MARK: - Rainy
//
//    private func drawRain(_ ctx: inout GraphicsContext, size: CGSize) {
//        let cx = size.width  / 2
//        let cy = size.height * 0.36
//        let cloud = cloudPath(cx: cx, cy: cy)
//        ctx.fill(cloud, with: .color(accent))
//
//        // Stripe cuts
//        for i in 0..<4 {
//            let y = cy - 8 + CGFloat(i) * 14
//            var line = Path()
//            line.move(to:    CGPoint(x: cx - 96, y: y))
//            line.addLine(to: CGPoint(x: cx + 96, y: y))
//            ctx.stroke(line, with: .color(bg), lineWidth: 9)
//        }
//
//        // Diagonal rain streaks
//        let offsets: [(CGFloat, CGFloat)] = [(-50, 0), (-24, 10), (2, 0), (28, 10), (54, 0)]
//        for (i, (xOff, yOff)) in offsets.enumerated() {
//            let x0 = cx + xOff
//            let y0 = cy + 52 + yOff
//            var streak = Path()
//            streak.move(to:    CGPoint(x: x0,     y: y0))
//            streak.addLine(to: CGPoint(x: x0 - 9, y: y0 + 44))
//            let op = 1.0 - Double(i) * 0.07
//            ctx.stroke(streak, with: .color(accent.opacity(op)), lineWidth: 2.2)
//        }
//    }
//
//    // MARK: - Snowy
//
//    private func drawSnow(_ ctx: inout GraphicsContext, size: CGSize) {
//        let cx = size.width  / 2
//        let cy = size.height * 0.48
//        let len: CGFloat = 68
//
//        for i in 0..<6 {
//            let angle: Double = Double(i) * 60.0 * .pi / 180.0
//            let ex = cx + CGFloat(cos(angle)) * len
//            let ey = cy + CGFloat(sin(angle)) * len
//
//            // Main arm
//            var arm = Path()
//            arm.move(to:    CGPoint(x: cx, y: cy))
//            arm.addLine(to: CGPoint(x: ex, y: ey))
//            ctx.stroke(arm, with: .color(accent), lineWidth: 2.5)
//
//            // Cross bars at 44% and 72% of arm length
//            for frac in [0.44, 0.71] {
//                let frac = CGFloat(frac)
//                let mx   = cx + CGFloat(cos(angle)) * len * frac
//                let my   = cy + CGFloat(sin(angle)) * len * frac
//                let perp: Double = angle + .pi / 2
//                let bl: CGFloat = frac < 0.5 ? 15 : 11
//                var bar = Path()
//                bar.move(to:    CGPoint(x: mx - CGFloat(cos(perp)) * bl, y: my - CGFloat(sin(perp)) * bl))
//                bar.addLine(to: CGPoint(x: mx + CGFloat(cos(perp)) * bl, y: my + CGFloat(sin(perp)) * bl))
//                ctx.stroke(bar, with: .color(accent), lineWidth: 2.0)
//            }
//        }
//        // Centre dot
//        let dr: CGFloat = 6
//        ctx.fill(Circle().path(in: CGRect(x: cx-dr, y: cy-dr, width: dr*2, height: dr*2)),
//                 with: .color(accent))
//    }
//
//    // MARK: - Thunderstorm
//
//    private func drawThunder(_ ctx: inout GraphicsContext, size: CGSize) {
//        let cx = size.width  / 2
//        let cy = size.height * 0.35
//        let cloud = cloudPath(cx: cx, cy: cy)
//        ctx.fill(cloud, with: .color(accent))
//
//        // Stripe cuts
//        for i in 0..<4 {
//            let y = cy - 8 + CGFloat(i) * 14
//            var line = Path()
//            line.move(to:    CGPoint(x: cx - 96, y: y))
//            line.addLine(to: CGPoint(x: cx + 96, y: y))
//            ctx.stroke(line, with: .color(bg), lineWidth: 9)
//        }
//
//        // Lightning bolt
//        var bolt = Path()
//        bolt.move(to:    CGPoint(x: cx + 14, y: cy + 10))
//        bolt.addLine(to: CGPoint(x: cx -  8, y: cy + 46))
//        bolt.addLine(to: CGPoint(x: cx +  6, y: cy + 46))
//        bolt.addLine(to: CGPoint(x: cx - 16, y: cy + 90))
//        bolt.addLine(to: CGPoint(x: cx + 14, y: cy + 50))
//        bolt.addLine(to: CGPoint(x: cx -  2, y: cy + 50))
//        bolt.closeSubpath()
//        ctx.fill(bolt, with: .color(accent))
//    }
//
//    // MARK: - Foggy
//    // Horizontal lines of varying width — pure geometric simplicity.
//
//    private func drawFog(_ ctx: inout GraphicsContext, size: CGSize) {
//        let cx = size.width  / 2
//        let startY = size.height * 0.26
//        let widths: [CGFloat] = [164, 118, 150, 96, 138, 110, 148]
//
//        for (i, w) in widths.enumerated() {
//            let y    = startY + CGFloat(i) * 24
//            let rect = CGRect(x: cx - w / 2, y: y, width: w, height: 5)
//            let op   = 1.0 - Double(i) * 0.10
//            ctx.fill(RoundedRectangle(cornerRadius: 2.5).path(in: rect),
//                     with: .color(accent.opacity(op)))
//        }
//    }
//
//    // MARK: - Hazy
//    // Like the sun but denser stripes and shorter, dimmer reflections —
//    // reads as diffused rather than crisp.
//
//    private func drawHaze(_ ctx: inout GraphicsContext, size: CGSize) {
//        let cx = size.width  / 2
//        let cy = size.height * 0.44
//        let r: CGFloat = 68
//
//        let sunRect = CGRect(x: cx - r, y: cy - r, width: r * 2, height: r * 2)
//        ctx.fill(Circle().path(in: sunRect), with: .color(accent.opacity(0.84)))
//
//        // Dense stripes (tighter spacing than the clear sun)
//        for i in 0..<8 {
//            let y = cy - r + CGFloat(i) * 18 + 14
//            var line = Path()
//            line.move(to:    CGPoint(x: cx - r - 3, y: y))
//            line.addLine(to: CGPoint(x: cx + r + 3, y: y))
//            ctx.stroke(line, with: .color(bg), lineWidth: 7)
//        }
//
//        // Short, faded reflection lines
//        for i in 0..<4 {
//            let fi   = CGFloat(i)
//            let lw   = r * 1.6 * (1.0 - fi * 0.22)
//            let y    = cy + r + 12 + fi * 15
//            let rect = CGRect(x: cx - lw / 2, y: y, width: lw, height: 3)
//            ctx.fill(RoundedRectangle(cornerRadius: 1.5).path(in: rect),
//                     with: .color(accent.opacity(0.62 - Double(i) * 0.13)))
//        }
//    }
//}
