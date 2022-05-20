require "rexml/document" # подключаем парсер


current_path = File.dirname(__FILE__)
file_name = current_path + "/my_card.xml"

abort "Извиняемся, хозяин, файлик my_card.xml не найден." unless File.exist?(file_name)
    
file = File.new(file_name)

doc = REXML::Document.new(file)

card = []

doc.elements.each("card") do |item|
    names = item.attributes["name"]
    phone = item.attributes["phone"]
    mail = item.attributes["mail"]
    about = item.attributes["about"]
    card << names
    card << phone
    card << mail
    card << about

end

file.close

puts card


# require 'rexml/document'

# current_path = File.dirname(__FILE__)
# file_name = current_path + '/business_card.xml'

# abort 'Не удалось найти визитку' unless File.exist?(file_name)

# # Открываем файл и создаём из его содержимого REXML-объект
# file = File.new(file_name, 'r:UTF-8')
# doc = REXML::Document.new(file)
# file.close

# # Теперь мы можем достать любое поле нашей визитки с помощью методов объекта doc
# # Например, doc.root.elements["first_name"].text
# # Давайте запишем все поля в ассоциативный массив

# card = {}

# # Обратите внимание, что ключами в нашем массиве будут не метки (как обычно), а строки
# ['first_name', 'second_name', 'last_name', 'phone', 'email', 'skills'].each do |field|
#   card[field] = doc.root.elements[field].text
# end

# # Наконец, выведем визитку в консоль
# puts "#{card['first_name']} #{card['second_name'][0]}. #{card['last_name']}"
# puts "#{card['phone']}, #{card['email']}"
# puts "#{card['skills']}"

