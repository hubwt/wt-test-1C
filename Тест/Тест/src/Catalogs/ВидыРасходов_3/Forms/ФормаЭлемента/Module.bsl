&НаСервере
Функция СсылкаКатегорияВидРасхода3()
	
 Запрос = Новый Запрос;
 Запрос.Текст =
 	"ВЫБРАТЬ
 	|	ВидыРасходов_3.Код КАК Код
 	|ИЗ
 	|	Справочник.ВидыРасходов_3 КАК ВидыРасходов_3
 	|ГДЕ
 	|	ВидыРасходов_3.Код = &Код";

 Запрос.УстановитьПараметр("Код","000000001");
 РезультатЗапроса = Запрос.Выполнить();
 
 ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
 
 Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
 	Возврат ВыборкаДетальныеЗаписи.Код;
 КонецЦикла;
	
	
КонецФункции

&НаКлиенте
Процедура ТаблицаВлияниеПриИзменении(Элемент)
	
	Если Объект.ТаблицаВлияние.Количество() > 0 Тогда
		Объект.План = Объект.ТаблицаВлияние.Итог("План");
	Иначе
		Объект.План = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СсылкаРодительФилиала()

	РодительКатегории 		= объект.Родитель; 	
	РодительФилиалаКод		= РодительКатегории.Родитель.Код;
	
	Возврат РодительФилиалаКод; 
	
КонецФункции

&НаСервере
Функция СсылкаРодительСтатья()

	Категории 			= объект.Родитель; 	
	Одел					= Категории.Родитель;
	Филиал				= Одел.Родитель;
	КореньКод			= Филиал.Родитель.Код; 
	Объект.РодительРодитель = Одел; 	
	Возврат КореньКод; 
	
КонецФункции

&НаСервере
Функция СсылкаРодительЗарплатаСтатья()

	ВидЗП 				= объект.Родитель; 	
	Зарплата				= ВидЗП.Родитель;
	Категория			= Зарплата.Родитель;
	Отдел					= Категория.Родитель; 
	ФилиалКод			= Отдел.Родитель.Код;
	
	Объект.РодительРодитель 				= Зарплата; 
	Объект.РодительРодительРодитель 	= Категория; 	
	
	Возврат ФилиалКод; 
	
КонецФункции


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если СсылкаРодительФилиала() = СсылкаКатегорияВидРасхода3()  Тогда
		Элементы.План.Видимость = Истина;
		Элементы.ТаблицаВлияние.Видимость = Истина;  
	Иначе 
		Элементы.План.Видимость = Ложь;
		Элементы.ТаблицаВлияние.Видимость = Ложь;   
	КонецЕсли; 
	
	Если СсылкаРодительСтатья() = СсылкаКатегорияВидРасхода3() И НЕ ЕстьПодчиненныеЭлементы() Тогда	
		
		Элементы.Влияние.Видимость 	= Истина;

	ИначеЕсли СсылкаРодительЗарплатаСтатья() = СсылкаКатегорияВидРасхода3() И НЕ ЕстьПодчиненныеЭлементы() Тогда
		
		Элементы.Влияние.Видимость 	= Истина;
	
	Иначе 
		
		Элементы.Влияние.Видимость 	= Ложь;

	КонецЕсли;
	
	
	
КонецПроцедуры

&НаСервере
Функция ЕстьПодчиненныеЭлементы()

Запрос = Новый Запрос;
Запрос.Текст =
	"ВЫБРАТЬ
	|	ВидыРасходов_3.Ссылка
	|ИЗ
	|	Справочник.ВидыРасходов_3 КАК ВидыРасходов_3
	|ГДЕ
	|	ВидыРасходов_3.Родитель = &Родитель";

Запрос.УстановитьПараметр("Родитель", Объект.Ссылка);


Если Запрос.Выполнить().Пустой() Тогда 
    Флаг = Ложь; 
Иначе 
    Флаг = Истина; 
КонецЕсли; 

Возврат Флаг; 
КонецФункции








