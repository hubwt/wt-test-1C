
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// Вставить содержимое обработчика.
	УстановитьПродавца();
КонецПроцедуры

&НаСервере
Процедура УстановитьПродавца()
	Реквизит1.Параметры.УстановитьЗначениеПараметра("КтоПродал",Справочники.Пользователи.НайтиПоНаименованию("Алексей"));
	Продавец = Справочники.Пользователи.НайтиПоНаименованию("Алексей");
	РасчетИтого(Продавец);
КонецПроцедуры


&НаКлиенте
Процедура ПродавецОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
	УстановитьПродавца1(ВыбранноеЗначение);
КонецПроцедуры

&НаСервере
Процедура УстановитьПродавца1(ВыбранноеЗначение)
	Реквизит1.Параметры.УстановитьЗначениеПараметра("КтоПродал",ВыбранноеЗначение);
	РасчетИтого(ВыбранноеЗначение);
КонецПроцедуры


&НаКлиенте
Процедура Установить(Команда)
	// Вставить содержимое обработчика.
	УстановитьДаты();
КонецПроцедуры


&НаКлиенте
Процедура ВсеПродажи(Команда)
	// Вставить содержимое обработчика.
	Всё();
КонецПроцедуры

&НаСервере
Процедура УстановитьДаты()
	Реквизит1.ТекстЗапроса = "ВЫБРАТЬ
	                         |	ПродажаЗапчастей.Номер,
	                         |	ПродажаЗапчастей.Дата,
	                         |	ПродажаЗапчастей.Комментарий,
	                         |	ПродажаЗапчастей.ИтогоРекв,
	                         |	ПродажаЗапчастей.КтоПродал,
	                         |	ПродажаЗапчастей.Ссылка,
							 |	ПродажаЗапчастей.Оплачено
	                         |	ПродажаЗапчастей.ИтогоРекв * 0.05 КАК Зароботок
	                         |ИЗ
	                         |	Документ.ПродажаЗапчастей КАК ПродажаЗапчастей
	                         |ГДЕ
	                         |	ПродажаЗапчастей.КтоПродал = &КтоПродал
							 |	И  ПродажаЗапчастей.Оплачено = ИСТИНА
	                         |	И ПродажаЗапчастей.Дата >= &ПериодС
	                         |	И ПродажаЗапчастей.Дата < &ПериодПо";
	Реквизит1.Параметры.УстановитьЗначениеПараметра("ПериодС",ПериодС);
	Реквизит1.Параметры.УстановитьЗначениеПараметра("ПериодПо",ПериодПо);
	 Запрос = Новый Запрос;
	 Запрос.Текст = "ВЫБРАТЬ
	                  |	СУММА(ПродажаЗапчастей.ИтогоРекв) КАК ИтогоРекв
	                  |ИЗ
	                  |	Документ.ПродажаЗапчастей КАК ПродажаЗапчастей
					  |	ГДЕ
						|	ПродажаЗапчастей.КтоПродал = &КтоПродал
						|   И ПродажаЗапчастей.Оплачено	= ИСТИНА
						|	И ПродажаЗапчастей.Дата > &ПериодС
	                         |	И ПродажаЗапчастей.Дата <= &ПериодПо";
	Запрос.УстановитьПараметр("КтоПродал",Продавец);
	Запрос.УстановитьПараметр("ПериодС",ПериодС);
	Запрос.УстановитьПараметр("ПериодПо",ПериодПо);
	Результат = Запрос.Выполнить();
    Таблица = Результат.Выгрузить();
	Итого = Таблица.Итог("ИтогоРекв")*0.05;	
	
КонецПроцедуры

&НаСервере
Процедура Всё()
	Реквизит1.ТекстЗапроса = "ВЫБРАТЬ
	                         |	ПродажаЗапчастей.Номер,
	                         |	ПродажаЗапчастей.Дата,
	                         |	ПродажаЗапчастей.Комментарий,
	                         |	ПродажаЗапчастей.ИтогоРекв,
	                         |	ПродажаЗапчастей.КтоПродал,
	                         |	ПродажаЗапчастей.Ссылка,
	                         |	ПродажаЗапчастей.ИтогоРекв * 0.05 КАК Зароботок,
							 |	ПродажаЗапчастей.Оплачено
	                         |ИЗ
	                         |	Документ.ПродажаЗапчастей КАК ПродажаЗапчастей
	                         |ГДЕ
	                         |	ПродажаЗапчастей.КтоПродал = &КтоПродал
							 |	И ПродажаЗапчастей.Оплачено = ИСТИНА";
КонецПроцедуры


 &НаСервере
 Процедура РасчетИтого(ВыбранноеЗначение)
	 Запрос = Новый Запрос;
	 Запрос.Текст = "ВЫБРАТЬ
	                  |	СУММА(ПродажаЗапчастей.ИтогоРекв) КАК ИтогоРекв
	                  |ИЗ
	                  |	Документ.ПродажаЗапчастей КАК ПродажаЗапчастей
					  |	ГДЕ
						|	ПродажаЗапчастей.КтоПродал = &КтоПродал";
						Запрос.УстановитьПараметр("КтоПродал",ВыбранноеЗначение);
	Результат = Запрос.Выполнить();
	Таблица = Результат.Выгрузить();
	Итого = Таблица.Итог("ИтогоРекв")*0.05;
КонецПроцедуры

&НаКлиенте
Процедура ВыдачаЗарплаты(Команда)
	// Вставить содержимое обработчика.
	рез = Выдача();
	рез.ПолучитьФорму().ОткрытьМодально();
КонецПроцедуры

Функция Выдача()
	Запрос = Новый Запрос;
	Запрос.Текст =  "ВЫБРАТЬ
	|	ПродажаЗапчастей.Ссылка,
	|	ПродажаЗапчастей.ИтогоРекв
	|ИЗ
	|	Документ.ПродажаЗапчастей КАК ПродажаЗапчастей
	|ГДЕ
	|	ПродажаЗапчастей.КтоПродал = &КтоПродал
	|	И ПродажаЗапчастей.Дата >= &ПериодС
	|	И ПродажаЗапчастей.Дата < &ПериодПо
	|	И ПродажаЗапчастей.Оплачено = &Оплачено";
	Запрос.УстановитьПараметр("КтоПродал",Продавец);
	Запрос.УстановитьПараметр("ПериодС",ПериодС);
	Запрос.УстановитьПараметр("ПериодПо",ПериодПо);
	Запрос.УстановитьПараметр("Оплачено",Истина);
	рез = Запрос.Выполнить();
	таб = рез.Выгрузить();
	Если таб.Количество() > 0 Тогда
		док = Документы.ЗарплатаМенеджеров.СоздатьДокумент();
		док.Дата = ТекущаяДата();
		Для Каждого стр из таб Цикл
			стр1 = док.Документы.Добавить();
			стр1.документ = стр.Ссылка;
			стр1.сумма = стр.ИтогоРекв*0.05;
		КонецЦикла;
		док.Записать();
		Возврат Документы.ЗарплатаМенеджеров.НайтиПоНомеру(док.Номер);
	КонецЕсли;
	
		
	
КонецФункции


 
