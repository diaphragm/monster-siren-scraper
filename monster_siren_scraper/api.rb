class MonsterSirenScraper
  class Api
    def initialize
      @endpoint = URI.parse('https://monster-siren.hypergryph.com/api/')
    end

    def songs
      fetch('songs')
    end

    def song(song_id)
      fetch("song/#{song_id}")
    end

    def albums
      fetch('albums')
    end

    def album_data(album_id)
      fetch("album/#{album_id}/data")
    end

    def album_detail(album_id)
      fetch("album/#{album_id}/detail")
    end

    private

    def fetch(api_path)
      res_json = Fetcher.new(@endpoint + api_path).fetch
      res_data = JSON.parse(res_json, symbolize_names: true)

      raise res_data[:msg] unless res_data[:code]== 0

      res_data[:data]
    end
  end
end
