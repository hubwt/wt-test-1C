Процедура ЗаполнитьПодвал()
	
	Схема = Элементы.Список.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	Настройки = Элементы.Список.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(Схема, Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Результат = ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
//	ЭтотОбъект.ЭтаФорма.Элементы.Количество.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;
	ЭтотОбъект.ЭтаФорма.Элементы.Сумма.ГоризонтальноеПоложениеВПодвале = ГоризонтальноеПоложениеЭлемента.Право;

	Структура = СуммаПоКорнюДляПодвала ();
	
	Если  Структура.Количество() <> 0 Тогда  	
//		ЭтотОбъект.ЭтаФорма.Элементы.Количество.ТекстПодвала =  Формат(Структура.Количество,"ЧДЦ=0; ЧН=-");
		ЭтотОбъект.ЭтаФорма.Элементы.Сумма.ТекстПодвала =  Формат(Структура.Сумма,"ЧДЦ=0; ЧН=-");
	КонецЕсли; 
	
КонецПроцедуры

Функция СуммаПоКорнюДляПодвала () 

	Запрос1 = Новый Запрос;
	Запрос1.Текст =
		"ВЫБРАТЬ
		|	 СУММА(ЕСТЬNULL(Расходы.Сумма,0)) КАК Сумма
		|ИЗ
		|	Документ.Расходы КАК Расходы
		|ГДЕ
		|	Расходы.ДатаРасхода МЕЖДУ &Дата1 И КОНЕЦПЕРИОДА(&Дата2, ДЕНЬ)
		|	И Расходы.Филиал.Родитель.Код = ""000000001""";
	
	Запрос1.УстановитьПараметр("Дата1", период.ДатаНачала);
	Запрос1.УстановитьПараметр("Дата2", период.ДатаОкончания);
	
	РезультатЗапроса1 = Запрос1.Выполнить();
	
	ВыборкаДетальныеЗаписи1 = РезультатЗапроса1.Выбрать();
	
	ЕСли ВыборкаДетальныеЗаписи1.Количество()<> 0 Тогда 
			Пока ВыборкаДетальныеЗаписи1.Следующий() Цикл
				Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи1.Сумма) Тогда 
					СуммаРасхода = ВыборкаДетальныеЗаписи1.Сумма;
				Иначе 
					СуммаРасхода = 0; 
				КонецЕсли; 
			КонецЦикла;
	Иначе СуммаРасхода = 0 ; 
	КонецЕСли; 
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СУММА(ЕСТЬNULL (ПриходДенегНаСчет.СуммаДокумента,0)) КАК Сумма
		|ИЗ
		|	Документ.ПриходДенегНаСчет КАК ПриходДенегНаСчет
		|ГДЕ
		|	ПриходДенегНаСчет.ДатаПрихода МЕЖДУ &Дата1 И КОНЕЦПЕРИОДА(&Дата2, ДЕНЬ)
		|	И ПриходДенегНаСчет.Филиал.Родитель.Код = ""000000218""";
	
	Запрос.УстановитьПараметр("Дата1", период.ДатаНачала);
	Запрос.УстановитьПараметр("Дата2", период.ДатаОкончания);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ЕСли ВыборкаДетальныеЗаписи.Количество()<> 0 Тогда 
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				
				Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Сумма) Тогда 
					СуммаДохода = ВыборкаДетальныеЗаписи.Сумма;
				Иначе 
					СуммаДохода = 0; 
				КонецЕсли;
				 
			КонецЦикла;
	Иначе СуммаДохода = 0 ; 
	КонецЕсли; 


	Запрос3 = Новый Запрос;
	Запрос3.Текст =
		"ВЫБРАТЬ
		|	СУММА(БюджетТМЦ.Сумма) КАК Сумма
		|ИЗ
		|	РегистрСведений.БюджетТМЦ КАК БюджетТМЦ
		|ГДЕ
		|	БюджетТМЦ.ДатаРасхода МЕЖДУ &Дата1 И КОНЕЦПЕРИОДА(&Дата2, ДЕНЬ)";
	
	Запрос3.УстановитьПараметр("Дата1", период.ДатаНачала);
	Запрос3.УстановитьПараметр("Дата2", период.ДатаОкончания);
	
	РезультатЗапроса3 = Запрос3.Выполнить();
	
	ВыборкаДетальныеЗаписи3 = РезультатЗапроса3.Выбрать();
	
	ЕСли ВыборкаДетальныеЗаписи3.Количество()<> 0 Тогда 
			Пока ВыборкаДетальныеЗаписи3.Следующий() Цикл
				Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи3.Сумма) Тогда 
					СуммаТМЦ = ВыборкаДетальныеЗаписи3.Сумма;
				Иначе 
					СуммаТМЦ = 0; 
				КонецЕсли;
			КонецЦикла;
			
	Иначе СуммаТМЦ = 0 ; 
	КонецЕсли;
	
	СуммаИтог = СуммаДохода + (0 - СуммаРасхода) + СуммаТМЦ; 
	Структура = Новый Структура;
	Структура.Вставить("Сумма",СуммаИтог);
	Возврат Структура; 
КонецФункции 


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Список.Параметры.УстановитьЗначениеПараметра	("Дата1", НачалоДня(ТекущаяДата()));
	Список.Параметры.УстановитьЗначениеПараметра	("Дата2", КонецДня(ТекущаяДата()));
	
	ЗаполнитьПодвал(); 
	
КонецПроцедуры


&НаКлиенте
Процедура ЗаполнитьСвязиДляОтбора(Команда)
	ЗаполнитьСвязиДляОтбораНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ВывестиДанныеПриИзменении(Элемент)
	
	Если ВывестиДанные = Истина И ЗначениеЗаполнено(Период) Тогда
		
		ЗаполнитьСписокнаСервере(период.ДатаНачала,период.ДатаОкончания);
		Элементы.Список.Видимость = Истина;
		Элементы.СписокЛегкий.Видимость = ложь;  
	Иначе 
		
//		ЗаполнитьСписокнаСервере(НачалоДня(ТекущаяДата()),КонецДня(ТекущаяДата()));
		Элементы.Список.Видимость = Ложь; 
		Элементы.СписокЛегкий.Видимость = истина; 
		ВывестиДанные = Ложь; 
	КонецЕсли; 	
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьСписокнаСервере(Дата1 = Неопределено,Дата2 = Неопределено )

		Список.Параметры.УстановитьЗначениеПараметра	("Дата1", Дата1);
		Список.Параметры.УстановитьЗначениеПараметра	("Дата2", Дата2);
		ЗаполнитьПодвал();
 
КонецФункции


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
		ТоварОбъект.РодительРодитель 				= Одел; 
		ТоварОбъект.РодительРодительРодитель 	= Одел.Родитель; 
		ТоварОбъект.Записать(); 
	КонецЦикла;
КонецПроцедуры
