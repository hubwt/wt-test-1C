Процедура ЗаполнитьПодвал()
	
	Схема = Элементы.Список.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	Настройки = Элементы.Список.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	ЭтотОбъект.ЭтаФорма.Элементы.Количество.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;
	ЭтотОбъект.ЭтаФорма.Элементы.Сумма.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;

		
	ЭтотОбъект.ЭтаФорма.Элементы.Количество.ТекстПодвала =  Формат(Результат.Итог("Количество"),"ЧДЦ=0; ЧН=-");
	ЭтотОбъект.ЭтаФорма.Элементы.Сумма.ТекстПодвала =  Формат(Результат.Итог("Сумма"),"ЧДЦ=0; ЧН=-");

	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Список.Параметры.УстановитьЗначениеПараметра	("Дата1", ДАТА(1,1,1));
	Список.Параметры.УстановитьЗначениеПараметра	("Дата2", ДАТА(1,1,1));
	ЗаполнитьПодвал(); 
	
КонецПроцедуры


&НаКлиенте
Процедура ЗаполнитьСвязиДляОтбора(Команда)
	ЗаполнитьСвязиДляОтбораНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	Список.Параметры.УстановитьЗначениеПараметра	("Дата1", период.ДатаНачала);
	Список.Параметры.УстановитьЗначениеПараметра	("Дата2", период.ДатаОкончания);
	ЗаполнитьПодвал();
КонецПроцедуры


&НаКлиенте
Процедура СписокОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	ПриПеретаскивании(ПараметрыПеретаскивания.Значение); 
КонецПроцедуры

&НаСервере
Функция ПриПеретаскивании(Массив) 
	
	Для каждого СтрокаМассива Из Массив Цикл
		
		ОбъектСчет = СтрокаМассива.ПолучитьОбъект(); 
		ОбъектСчет.РодительРодитель = ОбъектСчет.Родитель.Родитель; 
		ОбъектСчет.Записать(); 	
	
	КонецЦикла; 
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСвязиДляОтбораНаСервере()
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВидыРасходов_3.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ВидыРасходов_3 КАК ВидыРасходов_3";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		СсылкаНаВидРасх	=	ВыборкаДетальныеЗаписи.Ссылка; 
		ТоварОбъект = СсылкаНаВидРасх.ПолучитьОбъект(); 
		
		Категории 		= ТоварОбъект.Родитель; 	
		Одел			= Категории.Родитель; 
		ТоварОбъект.РодительРодитель = Одел; 
		
		ТоварОбъект.Записать(); 
	КонецЦикла;
КонецПроцедуры
