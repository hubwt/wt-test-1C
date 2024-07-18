Процедура ПровестиПродажиНаСервере()

Запрос = Новый Запрос;
Запрос.Текст =
	"ВЫБРАТЬ
	|	ПродажаЗапчастей.Ссылка КАК Ссылка,
	|	ПродажаЗапчастей.Дата КАК Дата
	|ИЗ
	|	Документ.ПродажаЗапчастей КАК ПродажаЗапчастей
	|ГДЕ
	|	ПродажаЗапчастей.Дата МЕЖДУ НачалоПериода(&ПериодНачало, День) И КонецПериода(&ПериодКонец, День)";

Запрос.УстановитьПараметр("ПериодНачало", '20160917');
Запрос.УстановитьПараметр("ПериодКонец",  '20230101');

РезультатЗапроса = Запрос.Выполнить();
 
ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
Кол =ВыборкаДетальныеЗаписи.Количество();  
КолОшибок=0;
КолПроведен = 0; 
СсылкиНепроеденные = "";
Массив  = новый Массив; 
Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	Массив.Добавить(ВыборкаДетальныеЗаписи.Ссылка); 
КонецЦикла;
Для Каждого Строка ИЗ Массив Цикл 
	ДокОбъект = Строка.ПолучитьОбъект();
		Для Каждого Строка ИЗ ДокОбъект.Таблица Цикл 
			Строка.СтатусТовара = Истина;
		КонецЦикла; 
	Попытка
	ДокОбъект.Записать(РежимЗаписиДокумента.Проведение);
	КолПроведен = КолПроведен +1;
	Исключение
	КолОшибок = КолОшибок +1;
	КонецПопытки;
КонецЦикла;	
	
Сообщить("Колличество документов = " +Кол +Символы.ПС + "Порведены Успешно = " + КолПроведен +Символы.ПС + "Колличество не проведенных = " + КолОшибок); 

КонецПроцедуры

Процедура ПроестиПродажи() Экспорт
	ПровестиПродажиНаСервере(); 
КонецПроцедуры

