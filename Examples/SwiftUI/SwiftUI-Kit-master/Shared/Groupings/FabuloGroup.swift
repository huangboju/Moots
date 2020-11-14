//
//  FabuloGroup.swift
//  SwiftUI Kit iOS
//
//  Created by jourhuang on 2020/11/14.
//

import SwiftUI

struct Repository {
    var id = UUID()
    var url: String
    var name: String
    var isSelected = true
}

class Repositories: ObservableObject {
    @Published var repositories = [
        Repository(url: "git@git.code.oa.com:TencentVideoShared/QADSplashSDK.git", name: "QADSplashSDK"),
        Repository(url: "git@git.code.oa.com:TencentVideoShared/OCCategories.git", name: "OCCategories"),
        Repository(url: "git@git.code.oa.com:TencentVideoShared/VBBaseKit.git", name: "VBBaseKit"),
        Repository(url: "http://git.code.oa.com/TencentVideoShared/TencentVideoJCE.git", name: "TencentVideoJCE"),
        Repository(url: "git@git.code.oa.com:TencentVideoShared/QLJCEData.git", name: "QLJCEData"),
        Repository(url: "git@git.code.oa.com:TencentVideoiPhone/TencentVideoiPhone.git", name: "TencentVideoiPhone"),
        Repository(url: "git@git.code.oa.com:TencentVideoShared/VBBaseCore.git", name: "VBBaseCore"),
        Repository(url: "git@git.code.oa.com:TencentVideoProto/TencentVideoProto.git", name: "TencentVideoProto"),
        Repository(url: "git@git.code.oa.com:TencentVideoShared/VBPBData.git", name: "VBPBData"),
        Repository(url: "git@git.code.oa.com:TencentVideoShared/VBQADCommonKit.git", name: "VBQADCommonKit"),
    ]
}

struct FabuloGroup: View {

    @ObservedObject var viewModel = Repositories()

    var body: some View {
        Group {
            ForEach(viewModel.repositories.indices, id: \.self) { index in
                RepositoryRow(repository: $viewModel.repositories[index])
                    .onTapGesture {
                        print(viewModel.repositories[index].isSelected)
                    }
            }
        }
    }
}

struct RepositoryRow: View {
    @Binding var repository: Repository
    var body: some View {
        HStack(spacing: 12) {
            Text(repository.name).font(.title)
            Toggle("", isOn: $repository.isSelected)
            Spacer()
        }
    }
}

struct FabuloGroup_Previews: PreviewProvider {
    static var previews: some View {
        FabuloGroup()
            .previewLayout(.sizeThatFits)
    }
}
