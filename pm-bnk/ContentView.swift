//
//  ContentView.swift
//  pm-bnk
//
//  Created by Sara Lieto on 7/7/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showText = false
    @State private var prompt: String?
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [DesignPackage.Colors.topGradient, DesignPackage.Colors.bottomGradient]), startPoint: .top, endPoint: .bottom)
                VStack(alignment: .center, spacing: 24.0, content: {
                    NavigationLink("Favorites :)") { FavoritePromptList() }.foregroundColor(.black)
                    if !showText {
                        Text("Press the book below to generate a random poetry prompt!")
                            .foregroundColor(DesignPackage.Colors.primary)
                            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    }
                    Button {
                        if showText == false { showText = true }
                        let interactor = PromptInteractor(dataSource: PromptDataSourceImpl(), favDataSource: FavoritesDataSourceImpl())
                        let randomPrompt = interactor.getRandomPrompt(request: PromptRequest(currentPromptId: nil))
                        prompt = randomPrompt?.promptDescription ?? ""
                        
                    } label: {
                        Image(systemName: "book")
                            .imageScale(.large)
                            .foregroundColor(DesignPackage.Colors.bottomGradient)
                    }
                    .padding(EdgeInsets(top: 16, leading: 64, bottom: 16, trailing: 64))
                    .foregroundColor(DesignPackage.Colors.secondary)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(30)
                    
                    if showText {
                        PromptTextView(descriptionText: prompt, isFavorite: true).padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    }
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.clear)
                .padding()
                .animation(.spring(), value: showText)
            }
        }
    }
}

struct PromptTextView: View {
    var descriptionText: String?
   @State var isFavorite: Bool
    
    var body: some View {
        HStack(alignment: .center, spacing: 16.0, content: {
            Button {
                let interactor = PromptInteractor(dataSource: PromptDataSourceImpl(), favDataSource: FavoritesDataSourceImpl())
                if isFavorite {
                    interactor.delete(thing: descriptionText ?? "" )
                } else {
                    interactor.save(thing: descriptionText ?? "")
                }
                isFavorite = !isFavorite
            } label: {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .imageScale(.medium)
                    .foregroundColor(DesignPackage.Colors.bottomGradient)
            }
            Text(descriptionText ?? "").foregroundColor(DesignPackage.Colors.bottomGradient)
        })
        .padding(EdgeInsets(top: 40, leading: 16, bottom: 40, trailing: 32))
        .background(DesignPackage.Colors.primary.opacity(0.5))
        .cornerRadius(16)
//        .overlay(
//               RoundedRectangle(cornerRadius: 16)
//                   .stroke(Color.white.opacity(0.8), lineWidth: 4)
//           )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct FavoritePromptList: View {
    struct FavoritePrompt: Identifiable {
        var id: String
    }
    
    let favs = PromptInteractor(dataSource: PromptDataSourceImpl(), favDataSource: FavoritesDataSourceImpl()).getFavorites()?.compactMap {
        FavoritePrompt(id: $0)
    }
    
    var body: some View {
        List {
            ForEach(favs!) { fav in
                PromptTextView(descriptionText: fav.id, isFavorite: true)
            }
        }.listStyle(.plain)
    }
}
