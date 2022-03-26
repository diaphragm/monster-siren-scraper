class MonsterSirenScraper
  class Album
    attr_reader :id, :raw

    def initialize(id)
      @id = id
      @raw = Api.new.album_detail(id)
    end

    def name
      @raw[:name]
    end

    def artist
      @raw[:belong]
    end

    def path
      SAVE_DIR + name
    end

    def cover
      @cover ||= Fetcher.new(URI.parse(@raw[:coverUrl])).fetch
    end

    def cover_de
      @cover_de ||= Fetcher.new(URI.parse(@raw[:coverDeUrl])).fetch
    end

    def songs
      @songs ||= @raw[:songs].map{|song_info| Song.new(song_info[:cid]) }
    end

    def total_tracks
      songs.size
    end

    def save
      setup
      songs.each(&:save)
    end

    private

    def setup
      Dir.mkdir(path) unless Dir.exist?(path)
    end
  end
end
