
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

//&НаКлиенте
//Процедура СостояниеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
//	СостояниеНачалоВыбораНаСервере();
//КонецПроцедуры


