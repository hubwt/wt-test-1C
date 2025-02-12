
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДанныеИзПоступления = Параметры.ДанныеПоПозиции;
	ВыводРасходаЗапчасти();
	
КонецПроцедуры

&НаСервере
Процедура ВыводРасходаЗапчасти()
	
	Запрос = Новый Запрос;
	//Запрос.УстановитьПараметр("Склад", ДанныеИзПоступления.Склад);
	//Запрос.УстановитьПараметр("ДатаДокумента", ДанныеИзПоступления.ДатаДокумента);
	Запрос.УстановитьПараметр("ИндКод", ДанныеИзПоступления.ИндКод);
	Запрос.УстановитьПараметр("Товар", ДанныеИзПоступления.Товар);
	Запрос.УстановитьПараметр("Машина", ДанныеИзПоступления.Машина);
	Запрос.Текст = "ВЫБРАТЬ
		|	Период КАК Дата,
		|   Регистратор КАК Документ,
		|   Товар,
		|   Колво КАК Количество, 
		|   НомерСтроки КАК НомерСтрокиВДокументе
		|
		|ИЗ
		|	РегистрНакопления.РегистрНакопления1
		|
		|ГДЕ
		//|	Период > &ДатаДокумента
		|   ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
		//|   И Склад = &Склад
		|   И Товар = &Товар
		|   И машина = &Машина
		|   И индкод = &ИндКод
		|	И (Регистратор ССЫЛКА Документ.ПродажаЗапчастей ИЛИ Регистратор ССЫЛКА Документ.ЗаказНаряд
		|   	ИЛИ Регистратор ССЫЛКА Документ.СписаниеЗапчастей)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Период
		|
		|";
	
	ТЗ = Запрос.Выполнить().Выгрузить();
	ТабВывода.Загрузить(ТЗ);
	
	ДобавитьЦену();
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьЦену()
	
	Для Каждого Стр Из ТабВывода Цикл
	
		Если ТипЗнч(Стр.Документ) = Тип("ДокументСсылка.СписаниеЗапчастей") Тогда
			Продолжить;
		КонецЕсли;
		
		Если ТипЗнч(Стр.Документ) = Тип("ДокументСсылка.ПродажаЗапчастей") Тогда
			ТаблицаФормы = Стр.Документ.Таблица;
		Иначе
			ТаблицаФормы = Стр.Документ.Товары;
		КонецЕсли;
		
		НайденнаяСтрока = ТаблицаФормы.Найти(Стр.НомерСтрокиВДокументе, "НомерСтроки");
		Стр.цена = НайденнаяСтрока.Цена;
	
	КонецЦикла; 
	
КонецПроцедуры

