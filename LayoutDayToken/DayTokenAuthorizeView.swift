//
//  DayTokenAuthorizeView.swift
//  LayoutDayToken
//
//  Created by Adauto Oliveira on 07/09/25.
//

import SwiftUI

// Modelo simples da operação que será autorizada
struct TokenOperation {
    var title: String              // ex: "Transferência TED"
    var debitAccount: String       // ex: "Ag: 0001 CC: 1234567"
    var beneficiary: String        // ex: "João da Silva"
    var bankLine: String           // ex: "Banco: 0123 Ag:0001 CC:1234567"
    var amount: String             // ex: "R$ 10.000,00"
}

struct DayTokenAuthorizeView: View {
    // Dados da operação (injete do fluxo real)
    let op: TokenOperation
    var onAuthorize: () -> Void = {}
    var onCancel: () -> Void = {}
    var onReport: () -> Void = {}    // "clique aqui"

    // Cores do app
    private let headerBlue = Color(red: 0.14, green: 0.45, blue: 0.73) // #1F74BA
    private let surface = Color(.systemGray6)
    private let accentBlue = Color(red: 0.18, green: 0.51, blue: 0.77) // #2F83C4
    private let navy = Color(red: 0.03, green: 0.16, blue: 0.40)       // botão "Autorizar"

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: {}) {
                        Image(systemName: "chevron.left")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.white)
                    }
                    Spacer()
                    Text("Day Token")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 16)
                .background(headerBlue)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Ícone de alerta
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 60, height: 60)
                                .shadow(color: .black.opacity(0.05), radius: 6, y: 2)

                            Circle()
                                .stroke(Color.orange, lineWidth: 3)
                                .frame(width: 60, height: 60)

                            Image(systemName: "exclamationmark")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundStyle(Color.orange)
                        }
                        .padding(.top, 18)

                        // Pergunta com ênfase em "transação financeira"
                        Text(promptAttributed)
                            .font(.system(size: 15))
                            .foregroundStyle(.black.opacity(0.75))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)

                        // Card com dados da operação
                        VStack(spacing: 12) {
                            Text(op.title)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.black.opacity(0.8))

                            VStack(spacing: 6) {
                                Text("Conta Débito: \(op.debitAccount)")
                                Text("Favorecido: \(op.beneficiary)")
                                Text(op.bankLine)
                            }
                            .font(.system(size: 13))
                            .foregroundStyle(.black.opacity(0.6))
                            .frame(maxWidth: .infinity, alignment: .leading)

                            Divider().padding(.vertical, 4)

                            HStack {
                                Text("Valor:")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.black.opacity(0.8))
                                Text(op.amount)
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundStyle(.black.opacity(0.8))
                                Spacer()
                            }
                        }
                        .padding(18)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.08), radius: 10, y: 3)
                        )
                        .padding(.horizontal, 20)

                        // Link "clique aqui"
                        Button(action: onReport) {
                            HStack(spacing: 4) {
                                Text("Caso não reconheça essa transação,")
                                    .foregroundStyle(.black.opacity(0.55))
                                Text("clique aqui.")
                                    .foregroundStyle(accentBlue)
                                    .underline()
                            }
                            .font(.system(size: 13))
                        }
                        .padding(.top, 4)
                        
                    }
                }
                VStack {
                    Button(action: onAuthorize) {
                        Text("Autorizar")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                Capsule().fill(navy)
                            )
                    }

                    Button(action: onCancel) {
                        Text("Cancelar")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(navy)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                Capsule()
                                    .stroke(navy.opacity(0.35), lineWidth: 1.2)
                                    .background(Capsule().fill(Color.white))
                            )
                    }
                }
                .padding(.horizontal, 24)
                .safeAreaPadding(.bottom, 24)
            }
        }
    }

    // MARK: - Texto com ênfase
    private var promptAttributed: AttributedString {
        var s = AttributedString("Deseja gerar um token para autorizar a ")
        var bold = AttributedString("transação financeira")
        var end = AttributedString(" em seu computador?")
        bold.font = .system(size: 15, weight: .semibold)
        return s + bold + end
    }
}

// MARK: - Preview
#Preview {
    DayTokenAuthorizeView(
        op: .init(
            title: "Transferência TED",
            debitAccount: "Ag: 0001 CC: 1234567",
            beneficiary: "João da Silva",
            bankLine: "Banco: 0123 Ag:0001 CC:1234567",
            amount: "R$ 10.000,00"
        ),
        onAuthorize: { print("Autorizar") },
        onCancel: { print("Cancelar") },
        onReport: { print("Reportar transação") }
    )
}

