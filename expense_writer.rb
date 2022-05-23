require "rexml/document" # подключаем парсер
require "date" # будем использовать операции с данными

# Спросим у пользователя, на что он потратил деньги и сколько
puts "На что потратили деньги?"
expense_text = STDIN.gets.chomp

puts "Сколько потратили?"
expense_amount = STDIN.gets.chomp.to_i

# Спросим у пользователя, когда он потратил деньги
puts "Укажите дату траты в формате ДД.ММ.ГГГГ, например 12.05.2003 (пустое поле - сегодня)"
date_input = STDIN.gets.chomp

# Для того, чтобы записать дату в удобном формате, воспользуемся методом parse класса Time
expense_date = nil

# Если пользователь ничего не ввёл, значит он потратил деньги сегодня
if date_input == ''
  expense_date = Date.today
else
  begin 
    expense_date = Date.parse(date_input)
  rescue ArgumentError # если дата введена неправильно, перехватываем исключение и выбираем "сегодня"
    expense_date = Date.today
  end
end

# Наконец, спросим категорию траты
puts "В какую категорию занести трату"
expense_category = STDIN.gets.chomp

# Сначала получим текущее содержимое файла
# И построим из него XML-структуру в переменной doc
current_path = File.dirname(__FILE__)
file_name = current_path + "/my_expenses.xml"

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

# Для этого найдём элемент expenses (корневой)
expenses = doc.elements.find('expenses').first

# И добавим элемент командой add_element
 # Все аттрибуты пропишем с помощью параметра, передаваемого в виде АМ
expense = expenses.add_element 'expense', {
    'amount' => expense_amount,
    'category' => expense_category,
    'date' => expense_date.strftime('%Y.%m.%d') # or Date#to_s
}
# А содержимое элемента меняется вызовом метода text
expense.text = expense_text

# Осталось только записать новую XML-структуру в файл методов write
# В качестве параметра методу передаётся указатель на файл
# Красиво отформатируем текст в файлике с отступами в два пробела
file = File.new(file_name, "w:UTF-8")
doc.write(file, 2)
file.close

puts "Информация успешно сохранена"