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
      @retry_count = 0

      res = Net::HTTP.get(@uri)
      write(res)

      sleep FETCH_INTERVAL_TIME

      res
    rescue Net::OpenTimeout, Net::ReadTimeout, Errno::ECONNRESET => e
      if @retry_count >= 10
        raise e
      else
        @retry_count += 1
        pp "Retry #{@retry_count} times..."
        sleep FETCH_INTERVAL_TIME
        retry
      end
    end

    def copy(to_path)
      get unless exist?
      FileUtils.copy(@cache_path, to_path)
    end
  end
end
