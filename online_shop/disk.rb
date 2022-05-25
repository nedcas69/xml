class Disk < Product
    def update(options)
      @album_name = options[:album_name]
      @artist_name = options[:artist_name]
      @genre = options[:genre]
    end
  
    # Для музыкального диска метод info возвращает исполнителя, название и жанр
    def info
      "Диск #{@artist_name} - #{@album_name} (#{@genre})"
    end
    def read_from_console
      puts 'Укажите имя исполнителя'
      @artist_name = STDIN.gets.chomp
  
      puts 'Укажите название альбома'
      @album_name = STDIN.gets.chomp
  
      puts 'Укажите музыкальный жанр'
      @genre = STDIN.gets.chomp
    end
   
    def to_xml
      product = super
      product.add_element('disk', {
        'artist_name' => @artist_name,
        'album_name' => @album_name,
        'genre' => @genre

      })
      product
    end
  end