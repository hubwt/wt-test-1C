
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
&НаСервере
Функция СсылкаРодительФилиала()

	РодительКатегории 		= объект.Родитель; 	
	РодительФилиалаКод		= РодительКатегории.Родитель.Код;
	
	Возврат РодительФилиалаКод; 
	
КонецФункции

&НаСервере
Функция СсылкаРодительСтатья()

	Категории 		= объект.Родитель; 	
	Одел			= Категории.Родитель;
	Филиал			= Одел.Родитель;
	КореньКод		= Филиал.Родитель.Код; 
	Объект.РодительРодитель = Одел; 	
	Возврат КореньКод; 
	
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
	
	Если СсылкаРодительСтатья() = СсылкаКатегорияВидРасхода3()  Тогда
		 		
		Элементы.Влияние.Видимость 	= Истина;
		Элементы.ЗП.Видимость		= Истина;
	Иначе 
		Элементы.Влияние.Видимость 	= Ложь;
		Элементы.ЗП.Видимость		= Ложь;  
	КонецЕсли;

КонецПроцедуры










