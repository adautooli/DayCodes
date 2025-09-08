//
//  ContentView.swift
//  LayoutDayToken
//
//  Created by Adauto Oliveira on 06/09/25.
//

import SwiftUI
import Combine

// MARK: - ViewModel
final class DayTokenViewModel: ObservableObject {
    // duração do ciclo em segundos
    let duration: TimeInterval = 60
    
    // estado
    @Published var token: String = "000000"
    @Published var remaining: TimeInterval = 60   // começa cheio
    
    private var timerCancellable: AnyCancellable?
    
    init() {
        start()
    }
    
    func start() {
        generateToken()
        remaining = duration
        startTimer()
    }
    
    func manualRefresh() {
        generateToken()
        remaining = duration
    }
    
    private func startTimer() {
        timerCancellable?.cancel()
        // tick a cada 0.05s para animação suave do anel
        timerCancellable = Timer
            .publish(every: 0.05, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                if remaining > 0 {
                    remaining = max(0, remaining - 0.05)
                } else {
                    // terminou: renova o token e reinicia o ciclo
                    generateToken()
                    remaining = duration
                }
            }
    }
    
    private func generateToken() {
        // aqui você pode plugar seu gerador real (TOTP, etc.)
        token = String(format: "%06d", Int.random(in: 0...999_999))
    }
}

// MARK: - Circular Progress (anti-horário)
struct AnticlockwiseRing: View {
    var progress: CGFloat          // 0..1 (restante/total)
    var lineWidth: CGFloat = 10
    
    var body: some View {
        ZStack {
            // trilho
            Circle()
                .stroke(Color.white.opacity(0.35), lineWidth: lineWidth)
            // anel restante (anti-horário)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.white, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                // começar no topo
                .rotationEffect(.degrees(-90))
                // espelhar para ficar anti-horário
                .scaleEffect(x: -1, y: 1, anchor: .center)
                .animation(.linear(duration: 0.05), value: progress)
        }
    }
}

// MARK: - Tela
struct DayTokenCodeView: View {
    @StateObject private var vm = DayTokenViewModel()
    
    // estilos
    private let bgBlue = Color(red: 36/255, green: 129/255, blue: 199/255)
    private let headerBlue = Color(red: 23/255, green: 115/255, blue: 185/255)
    
    var body: some View {
        ZStack {
            bgBlue.ignoresSafeArea()
            
            VStack(spacing: 24) {
                // header
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.white.opacity(0.9))
                        Spacer()
                    }
                    
                    Text("Day Token")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                }
                
                // infos do topo
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("CPF do usuário")
                            .font(.footnote)
                            .foregroundStyle(.white.opacity(0.8))
                        Text("000.450.235-00")
                            .font(.callout.weight(.semibold))
                            .foregroundStyle(.white)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 6) {
                        Text("Token nº")
                            .font(.footnote)
                            .foregroundStyle(.white.opacity(0.8))
                        Text("123456")
                            .font(.callout.weight(.semibold))
                            .foregroundStyle(.white)
                    }
                }
                .padding(.horizontal, 4)
                
                // círculo + número grande
                ZStack {
                    AnticlockwiseRing(progress: CGFloat(vm.remaining / vm.duration),
                                      lineWidth: 10)
                        .frame(width: 260, height: 260)
                        .shadow(color: .black.opacity(0.15), radius: 4, y: 2)
                    
                    Text(vm.token)
                        .font(.system(size: 44, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .monospacedDigit()
                        .accessibilityLabel("Token atual")
                }
                .padding(.top, 8)
                
                // aviso
                VStack(spacing: 14) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.title2)
                        .foregroundStyle(.white.opacity(0.9))
                    Text("Fique Atento")
                        .font(.headline)
                        .foregroundStyle(.white)
                    Text("Não informe e nem compartilhe o código token com ninguém.")
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white.opacity(0.9))
                        .padding(.horizontal, 24)
                }
                .padding(.top, 4)
                
                Spacer()
                
                // botão
                Button(action: vm.manualRefresh) {
                    Text("Novo token")
                        .font(.headline)
                        .foregroundStyle(bgBlue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(.white, in: Capsule())
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 8)
            }
            .padding(.horizontal, 24)
        }
        .onAppear { /* inicia o timer no init do VM */ }
        // acessibilidade: progresso restante em segundos
        .accessibilityElement(children: .combine)
        .accessibilityValue(Text("Restam \(Int(vm.remaining)) segundos"))
    }
}

// MARK: - Preview
#Preview {
    DayTokenCodeView()
}

