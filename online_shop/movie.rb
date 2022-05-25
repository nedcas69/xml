class Movie < Product
    def update(options)
      @title = options[:title]
      @director_name = options[:director_name]
      @year = options[:year]
    end
  
    # Для фильма метод info возвращает строку с названием фильма, режиссёром и годом выхода
    def info
      "Фильм #{@title}, реж. #{@director_name} (#{@year})"
    end

    def read_from_console
      puts 'Укажите название фильма'
      @title = STDIN.gets.chomp
      puts 'Укажите год выпуска'
      @year = STDIN.gets.chomp
      puts 'Укажите режиссора фильма'
      @director_name = STDIN.gets.chomp
    end
   
    def to_xml
      product = super
      product.add_element('movie', {
        'title' => @title,
        'year' => @year,
        'director_name' => @director_name

      })
      product
    end
  end