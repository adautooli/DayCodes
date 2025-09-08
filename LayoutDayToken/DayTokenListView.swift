//
//  DayTokenListView.swift
//  LayoutDayToken
//
//  Created by Adauto Oliveira on 06/09/25.
//

import SwiftUI

// MARK: - Tipos
enum DayTokenListMode {
    case tokenTypes     // Acesso ao Internet Banking, Transações Financeira, etc.
    case cpf            // lista de CPFs com token cadastrado (pode excluir)
    case userCode       // lista de Códigos de Usuário (PJ, pode excluir, header preto)
}

struct TokenTypeItem: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let subtitle: String
    let iconSystemName: String
}

struct CredentialItem: Identifiable, Equatable {
    let id = UUID()
    let value: String          // CPF ou Código de Usuário
    let tokenSuffix: String    // ex: "1234"
}

// MARK: - View
struct DayTokenListView: View {
    let mode: DayTokenListMode
    var onSelect: (String) -> Void
    var onDelete: ((String, DayTokenListMode) -> Void)?

    // tema
    private let bgBlue  = Color(red: 0.18, green: 0.51, blue: 0.77) // #2F83C4
    private let headerBlue = Color(red: 0.14, green: 0.45, blue: 0.73) // #1F74BA
    private var headerColor: Color { mode == .userCode ? .black : headerBlue }
    private let surface = Color(.systemGray6)

    // dados (podem ser injetados no init)
    @State private var tokenTypes: [TokenTypeItem]
    @State private var cpfs: [CredentialItem]
    @State private var userCodes: [CredentialItem]

    init(
        mode: DayTokenListMode,
        tokenTypes: [TokenTypeItem] = [
            .init(title: "Acesso ao Internet Banking",
                  subtitle: "Para acessar a sua Conta Investimento e Conta Global através de um computador.",
                  iconSystemName: "laptopcomputer"),
            .init(title: "Transações Financeira",
                  subtitle: "Para Pix, Transferências, TED, Pagamento, Câmbio e Resgate de Investimentos e transações na Conta Global.",
                  iconSystemName: "creditcard"),
            .init(title: "Demais Transações",
                  subtitle: "Para Atualização Cadastral, Solicitação de Cartão, Minhas Chaves, Limites Pix e demais transações.",
                  iconSystemName: "list.bullet.rectangle"),
            .init(title: "Atendimento",
                  subtitle: "Para atendimento telefônico. Poupe tempo e agilize a ligação realizando sua identificação.",
                  iconSystemName: "phone.fill")
        ],
        cpfs: [CredentialItem] = [
            .init(value: "012.345.678-90", tokenSuffix: "1234"),
            .init(value: "012.345.678-90", tokenSuffix: "1234"),
            .init(value: "012.345.678-90", tokenSuffix: "1234")
        ],
        userCodes: [CredentialItem] = [
            .init(value: "012.345.678-90", tokenSuffix: "1234"),
            .init(value: "012.345.678-90", tokenSuffix: "1234"),
            .init(value: "012.345.678-90", tokenSuffix: "1234")
        ],
        onSelect: @escaping (String) -> Void = { _ in },
        onDelete: ((String, DayTokenListMode) -> Void)? = nil
    ) {
        self.mode = mode
        _tokenTypes = State(initialValue: tokenTypes)
        _cpfs = State(initialValue: cpfs)
        _userCodes = State(initialValue: userCodes)
        self.onSelect = onSelect
        self.onDelete = onDelete
    }

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
                    Text("DayToken")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                    Spacer()
                }
                VStack(alignment: .leading) {
                    Text(bigHeadline)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.leading)
                        .padding(.top, 60)
                        .padding(.bottom, 16)
                }
                .background(headerColor)
            }
            .padding(.top, 16.0)
            .padding(.horizontal, 20.0)
            .background(headerColor)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            VStack {
                contentList
            }
            .padding(.top, 190)
        }
        
    }

    // MARK: - Conteúdo por modo
    @ViewBuilder
    private var contentList: some View {
        List {
            Section {
                switch mode {
                case .tokenTypes:
                    ForEach(tokenTypes) { item in
                        TokenTypeRow(item: item, accent: bgBlue) {
                            onSelect(item.title)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
                    }

                case .cpf:
                    ForEach(cpfs) { cred in
                        CredentialRow(title: cred.value,
                                      subtitle: "Token Final *\(cred.tokenSuffix)",
                                      accent: bgBlue) {
                            onSelect(cred.value)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                withAnimation {
                                    cpfs.removeAll { $0.id == cred.id }
                                }
                                onDelete?(cred.value, .cpf)
                            } label: {
                                Label("Excluir", systemImage: "trash")
                            }
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
                    }

                case .userCode:
                    ForEach(userCodes) { cred in
                        CredentialRow(title: cred.value,
                                      subtitle: "Token Final *\(cred.tokenSuffix)",
                                      accent: bgBlue) {
                            onSelect(cred.value)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                withAnimation {
                                    userCodes.removeAll { $0.id == cred.id }
                                }
                                onDelete?(cred.value, .userCode)
                            } label: {
                                Label("Excluir", systemImage: "trash")
                            }
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
                    }
                }
            } footer: { EmptyView() }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    // MARK: - Headline por modo
    private var bigHeadline: String {
        switch mode {
        case .tokenTypes:
            return "Selecione o Token que deseja visualizar."
        case .cpf:
            return "Selecione o CPF do DayToken que deseja utilizar."
        case .userCode:
            return "Selecione o Código de Usuário do DayToken que deseja utilizar."
        }
    }
}

// MARK: - Rows
private struct TokenTypeRow: View {
    let item: TokenTypeItem
    let accent: Color
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(accent.opacity(0.12))
                    Image(systemName: item.iconSystemName)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(accent)
                }
                .frame(width: 44, height: 44)

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.black.opacity(0.85))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(item.subtitle)
                        .font(.system(size: 12))
                        .foregroundStyle(.black.opacity(0.6))
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 8)

                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(accent)
                    .padding(.top, 2)
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.06), radius: 8, y: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

private struct CredentialRow: View {
    let title: String
    let subtitle: String
    let accent: Color
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(accent.opacity(0.12))
                    Image(systemName: "person.crop.circle")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(accent)
                }
                .frame(width: 44, height: 44)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.black.opacity(0.85))
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundStyle(.black.opacity(0.6))
                }

                Spacer(minLength: 8)

                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(accent)
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.06), radius: 8, y: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview
#Preview {
    
//    DayTokenListView(mode: .cpf)
//    DayTokenListView(mode: .userCode)
    DayTokenListView(mode: .tokenTypes)
    

}

