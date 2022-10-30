//
//  BankSelector.swift
//  Taxi
//
//  Created by JongHo Park on 2022/10/29.
//

import SwiftUI

struct BankSelector: View {
    private let onBankSelect: (Bank) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var searchText: String = ""
    @State private var bankList: [Bank] = Bank.allCases

    init(onBankSelect: @escaping (Bank) -> Void = { _ in }) {
        self.onBankSelect = onBankSelect
    }

    var body: some View {
        VStack {
            navigationBar()
            Group {
                searchTextField
                bankList(list: bankList)
            }
            .padding()
            Spacer()
        }
        .onChange(of: searchText) { newValue in
            filterBanks(newValue)
        }
    }
}

// MARK: - Side Effects
private extension BankSelector {
    func filterBanks(_ bankName: String) {
        bankList = Bank.allCases.filter {
            $0.rawValue.uppercased().contains(bankName.uppercased())
        }
    }
}

private extension BankSelector {
    func navigationBar() -> some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Text("취소")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Text("은행 선택")
                .font(Font.custom("AppleSDGothicNeo-Medium", size: 18))
                .foregroundColor(.customBlack)
            Text("")
                .frame(maxWidth: .infinity)

        }
        .padding()
    }

    var searchTextField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .imageScale(.large)
            TextField("은행 이름을 입력해주세요", text: $searchText)
                .textFieldStyle(.roundedBorder)
        }
    }

    func bankList(list: [Bank]) -> some View {
        ScrollView(.vertical, showsIndicators: true) {
            LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: 8), count: 3)) {
                ForEach(list, id: \.self) { bank in
                    bankCell(bank: bank)
                }
            }
            .padding(.horizontal)
        }
    }

    func bankCell(bank: Bank) -> some View {
        Button {
            onBankSelect(bank)
            dismiss()
        } label: {
            VStack(spacing: 8) {
                bank.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 30)
                Text(bank.rawValue)
                    .font(.caption)
                    .fontWeight(.regular)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(RoundedRectangle(cornerRadius: 8).fill(Color.lightGray))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview
#if DEBUG
struct BankSelector_Previews: PreviewProvider {
    static var previews: some View {
        AccountSetting(viewModel: .init())
            .sheet(isPresented: .constant(true)) {
                BankSelector()
            }
    }
}
#endif
