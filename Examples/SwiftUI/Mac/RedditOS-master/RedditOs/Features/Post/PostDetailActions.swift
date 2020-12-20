//
//  PostDetailActions.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 10/07/2020.
//

import SwiftUI
import Backend

struct PostDetailActionsView: View {
    @ObservedObject var viewModel: PostViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            HStack(spacing: 6) {
                Image(systemName: "bubble.middle.bottom.fill")
                    .imageScale(.small)
                Text("\(viewModel.post.numComments) comments")
            }
            
            HStack(spacing: 6) {
                Image(systemName: "square.and.arrow.up")
                    .imageScale(.small)
                Text("Share")
            }
            
            HStack(spacing: 6) {
                Button(action: {
                    viewModel.toggleSave()
                }) {
                    Image(systemName: viewModel.post.saved ? "bookmark.fill": "bookmark")
                        .imageScale(.small)
                    Text("Save")
                }.buttonStyle(BorderlessButtonStyle())
            }
            
            HStack(spacing: 6) {
                Image(systemName: "flag")
                    .imageScale(.small)
                Text("Report")
            }
            
        }
    }
}

struct PostDetailActions_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailActionsView(viewModel: PostViewModel(post: static_listing))
    }
}
