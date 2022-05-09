//
//  SettingView.swift
//  PokeMaster
//
//  Created by 黄伯驹 on 2021/11/28.
//

import SwiftUI
import Combine

extension AppState.Settings.Sorting {
    var text: String {
        switch self {
        case .id: return "ID"
        case .name: return "名字"
        case .color: return "颜色"
        case .favorite: return "最爱"
        }
    }
}


extension AppState.Settings.AccountBehavior {
    var text: String {
        switch self {
        case .register: return "注册"
        case .login: return "登录"
        }
    }
}

struct SettingView: View {

    @EnvironmentObject var store: Store
    var settingsBinding: Binding<AppState.Settings> {
        $store.appState.settings
    }

    var settings: AppState.Settings {
        store.appState.settings
    }
    
    var accountSection: some View {
        Section(header: Text("账户")) {
            if let user = settings.loginUser {
                Text(user.email)
                Button("注销") {
                    print("注销")
                }
            } else {
                Picker(selection: settingsBinding.accountBehavior,
                       label: Text("")) {
                    ForEach(AppState.Settings.AccountBehavior.allCases, id: \.self) {
                        Text($0.text)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                TextField("电子邮箱", text: settingsBinding.email)
                SecureField("密码", text: settingsBinding.password)
                if settings.accountBehavior == .register {
                    SecureField("确认密码", text: settingsBinding.verifyPassword)
                }
                Button(settings.accountBehavior.text) {
                    self.store.dispatch(.login(email: self.settings.email, password: self.settings.password))
                }
            }
        }
    }
    
    var optionSection: some View {
        Section(header: Text("选项")) {
            Toggle(isOn: settingsBinding.showEnglishName) {
                Text("显示英文名")
            }
            Picker(selection: settingsBinding.sorting, label: Text("排序方式")) {
                ForEach(AppState.Settings.Sorting.allCases, id: \.self) {
                    Text($0.text)
                }
            }
            Toggle(isOn: settingsBinding.showFavoriteOnly) {
                Text("只显示收藏")
            }
        }
    }

    var actionSection: some View {
        Section {
            Button(action: {
                print("清空缓存")
            }) {
                Text("清空缓存").foregroundColor(.red)
            }
        }
    }
    
    var body: some View {
        Form {
            accountSection
            optionSection
            actionSection
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}

