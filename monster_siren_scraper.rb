require 'net/http'
require 'bundler/setup'
Bundler.require
require 'taglib'

class MonsterSirenScraper
  CACHE_DIR = Pathname.new('cache/')
  SAVE_DIR = Pathname.new('download/')
  FETCH_INTERVAL_TIME = 5 # seconds

  def scrape
    setup

    albums = Api.new.albums
    total_albums_count = albums.size

    albums.each.with_index(1) do |album, i|
      puts "#{i}/#{total_albums_count}\t#{album[:name]}"
      Album.new(album[:cid]).save
    end
  end

  private

  def setup
    Dir.mkdir(SAVE_DIR) unless Dir.exist?(SAVE_DIR)
    Dir.mkdir(CACHE_DIR) unless Dir.exist?(CACHE_DIR)
  end
end

require_relative './monster_siren_scraper/fetcher.rb'
require_relative './monster_siren_scraper/api.rb'
require_relative './monster_siren_scraper/song.rb'
require_relative './monster_siren_scraper/album.rb'
