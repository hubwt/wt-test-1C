
#Область ПрограммныйИнтерфейс
Процедура ЗаблокироватьПродажиЗаПрошлыйМесяц() Экспорт
	// КомлевАА +++
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПродажаЗапчастей.Ссылка КАК Ссылка,
		|	ПродажаЗапчастей.Дата КАК Дата,
		|	ПродажаЗапчастей.ПродажаЗаблокированаДляИзменения КАК ПродажаЗаблокированаДляИзменения
		|ИЗ
		|	Документ.ПродажаЗапчастей КАК ПродажаЗапчастей
		|ГДЕ
		|	ПродажаЗапчастей.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания"; 
	
	ДатаНачала = ДобавитьМесяц(ТекущаяДата(), -6);
	
	Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ТекущаяДата());
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл 
		Если Месяц(Выборка.Дата) <> Месяц(ТекущаяДата())И Выборка.ПродажаЗаблокированаДляИзменения = Ложь Тогда 
			Продажа = Выборка.Ссылка.ПолучитьОбъект();
			Продажа.ПродажаЗаблокированаДляИзменения = Истина;
			Продажа.Записать(); 
		Иначе 
			Продолжить;
		КонецЕсли;
	КонецЦикла;
	// КомлевАА ---
КонецПроцедуры

// Проставить в Номенклатуре процент менеджеру от продажи этого товара, в зависимости от категории товара.
Процедура ПроставитьПроцентМенеджераВНоменклатуре() Экспорт
	// КомлевАА +++
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаказКлиентаТовары.Номенклатура КАК Номенклатура,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказКлиентаТовары.Ссылка) КАК КоличествоЗаявок
	|ПОМЕСТИТЬ ТоварыИзЗаявок
	|ИЗ
	|	Документ.ЗаказКлиента.Товары КАК ЗаказКлиентаТовары
	|ГДЕ
	|	ЗаказКлиентаТовары.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗаказКлиентаТовары.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СпрНоменклатура.Ссылка КАК Товар,
	|	ВЫБОР
	|		КОГДА СпрНоменклатура.ДатаСоздания > &ДатаПолгодаНазад
	|			ТОГДА ""Новые""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|				И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) = 0
	|			ТОГДА ""Низкий спрос (Нет заявок)""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|				И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) > 0
	|				И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) <= 1
	|			ТОГДА ""Категория 8 (1 Заявка)""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|				И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) > 1
	|				И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) <= 3
	|			ТОГДА ""Категория 7 (от 2 до 3)""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|				И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) > 3
	|				И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) <= 7
	|			ТОГДА ""Категория 6 (от 3 до 7)""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|				И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) > 7
	|				И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) <= 13
	|			ТОГДА ""Категория 5 (от 7 до 13)""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|				И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) > 13
	|				И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) <= 33
	|			ТОГДА ""Категория 4 (от 13 до 33)""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|				И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) > 33
	|				И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) <= 50
	|			ТОГДА ""Категория 3 (от 33 до 50)""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|				И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) > 50
	|				И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) <= 100
	|			ТОГДА ""Категория 2 (от 50 до 100)""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|				И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) > 100
	|			ТОГДА ""Высокий спрос (от 100)""
	|	КОНЕЦ КАК Категория
	|ИЗ
	|	Справочник.Номенклатура КАК СпрНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТоварыИзЗаявок КАК ТоварыИзЗаявок
	|		ПО (ТоварыИзЗаявок.Номенклатура = СпрНоменклатура.Ссылка)";

	ДатаПолгодаНазад = ДобавитьМесяц(ТекущаяДата(), -6);

	Запрос.УстановитьПараметр("ДатаПолгодаНазад", ДатаПолгодаНазад);

	РезультатЗапроса = Запрос.Выполнить();

	Выборка = РезультатЗапроса.Выбрать();

	Пока Выборка.Следующий() Цикл
		НоменклатураОбъект = Выборка.Товар.ПолучитьОбъект();
		Если Выборка.Категория = "Новые" Тогда
			НоменклатураОбъект.ПроцентМенеджераНаНеЛиквид = 0;
			НоменклатураОбъект.Записать();
			Продолжить;
		КонецЕсли;
		Если Выборка.Категория = "Низкий спрос (Нет заявок)" Тогда
			Если НоменклатураОбъект.ПроцентМенеджераНаНеЛиквид <> 20 Тогда
				НоменклатураОбъект.ПроцентМенеджераНаНеЛиквид = 20;
				НоменклатураОбъект.Записать();
				Продолжить;
			Иначе
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		Если Выборка.Категория = "Категория 8 (1 Заявка)" Тогда
			Если НоменклатураОбъект.ПроцентМенеджераНаНеЛиквид <> 10 Тогда
				НоменклатураОбъект.ПроцентМенеджераНаНеЛиквид = 10;
				НоменклатураОбъект.Записать();
				Продолжить;
			Иначе
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		Если Выборка.Категория = "Категория 7 (от 2 до 3)" Тогда
			Если НоменклатураОбъект.ПроцентМенеджераНаНеЛиквид <> 9 Тогда
				НоменклатураОбъект.ПроцентМенеджераНаНеЛиквид = 9;
				НоменклатураОбъект.Записать();
				Продолжить;
			Иначе
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		Если Выборка.Категория = "Категория 6 (от 3 до 7)" Тогда
			Если НоменклатураОбъект.ПроцентМенеджераНаНеЛиквид <> 8 Тогда
				НоменклатураОбъект.ПроцентМенеджераНаНеЛиквид = 8;
				НоменклатураОбъект.Записать();
				Продолжить;
			Иначе
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		Если Выборка.Категория = "Категория 5 (от 7 до 13)" Тогда
			Если НоменклатураОбъект.ПроцентМенеджераНаНеЛиквид <> 7 Тогда
				НоменклатураОбъект.ПроцентМенеджераНаНеЛиквид = 7;
				НоменклатураОбъект.Записать();
				Продолжить;
			Иначе
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		Если Выборка.Категория = "Категория 4 (от 13 до 33)" Тогда
			Если НоменклатураОбъект.ПроцентМенеджераНаНеЛиквид <> 6 Тогда
				НоменклатураОбъект.ПроцентМенеджераНаНеЛиквид = 6;
				НоменклатураОбъект.Записать();
				Продолжить;
			Иначе
				Продолжить;
			КонецЕсли;
		КонецЕсли;

		Если Выборка.Категория = "Категория 3 (от 33 до 50)" Или Выборка.Категория = "Категория 2 (от 50 до 100)"
			Или Выборка.Категория = "Высокий спрос (от 100)" Тогда
			Если НоменклатураОбъект.ПроцентМенеджераНаНеЛиквид <> 3 Тогда
				НоменклатураОбъект.ПроцентМенеджераНаНеЛиквид = 3;
				НоменклатураОбъект.Записать();
				Продолжить;
			Иначе
				Продолжить;
			КонецЕсли;
		КонецЕсли;

	КонецЦикла;
	// КомлевАА +++
КонецПроцедуры

Функция ПараметрыЗаполненияВременнойТаблицыТоваров() Экспорт
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ПересчитыватьВВалютуРегл", Ложь);
	СтруктураПараметров.Вставить("ВключаяНомераГТД", Ложь);
	СтруктураПараметров.Вставить("ВключаяДоКорректировки", Ложь);
	СтруктураПараметров.Вставить("АктуализироватьРасчеты", Истина);
	СтруктураПараметров.Вставить("ВключатьУслуги", Истина);
	СтруктураПараметров.Вставить("ВключатьТоварыНаКомиссии", Истина);
	
	Возврат СтруктураПараметров;
	
КонецФункции

Процедура СброситьФлагПерезвонилиУКлиента() Экспорт
	// КомлевАА +++
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПродажаЗапчастей.Клиент КАК Клиент
	|ПОМЕСТИТЬ КлиентыПолучившиеДоставку
	|ИЗ
	|	Документ.ПродажаЗапчастей КАК ПродажаЗапчастей
	|ГДЕ
	|	(ПродажаЗапчастей.ЕстьДоставка
	|	И ПродажаЗапчастей.ДатаПолучения МЕЖДУ &ДатаНачала И &ДатаОкончания)
	|	ИЛИ (ПродажаЗапчастей.Самовывоз
	|	И ПродажаЗапчастей.ДатаОтгрузкиСоСклада МЕЖДУ &ДатаНачала И &ДатаОкончания)
	|СГРУППИРОВАТЬ ПО
	|	ПродажаЗапчастей.Клиент
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Клиенты.Ссылка КАК Клиент
	|ИЗ
	|	Справочник.Клиенты КАК Клиенты
	|ГДЕ
	|	НЕ Клиенты.Ссылка В
	|		(Выбрать
	|			КлиентыПолучившиеДоставку.Клиент
	|		Из
	|			КлиентыПолучившиеДоставку КАК КлиентыПолучившиеДоставку)
	|	И Клиенты.ПерезвонилиПослеДоставки = ИСТИНА";

	ДатаВПрошлом  = НачалоДня(ТекущаяДата() - (24 * 60 * 60) * 10);

	Запрос.УстановитьПараметр("ДатаНачала", ДатаВПрошлом);
	Запрос.УстановитьПараметр("ДатаОкончания", КонецДня(ТекущаяДата()));
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			КлиентОбъект = Выборка.Клиент.ПолучитьОбъект();
			КлиентОбъект.ПерезвонилиПослеДоставки = Ложь;
			КлиентОбъект.Записать();
		КонецЦикла;
	КонецЕсли;
// КомлевАА +++
КонецПроцедуры



#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс



#КонецОбласти

#Область СлужебныеПроцедурыИФункции



#КонецОбласти