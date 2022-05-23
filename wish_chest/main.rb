require "rexml/document" # подключаем парсер
require "date" # будем использовать операции с данными

puts "В этом сундуке хранятся ваши желания."
puts "Чего бы вы хотели?"
desire_text = STDIN.gets.chomp


# Спросим у пользователя, когда он потратил деньги
puts "До какого числа вы хотите осуществить это желание?
(укажите дату в формате ДД.ММ.ГГГГ)(пустое поле - сегодня)"
date_input = STDIN.gets.chomp

# Для того, чтобы записать дату в удобном формате, воспользуемся методом parse класса Time
desire_date = nil

# Если пользователь ничего не ввёл, значит он потратил деньги сегодня
if date_input == ''
  desire_date = Date.today
else
  begin 
    desire_date = Date.parse(date_input)
  rescue ArgumentError # если дата введена неправильно, перехватываем исключение и выбираем "сегодня"
    desire_date = Date.today
  end
end

# Сначала получим текущее содержимое файла
# И построим из него XML-структуру в переменной doc
current_path = File.dirname(__FILE__)
file_name = current_path + "/data/chest.xml"

file = File.new(file_name, "r:UTF-8")
doc = nil 

begin
  doc = REXML::Document.new(file)
rescue REXML::ParseException => e # если парсер ошибся при чтении файла, придется закрыть прогу :(
  puts "XML файл похоже битый :("
  abort e.message
end

file.close

# Добавим трату в нашу XML-структуру в переменной doc

# Для этого найдём элемент desires (корневой)
desires = doc.elements.find('desires').first

# И добавим элемент командой add_element
 # Все аттрибуты пропишем с помощью параметра, передаваемого в виде АМ
desire = desires.add_element 'desire', {
    'category' => "desire",
    'date' => desire_date.strftime('%Y.%m.%d') # or Date#to_s
}
# А содержимое элемента меняется вызовом метода text
desire.text = desire_text

# Осталось только записать новую XML-структуру в файл методов write
# В качестве параметра методу передаётся указатель на файл
# Красиво отформатируем текст в файлике с отступами в два пробела
file = File.new(file_name, "w:UTF-8")
doc.write(file, 2)
file.close

puts "Информация успешно сохранена"

# Открываем файл и создаём из его содержимого REXML-объект
file = File.new(file_name, 'r:UTF-8')
doc = REXML::Document.new(file)
file.close

# Теперь мы можем достать любое поле нашей визитки с помощью методов объекта doc
# Например, doc.root.elements["first_name"].text
# Давайте запишем все поля в ассоциативный массив



# Обратите внимание, что ключами в нашем массиве будут не метки (как обычно), а строки

chest = Hash.new  
doc.elements.each('desires/desire') do |item|
    date = item.attributes['date']
    category = item.attributes['category']
    chest['date'] = date
    chest['category'] = category
end

['desire'].each do |field|
      chest[field] = doc.root.elements[field].text
end

puts "#{chest['desire']}, #{chest['date']}"
puts chest