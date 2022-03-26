class MonsterSirenScraper
  class Song
    attr_reader :id, :raw

    def initialize(id)
      @id = id
      @raw = Api.new.song(id)
    end

    def name
      raw[:name]
    end

    def file_name
      track_prefix = track_number.to_s.rjust(album.total_tracks.to_s.size, '0')
      ext = 'mp3'
      "#{track_prefix}. #{name}.#{ext}"
    end

    def artists
      raw[:artists]
    end

    def path
      album.path + file_name
    end

    def album
      @album ||= Album.new(raw[:albumCid])
    end

    def track_number
      album.songs.map(&:id).find_index(id) + 1
    end

    def lyric
      @lyric ||= raw[:lyricUrl] && Fetcher.new(URI.parse(raw[:lyricUrl])).fetch
    end

    def save
      Fetcher.new(URI.parse(raw[:sourceUrl])).copy(path)
      add_tag_info
    end

    def add_tag_info
      TagLib::MPEG::File.open(path.to_s) do |file|
        tag = file.id3v2_tag

        tag.title = name
        tag.artist = artists.join("\0")
        tag.album = album.name
        tag.track = track_number
        tag.add_frame(
          TagLib::ID3v2::TextIdentificationFrame.new('TPE2', TagLib::String::UTF8)
          .tap{|tpe2| tpe2.text = album.artist}
        )

        tag.add_frame(TagLib::ID3v2::UnsynchronizedLyricsFrame.new.tap{|uslt|
          uslt.text = lyric
        }) if lyric

        tag.add_frame(TagLib::ID3v2::AttachedPictureFrame.new.tap{|apic|
          # apic.mime_type = "image/jpeg"
          apic.description = "Cover"
          apic.type = TagLib::ID3v2::AttachedPictureFrame::FrontCover
          apic.picture = album.cover
        })

        tag.add_frame(TagLib::ID3v2::AttachedPictureFrame.new.tap{|apic|
          # apic.mime_type = "image/png"
          apic.description = "Cover De"
          apic.type = TagLib::ID3v2::AttachedPictureFrame::LeafletPage
          apic.picture = album.cover_de
        })

        file.save
      end
    end
  end
end
