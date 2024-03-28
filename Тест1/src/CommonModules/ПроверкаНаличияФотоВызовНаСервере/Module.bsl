
Процедура УстановитьПризнакНаличияФотоНоменклатуры() Экспорт

	///+ГомзМА 17.10.2023
	//Установить галочки ЕстьФото в инд номерах
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИндНомер.Цена КАК Цена,
	|	ИндНомер.Код КАК Код,
	|	ИндНомер.АвитоЧастник КАК Конвеер,
	|	ИндНомер.ЦенаПроверена КАК ЦенаПроверена,
	|	ИндНомер.индкод.Владелец.Артикул КАК Артикул,
	|	ИндНомер.индкод КАК индкод,
	|	ИндНомер.индкод.Владелец КАК Товар,
	|	ИндНомер.ЕстьФото КАК ЕстьФото,
	|	ИндНомер.наценка КАК наценка,
	|	ИндНомер.цп КАК цп,
	|	ИндНомер.дн КАК дн,
	|	ИндНомер.п КАК п,
	|	ИндНомер.Стеллаж КАК Стеллаж,
	|	ИндНомер.Комментарий КАК Комментарий,
	|	ИндНомер.Модель КАК Модель,
	|	ИндНомер.ДатаИзмененияКонвеера КАК ДатаИзмененияКонвеера,
	|	ИндНомер.Ответственный КАК Ответственный
	|ИЗ
	|	РегистрСведений.ИндНомер КАК ИндНомер
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РегистрНакопления1.Остатки КАК РегистрНакопления1Остатки
	|		ПО ИндНомер.индкод = РегистрНакопления1Остатки.индкод
	|ГДЕ
	|	НЕ ИндНомер.ЕстьФото
	|	И РегистрНакопления1Остатки.КолвоОстаток > 0";
	
	Запрос.УстановитьПараметр("Индкод", Справочники.ИндКод.НайтиПоНаименованию("00393_S2_7"));
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();

	МассивИндкодов = Новый Массив;
	Пока РезультатЗапроса.Следующий() Цикл
		МассивИндкодов.Добавить(РезультатЗапроса.индкод.Наименование);
	КонецЦикла;
	
	Фотки = ПолучениеФото(МассивИндкодов);
	Если Фотки.indCode.Количество() > 0 Тогда
		Для каждого Индкод Из Фотки.indCode Цикл
			ЗаписьВРегистреСведений 		= РегистрыСведений.ИндНомер.СоздатьМенеджерЗаписи();
			ЗаписьВРегистреСведений.индкод 	= Справочники.ИндКод.НайтиПоНаименованию(Индкод);
			ЗаписьВРегистреСведений.Прочитать();
			Если ЗаписьВРегистреСведений.Выбран() Тогда
				ЗаписьВРегистреСведений.ЕстьФото = Истина;
				ЗаписьВРегистреСведений.Записать();
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	//Убрать галочки ЕстьФото в инд номерах
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИндНомер.Цена КАК Цена,
	|	ИндНомер.Код КАК Код,
	|	ИндНомер.АвитоЧастник КАК Конвеер,
	|	ИндНомер.ЦенаПроверена КАК ЦенаПроверена,
	|	ИндНомер.индкод.Владелец.Артикул КАК Артикул,
	|	ИндНомер.индкод КАК индкод,
	|	ИндНомер.индкод.Владелец КАК Товар,
	|	ИндНомер.ЕстьФото КАК ЕстьФото,
	|	ИндНомер.наценка КАК наценка,
	|	ИндНомер.цп КАК цп,
	|	ИндНомер.дн КАК дн,
	|	ИндНомер.п КАК п,
	|	ИндНомер.Стеллаж КАК Стеллаж,
	|	ИндНомер.Комментарий КАК Комментарий,
	|	ИндНомер.Модель КАК Модель,
	|	ИндНомер.ДатаИзмененияКонвеера КАК ДатаИзмененияКонвеера,
	|	ИндНомер.Ответственный КАК Ответственный
	|ИЗ
	|	РегистрСведений.ИндНомер КАК ИндНомер
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РегистрНакопления1.Остатки КАК РегистрНакопления1Остатки
	|		ПО ИндНомер.индкод = РегистрНакопления1Остатки.индкод
	|ГДЕ
	|	ИндНомер.ЕстьФото
	|	И РегистрНакопления1Остатки.КолвоОстаток > 0";
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();

	МассивИндкодов = Новый Массив;
	Пока РезультатЗапроса.Следующий() Цикл
		МассивИндкодов.Добавить(РезультатЗапроса.индкод.Наименование);
	КонецЦикла;
	
	Фотки = ПолучениеФото(МассивИндкодов);

	Если МассивИндкодов.Количество() > 0 Тогда
		Для каждого Индкод Из МассивИндкодов Цикл
			ФотоИндкода = Фотки.indCode.Найти(Индкод);
			Если ФотоИндкода = Неопределено Тогда
				ЗаписьВРегистреСведений 		= РегистрыСведений.ИндНомер.СоздатьМенеджерЗаписи();
				ЗаписьВРегистреСведений.индкод 	= Справочники.ИндКод.НайтиПоНаименованию(Индкод);
				ЗаписьВРегистреСведений.Прочитать();
				Если ЗаписьВРегистреСведений.Выбран() Тогда
					ЗаписьВРегистреСведений.ЕстьФото = Ложь;
					ЗаписьВРегистреСведений.Записать();
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	///-ГомзМА 17.10.2023

КонецПроцедуры


&НаСервере
Функция ПолучениеФото(МассивИндкодов)

	///+ГомзМА 13.10.2023
	Структура = Новый Структура;
	Структура.Вставить("indCode", МассивИндкодов);
	
	СтрокаJSON = ПреобразоватьВJSON(Структура);
	
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	
	Соединение = Новый HTTPСоединение("192.168.0.44", 8085);
	Запрос = Новый HTTPЗапрос("/v1/images/existing", Заголовки);
	Запрос.УстановитьТелоИзСтроки(СтрокаJSON);
	//В запросе можно обратиться к нужному ресурсу и с нужными параметрами 
	Ответ = Соединение.ОтправитьДляОбработки(Запрос);
	
	Если Ответ.КодСостояния = 200 Тогда
		Тело = Ответ.ПолучитьТелоКакСтроку();  
		ЧтениеJSON = Новый ЧтениеJSON();
		ЧтениеJSON.УстановитьСтроку(Тело); 
		Ответ  = ПрочитатьJSON(ЧтениеJSON); 
	Иначе Сообщить("Код ответа: " + Ответ.КодСостояния); //анализируем код состояния и делаем выводы 
		Ответ = Неопределено;
	КонецЕсли;
		
	Возврат Ответ;
	///-ГомзМА 13.10.2023

КонецФункции


&НаСервере
Функция ПреобразоватьВJSON(Данные)

	///+ГомзМА 13.10.2023
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	ЗаписатьJSON(ЗаписьJSON, Данные);
	СтрокаJSON = ЗаписьJSON.Закрыть();
	
	Возврат СтрокаJSON;
	///-ГомзМА 13.10.2023

КонецФункции // ПреобразоватьВJSON()
