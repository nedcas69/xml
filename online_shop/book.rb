class Book < Product
    def update(options)
      @title = options[:title]
      @author_name = options[:author_name]
    end
  
    # Для книги метод info возвращает название произведения и автора
    def info
      "Книга #{@title}, автор: #{@author_name}"
    end
   
    def read_from_console
      puts 'Укажите название книги'
      @title = STDIN.gets.chomp
  
      puts 'Укажите автора произведения'
      @author_name = STDIN.gets.chomp
    end
   
    def to_xml
      product = super
      product.add_element('book', {
        'title' => @title,
        'author_name' => @author_name

      })
      product
    end
  end