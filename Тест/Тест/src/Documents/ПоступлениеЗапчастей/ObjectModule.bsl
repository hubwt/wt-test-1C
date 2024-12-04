#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
	#Область ПрограммныйИнтерфейс
	
	
	
	#КонецОбласти
	
#Область ОбработчикиСобытий
Процедура ОбработкаПроведения(Отказ, Режим)
	// Комлев АА  04/12/24 +++
	//Отменить Поступление товара которого и так много на Складах
	Если НЕ Перекуп И НЕ Новые И Дата > '20241204170000'Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
					   |	ПоступлениеЗапчастейТаблица.Товар КАК Товар,
					   |	СУММА(ПоступлениеЗапчастейТаблица.Колво) КАК Колво,
					   |	МАКСИМУМ(ПоступлениеЗапчастейТаблица.НомерСтроки) КАК НомерСтроки
					   |ПОМЕСТИТЬ ВТ_ТЧ_Товары
					   |ИЗ
					   |	Документ.ПоступлениеЗапчастей.Таблица КАК ПоступлениеЗапчастейТаблица
					   |ГДЕ
					   |	ПоступлениеЗапчастейТаблица.Ссылка = &Ссылка
					   |СГРУППИРОВАТЬ ПО
					   |	ПоступлениеЗапчастейТаблица.Товар
					   |;
					   |
					   |////////////////////////////////////////////////////////////////////////////////
					   |ВЫБРАТЬ
					   |	РегистрНакопления1Остатки.Товар КАК Товар,
					   |	РегистрНакопления1Остатки.КолвоОстаток КАК КолвоОстаток
					   |ПОМЕСТИТЬ ОстаткиТовара
					   |ИЗ
					   |	РегистрНакопления.РегистрНакопления1.Остатки(&МоментВремени, Товар В
					   |		(ВЫБРАТЬ
					   |			ВТ_ТЧ_Товары.Товар
					   |		ИЗ
					   |			ВТ_ТЧ_Товары КАК ВТ_ТЧ_Товары)
					   |	И Склад = &Склад) КАК РегистрНакопления1Остатки
					   |;
					   |
					   |////////////////////////////////////////////////////////////////////////////////
					   |ВЫБРАТЬ
					   |	ЗаказКлиентаТовары.Номенклатура КАК Товар,
					   |	КОЛИЧЕСТВО(ЗаказКлиентаТовары.Номенклатура.Код) КАК КоличествоТовараИзЗаявокБезПродажи
					   |ПОМЕСТИТЬ ВТ_ТоварыИзЗаявок
					   |ИЗ
					   |	Документ.ЗаказКлиента.Товары КАК ЗаказКлиентаТовары
					   |ГДЕ
					   |	ЗаказКлиентаТовары.Ссылка.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
					   |	И ЗаказКлиентаТовары.Ссылка.Состояние <> ЗНАЧЕНИЕ(Перечисление.дт_СостоянияЗаказовКлиента.Продажа)
					   |СГРУППИРОВАТЬ ПО
					   |	ЗаказКлиентаТовары.Номенклатура
					   |;
					   |
					   |////////////////////////////////////////////////////////////////////////////////
					   |ВЫБРАТЬ
					   |	ПродажаЗапчастейТаблица.Товар КАК Товар,
					   |	КОЛИЧЕСТВО(ПродажаЗапчастейТаблица.Товар.Код) КАК КоличествоТовараПродажа
					   |ПОМЕСТИТЬ ВТ_ТоварыПродажа
					   |ИЗ
					   |	Документ.ПродажаЗапчастей.Таблица КАК ПродажаЗапчастейТаблица
					   |ГДЕ
					   |	ПродажаЗапчастейТаблица.Ссылка.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
					   |СГРУППИРОВАТЬ ПО
					   |	ПродажаЗапчастейТаблица.Товар
					   |;
					   |
					   |////////////////////////////////////////////////////////////////////////////////
					   |ВЫБРАТЬ
					   |	ЗаказНарядТовары.Номенклатура КАК Товар,
					   |	КОЛИЧЕСТВО(ЗаказНарядТовары.Номенклатура.Код) КАК КоличествоТовараЗаказНаряд
					   |ПОМЕСТИТЬ ВТ_ТоварыИзЗаказНарядов
					   |ИЗ
					   |	Документ.ЗаказНаряд.Товары КАК ЗаказНарядТовары
					   |ГДЕ
					   |	ЗаказНарядТовары.Ссылка.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
					   |СГРУППИРОВАТЬ ПО
					   |	ЗаказНарядТовары.Номенклатура
					   |;
					   |
					   |////////////////////////////////////////////////////////////////////////////////
					   |ВЫБРАТЬ
					   |	ВТ_ТЧ_Товары.Товар КАК Товар,
					   |	ВТ_ТЧ_Товары.Колво,
					   |	ЕСТЬNULL(ВТ_ТоварыИзЗаявок.КоличествоТовараИзЗаявокБезПродажи, 0) КАК КоличествоТовараИзЗаявокБезПродажи,
					   |	ЕСТЬNULL(ВТ_ТоварыПродажа.КоличествоТовараПродажа, 0) КАК КоличествоТовараПродажа,
					   |	ЕСТЬNULL(ВТ_ТоварыИзЗаказНарядов.КоличествоТовараЗаказНаряд, 0) КАК КоличествоТовараЗаказНаряд,
					   |	ЕСТЬNULL(ВТ_ТоварыИзЗаявок.КоличествоТовараИзЗаявокБезПродажи, 0) +
					   |		ЕСТЬNULL(ВТ_ТоварыПродажа.КоличествоТовараПродажа, 0) + ЕСТЬNULL(ВТ_ТоварыИзЗаказНарядов.КоличествоТовараЗаказНаряд,
					   |		0) КАК СпросЗаГод,
					   |	ЕСТЬNULL(ОстаткиТовара.КолвоОстаток, 0) КАК КолвоОстаток,
					   |	ВТ_ТЧ_Товары.НомерСтроки
					   |ИЗ
					   |	ВТ_ТЧ_Товары КАК ВТ_ТЧ_Товары
					   |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ТоварыИзЗаявок КАК ВТ_ТоварыИзЗаявок
					   |		ПО (ВТ_ТоварыИзЗаявок.Товар = ВТ_ТЧ_Товары.Товар)
					   |		ЛЕВОЕ СОЕДИНЕНИЕ ОстаткиТовара КАК ОстаткиТовара
					   |		ПО (ОстаткиТовара.Товар = ВТ_ТЧ_Товары.Товар)
					   |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ТоварыПродажа КАК ВТ_ТоварыПродажа
					   |		ПО (ВТ_ТоварыПродажа.Товар = ВТ_ТЧ_Товары.Товар)
					   |		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ТоварыИзЗаказНарядов КАК ВТ_ТоварыИзЗаказНарядов
					   |		ПО (ВТ_ТоварыИзЗаказНарядов.Товар = ВТ_ТЧ_Товары.Товар)";

		ДатаНачала = ДобавитьМесяц(ТекущаяДата(), -12);
		ДатаОкончания = КонецДня(ТекущаяДата());
		Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
		Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);

		Запрос.УстановитьПараметр("МоментВремени", МоментВремени());
		Запрос.УстановитьПараметр("Склад", Склад);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);

		РезультатЗапроса = Запрос.Выполнить();

		Выборка = РезультатЗапроса.Выбрать();

		Пока Выборка.Следующий() Цикл
			Если Выборка.СпросЗаГод = 0 Тогда
				Отказ = Истина;
				Сообщить("Поступление товара  " + Выборка.Товар + " запрещено. Не пользуется спросом. Строка № "
					+ Выборка.НомерСтроки);
				Продолжить;
			КонецЕсли;
			Если Выборка.КолвоОстаток > (Выборка.СпросЗаГод * 2) Тогда
				Отказ = Истина;
				Сообщить("Поступление товара  " + Выборка.Товар + " запрещено. Остаток на складе " + Склад
					+ " превышает спрос. Строка № " + Выборка.НомерСтроки);
				Продолжить;
			КонецЕсли;
			Если (Выборка.Колво + Выборка.КолвоОстаток) > (Выборка.СпросЗаГод * 2) Тогда
				Отказ = Истина;
				Сообщить("Поступление товара  " + Выборка.Товар + " запрещено. Остаток на складе " + Склад
					+ ", с учетом поступления превышает спрос. Строка № " + Выборка.НомерСтроки
					+ " Можно оприходовать " + ((Выборка.СпросЗаГод * 2) - Выборка.КолвоОстаток));
				Продолжить;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Комлев АА  04/12/24 ---
	
	
	
	ИспользуетсяСтараяСхемаУчета = Дата < дт_Склад.ДатаНачалаИспользованияЗаявокНаСборку();
		
		// регистр РегистрНакопления1 Приход
	Движения.РегистрНакопления1.Записывать = Истина;
	Движения.ДобавлениеЗапчастей.Записывать = Истина;
	Движения.дт_ЦеныНоменклатуры.Записывать = Истина;
	Движения.дт_НоменклатураПоставщиков.Записывать = Истина;
	Движения.ТоварыОрганизаций.Записывать = Истина;
	Движения.РасчетыСПоставщиками.Записывать = Истина;
	Движения.ТоварыВТранзитнойЗоне.Записывать = Истина;
		
		//пн = Справочники.Пользователи.НайтиПоКоду("000000021");
		
		// Получим таблицу партий
	ТаблицаТовары = Таблица.Выгрузить();
		//ТаблицаТовары.Колонки.Добавить("Партия", Новый ОписаниеТипов("СправочникСсылка.ИндКод"));
	Для Каждого СтрокаТаблицы Из ТаблицаТовары Цикл

		Если Не ЗначениеЗаполнено(СтрокаТаблицы.Партия) Тогда
			СтрокаТаблицы.Партия = СсылкаИндКод(СтрокаТаблицы.код, СтрокаТаблицы.Товар, Отказ);
		КонецЕсли;
		Если Отказ Тогда
			Возврат;
		КонецЕсли
		;

	КонецЦикла;

	Если Дата < '20231003' Тогда
		ЭтоПоступлениеВТранзитнуюЗону = ЗначениеЗаполнено(СкладТранзитный) И Не ИспользуетсяСтараяСхемаУчета;
	Иначе
		ЭтоПоступлениеВТранзитнуюЗону = Ложь;
	КонецЕсли;
	Для Каждого ТекСтрокаТаблица Из ТаблицаТовары Цикл
			
			//Волков ИО 06.03.24 ++ 
		Если Новые Тогда
			ТекСтрокаТаблица.Автомобиль = Справочники.Машины.НайтиПоКоду("000000008");
		КонецЕсли;                                       			
			//Волков ИО 06.03.24 --

		индкод = ТекСтрокаТаблица.Партия;

		Движение = Движения.РегистрНакопления1.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
			
			// ++ obrv 04.09.18
		Движение.Склад = ?(ЭтоПоступлениеВТранзитнуюЗону, СкладТранзитный, Склад);
			// -- obrv 04.09.18
		Движение.Товар = ТекСтрокаТаблица.Товар;
			//об = ТекСтрокаТаблица.Товар.ПолучитьОбъект();
			//Если об.Производитель <> Машина.Производитель Тогда 
			//	об.Производитель = Машина.Производитель;
			//	об.Записать();
			//КонецЕсли;

		Движение.машина = ?(ИспользуетсяСтараяСхемаУчета, Машина, ТекСтрокаТаблица.Автомобиль);
		Движение.индкод = индкод;
		Движение.Колво = ТекСтрокаТаблица.Колво;
			//Движение.Стеллаж = ТекСтрокаТаблица.МестоНаСкладе;

		об = РегистрыСведений.Комментарии.СоздатьМенеджерЗаписи();
		об.Машина = ?(ИспользуетсяСтараяСхемаУчета, Машина, ТекСтрокаТаблица.Автомобиль);
		об.Товар = ТекСтрокаТаблица.Товар;
		об.индкод = индкод;
		об.Прочитать();
		Если (Не об.Выбран()) И (Не ПустаяСтрока(ТекСтрокаТаблица.Комментарий)) Тогда
			об.Комментарий = ТекСтрокаТаблица.Комментарий;
			об.Машина = ?(ИспользуетсяСтараяСхемаУчета, Машина, ТекСтрокаТаблица.Автомобиль);
			об.Товар = ТекСтрокаТаблица.Товар;
			об.индкод = индкод;

			об.Записать();
		Иначе
			об.Комментарий = ТекСтрокаТаблица.Комментарий;
			об.Записать(Истина);
		КонецЕсли;

		об = РегистрыСведений.ИндНомер.СоздатьМенеджерЗаписи();
		об.индкод = индкод;
		об.Прочитать();
			// ++ obrv 23.11.19
			//Если (Не об.Выбран()) И ((Не ПустаяСтрока(ТекСтрокаТаблица.Код)) ИЛИ (ТекСтрокаТаблица.наценка > 0 или ТекСтрокаТаблица.наценка < 0))  Тогда
		Если (Не об.Выбран()) И ((Не ПустаяСтрока(ТекСтрокаТаблица.Код)) Или ЗначениеЗаполнено(
			ТекСтрокаТаблица.наценка)) Тогда
				// -- obrv 23.11.19	
			об.Код = ТекСтрокаТаблица.Код;
			об.наценка = ТекСтрокаТаблица.Наценка;
				//об.Цена = ТекСтрокаТаблица.Цена;
			об.индкод = индкод;
			об.цп = ТекСтрокаТаблица.ЦенаПоступления;
			об.дн = ДатаНакладной;
			об.п =  Поставшик;
			об.Записать();
		Иначе
			об.наценка = ТекСтрокаТаблица.наценка;
				//об.Цена = ТекСтрокаТаблица.Цена;
			об.цп = ТекСтрокаТаблица.ЦенаПоступления;
			об.дн = ДатаНакладной;
			об.п =  Поставшик;
			об.Записать(Истина);
		КонецЕсли;

		об2 = Движения.ДобавлениеЗапчастей.Добавить();
		об2.ВидДвижения = ВидДвиженияНакопления.Приход;
		об2.Период = Дата;

		Если ТекСтрокаТаблица.Ответственный.Пустая() <> Истина Тогда
			об2.пользователь = ТекСтрокаТаблица.Ответственный;
				//		Иначе
				//			об2.пользователь = пн;
		КонецЕсли;
		об2.Колво = 1;
			
			// Цены номенклатуры. Закупочная на партию
		ЗаписатьЦену(ТекСтрокаТаблица, "ЦенаПоступления", ПредопределенноеЗначение("Справочник.ТипыЦен.Закупочная"));
			
			// Рекомендованная на партию
		ДанныеЗаполнения = Новый Структура("Товар,Партия,ЦенаРекомендованная");
		ЗаполнитьЗначенияСвойств(ДанныеЗаполнения, ТекСтрокаТаблица);
		ДанныеЗаполнения.ЦенаРекомендованная = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТекСтрокаТаблица.Товар,
			"РекомендованаяЦена");

		Если ЗначениеЗаполнено(ДанныеЗаполнения.ЦенаРекомендованная) Тогда
			Коэффициент = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТекСтрокаТаблица.Наценка, "Коофициент");
			Если Не ЗначениеЗаполнено(Коэффициент) Тогда
				Коэффициент = 1;
			КонецЕсли;

			ДанныеЗаполнения.ЦенаРекомендованная = ДанныеЗаполнения.ЦенаРекомендованная * Коэффициент;

			ЗаписатьЦену(ДанныеЗаполнения, "ЦенаРекомендованная", ПредопределенноеЗначение(
				"Справочник.ТипыЦен.Рекомендованная"));

		КонецЕсли;

		Если Новые Тогда
			Новые = Ложь;
			Новые = Истина;

			ЗаписатьЦену(ТекСтрокаТаблица, "Цена", ПредопределенноеЗначение("Справочник.ТипыЦен.Розничная"));
		Иначе
			ЗаписатьЦену(ДанныеЗаполнения, "ЦенаРекомендованная", ПредопределенноеЗначение(
				"Справочник.ТипыЦен.Розничная"));
		КонецЕсли;	
			
			// ТоварыОрганизаций
		Движение = Движения.ТоварыОрганизаций.Добавить();
		Движение.Период = Дата;
		Движение.Организация = Организация;
		Движение.Номенклатура = ТекСтрокаТаблица.Товар;
		Движение.Склад = Склад;
		Движение.Партия = ТекСтрокаТаблица.Партия;
		Движение.Количество = ТекСтрокаТаблица.Колво;
		Движение.Стоимость =  ТекСтрокаТаблица.СуммаПоступления;
			
			// ТоварыВТранзитнойЗоне
		Если ЭтоПоступлениеВТранзитнуюЗону Тогда

			Движение = Движения.ТоварыВТранзитнойЗоне.Добавить();
			Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
			Движение.Период = Дата;
			Движение.Номенклатура = ТекСтрокаТаблица.Товар;
			Движение.Склад = СкладТранзитный;
			Движение.Партия = ТекСтрокаТаблица.Партия;
			Движение.Автомобиль = ?(ИспользуетсяСтараяСхемаУчета, Машина, ТекСтрокаТаблица.Автомобиль);
			Движение.Распоряжение = Ссылка;
			Движение.Количество = ТекСтрокаТаблица.Колво;

		КонецЕсли;
		// Комлев АА 02/12/24 +++	
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ЗакупкаТовараЗакупленныйТовар.Товар,
		|	ЗакупкаТовараЗакупленныйТовар.НомерСтроки,
		|	ЗакупкаТовараЗакупленныйТовар.Ссылка
		|ИЗ
		|	Документ.ЗакупкаТовара.ЗакупленныйТовар КАК ЗакупкаТовараЗакупленныйТовар
		|ГДЕ
		|	ЗакупкаТовараЗакупленныйТовар.Ссылка = &Ссылка";

		Запрос.УстановитьПараметр("Ссылка", ТекСтрокаТаблица.ДокументЗакупкаТовара);

		РезультатЗапроса = Запрос.Выполнить();

		Выборка = РезультатЗапроса.Выбрать();

		Пока Выборка.Следующий() Цикл
			Если Выборка.Товар = ТекСтрокаТаблица.Товар Тогда
				ДокЗакупка = ТекСтрокаТаблица.ДокументЗакупкаТовара.ПолучитьОбъект();
				ДокЗакупка.ЗакупленныйТовар[Число(Выборка.НомерСтроки)
					- 1].СтатусПоступления = Перечисления.СтатусЗакупкиТовара.Поступил;
				ДокЗакупка.Записать();
			КонецЕсли;
		КонецЦикла;
		// Комлев АА 02/12/24 ---
	
	КонецЦикла;

	СвернутьЦены();
		
		// Наименования поставщиков
	Если ПолучитьФункциональнуюОпцию("дт_ИспользоватьНаименованияПоставщиков") И ЗначениеЗаполнено(Поставшик) Тогда

		Для Каждого СтрокаТаблицы Из ТаблицаТовары Цикл

			Если ЗначениеЗаполнено(СтрокаТаблицы.НаименованиеПоставщика) Тогда

				Запись = Движения.дт_НоменклатураПоставщиков.Добавить();

				Запись.Период = Дата;
				Запись.Контрагент = Поставшик;
				Запись.Номенклатура = СтрокаТаблицы.Товар;
				Запись.Партия = СтрокаТаблицы.Партия;
				Запись.Наименование = СтрокаТаблицы.НаименованиеПоставщика;

			КонецЕсли;

		КонецЦикла;

	КонецЕсли;
		
		// Расчеты с поставщиками
	Запись = Движения.РасчетыСПоставщиками.ДобавитьПриход();
	Запись.Период = Дата;
	Запись.Организация = Организация;
	Запись.Контрагент = ЭтотОбъект.Поставшик;
	Запись.Сделка = Ссылка;
	Запись.Сумма = Таблица.Итог("СуммаПоступления");

	Движения.Записать();
		
		// Контроль отрицательных остаткок по регистрам накопления (только в рамках Д_Доработок)
	Если Не ИспользуетсяСтараяСхемаУчета Тогда
		Документы.ПоступлениеЗапчастей.ВыполнитьКонтроль(ЭтотОбъект, ДополнительныеСвойства, Отказ);
	КонецЕсли;
		
// ++ Движение по регистру ДвижениеТМЦВорктрак (регистр ДвижениеТМЦВорктрак Приход)
	Если ТМЦ.Количество() > 0 Тогда
		Движения.ДвижениеТМЦВорктрак.Записывать = Истина;
		Для Каждого ТекСтрокаСписокТМЦ Из ТМЦ Цикл
			Запрос = Новый Запрос;
			Запрос.Текст =
			"ВЫБРАТЬ
			|	ИнвентарныеНомера.Владелец КАК ТМЦ,
			|	ИнвентарныеНомера.Наименование КАК Наименование,
			|	ИнвентарныеНомера.СерийныйНомер КАК СерийныйНомер,
			|	ИнвентарныеНомера.ДатаПоступления КАК ДатаПоступления,
			|	ИнвентарныеНомера.ДокументПоступления КАК ДокументПоступления,
			|	ИнвентарныеНомера.Ссылка КАК Ссылка,
			|	ИнвентарныеНомера.Стоимость КАК Цена
			|ИЗ
			|	Справочник.ИнвентарныеНомера КАК ИнвентарныеНомера
			|ГДЕ
			|	ИнвентарныеНомера.ДокументПоступления = &ДокументПоступления
			|	И ИнвентарныеНомера.Владелец = &Владелец";

			Запрос.УстановитьПараметр("ДокументПоступления", Ссылка);
			Запрос.УстановитьПараметр("Владелец", ТекСтрокаСписокТМЦ.Товар);

			РезультатЗапроса = Запрос.Выполнить().Выбрать();

			Если РезультатЗапроса.Количество() < 1 Тогда
				Отказ = Истина;
				Сообщение = Новый СообщениеПользователю;
				Сообщение.текст = " Товаром ТМЦ не присвоены инвентарные номера ";
				Сообщение.Сообщить();
			КонецЕсли;

			Если ТекСтрокаСписокТМЦ.ТипУчетаТМЦ = Перечисления.ТипУчетаТМЦ.УчестьПоштучно Тогда
				Пока РезультатЗапроса.Следующий() Цикл
					Движение 					= Движения.ДвижениеТМЦВорктрак.Добавить();
					Движение.ВидДвижения 		= ВидДвиженияНакопления.Приход;
					Движение.Период 			= Дата;
					Движение.ТМЦ 				= РезультатЗапроса.ТМЦ;
					Движение.МестоХранения 		= ТекСтрокаСписокТМЦ.Склад;
					Движение.ИнвентарныйНомер 	= РезультатЗапроса.Ссылка;
					Движение.Количество 		= 1;
					Движение.Цена 				= РезультатЗапроса.Цена;
				КонецЦикла;
			Иначе
				Пока РезультатЗапроса.Следующий() Цикл
					Движение 					= Движения.ДвижениеТМЦВорктрак.Добавить();
					Движение.ВидДвижения 		= ВидДвиженияНакопления.Приход;
					Движение.Период 			= Дата;
					Движение.ТМЦ 				= РезультатЗапроса.ТМЦ;
					Движение.МестоХранения 		= ТекСтрокаСписокТМЦ.Склад;
					Движение.ИнвентарныйНомер 	= РезультатЗапроса.Ссылка;
					Движение.Количество 		= ТекСтрокаСписокТМЦ.Количество;
					Движение.Цена 				= РезультатЗапроса.Цена;
				КонецЦикла;
			КонецЕсли;

		КонецЦикла;

	КонецЕсли; 
// -- Движение по регистру ДвижениеТМЦВорктрак (регистр ДвижениеТМЦВорктрак Приход)	

КонецПроцедуры

	
	Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
		Если ОбменДанными.Загрузка Тогда 
			Возврат
		КонецЕсли;
		
		дт_Склад.УстановитьТранзитныйСклад(ЭтотОбъект);
		
		// Заполнить даты создания
		Если ЭтоНовый() Тогда
			Для каждого СтрокаТовары Из Таблица Цикл
				
				Если Не ЗначениеЗаполнено(СтрокаТовары.ДатаДобавления) Тогда
					СтрокаТовары.ДатаДобавления = ТекущаяДата();
				КонецЕсли;
				
			КонецЦикла;
		КонецЕсли;
		
		СуммаНакладной = Таблица.Итог("СуммаПоступления");
		
		СуммаНакладной = СуммаНакладной + ТМЦ.Итог("Сумма"); 
		Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
			ПроверитьИсправитьПартии(Отказ);
		КонецЕсли;
		
	КонецПроцедуры
	
	Процедура ПроверитьИсправитьПартии(Отказ)
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Партии.Партия
		|ПОМЕСТИТЬ втПартии
		|ИЗ
		|	&Партии КАК Партии
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втПартии.Партия
		|ИЗ
		|	втПартии КАК втПартии
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ИндКод КАК ИндКод
		|		ПО втПартии.Партия = ИндКод.Ссылка
		|ГДЕ
		|	ИндКод.ДатаПоступления <> &ДатаПоступления";
		
		ДатаПоступения = НачалоДня(Дата);
		Запрос.УстановитьПараметр("Партии", Таблица.Выгрузить(, "Партия"));
		Запрос.УстановитьПараметр("ДатаПоступления", ДатаПоступения);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			Спр = ВыборкаДетальныеЗаписи.Партия.ПолучитьОбъект();
			Спр.ДатаПоступления = ДатаПоступения;
			Попытка
				Спр.Записать();
			Исключение
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтрШаблон("Не удалось записать %1. %2",
				Спр,
				ОписаниеОшибки()),
				,
				,
				,
				Отказ
				);
				
				
			КонецПопытки;					
			
		КонецЦикла;
	
	// ++МазинЕС 27-05-24
	Соответствие = Новый Структура; 
	ЦветСписка = Истина; 

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Заявка.Ссылка КАК Ссылка
		|ПОМЕСТИТЬ ВременнаяТаблица
		|ИЗ
		|	Документ.ЗаявкаНаРасход КАК Заявка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПоступлениеЗапчастей КАК ПоступлениеЗапчастей
		|		ПО (Заявка.Основание = ПоступлениеЗапчастей.Ссылка)
		|ГДЕ
		|	ПоступлениеЗапчастей.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СУММА(Расходы.Сумма) КАК Сумма
		|ИЗ
		|	Документ.Расходы КАК Расходы
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблица КАК ВременнаяТаблица
		|		ПО (ВременнаяТаблица.Ссылка = Расходы.ЗаявкаНаРасход)";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Соответствие.Вставить("Сумма",ВыборкаДетальныеЗаписи.Сумма);
	КонецЦикла;
	Попытка
     Если Соответствие.Сумма >= СуммаНакладной Тогда    
     ЦветСписка = Ложь; 
     Иначе 
     ЦветСписка = истина; 
     	
     КонецЕсли; 
	Исключение 
		
  	КонецПопытки;

	
	// --МазинЕС 27-05-24
		
	КонецПроцедуры
	
	Процедура ЗаписатьЦену(ДанныеЗаполнения, СвойствоЦена, ТипЦены)
		
		Если НЕ ЗначениеЗаполнено(ДанныеЗаполнения[СвойствоЦена]) Тогда
			Возврат
		КонецЕсли;
		
		Запись = Движения.дт_ЦеныНоменклатуры.Добавить();
		Запись.Период = Дата;
		Запись.Номенклатура = ДанныеЗаполнения.Товар;
		Запись.ТипЦен = ТипЦены;
		Запись.Партия = ДанныеЗаполнения.Партия;
		Запись.Цена = ДанныеЗаполнения[СвойствоЦена];
		
		
	КонецПроцедуры
	
	Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
		
		Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
			
			ЗаполнениеДокументов.Заполнить(ЭтотОбъект);
			ЗаполнениеДокументов.ЗаполнитьПоСтруктуре(ЭтотОбъект, ДанныеЗаполнения);
			
		ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаявкаНаСборку") Тогда
			
			Запрос = Новый Запрос;
			Запрос.Текст =
			"ВЫБРАТЬ
			|	Док.Проект,
			|	Док.Склад КАК Склад,
			|	Док.Ответственный КАК Ответственный,
			|	Док.Ссылка КАК Ссылка
			|ПОМЕСТИТЬ втШапка
			|ИЗ
			|	Документ.ЗаявкаНаСборку КАК Док
			|ГДЕ
			|	Док.Ссылка = &Ссылка
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	Товары.Ссылка КАК Ссылка,
			|	Товары.НомерСтроки КАК НомерСтроки,
			|	Товары.Номенклатура КАК Номенклатура,
			|	Товары.Автомобиль КАК Автомобиль,
			|	Товары.Партия КАК Партия,
			|	Товары.Количество КАК Количество
			|ПОМЕСТИТЬ втТовары
			|ИЗ
			|	Документ.ЗаявкаНаСборку.Товары КАК Товары
			|ГДЕ
			|	Товары.Ссылка = &Ссылка
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	Док.Проект,
			|	Док.Склад КАК Склад,
			|	Док.Ответственный КАК Ответственный,
			|	Док.Ссылка КАК Основание,
			|	втАвтомобили.Автомобиль КАК Машина
			|ИЗ
			|	втШапка КАК Док
			|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
			|			МАКСИМУМ(втТовары.Автомобиль) КАК Автомобиль,
			|			втТовары.Ссылка
			|		ИЗ
			|			втТовары КАК втТовары
			|		СГРУППИРОВАТЬ ПО
			|			втТовары.Ссылка) КАК втАвтомобили
			|		ПО втАвтомобили.Ссылка = Док.Ссылка
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	Товары.Номенклатура КАК Товар,
			|	ПРЕДСТАВЛЕНИЕ(Товары.Партия) КАК Код,
			|	&ТекДата КАК ДатаДобавления,
			|	Товары.Количество КАК Колво,
			|	втШапка.Ответственный
			|ИЗ
			|	втТовары КАК Товары
			|		ЛЕВОЕ СОЕДИНЕНИЕ втШапка КАК втШапка
			|		ПО втШапка.Ссылка = Товары.Ссылка
			|
			|УПОРЯДОЧИТЬ ПО
			|	Товары.НомерСтроки";
			
			
			Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
			Запрос.УстановитьПараметр("ТекДата", ТекущаяДата());
			
			РезультатЗапроса = Запрос.ВыполнитьПакет();
			
			Шапка = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(РезультатЗапроса[2].Выгрузить()[0]);
			
			ЗаполнениеДокументов.Заполнить(ЭтотОбъект, Шапка);
			
			Таблица.Загрузить(РезультатЗапроса[3].Выгрузить());
			
		ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаявкаНаРасход") тогда
			Новые = Истина;
			Состояние = Перечисления.дт_СостоянияПоступленияЗапчастей.ОжидаемТовар;
			Запрос = Новый Запрос;
			Запрос.Текст =
			"ВЫБРАТЬ
			|	ЗаявкаНаРасходЗапчасти.Ссылка КАК Ссылка,
			|	ЗаявкаНаРасходЗапчасти.Ссылка.Получатель КАК Получатель,
			|	ЗаявкаНаРасходЗапчасти.Количество КАК Количество,
			|	ЗаявкаНаРасходЗапчасти.Код КАК Код,
			|	ЗаявкаНаРасходЗапчасти.Номенклатура КАК Номенклатура,
			|	ЗаявкаНаРасходЗапчасти.НаименованиеПоНакладной КАК НаименованиеПоНакладной,
			|	ЗаявкаНаРасходЗапчасти.НомерПроизводителя КАК НомерПроизводителя,
			|	ЗаявкаНаРасходЗапчасти.Сумма КАК Сумма,
			|	ЗаявкаНаРасходЗапчасти.Цена КАК Цена,
			|	ЗаявкаНаРасходЗапчасти.Номенклатура.Производитель КАК Производитель,
			|	ЗаявкаНаРасходЗапчасти.Номенклатура.Артикул КАК Артикул
			|ИЗ
			|	Документ.ЗаявкаНаРасход.Запчасти КАК ЗаявкаНаРасходЗапчасти
			|ГДЕ
			|	ЗаявкаНаРасходЗапчасти.Ссылка = &Ссылка";
			
			
			Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения.Ссылка);
			
			РезультатЗапроса = Запрос.Выполнить().выбрать();
			
			Пока РезультатЗапроса.Следующий() цикл
				
				Поставшик 	   = РезультатЗапроса.Получатель;
				ЗаявкаНаРасход = РезультатЗапроса.Ссылка;
				
				строкаТаблицы = таблица.Добавить();
				строкаТаблицы.Товар            = РезультатЗапроса.Номенклатура;
				строкаТаблицы.Колво            = РезультатЗапроса.Количество;
				
				строкаТаблицы.ЦенаПоступления  = РезультатЗапроса.Цена;
				строкаТаблицы.СуммаПоступления = РезультатЗапроса.Сумма;
				
			КонецЦикла;
			
			//Таблица.Загрузить(РезультатЗапроса.Выгрузить());
			
			//ЗаполнениеДокументов.ЗаполнитьПоОснованию(ЭтотОбъект, ДанныеЗаполнения);
			ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
			
			//Волков 29.11.2023 ++ 
			Организация = ОтборОрганизации(ДанныеЗаполнения); 
			
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, Организация);
			//Волков 29.11.2023 --
			
		КонецЕсли;  
		
		Если НЕ ПолучитьФункциональнуюОпцию("дт_ИспользоватьРазборку") Тогда
			Новые = Истина;
		КонецЕсли;
		
		// На случай ввода на основании обнулим даты добавления строк
		//	Для каждого СтрокаТовары Из Таблица Цикл
		//		
		//		СтрокаТовары.ДатаДобавления = '00010101';
		//	
		//	КонецЦикла;
		
		Если Не ЗначениеЗаполнено(СостояниеРасчетов) Тогда
			СостояниеРасчетов = Перечисления.СостоянияВзаиморасчетов.Долг;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Состояние) Тогда
			Состояние = Перечисления.дт_СостоянияПоступленияЗапчастей.ВРаботе;
		КонецЕсли;
		Дата = НачалоДня(ТекущаяДата());
	КонецПроцедуры
	
	//Волков 29.11.2023 ++
	Функция ОтборОрганизации(ДанныеЗаполнения);
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаявкаНаРасход.Счет.Владелец КАК Счет_СпрОрганизация
		|ИЗ
		|	Документ.ЗаявкаНаРасход КАК ЗаявкаНаРасход
		|ГДЕ
		|	ЗаявкаНаРасход.Ссылка = &Ссылка";
		
		Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаШапка = РезультатЗапроса.Выбрать();	
		Пока ВыборкаШапка.Следующий() Цикл
			
			Счет = ВыборкаШапка.Счет_СпрОрганизация;
			
		КонецЦикла;
		
		Возврат Счет;
	КонецФункции
	//Волков 29.11.2023 --	
	
	Процедура ПриКопировании(ОбъектКопирования)
		
		Состояние = Перечисления.дт_СостоянияПоступленияЗапчастей.ВРаботе;
		Ответственный = Пользователи.ТекущийПользователь();
		
		// На случай копирования обнулим даты добавления строк
		Для каждого СтрокаТовары Из Таблица Цикл
			
			СтрокаТовары.ДатаДобавления = '00010101';
			
		КонецЦикла;
		
	КонецПроцедуры
	
	Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
		
		МассивНепроверяемыхРеквизитов = Новый Массив();
		
		ИспользоватьНаименованияПоставщиков = ПолучитьФункциональнуюОпцию("дт_ИспользоватьНаименованияПоставщиков");
		
		Если НЕ (Перекуп ИЛИ Новые) Тогда	
			МассивНепроверяемыхРеквизитов.Добавить("Поставшик");	
		КонецЕсли;
		
		Если НЕ ИспользоватьНаименованияПоставщиков
			ИЛИ НЕ ЗначениеЗаполнено(Поставшик)
			ИЛИ дт_ОбщегоНазначенияВызовСервераПовтИсп.ДатаНачалаУчетаНаименованийПоставщиков() > Дата Тогда
			
			МассивНепроверяемыхРеквизитов.Добавить("Таблица.НаименованиеПоставщика");
			
		КонецЕсли;
		
		
		// Складской учет
		УчетПоСкладам = дт_ОбщегоНазначенияКлиентСервер.УчетПоСкладам(Дата);
		
		Если НЕ УчетПоСкладам Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Склад");
		КонецЕсли;
		
		УчетНДС = Ложь;
		Если ЗначениеЗаполнено(Организация) Тогда
			УчетНДС = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "ЕстьУчетНДС");
		КонецЕсли;
		
		Если Не Новые Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Контрагенты");
			МассивНепроверяемыхРеквизитов.Добавить("Таблица.Колво");
			МассивНепроверяемыхРеквизитов.Добавить("Таблица.ЦенаПоступления");
		КонецЕсли;
		
		Если (Не Новые) ИЛИ (НЕ УчетНДС) Тогда
			МассивНепроверяемыхРеквизитов.Добавить("НомерНакладной");
			МассивНепроверяемыхРеквизитов.Добавить("ДатаНакладной");
			МассивНепроверяемыхРеквизитов.Добавить("НомерСчетФактуры");
			МассивНепроверяемыхРеквизитов.Добавить("ДатаСчетФактура");
		КонецЕсли;
		
		ИспользуетсяСтараяСхемаУчета = Дата < дт_Склад.ДатаНачалаИспользованияЗаявокНаСборку();
		Если ИспользуетсяСтараяСхемаУчета Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Таблица.Автомобиль");
			МассивНепроверяемыхРеквизитов.Добавить("Таблица.Партия");
		КонецЕсли;
		
		Если ЭтотОбъект.Новые Или ЭтотОбъект.Перекуп Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Таблица.Автомобиль");
		КонецЕсли;	
		
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
		
		
	КонецПроцедуры
	
	
	#КонецОбласти
	
	#Область СлужебныеПроцедурыИФункции
	
	Функция СсылкаИндКод(код, Номенклатура, Отказ) Экспорт
		
		Возврат Справочники.ИндКод.ПолучитьПартиюПоКоду(Код, Номенклатура, ЭтотОбъект, Отказ);
		
	КонецФункции
	
	Процедура ПроверитьРазрешенияПриСтаройСхемеУчета(Отказ)
		
		Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
			Возврат
		КонецЕсли;
		
		// Проверим разрешено ли добавление
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	СУММА(1) КАК КоличествоСтрок
		|ИЗ
		|	Документ.ПоступлениеЗапчастей.Таблица КАК ПоступлениеЗапчастейТаблица
		|ГДЕ
		|	ПоступлениеЗапчастейТаблица.Ссылка = &Ссылка";
		
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		КоличествоСтрок = 0; 
		Если ВыборкаДетальныеЗаписи.Следующий() Тогда
			КоличествоСтрок = ВыборкаДетальныеЗаписи.КоличествоСтрок;
			Если КоличествоСтрок = null Тогда
				КоличествоСтрок = 0;
			КонецЕсли;
		КонецЕсли;
		
		Если Таблица.Количество() > КоличествоСтрок Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрШаблон("Запрещено добавление строк в старых документах (до %1) без заявки на сборку", 
			Формат(дт_Склад.ДатаНачалаИспользованияЗаявокНаСборку(), "ДЛФ=D;")),
			,
			,
			,
			Отказ
			);
			
		КонецЕсли;
		
	КонецПроцедуры
	
	Процедура СвернутьЦены() 
		
		ТаблицаЦены = Движения.дт_ЦеныНоменклатуры.Выгрузить();
		Запрос = Новый Запрос();
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаЦены.Номенклатура КАК Номенклатура,
		|	ТаблицаЦены.Период КАК Период,
		|	ТаблицаЦены.ТипЦен КАК ТипЦен,
		|	ТаблицаЦены.Партия КАК Партия,
		|	ТаблицаЦены.Цена КАК Цена
		|ПОМЕСТИТЬ втЦены
		|ИЗ
		|	&ТаблицаЦены КАК ТаблицаЦены
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втЦены.Номенклатура КАК Номенклатура,
		|	втЦены.Период КАК Период,
		|	втЦены.ТипЦен КАК ТипЦен,
		|	втЦены.Партия КАК Партия,
		|	МАКСИМУМ(втЦены.Цена) КАК Цена
		|ИЗ
		|	втЦены КАК втЦены
		|
		|СГРУППИРОВАТЬ ПО
		|	втЦены.ТипЦен,
		|	втЦены.Партия,
		|	втЦены.Период,
		|	втЦены.Номенклатура";
		
		Запрос.УстановитьПараметр("ТаблицаЦены", ТаблицаЦены);
		РезультатЗапроса = Запрос.Выполнить();
		
		Движения.дт_ЦеныНоменклатуры.Загрузить(РезультатЗапроса.Выгрузить());
		
	КонецПроцедуры
	
	
    Процедура ОбработкаУдаленияПроведения  (Отказ)
		///Удаляем записи из регистра "НаименованиеТМЦПоНакладной" и Удаление инвентарного номера
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИнвентарныеНомера.Код КАК Код,
		|	ИнвентарныеНомера.Ссылка КАК Ссылка,
		|	ИнвентарныеНомера.Владелец КАК Владелец,
		|	ИнвентарныеНомера.ДокументПоступления КАК ДокументПоступления,
		|	ИнвентарныеНомера.Наименование КАК Наименование
		|ИЗ
		|	Справочник.ИнвентарныеНомера КАК ИнвентарныеНомера
		|ГДЕ
		|	ИнвентарныеНомера.ДокументПоступления = &ДокументПоступления
		|
		|УПОРЯДОЧИТЬ ПО
		|	Код УБЫВ";
	
	Запрос.УстановитьПараметр("ДокументПоступления", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		// Удаляем записи из регистра "НаименованиеТМЦПоНакладной"
		НаборЗаписей=РегистрыСведений.НаименованиеТМЦПоНакладной.СоздатьМенеджерЗаписи();
        НаборЗаписей.ИнвентарныйНомер = ВыборкаДетальныеЗаписи.Ссылка;       
        НаборЗаписей.Прочитать();
        НаборЗаписей.Удалить();
        
        //Удаление инвентарного номера
        ВыборкаСсылка = ВыборкаДетальныеЗаписи.Ссылка; 
		ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект().Удалить(); 
		
	КонецЦикла;
	
//	/// --- Удаляем записи из регистра "НаименованиеТМЦПоНакладной" и Удаление инвентарного номера
		
	КонецПроцедуры
	
	
	#КонецОбласти
	
#КонецЕсли