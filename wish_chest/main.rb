# Как всегда подключаем парсер и библиотеку для работы с датами
require 'rexml/document'
require 'date'

# Наш сундук будет по адресу data/chest.xml, запишем путь к нему в переменную
# file_path
file_path = File.dirname(__FILE__) + '/data/chest.xml'

# Если файл с сундуком не найден, его надо создать
unless File.exist?(file_path)
  # Тут мы воспользуемся ещё одним удобным интерфейсом класса File — методом
  # open, которому можно передать блок с инструкциями для работы с объектом
  # класса File. Тогда нам не придется закрывать файл вручную, т.к. сразу после
  # выполнения действий в блоке файл будет закрыт.
  File.open(file_path, 'w:UTF-8') do |file|
    # Добавим в документ служебную строку с версией и кодировкой и пустой тег
    file.puts "<?xml version='1.0' encoding='UTF-8'?>"
    file.puts '<wishes></wishes>'
  end
end

# Теперь мы можем быть уверены, что файл на диске внужном месте точно есть. Если
# он был — хорошо, если нет — мы его создали, без данных но с нужной нам
# структурой. В любом случае считываем из него содержимое и строим из него
# структуру XML с помощью нашего любимого парсера REXML.
xml_file = File.read(file_path, encoding: 'UTF-8')
doc = REXML::Document.new(xml_file)

# Спросим у пользователя желание и запишем его в переменную wist_text
puts 'В этом сундуке храняться ваши желания.'
puts
puts 'Чего бы вы хотели?'
wish_text = STDIN.gets.chomp

# Спросим у пользователя дату, до которой он хочет, чтобы его желание
# исполнилось и запишем её в переменную wish_date, предварительно сделав из
# строки с вводом пользователя объект класса Date.
puts
puts 'До какого числа вы хотите осуществить это желание?'
puts 'Укажите дату в формате ДД.ММ.ГГГГ'
wish_date_input = STDIN.gets.chomp
wish_date = nil

# Если пользователь ничего не ввёл, значит он потратил деньги сегодня
if wish_date_input == ''
    wish_date = Date.today
else
  begin 
    wish_date = Date.parse(wish_date_input)
  rescue ArgumentError # если дата введена неправильно, перехватываем исключение и выбираем "сегодня"
    wish_date = Date.today
  end
end

# Добавим к корневому элементу нашей XML-структуры ещё один тег wish и добавим
# к нему аттрибут date  со строкой даты в нужном формате
wish = doc.root.add_element('wish', {'date' => wish_date.strftime('%d.%m.%Y')})

# Добавим текст желания к тексту элемента с пом. метода add_text
wish.add_text(wish_text)

# Снова откроем файл, но уже на запись и запишем туда все данные в нужном
# формате
File.open(file_path, 'w:UTF-8') do |file|
  doc.write(file, 2)
end

# Попрощаемся с пользователем
puts
puts 'Ваше желание в сундуке'


# require "rexml/document" # подключаем парсер
# require "date" # будем использовать операции с данными

# puts "В этом сундуке хранятся ваши желания."
# puts "Чего бы вы хотели?"
# desire_text = STDIN.gets.chomp


# # Спросим у пользователя, когда он потратил деньги
# puts "До какого числа вы хотите осуществить это желание?
# (укажите дату в формате ДД.ММ.ГГГГ)(пустое поле - сегодня)"
# date_input = STDIN.gets.chomp

# # Для того, чтобы записать дату в удобном формате, воспользуемся методом parse класса Time
# desire_date = nil

# # Если пользователь ничего не ввёл, значит он потратил деньги сегодня
# if date_input == ''
#   desire_date = Date.today
# else
#   begin 
#     desire_date = Date.parse(date_input)
#   rescue ArgumentError # если дата введена неправильно, перехватываем исключение и выбираем "сегодня"
#     desire_date = Date.today
#   end
# end

# # Сначала получим текущее содержимое файла
# # И построим из него XML-структуру в переменной doc
# current_path = File.dirname(__FILE__)
# file_name = current_path + "/data/chest.xml"

# file = File.new(file_name, "r:UTF-8")
# doc = nil 

# begin
#   doc = REXML::Document.new(file)
# rescue REXML::ParseException => e # если парсер ошибся при чтении файла, придется закрыть прогу :(
#   puts "XML файл похоже битый :("
#   abort e.message
# end

# file.close

# # Добавим трату в нашу XML-структуру в переменной doc

# # Для этого найдём элемент desires (корневой)
# desires = doc.elements.find('desires').first

# # И добавим элемент командой add_element
#  # Все аттрибуты пропишем с помощью параметра, передаваемого в виде АМ
# desire = desires.add_element 'desire', {
#     'category' => "desire",
#     'date' => desire_date.strftime('%Y.%m.%d') # or Date#to_s
# }
# # А содержимое элемента меняется вызовом метода text
# desire.text = desire_text

# # Осталось только записать новую XML-структуру в файл методов write
# # В качестве параметра методу передаётся указатель на файл
# # Красиво отформатируем текст в файлике с отступами в два пробела
# file = File.new(file_name, "w:UTF-8")
# doc.write(file, 2)
# file.close

# puts "Информация успешно сохранена"

# # Открываем файл и создаём из его содержимого REXML-объект
# file = File.new(file_name, 'r:UTF-8')
# doc = REXML::Document.new(file)
# file.close

# # Теперь мы можем достать любое поле нашей визитки с помощью методов объекта doc
# # Например, doc.root.elements["first_name"].text
# # Давайте запишем все поля в ассоциативный массив



# # Обратите внимание, что ключами в нашем массиве будут не метки (как обычно), а строки

# chest = Hash.new  
# doc.elements.each('desires/desire') do |item|
#     date = item.attributes['date']
#     category = item.attributes['category']
#     chest['date'] = date
#     chest['category'] = category
# end

# ['desire'].each do |field|
#       chest[field] = doc.root.elements[field].text
# end

# puts "#{chest['desire']}, #{chest['date']}"
# puts chest