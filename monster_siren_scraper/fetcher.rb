class MonsterSirenScraper
  class Fetcher
    def initialize(uri)
      @uri = uri
      @digest = Digest::MD5.hexdigest(uri.to_s)
      @cache_path = CACHE_DIR + @digest
    end

    def fetch
      exist? ? read : get
    end

    def exist?
      File.exist?(@cache_path)
    end

    def read
      File.binread(@cache_path)
    end

    def write(data)
      File.binwrite(@cache_path, data)
    end

    def get
      res = Net::HTTP.get(@uri)
      write(res)
      res
    end

    def copy(to_path)
      get unless exist?
      FileUtils.copy(@cache_path, to_path)
    end
  end
end
