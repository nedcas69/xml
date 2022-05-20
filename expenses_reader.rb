require "rexml/document" #подключаем парсер
require "date" # будем использовать операции с датами

current_path = File.dirname(__FILE__)
file_name = current_path + "/my_expenses.xml"

abort "Извиняемся, хозяин, файлик my_expenses.xml не найден." unless File.exist?(file_name)
    
file = File.new(file_name)

doc = REXML::Document.new(file)

amount_by_day = Hash.new

doc.elements.each("expenses/expense") do |item|
    loss_sum = item.attributes["amount"].to_i
    loss_date = Date.parse(item.attributes["date"])

    amount_by_day[loss_date] ||= 0
    amount_by_day[loss_date] += loss_sum 
end
file.close

sum_by_month = Hash.new
current_month = amount_by_day.keys.sort[0].strftime("%B %Y")

amount_by_day.keys.sort.each do |key|
    sum_by_month[key.strftime("%B %Y")] ||= 0
    sum_by_month[key.strftime("%B %Y")] += amount_by_day[key]
end

# выводим заголовок для первого месяца
puts "------[ #{current_month}, всего потрачено: #{sum_by_month[current_month]} р. ]--------"

# цикл по всем дням
amount_by_day.keys.sort.each do |key|

  # если текущий день принадлежит уже другому месяцу...
  if key.strftime("%B %Y") != current_month

    # то значит мы перешли на новый месяц и теперь он станет текущим
    current_month = key.strftime("%B %Y")

    # выводим заголовок для нового текущего месяца
    puts "------[ #{current_month}, всего потрачено: #{sum_by_month[current_month]} р. ]--------"
  end

  # выводим расходы за конкретный день
  puts "\t#{key.day}: #{amount_by_day[key]} р."
end


# require "rexml/document" # подключаем парсер
# require "date" # будем использовать операции с датами

# current_path = File.dirname(__FILE__)
# file_name = current_path + "/my_expenses.xml"

# # UNLESS в руби - противоположный по смыслу оператору IF
# # прерываем выполнение программы досрочно, если конечно файл не существует.
# abort "Извиняемся, хозяин, файлик my_expenses.xml не найден." unless File.exist?(file_name)

# file = File.new(file_name) # открыли файл

# doc = REXML::Document.new(file) # создаем новый документ REXML, построенный из открытого XML файла

# amount_by_day = Hash.new # пустой асс. массив, куда сложим все траты по дням

# # выбираем из элементов документа все тэги <expense> внутри <expenses>
# # и в цикле проходимся по ним
# doc.elements.each("expenses/expense") do |item|

#   # (Обратите внимание это локальная переменная объявленая в теле цикла, для каждой итерации
#   # создается новая такая. За пределами цикла она не видна.)
#   loss_sum = item.attributes["amount"].to_i # сколько потратили

#   loss_date = Date.parse(item.attributes["date"]) # когда. Date.parse(...) создает из строки объект Date

#   # иницилизируем нулем значение хэша, если этой даты еще не было
#   amount_by_day[loss_date] ||= 0

#   # в руби "a ||= b" эквивалентно "if a == nil  a = b"

#   # добавили трату за этот день
#   amount_by_day[loss_date] += loss_sum
# end

# file.close

# # сделаем хэш, в который соберем сумму расходов за каждый месяц
# sum_by_month = Hash.new

# # в цикле по всем датам хэша amount_by_day накопим в хэше sum_by_month
# # значения потраченных сумм каждого дня
# amount_by_day.keys.sort.each do |key|
#   # key.strftime("%B %Y") вернет одинаковую строку для всех дней одного месяца
#   # поэтому можем использовать ее как уникальный для каждого месяца ключ
#   sum_by_month[key.strftime("%B %Y")] ||= 0

#   sum_by_month[key.strftime("%B %Y")] += amount_by_day[key] # приплюсовываем к тому что было сумму следующего дня
# end

# # пришло время выводить статистику на экран
# # в цикле пройдемся по всем месяцам и начнем с первого
# current_month = amount_by_day.keys.sort[0].strftime("%B %Y")

# # выводим заголовок для первого месяца
# puts "------[ #{current_month}, всего потрачено: #{sum_by_month[current_month]} р. ]--------"

# # цикл по всем дням
# amount_by_day.keys.sort.each do |key|

#   # если текущий день принадлежит уже другому месяцу...
#   if key.strftime("%B %Y") != current_month

#     # то значит мы перешли на новый месяц и теперь он станет текущим
#     current_month = key.strftime("%B %Y")

#     # выводим заголовок для нового текущего месяца
#     puts "------[ #{current_month}, всего потрачено: #{sum_by_month[current_month]} р. ]--------"
#   end

#   # выводим расходы за конкретный день
#   puts "\t#{key.day}: #{amount_by_day[key]} р."
# end