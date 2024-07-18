

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Для каждого Строка из Объект.Таблица Цикл
		Строка.местоХранения = ПолучитьМестоХранения(Строка.Товар, Строка.Склад);
	КонецЦикла;
	
	ЗаполнениеСписков();
	ПосчитатьИтоги();
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаКоличествоПриИзменении(Элемент)
	ОбработкаИзмененияСтроки("Таблица");
	ПосчитатьИтоги();
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаЦенаПриИзменении(Элемент)
	ОбработкаИзмененияСтроки("Таблица");
	ПосчитатьИтоги();
КонецПроцедуры

&НаСервере
Процедура ПосчитатьИтоги()
	
	Объект.ОбщаяСумма =  0;
	
	Для Каждого СтрокаТаблицы Из Объект.Таблица Цикл
		Если СтрокаТаблицы.Сумма = 0 Тогда
			СтрокаТаблицы.Сумма = СтрокаТаблицы.Количество * СтрокаТаблицы.Цена;
		КонецЕсли;
		Объект.ОбщаяСумма =  Объект.ОбщаяСумма + СтрокаТаблицы.Сумма;	
	КонецЦикла;	
	
	
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаИзмененияСтроки(ИмяТабличнойЧасти, Поле = Неопределено, ДанныеСтроки = Неопределено)
	
	ТекДанные 		= ?(ДанныеСтроки = Неопределено, Элементы[ИмяТабличнойЧасти].ТекущиеДанные, ДанныеСтроки);
	ТекДанные.Сумма = ТекДанные.Цена * ТекДанные.Количество;
	
КонецПроцедуры // ОбработкаИзмененияСтроки()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ДокСсылка = ПриОткрытииНаСервере();
	Если ДокСсылка <> 0 Тогда
		Отказ = Истина;
		ОткрытьЗначение(ДокСсылка);     
	КонецЕсли;  
	
	//Волков ИО 29.12.23 ++ 
	ПроверитьРоль();  
	//Волков ИО 29.12.23 --  
	
КонецПроцедуры

Процедура ПроверитьРоль()    
	//Волков ИО 09.01.24 ++ 	
	Если РольДоступна(Метаданные.Роли.МенеджерПоПродажам) И Не РольДоступна(Метаданные.Роли.СписаниеТоваров) Тогда 
		
		Элементы.Кладовщик.Доступность = Истина;   
		Элементы.Состояние.СписокВыбора.Очистить();
		Элементы.Состояние.СписокВыбора.Добавить(Перечисления.СтатусыАктаВозврата.ОжидаемНаСклад);
		Элементы.Состояние.СписокВыбора.Добавить(Перечисления.СтатусыАктаВозврата.ПринятоНаСкладе);
		Элементы.Состояние.СписокВыбора.Добавить(Перечисления.СтатусыАктаВозврата.Разнесено);
		Элементы.Состояние.СписокВыбора.Добавить(Перечисления.СтатусыАктаВозврата.ВозвратЗалога);
		
	ИначеЕсли РольДоступна(Метаданные.Роли.дт_ПодсистемаСклад) И РольДоступна(Метаданные.Роли.СписаниеТоваров) Тогда
		
		Элементы.Кладовщик.Доступность = Истина; 
		Элементы.Состояние.СписокВыбора.Очистить();
		Элементы.Состояние.СписокВыбора.Добавить(Перечисления.СтатусыАктаВозврата.Разнесено);
		Элементы.Состояние.СписокВыбора.Добавить(Перечисления.СтатусыАктаВозврата.ВозвратЗалога);
		
	КонецЕсли;	
	//Волков ИО 09.01.24 -- 		
КонецПроцедуры	



&НаСервере
Функция ПриОткрытииНаСервере()
	Если  НЕ РеквизитФормыВЗначение("Объект").ЭтоНовый() Тогда
		Возврат 0; //открывается уже существующий док
	Иначе    
		Запрос = Новый Запрос;
		Запрос.Текст =  "ВЫБРАТЬ
		|	АктВозврата.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.АктВозврата КАК АктВозврата
		|ГДЕ
		|	АктВозврата.Продажа = &Продажа";
		
		Запрос.УстановитьПараметр("Продажа", Объект.Продажа);
		Результат = Запрос.Выполнить();
		Если Результат.Пустой() Тогда
			Возврат 0; // документа нет
		Иначе
			Выборка = Результат.Выбрать();
			Выборка.Следующий();
			Возврат Выборка.Ссылка; //Возвращаем ссылку на существующий док
		КонецЕсли;
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура ТаблицаТоварПриИзменении(Элемент)
	Элементы.Таблица.ТекущиеДанные.МестоХранения = ПолучитьМестоХранения(Элементы.Таблица.ТекущиеДанные.Товар, 
	Элементы.Таблица.ТекущиеДанные.Склад);
КонецПроцедуры

&НаСервере
Функция ПолучитьМестоХранения(Номенклатура, Склад)
	
	Если ЗначениеЗаполнено(Номенклатура) Тогда
		Результат = дт_АдресноеХранение.ПолучитьМестоХранения(Новый Структура("Дата,Склад,Номенклатура", Объект.Дата, Склад, Номенклатура));
	Иначе
		Результат = Неопределено;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ЗаполнениеСписков()
	//МассивКладовщиков = Новый Массив;
	// РольВМетаданных = Метаданные.Роли["дт_ПодсистемаСклад"]; 
	//Запрос = Новый Запрос;
	//Запрос.Текст = "ВЫБРАТЬ
	//               |	Пользователи.Ссылка КАК Ссылка,
	//               |	Пользователи.Код КАК Код,
	//               |	Пользователи.Наименование КАК Представление
	//               |ИЗ
	//               |	Справочник.Пользователи КАК Пользователи";
	//Выборка = Запрос.Выполнить().выбрать();
	//
	//Пока Выборка.Следующий() Цикл
	//	 ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени(Выборка.Представление);
	
	//    Если ПользовательИБ <> Неопределено И ПользовательИБ.Роли.Содержит(РольВМетаданных)  Тогда
	//		Элементы.Кладовщик.СписокВыбора.Добавить(Выборка.ссылка,Выборка.Представление);
	//	КонецЕсли;
	//КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СостояниеНачалоВыбораНаСервере()

		СтандартнаяОбработка = Ложь;
	Если РольДоступна(Метаданные.Роли.МенеджерПоПродажам) И Не РольДоступна(Метаданные.Роли.СписаниеТоваров) Тогда 
		
		
		//ДанныеВыбора = Новый СписокЗначений;
		//ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАктаВозврата.ОжидаемНаСклад"));
		//ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыРассылки.ПринятоНаСкладе"));
		
		ДанныеВыбора = Новый СписокЗначений;
		ДанныеВыбора.Добавить("ОжидаемНаСклад");
		ДанныеВыбора.Добавить("ПринятоНаСкладе");
       
		
	ИначеЕсли РольДоступна(Метаданные.Роли.дт_ПодсистемаСклад) И РольДоступна(Метаданные.Роли.СписаниеТоваров) Тогда
		
		//СписокВыбора = Новый СписокЗначений;
		//ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыАктаВозврата.Разнесено"));
		//ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыРассылки.ВозвратЗалога"));
		ДанныеВыбора = Новый СписокЗначений;
		ДанныеВыбора.Добавить("Разнесено");
		ДанныеВыбора.Добавить("ВозвратЗалога");

	КонецЕсли;	


КонецПроцедуры

&НаСервереБезКонтекста
Функция ПредставлениеДляПечати(СведенияКонтрагента)
	
	ПоляПредставления = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок("ФактическийАдрес,ИНН,Телефоны,EMail");
	
	
	Представление = "";
	Для каждого Поле Из ПоляПредставления Цикл
		
		ЗначениеПоля =  ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияКонтрагента, Поле);
		Если НЕ ПустаяСтрока(ЗначениеПоля) Тогда
			Представление = Представление + ЗначениеПоля + Символы.ПС;
		КонецЕсли;
		
	КонецЦикла;
	СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(Представление);
	
	Возврат Представление;
	
КонецФункции // ПредставлениеДляПечати()

&НаКлиенте
процедура Печать(Команда)
	Если ЗначениеЗаполнено(объект.Ссылка)  тогда 
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ОтображатьСетку = Ложь; 
	ПечатьНаСервере(ТабДок,Объект.Ссылка); 
//	ТабДок.Показать("МакетАктВозврата"); 
	ТабДок.АвтоМасштаб = Истина; //Ложь;
	 
	
	КоллекцияПечатныхФорм = УправлениеПечатьюКлиент.НоваяКоллекцияПечатныхФорм("МакетАктВозврата");
	// Добавляем в коллекцию (тип массив) сформированный Табличный документ
	КоллекцияПечатныхФорм[0].ТабличныйДокумент = ТабДок;
	// если требуется устанавливаем параметры печати
	КоллекцияПечатныхФорм[0].Экземпляров=1;
	КоллекцияПечатныхФорм[0].СинонимМакета = "МакетАктВозврата";  // используется для формирования имени файла при сохранении из общей формы печати документов
	// .. и выводим стандартной процедурой БСП
	УправлениеПечатьюКлиент.ПечатьДокументов(КоллекцияПечатныхФорм,Неопределено,ЭтаФорма);

	
	иначе  
	Сообщение = Новый СообщениеПользователю();
	Сообщение.Текст="Необходимо провести документ";
	Сообщение.Сообщить(); 
	конецЕсли; 
		
КонецПроцедуры


&НаСервере 
Функция ПечатьНаСервере(ТабДок, СсылкаНаДокумент)

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	АктВозврата.Номер,
		|	АктВозврата.Дата,
		|	АктВозврата.Клиент,
		|	АктВозврата.Организация,
		|	АктВозврата.Продажа,
		|	АктВозврата.Ответственный,
		|	АктВозвратаТаблица.НомерСтроки,
		|	АктВозвратаТаблица.укод,
		|	АктВозвратаТаблица.Артикул,
		|	АктВозвратаТаблица.Товар,
		|	АктВозвратаТаблица.Количество,
		|	АктВозвратаТаблица.Цена,
		|	АктВозвратаТаблица.Сумма,
		|	АктВозвратаТаблица.Партия
		|ИЗ
		|	Документ.АктВозврата.Таблица КАК АктВозвратаТаблица
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.АктВозврата КАК АктВозврата
		|		ПО АктВозвратаТаблица.Ссылка = АктВозврата.Ссылка
		|ГДЕ
		|	АктВозврата.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", СсылкаНаДокумент);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	
	
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Структура = Новый Структура; 
	СуммаИтого =0; 
	КолличествоСтрок =0; 

	
	Макет = Документы.Актвозврата.ПолучитьМакет("МакетАктВозврата"); 
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("заголовок"); 
	
	Штрихкод =  ГенераторШтрихКода.ПолучитьКомпонентуШтрихКодирования(""); 
	Штрихкод.Ширина = 250; 
	Штрихкод.Высота = 250;
	Штрихкод.ТипКода = 16;
	Штрихкод.УголПоворота = 0;
	Штрихкод.ЗначениеКода = объект.Номер;
	Штрихкод.ПрозрачныйФон = Истина;
	Штрихкод.ОтображатьТекст = Ложь;
	ДвоичныйШтрихКод = штрихкод.ПолучитьШтрихКод();
	КартинкаШтрихКод = Новый Картинка(ДвоичныйШтрихКод,Истина);
	ФайлКартинки 			             = КартинкаШтрихКод;
	ОбластьЗаголовок.Рисунки.QrКод.Картинка = КартинкаШтрихКод;
	
	ОбластьЗаголовок.Параметры.НомерДокумента = Объект.Номер;  
	ОбластьЗаголовок.Параметры.ДатаДокумента = Объект.Дата; 
	 
	СведенияОПокупателе = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(Объект.Клиент, Объект.Дата);
	СведенияОПродавце = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(Объект.Организация, Объект.Дата);
	
	ПараметрыШапки = Новый Структура; 
	ПараметрыШапки.Вставить("ОрганизацияНаименование", ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПродавце, "ПолноеНаименование"));
	ПараметрыШапки.Вставить("ОрганизацияРеквизиты",		ПредставлениеДляПечати(СведенияОПродавце));
	
	ПараметрыШапки.Вставить("ПокупательНаименование",	ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПокупателе, "ПолноеНаименование"));
	ПараметрыШапки.Вставить("ПокупательРеквизиты",		ПредставлениеДляПечати(СведенияОПокупателе));
	
	ОбластьЗаголовок.Параметры.ПокупательНаименование = ПараметрыШапки.ПокупательНаименование;  
	ОбластьЗаголовок.Параметры.ПокупательРеквизиты = ПараметрыШапки.ПокупательРеквизиты;   
	
	ОбластьЗаголовок.Параметры.ОрганизацияНаименование = ПараметрыШапки.ОрганизацияНаименование;  
	ОбластьЗаголовок.Параметры.ОрганизацияРеквизиты = ПараметрыШапки.ОрганизацияРеквизиты;  
	
	ТабДок.Вывести(ОбластьЗаголовок); 
	
	ОбластьЗаголовок2 = Макет.ПолучитьОбласть("заголовок2"); 
	ТабДок.Вывести(ОбластьЗаголовок2); 
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка"); 
	ТабДок.Вывести(ОбластьШапка); 
	НомерСтроки = 0; 
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			НомерСтроки = НомерСтроки + 1;
		ОбластьСтрока.Параметры.НомерСтроки = НомерСтроки;
		ОбластьСтрока.Параметры.НашКод = ВыборкаДетальныеЗаписи.укод;
		ОбластьСтрока.Параметры.артикул = ВыборкаДетальныеЗаписи.Артикул;
		ОбластьСтрока.Параметры.наименование = ВыборкаДетальныеЗаписи.Товар;
		ОбластьСтрока.Параметры.колво = ВыборкаДетальныеЗаписи.Количество;
		ОбластьСтрока.Параметры.цена = ВыборкаДетальныеЗаписи.Цена;
		ОбластьСтрока.Параметры.сумма = ВыборкаДетальныеЗаписи.Сумма;
		ОбластьСтрока.Параметры.код = ВыборкаДетальныеЗаписи.Партия;
		СуммаИтого = СуммаИтого + ВыборкаДетальныеЗаписи.Сумма;  
		КолличествоСтрок = КолличествоСтрок + 1; 
		ТабДок.Вывести(ОбластьСтрока);
	КонецЦикла;
	
	



	ОбластьПодвал = Макет.ПолучитьОбласть("подвал"); 
	ОбластьПодвал.Параметры.КоличествоСтрок = КолличествоСтрок;
	ОбластьПодвал.Параметры.СуммаИтого = Формат(СуммаИтого, "ЧДЦ=2");
	ОбластьПодвал.Параметры.СуммаПрописью = ЧислоПрописью(СуммаИтого, ,"рубль, рубля, рублей, м, копейка, копейки, копеек, ж");
	ОбластьПодвал.Параметры.ПродавецФИО = Объект.Ответственный;
	ОбластьПодвал.Параметры.Продажа = Объект.Продажа;
	
	
	ТабДок.Вывести(ОбластьПодвал); 
	
	ОбластьРазделитель = Макет.ПолучитьОбласть("Разделитель"); 
	ТабДок.Вывести(ОбластьРазделитель); 
	
	Возврат ТабДок; 
КонецФункции;
//&НаКлиенте
//Процедура СостояниеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
//	СостояниеНачалоВыбораНаСервере();
//КонецПроцедуры


