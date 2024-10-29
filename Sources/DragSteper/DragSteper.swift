// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public struct DragSteper: View {
    @Binding var value: Int
    @State var minValue: Int? = nil
    @State var maxValue: Int? = nil
    @State var haptic: Bool = false
    
    @State private var offset: Double = 0
    @State private var dotOffset: Double = 0
    @State private var origin: Int = 0
    @State private var dotLocked: Bool = false
    @State private var locked: Bool = false
    @State private var noHaptic: Bool = false
    
    private let hapticManager = NSHapticFeedbackManager.defaultPerformer
    
    public var body: some View {
        HStack(spacing: 2) {
            Button(action: {
                if locked { return }
                locked = true
                noHaptic = true
                withAnimation(.easeInOut(duration: 0.2)) { offset += 7.4 }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    offset = 0
                    dotOffset += 7.5
                    dotOffset = Double(Int(dotOffset / 7.5)) * 7.5
                    value -= 1
                    value = max(minValue ?? value, min(maxValue ?? value, value))
                    locked = false
                }
                
            }, label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.secondary)
            }).buttonStyle(.plain)
            VStack(spacing: 3) {
                Circle().frame(width: 3, height: 3)
                    .offset(x: (offset != 0 && dotOffset == 0) ? min(37.5, max(-37.5, offset)) : min(37.5, max(-37.5, dotOffset + offset)))
                VStack(spacing: 0) {
                    HStack(alignment: .top, spacing: 6) {
                        ForEach(0..<4) { i in
                            RoundedRectangle(cornerRadius: 1)
                                .fill(Color.secondary)
                                .frame(width: 1.5, height: 12)
                        }
                        RoundedRectangle(cornerRadius: 1)
                            .fill(Color.secondary)
                            .frame(width: 1.5, height: offset >= 0 ? min(19, 12 + offset.truncatingRemainder(dividingBy: 7.5)) : 12)
                        RoundedRectangle(cornerRadius: 1)
                            .frame(width: 1.5, height: offset != 0 ? max(12, 19 - abs(offset.truncatingRemainder(dividingBy: 7.5))) : 19)
                        RoundedRectangle(cornerRadius: 1)
                            .fill(Color.secondary)
                            .frame(width: 1.5, height: offset <= 0 ? min(19, 12 + abs(offset.truncatingRemainder(dividingBy: 7.5))) : 12)
                        ForEach(0..<4) { i in
                            RoundedRectangle(cornerRadius: 1)
                                .fill(Color.secondary)
                                .frame(width: 1.5, height: 12)
                        }
                    }
                    .padding([.leading, .trailing], 6)
                    .offset(x: offset.truncatingRemainder(dividingBy: 7.5))
                    .background(Color.white.opacity(0.0001))
                    .mask(
                        LinearGradient(gradient: Gradient(stops: [
                            .init(color: .clear, location: 0.0),
                            .init(color: .black, location: 0.5),
                            .init(color: .clear, location: 1.0)
                        ]), startPoint: .leading, endPoint: .trailing)
                    )
                    .gesture(
                        DragGesture()
                            .onChanged { newValue in
                                let width = newValue.translation.width
                                value = origin - Int(floor(width / 7.5))
                                value = max(minValue ?? value, min(maxValue ?? value, value))
                                if let maxV = maxValue, value >= maxV {
                                    if dotLocked { return }
                                    dotLocked = true
                                    offset = 0
                                    dotOffset = max(-37.5, Double(Int(width / 7.5)) * 7.5)
                                    return
                                }
                                if let minV = minValue, value <= minV {
                                    if dotLocked { return }
                                    dotLocked = true
                                    offset = 0
                                    dotOffset = min(37.5, Double(Int(width / 7.5)) * 7.5)
                                    return
                                }
                                dotLocked = false
                                offset = width
                            }
                            .onEnded { newValue in
                                withAnimation(.easeOut(duration: 0.2)) {
                                    offset = 0
                                    origin = value
                                    if let max = maxValue, value >= max { return }
                                    if let min = minValue, value <= min { return }
                                    dotOffset += newValue.translation.width
                                    dotOffset = Double(Int(dotOffset / 7.5)) * 7.5
                                }
                                
                            }
                    )
                    Spacer().frame(minHeight: 0)
                }
                .frame(height: 19)
            }.offset(y: 0.5)
            Button(action: {
                if locked { return }
                locked = true
                noHaptic = true
                withAnimation(.easeInOut(duration: 0.2)) { offset -= 7.4 }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    offset = 0
                    dotOffset -= 7.5
                    dotOffset = Double(Int(dotOffset / 7.5)) * 7.5
                    value += 1
                    value = max(minValue ?? value, min(maxValue ?? value, value))
                    locked = false
                }
            }, label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.secondary)
            })
            .buttonStyle(.plain)
        }
        .padding(2.5)
        .padding([.leading, .trailing], 3)
        .onAppear { origin = value }
        .onChange(of: value) { _ in
            if haptic && !noHaptic { hapticManager.perform(.alignment, performanceTime: .now) }
            noHaptic = false
        }
    }
}
