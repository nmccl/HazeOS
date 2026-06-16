//
//  WeatherParticleSystem.swift
//  Haze
//
//  GPU-driven particle canvas. All particles are deterministic functions of
//  wall-clock time — no @State, no timers, pure math.
//

import SwiftUI

struct WeatherParticleSystem: View {
    let condition: AppWeatherCondition

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { ctx, size in
                let t = timeline.date.timeIntervalSinceReferenceDate
                switch condition {
                case .rainy:
                    drawRain(&ctx, size: size, time: t, heavy: false)
                case .thunderstorm:
                    drawRain(&ctx, size: size, time: t, heavy: true)
                    drawLightning(&ctx, size: size, time: t)
                case .snowy:
                    drawSnow(&ctx, size: size, time: t)
                case .clear:
                    drawMotes(&ctx, size: size, time: t)
                case .foggy, .cloudy:
                    drawMist(&ctx, size: size, time: t)
                case .hazy:
                    drawHaze(&ctx, size: size, time: t)
                }
            }
        }
        .allowsHitTesting(false)
        .ignoresSafeArea()
    }

    // MARK: - Rain

    private func drawRain(_ ctx: inout GraphicsContext, size: CGSize, time: Double, heavy: Bool) {
        let count  = heavy ? 110 : 65
        let speed  = heavy ? 680.0 : 480.0
        let totalH = size.height + 80.0

        for i in 0..<count {
            let fi  = Double(i)
            let x   = (fi * 89.7).truncatingRemainder(dividingBy: size.width + 60) - 30
            let yOff = (fi / Double(count)) * totalH
            let y   = (time * speed + yOff).truncatingRemainder(dividingBy: totalH) - 20
            let op  = 0.06 + fi.truncatingRemainder(dividingBy: 7) / 7.0 * 0.14
            let len = heavy ? 20.0 : 14.0

            var p = Path()
            p.move(to: CGPoint(x: x, y: y))
            p.addLine(to: CGPoint(x: x - 1.2, y: y + len))
            ctx.stroke(p, with: .color(.white.opacity(op)), lineWidth: 0.55)
        }
    }

    // MARK: - Lightning flash

    private func drawLightning(_ ctx: inout GraphicsContext, size: CGSize, time: Double) {
        let phase = sin(time * 4.7) * cos(time * 3.1)
        guard phase > 0.88 else { return }
        let intensity = (phase - 0.88) / 0.12 * 0.28
        let rect = CGRect(origin: .zero, size: size)
        ctx.fill(Rectangle().path(in: rect), with: .color(.white.opacity(intensity)))
    }

    // MARK: - Snow

    private func drawSnow(_ ctx: inout GraphicsContext, size: CGSize, time: Double) {
        let count = 55
        for i in 0..<count {
            let fi     = Double(i)
            let baseX  = (fi * 127.3).truncatingRemainder(dividingBy: size.width)
            let speed  = 16.0 + fi.truncatingRemainder(dividingBy: 5) * 5.0
            let sway   = sin(time * 0.38 + fi * 0.85) * 20.0
            let x      = baseX + sway
            let y      = (time * speed + fi * size.height / Double(count))
                             .truncatingRemainder(dividingBy: size.height + 20) - 10
            let radius = 1.6 + fi.truncatingRemainder(dividingBy: 3) * 0.8
            let pulse  = (sin(time * 1.2 + fi * 2.3) + 1.0) / 2.0
            let op     = 0.4 + pulse * 0.35

            let r = CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2)
            ctx.fill(Circle().path(in: r), with: .color(.white.opacity(op)))
        }
    }

    // MARK: - Clear golden motes

    private func drawMotes(_ ctx: inout GraphicsContext, size: CGSize, time: Double) {
        let count = 22
        for i in 0..<count {
            let fi     = Double(i)
            let baseX  = (fi * 173.1).truncatingRemainder(dividingBy: size.width)
            let baseY  = (fi * 97.7).truncatingRemainder(dividingBy: size.height)
            let x      = baseX + sin(time * 0.22 + fi * 0.8) * 14.0
            let y      = baseY + cos(time * 0.17 + fi * 0.6) * 18.0
            let pulse  = (sin(time * 1.0 + fi * 1.9) + 1.0) / 2.0
            let op     = pulse * 0.32 + 0.04
            let radius = 1.4 + pulse * 1.8

            let r = CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2)
            ctx.fill(Circle().path(in: r),
                     with: .color(Color(red: 1.0, green: 0.87, blue: 0.42).opacity(op)))
        }
    }

    // MARK: - Fog / Cloudy mist wisps

    private func drawMist(_ ctx: inout GraphicsContext, size: CGSize, time: Double) {
        for i in 0..<5 {
            let fi    = Double(i)
            let drift = sin(time * (0.055 + fi * 0.012) + fi * 1.4) * 55.0
            let y     = size.height * (0.22 + fi * 0.15)
            let op    = max(0, 0.028 + sin(time * 0.09 + fi) * 0.014)
            let rect  = CGRect(x: drift - 70, y: y - 28, width: size.width + 140, height: 56)
            ctx.fill(RoundedRectangle(cornerRadius: 28).path(in: rect),
                     with: .color(.white.opacity(op)))
        }
    }

    // MARK: - Hazy shimmer

    private func drawHaze(_ ctx: inout GraphicsContext, size: CGSize, time: Double) {
        let count = 28
        for i in 0..<count {
            let fi     = Double(i)
            let x      = (fi * 211.3).truncatingRemainder(dividingBy: size.width)
            let y      = (fi * 137.8).truncatingRemainder(dividingBy: size.height)
            let pulse  = (sin(time * 0.65 + fi * 2.8) + 1.0) / 2.0
            let op     = pulse * 0.11
            let radius = 3.0 + pulse * 5.5

            let r = CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2)
            ctx.fill(Circle().path(in: r),
                     with: .color(Color(red: 1.0, green: 0.6, blue: 0.25).opacity(op)))
        }
    }
}
