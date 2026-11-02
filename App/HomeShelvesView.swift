// HomeShelvesView.swift
// Console-inspired home built entirely from the authenticated cloud catalog.
// Game launching still goes through LibraryView and the native StreamView.

import SwiftUI
import StratixCore
import StratixModels

struct GameShelf: Identifiable, Equatable {
    let id: String
    let title: String
    let items: [CloudLibraryItem]
}

struct HomeShelvesView: View {
    let shelves: [GameShelf]
    let allItems: [CloudLibraryItem]
    let tileWidth: CGFloat
    let columns: [GridItem]
    let onSelect: (CloudLibraryItem) -> Void
    let onShowAll: (GameShelf) -> Void

    private var featured: CloudLibraryItem? {
        shelves.first(where: { $0.id == "mru" })?.items.first
            ?? shelves.first?.items.first
            ?? allItems.first
    }

    private var allGamesShelf: GameShelf {
        GameShelf(id: "all", title: "All cloud games", items: allItems)
    }

    var body: some View {
        LazyVStack(alignment: .leading, spacing: 26) {
            if let featured {
                ConsoleFeaturedHero(
                    item: featured,
                    isRecent: shelves.contains(where: { $0.id == "mru" }),
                    onPlay: { onSelect(featured) }
                )
                .padding(.horizontal, 16)
            }

            quickLinks.padding(.horizontal, 16)

            ForEach(shelves) { shelf in
                ShelfRow(shelf: shelf, tileWidth: tileWidth, onSelect: onSelect, onShowAll: onShowAll)
            }

            VStack(alignment: .leading, spacing: 12) {
                ShelfHeader(title: "All cloud games", count: allItems.count) {
                    onShowAll(allGamesShelf)
                }
                .padding(.horizontal, 16)

                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(allItems.prefix(18)) { item in
                        GameTile(item: item) { onSelect(item) }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(.top, 16)
        .padding(.bottom, 32)
    }

    private var quickLinks: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ConsoleQuickLink(title: "My games", subtitle: "Cloud library", icon: "square.grid.2x2.fill") {
                    onShowAll(allGamesShelf)
                }
                if let recent = shelves.first(where: { $0.id == "mru" }) {
                    ConsoleQuickLink(title: "Jump back in", subtitle: "Recently played", icon: "arrow.uturn.backward") {
                        onShowAll(recent)
                    }
                }
                if let discovery = shelves.first(where: { $0.id != "mru" }) {
                    ConsoleQuickLink(title: "Game Pass", subtitle: "Discover games", icon: "sparkles") {
                        onShowAll(discovery)
                    }
                }
            }
            .padding(.vertical, 4)
        }
        .scrollClipDisabled()
    }
}

private struct ConsoleFeaturedHero: View {
    let item: CloudLibraryItem
    let isRecent: Bool
    let onPlay: () -> Void

    var body: some View {
        Button(action: onPlay) {
            ZStack(alignment: .bottomLeading) {
                Color(red: 0.07, green: 0.12, blue: 0.08)
                RemoteImage(urls: [item.heroImageURL, item.artURL, item.posterImageURL], kind: .hero, maxPixelSize: 1600) {
                    Color(red: 0.09, green: 0.16, blue: 0.10)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 265)
                .clipped()

                LinearGradient(
                    colors: [.clear, .black.opacity(0.40), .black.opacity(0.90)],
                    startPoint: .top,
                    endPoint: .bottom
                )

                VStack(alignment: .leading, spacing: 9) {
                    Label(isRecent ? "JUMP BACK IN" : "FEATURED ON CLOUD", systemImage: "gamecontroller.fill")
                        .font(.system(size: 11, weight: .heavy, design: .rounded))
                        .tracking(1.8)
                        .foregroundStyle(Color(red: 0.60, green: 0.94, blue: 0.47))

                    Text(item.name)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.white)
                        .lineLimit(2)

                    Label("Play with Cloud Gaming", systemImage: "play.fill")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 17)
                        .padding(.vertical, 10)
                        .background(Color(red: 0.12, green: 0.54, blue: 0.17), in: RoundedRectangle(cornerRadius: 7))
                }
                .padding(20)
            }
            .frame(height: 265)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(.white.opacity(0.12), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Play \(item.name) with cloud gaming")
    }
}

private struct ConsoleQuickLink: View {
    let title: String
    let subtitle: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Color(red: 0.50, green: 0.94, blue: 0.44))
                    .frame(width: 30)
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.white)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                }
                Spacer(minLength: 0)
            }
            .frame(width: 158, height: 52)
            .padding(.horizontal, 13)
            .background(Color.white.opacity(0.075), in: RoundedRectangle(cornerRadius: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.white.opacity(0.10), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(title), \(subtitle)")
    }
}

private struct ShelfRow: View {
    let shelf: GameShelf
    let tileWidth: CGFloat
    let onSelect: (CloudLibraryItem) -> Void
    let onShowAll: (GameShelf) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ShelfHeader(title: shelf.title, count: shelf.items.count) {
                onShowAll(shelf)
            }
            .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 14) {
                    ForEach(shelf.items) { item in
                        GameTile(item: item, width: tileWidth) { onSelect(item) }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            .scrollClipDisabled()
        }
    }
}

private struct ShelfHeader: View {
    let title: String
    let count: Int
    let showAll: (() -> Void)?

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color(red: 0.19, green: 0.70, blue: 0.23))
                .frame(width: 4, height: 18)
            Text(title)
                .font(.title3.weight(.bold))
                .foregroundStyle(.white)
            Text("\(count)")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
            Spacer()
            if let showAll {
                Button("Show all", action: showAll)
                    .buttonStyle(.plain)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Color(red: 0.54, green: 0.90, blue: 0.46))
            }
        }
    }
}
