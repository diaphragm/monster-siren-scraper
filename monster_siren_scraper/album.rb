class MonsterSirenScraper
  class Album
    attr_reader :id, :raw

    def initialize(id)
      @id = id
      @raw = Api.new.album_detail(id)
    end

    def name
      raw[:name]
    end

    def artist
      raw[:belong]
    end

    def path
      SAVE_DIR + name
    end

    def cover
      @cover ||= Fetcher.new(URI.parse(raw[:coverUrl])).fetch
    end

    def cover_de
      @cover_de ||= Fetcher.new(URI.parse(raw[:coverDeUrl])).fetch
    end

    def songs
      @songs ||= raw[:songs].map{|song_info| Song.new(song_info[:cid]) }
    end

    def total_tracks
      songs.size
    end

    def save
      setup
      save_covers
      songs.each(&:save)
    end

    private

    def setup
      Dir.mkdir(path) unless Dir.exist?(path)
    end

    def save_covers
      cover_url = raw[:coverUrl]
      cover_ext = cover_url[/\.(\w+?)$/, 1]
      Fetcher.new(URI.parse(cover_url)).copy(path + "cover.#{cover_ext}")

      cover_de_url = raw[:coverDeUrl]
      cover_de_ext = cover_de_url[/\.(\w+?)$/, 1]
      Fetcher.new(URI.parse(cover_de_url)).copy(path + "leaflet.#{cover_de_ext}")
    end
  end
end
