//
//  AccountSetting.swift
//  Taxi
//
//  Created by JongHo Park on 2022/10/29.
//

import SwiftUI

struct AccountSetting: View {
    @ObservedObject private var viewModel: AccountViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isShowBankSelector: Bool = false
    @State private var bank: Bank?
    @State private var accountNumber: AccountNumber
    @State private var owner: AccountOwner
    @State private var accountNumberValidation: ValidationResult = .empty(message: "")
    @State private var accountOwnerValidation: ValidationResult = .empty(message: "")

    init(viewModel: AccountViewModel) {
        self.viewModel = viewModel
        if let account = viewModel.account {
            self._bank = State(initialValue: account.bank)
            self._accountNumber = State(initialValue: .init(account.accountNumber))
            self._owner = State(initialValue: .init(account.owner))
        } else {
            self._bank = State(initialValue: nil)
            self._accountNumber = State(initialValue: .init())
            self._owner = State(initialValue: .init())
        }
    }

    var body: some View {
        VStack {
            navigationBar()
            Group {
                HStack(alignment: .center, spacing: 16) {
                    bankSelector
                    nameTextField
                }
                accountNumberTextField
            }
            .padding()
            Spacer()
        }
        .sheet(isPresented: $isShowBankSelector) {
            BankSelector {
                bank = $0
            }
        }
        .onChange(of: accountNumber.value) { _ in
            accountNumberValidation = accountNumber.validate()
        }
        .onChange(of: owner.value) { _ in
            accountOwnerValidation = owner.validate()
        }
    }
}

// MARK: - UI Components
private extension AccountSetting {
    func navigationBar() -> some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Text("취소")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Text("계좌번호 설정")
                .font(Font.custom("AppleSDGothicNeo-Medium", size: 18))
                .foregroundColor(.customBlack)
            applyChangeButton
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
    }

    var applyChangeButton: some View {
        Button {
            guard let bank else { return }
            viewModel.saveAccount(bank: bank, accountNumber: accountNumber.value, owner: owner.value)
            dismiss()
        } label: {
            Text("저장")
        }
        .disabled(bank == nil || !accountNumberValidation.isValid || !accountOwnerValidation.isValid)
    }
    var bankSelector: some View {
        Button {
            isShowBankSelector = true
        } label: {
            Text(bank?.rawValue ?? "은행선택")
                .foregroundColor(.black)
                .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.customYellow))
        }
    }

    var accountNumberTextField: some View {
        UnderlinedTextField(text: $accountNumber.value, accountNumberValidation, "계좌번호를 입력해주세요")
            .keyboardType(.numberPad)
    }
    var nameTextField: some View {
        UnderlinedTextField(text: $owner.value, accountOwnerValidation, "계좌주인을 입력해주세요")
    }
}

#if DEBUG
struct AccountSettingPreview: PreviewProvider {
    static var previews: some View {
        Text("")
            .sheet(isPresented: .constant(true)) {
                AccountSetting(viewModel: .init())
            }
    }
}
#endif
