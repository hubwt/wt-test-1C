#Область ОбработчикиСобытийФормы 
&НаКлиенте
Процедура ПриОткрытии(Отказ)

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	/// Комлев АА 19/11/24 +++
	ВсеГода = 1;
	Элементы.Год.СписокВыбора.ЗагрузитьЗначения(СформироватьСвойМассивЗначений());
	ДатаПолгодаНазад = ДобавитьМесяц(ТекущаяДата(), - 6);
	СписокНоменклатурыКоэффицент.Параметры.УстановитьЗначениеПараметра("ДатаПолгодаНазад", НачалоДня(ДатаПолгодаНазад));
	КоличествоТоваровВКатегрии.Параметры.УстановитьЗначениеПараметра("ДатаПолгодаНазад", НачалоДня(ДатаПолгодаНазад));
	СписокНоменклатурыКоэффицент.Параметры.УстановитьЗначениеПараметра("Склад", Справочники.Склады.НайтиПоКоду("000000002"));
	УсловноеОФормлениеСписокТоваровКоэффицент() ;
	/// Комлев АА 19/11/24 ---
КонецПроцедуры

&НаКлиенте
Процедура ГодНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	/// Комлев АА 14/11/24 +++
	СтандартнаяОбработка = Ложь;
	Элемент.СписокВыбора.ЗагрузитьЗначения(СформироватьСвойМассивЗначений());
	/// Комлев АА 14/11/24 ---
КонецПроцедуры

&НаКлиенте
Процедура ГодОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Год = ВыбранноеЗначение;
КонецПроцедуры

&НаКлиенте
Процедура ГодПриИзменении(Элемент)
	/// Комлев АА 19/11/24 +++
	ВсеГода = 2;
	КоэффицентПоГоду();
	/// Комлев АА 19/11/24 ---
КонецПроцедуры

&НаКлиенте
Процедура ВсеГодаПриИзменении(Элемент)
	/// Комлев АА 19/11/24 +++
	Год = Дата(1, 1, 1);
	Если ВсеГода = 1 Тогда
		ТекстЗапросаВсеКоэффВсеГода();
	КонецЕсли;
	/// Комлев АА 19/11/24 ---
КонецПроцедуры


&НаКлиенте
Процедура СписокНоменклатурыКоэффицентВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	/// Комлев АА 25/11/24 ---
	Если Поле = Элементы.СписокНоменклатурыКоэффицентОстатокСовпадает Тогда
		СтандартнаяОбработка = Ложь;
		ТекущиеДанные = Элемент.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда
			Если ТекущиеДанные.ОстатокСовпадает = Ложь Тогда
				ПроставитьГалочкуОстатокСовпадает(ТекущиеДанные.Товар);
			Иначе
				СнятьГалочкуОстатокСовпадает(ТекущиеДанные.Товар);
			КонецЕсли;
		КонецЕсли;
		Элементы.СписокНоменклатурыКоэффицент.Обновить();
	КонецЕсли;
	/// Комлев АА 25/11/24 ---
	
	/// Комлев АА 29/11/24 +++
	Если Поле = Элементы.СписокНоменклатурыКоэффицентОписаниеЗаполнено Тогда
		СтандартнаяОбработка = Ложь;
		ТекущиеДанные = Элемент.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда
			Если ТекущиеДанные.ОписаниеЗаполнено = Ложь Тогда
				ПроставитьГалочкуОписаниеЗаполнено(ТекущиеДанные.Товар);
			Иначе
				СнятьГалочкуОписаниеЗаполнено(ТекущиеДанные.Товар);
			КонецЕсли;
		КонецЕсли;
		Элементы.СписокНоменклатурыКоэффицент.Обновить();
	КонецЕсли;
	/// Комлев АА 29/11/24 ---
КонецПроцедуры


Процедура УсловноеОФормлениеСписокТоваровКоэффицент() 
	/// Комлев АА 19/11/24 ++++
	ЭлементОформления = СписокНоменклатурыКоэффицент.УсловноеОформление.Элементы.Добавить();
	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("КолвоОстаток");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = 0;
	ЭлементОтбора.Использование = Истина;
	ПолеОформления = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных("КолвоОстаток");
	ПолеОформления.Использование = Истина;
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона", WebЦвета.СветлоКоралловый);
	
	ЭлементОформления = СписокНоменклатурыКоэффицент.УсловноеОформление.Элементы.Добавить();
	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("КолвоОстаток");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = 1;
	ЭлементОтбора.Использование = Истина;
	ПолеОформления = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных("КолвоОстаток");
	ПолеОформления.Использование = Истина;
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона", WebЦвета.СветлоНебесноГолубой);
	
	
	ЭлементОформления = СписокНоменклатурыКоэффицент.УсловноеОформление.Элементы.Добавить();
	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("КолвоОстаток");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = 2;
	ЭлементОтбора.Использование = Истина;
	ПолеОформления = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных("КолвоОстаток");
	ПолеОформления.Использование = Истина;
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона", WebЦвета.СветлоЗолотистый);
	
	
	ЭлементОформления = СписокНоменклатурыКоэффицент.УсловноеОформление.Элементы.Добавить();
	ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("КолвоОстаток");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = 3;
	ЭлементОтбора.Использование = Истина;
	ПолеОформления = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеОформления.Поле = Новый ПолеКомпоновкиДанных("КолвоОстаток");
	ПолеОформления.Использование = Истина;
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона", WebЦвета.БледноЗеленый);
	/// Комлев АА 19/11/24 ---
КонецПроцедуры

#КонецОбласти
#Область СлужебныеПроцедурыИФункции
Функция СформироватьСвойМассивЗначений()
	/// Комлев АА 14/11/24 +++
	МассивГодов = Новый Массив;
	МассивГодов.Добавить(Дата(Год(ТекущаяДата()), 1, 1));
	Индекс = 7;
	ТекДата = ТекущаяДата();
	Пока Индекс <> 0 Цикл
		ТекДата =  ДобавитьМесяц(ТекДата, -12);
		МассивГодов.Добавить(Дата(Год(ТекДата), 1, 1));
		Индекс = Индекс - 1;
	КонецЦикла;
	Возврат МассивГодов;
	/// Комлев АА 14/11/24 ---
КонецФункции

&НаСервереБезКонтекста
Процедура СнятьГалочкуОписаниеЗаполнено(СсылкаНаНоменклатуру)
	/// Комлев АА 25/11/24 +++
	НоменклатураОбъект = СсылкаНаНоменклатуру.ПолучитьОбъект();
	НоменклатураОбъект.ОписаниеЗаполнено  = Ложь;
	НоменклатураОбъект.Записать();
	/// Комлев АА 25/11/24 ---
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПроставитьГалочкуОписаниеЗаполнено(СсылкаНаНоменклатуру)
	/// Комлев АА 25/11/24 +++
	НоменклатураОбъект = СсылкаНаНоменклатуру.ПолучитьОбъект();
	НоменклатураОбъект.ОписаниеЗаполнено  = Истина;
	НоменклатураОбъект.Записать();
	/// Комлев АА 25/11/24 ---
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СнятьГалочкуОстатокСовпадает(СсылкаНаНоменклатуру)
	/// Комлев АА 25/11/24 +++
	НоменклатураОбъект = СсылкаНаНоменклатуру.ПолучитьОбъект();
	НоменклатураОбъект.ОстатокСовпадает  = Ложь;
	НоменклатураОбъект.Записать();
	/// Комлев АА 25/11/24 ---
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПроставитьГалочкуОстатокСовпадает(СсылкаНаНоменклатуру)
	/// Комлев АА 25/11/24 +++
	НоменклатураОбъект = СсылкаНаНоменклатуру.ПолучитьОбъект();
	НоменклатураОбъект.ОстатокСовпадает  = Истина;
	НоменклатураОбъект.Записать();
	/// Комлев АА 25/11/24 ---
КонецПроцедуры

Процедура ТекстЗапросаВсеКоэффВсеГода()
	/// Комлев АА 19/11/24 +++
	Текст = "ВЫБРАТЬ
	|	ЗаказКлиентаТовары.Номенклатура КАК Номенклатура,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказКлиентаТовары.Ссылка) КАК КоличествоЗаявок
	|ПОМЕСТИТЬ ТоварыИзЗаявок
	|ИЗ
	|	Документ.ЗаказКлиента.Товары КАК ЗаказКлиентаТовары
	|ГДЕ
	|	ЗаказКлиентаТовары.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|СГРУППИРОВАТЬ ПО
	|	ЗаказКлиентаТовары.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РегистрНакопления1Остатки.Товар КАК Товар,
	|	КОЛИЧЕСТВО(РегистрНакопления1Остатки.КолвоОстаток) КАК КолвоОстаток,
	|	СУММА(ИндНомер.Цена) КАК Сумма
	|ПОМЕСТИТЬ ОстаткиСумма
	|ИЗ
	|	РегистрНакопления.РегистрНакопления1.Остатки КАК РегистрНакопления1Остатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИндНомер КАК ИндНомер
	|		ПО ИндНомер.индкод = РегистрНакопления1Остатки.индкод
	|ГДЕ
	|	РегистрНакопления1Остатки.КолвоОстаток > 0
	|СГРУППИРОВАТЬ ПО
	|	РегистрНакопления1Остатки.Товар
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СпрНоменклатура.Ссылка КАК Товар,
	|	СпрНоменклатура.Артикул КАК Артикул,
	|	ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) КАК КоличествоЗаявок,
	|	12 КАК Месяцев,
	|	ВЫРАЗИТЬ(ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) / 12 КАК ЧИСЛО(10, 2)) КАК Коэффицент,
	|	ЕстьNULL(ОстаткиСумма.КолвоОстаток, 0) КАК КолвоОстаток,
	|	ОстаткиСумма.Сумма КАК Сумма,
	|	ВЫБОР
	|		КОГДА СпрНоменклатура.ДатаСоздания > &ДатаПолгодаНазад
	|			ТОГДА ""Новые""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) = 0
	|			ТОГДА ""Низкий спрос (Нет заявок)""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) > 0
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) <= 1
	|			ТОГДА ""Категория 8 (1 Заявка)""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) > 1
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) <= 3
	|			ТОГДА ""Категория 7 (от 2 до 3)""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) > 3
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) <= 7
	|			ТОГДА ""Категория 6 (от 3 до 7)""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) > 7
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) <= 13
	|			ТОГДА ""Категория 5 (от 7 до 13)""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) > 13
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) <= 33
	|			ТОГДА ""Категория 4 (от 13 до 33)""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) > 33
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) <= 50
	|			ТОГДА ""Категория 3 (от 33 до 50)""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) > 50
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) <= 100
	|			ТОГДА ""Категория 2 (от 50 до 100)""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) > 100
	|			ТОГДА ""Высокий спрос (от 100)""
	|	КОНЕЦ КАК Категория,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ОстаткиСумма.КолвоОстаток, 0) = 0
	|		ИЛИ ЕСТЬNULL(ОстаткиСумма.КолвоОстаток, 0) = 1
	|		ИЛИ ЕСТЬNULL(ОстаткиСумма.КолвоОстаток, 0) = 2
	|		ИЛИ ЕСТЬNULL(ОстаткиСумма.КолвоОстаток, 0) = 3
	|			ТОГДА СпрНоменклатура.РекомендованаяЦена
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК РекомендованаяЦена,
	|	СпрНоменклатура.Код,
	|	СпрНоменклатура.ОстатокСовпадает,
	|	дт_МестаХраненияНоменклатурыСрезПоследних.МестоХранения,
	|	СпрНоменклатура.ПроцентМенеджераНаНеЛиквид КАК ПроцентМенеджера,
	|	СпрНоменклатура.ОписаниеЗаполнено
	|ИЗ
	|	Справочник.Номенклатура КАК СпрНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТоварыИзЗаявок КАК ТоварыИзЗаявок
	|		ПО ТоварыИзЗаявок.Номенклатура = СпрНоменклатура.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ ОстаткиСумма КАК ОстаткиСумма
	|		ПО ОстаткиСумма.Товар = СпрНоменклатура.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.дт_МестаХраненияНоменклатуры.СрезПоследних(, Склад = &Склад) КАК
	|			дт_МестаХраненияНоменклатурыСрезПоследних
	|		ПО дт_МестаХраненияНоменклатурыСрезПоследних.Номенклатура = СпрНоменклатура.Ссылка";
	
	ТекстСГруппировкой = "ВЫБРАТЬ
	|	ЗаказКлиентаТовары.Номенклатура КАК Номенклатура,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказКлиентаТовары.Ссылка) КАК КоличествоЗаявок
	|ПОМЕСТИТЬ ТоварыИзЗаявок
	|ИЗ
	|	Документ.ЗаказКлиента.Товары КАК ЗаказКлиентаТовары
	|ГДЕ
	|	ЗаказКлиентаТовары.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|СГРУППИРОВАТЬ ПО
	|	ЗаказКлиентаТовары.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РегистрНакопления1Остатки.Товар КАК Товар,
	|	КОЛИЧЕСТВО(РегистрНакопления1Остатки.КолвоОстаток) КАК КолвоОстаток,
	|	СУММА(ИндНомер.Цена) КАК Сумма
	|ПОМЕСТИТЬ ОстаткиСумма
	|ИЗ
	|	РегистрНакопления.РегистрНакопления1.Остатки КАК РегистрНакопления1Остатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИндНомер КАК ИндНомер
	|		ПО ИндНомер.индкод = РегистрНакопления1Остатки.индкод
	|ГДЕ
	|	РегистрНакопления1Остатки.КолвоОстаток > 0
	|СГРУППИРОВАТЬ ПО
	|	РегистрНакопления1Остатки.Товар
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СпрНоменклатура.Ссылка КАК Товар,
	|	СпрНоменклатура.Артикул КАК Артикул,
	|	ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) КАК КоличествоЗаявок,
	|	12 КАК Месяцев,
	|	ВЫРАЗИТЬ(ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) / 12 КАК ЧИСЛО(10, 2)) КАК Коэффицент,
	|	ЕСТЬNULL(ОстаткиСумма.КолвоОстаток, 0) КАК КолвоОстаток,
	|	ОстаткиСумма.Сумма КАК Сумма,
	|	ВЫБОР
	|		КОГДА СпрНоменклатура.ДатаСоздания > &ДатаПолгодаНазад
	|			ТОГДА ""Новые""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) = 0
	|			ТОГДА ""Низкий спрос (Нет заявок)""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) > 0
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) <= 1
	|			ТОГДА ""Категория 8 (1 Заявка)""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) > 1
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) <= 3
	|			ТОГДА ""Категория 7 (от 2 до 3)""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) > 3
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) <= 7
	|			ТОГДА ""Категория 6 (от 3 до 7)""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) > 7
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) <= 13
	|			ТОГДА ""Категория 5 (от 7 до 13)""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) > 13
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) <= 33
	|			ТОГДА ""Категория 4 (от 13 до 33)""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) > 33
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) <= 50
	|			ТОГДА ""Категория 3 (от 33 до 50)""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) > 50
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) <= 100
	|			ТОГДА ""Категория 2 (от 50 до 100)""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) > 100
	|			ТОГДА ""Высокий спрос (от 100)""
	|	КОНЕЦ КАК Категория,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ОстаткиСумма.КолвоОстаток, 0) = 0
	|		ИЛИ ЕСТЬNULL(ОстаткиСумма.КолвоОстаток, 0) = 1
	|		ИЛИ ЕСТЬNULL(ОстаткиСумма.КолвоОстаток, 0) = 2
	|		ИЛИ ЕСТЬNULL(ОстаткиСумма.КолвоОстаток, 0) = 3
	|			ТОГДА СпрНоменклатура.РекомендованаяЦена
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК РекомендованаяЦена
	|ПОМЕСТИТЬ ГотоваяТаблица
	|ИЗ
	|	Справочник.Номенклатура КАК СпрНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТоварыИзЗаявок КАК ТоварыИзЗаявок
	|		ПО (ТоварыИзЗаявок.Номенклатура = СпрНоменклатура.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ОстаткиСумма КАК ОстаткиСумма
	|		ПО (ОстаткиСумма.Товар = СпрНоменклатура.Ссылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ГотоваяТаблица.Категория КАК Категория,
	|	СУММА(ГотоваяТаблица.РекомендованаяЦена) КАК СуммаДенегНаЗакуп,
	|	КОЛИЧЕСТВО(ГотоваяТаблица.Товар) КАК КоличествоТоваров0
	|ПОМЕСТИТЬ ДеньгиНаЗакупкуИКоличествоТоваровОстаток0
	|ИЗ
	|	ГотоваяТаблица КАК ГотоваяТаблица
	|ГДЕ
	|	ГотоваяТаблица.КолвоОстаток = 0
	|СГРУППИРОВАТЬ ПО
	|	ГотоваяТаблица.Категория
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ГотоваяТаблица.Категория КАК Категория,
	|	КОЛИЧЕСТВО(ГотоваяТаблица.Товар) КАК КоличествоТоваров1
	|ПОМЕСТИТЬ КоличествоТоваровОстаток1
	|ИЗ
	|	ГотоваяТаблица КАК ГотоваяТаблица
	|ГДЕ
	|	ГотоваяТаблица.КолвоОстаток = 1
	|СГРУППИРОВАТЬ ПО
	|	ГотоваяТаблица.Категория
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ГотоваяТаблица.Категория КАК Категория,
	|	КОЛИЧЕСТВО(ГотоваяТаблица.Товар) КАК КоличествоТоваров2
	|ПОМЕСТИТЬ КоличествоТоваровОстаток2
	|ИЗ
	|	ГотоваяТаблица КАК ГотоваяТаблица
	|ГДЕ
	|	ГотоваяТаблица.КолвоОстаток = 2
	|СГРУППИРОВАТЬ ПО
	|	ГотоваяТаблица.Категория
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ГотоваяТаблица.Категория КАК Категория,
	|	КОЛИЧЕСТВО(ГотоваяТаблица.Товар) КАК КоличествоТоваров3
	|ПОМЕСТИТЬ КоличествоТоваровОстаток3
	|ИЗ
	|	ГотоваяТаблица КАК ГотоваяТаблица
	|ГДЕ
	|	ГотоваяТаблица.КолвоОстаток = 3
	|СГРУППИРОВАТЬ ПО
	|	ГотоваяТаблица.Категория
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ГотоваяТаблица.Категория КАК Категория,
	|	МАКСИМУМ(ДеньгиНаЗакупкуИКоличествоТоваровОстаток0.СуммаДенегНаЗакуп) КАК СуммаЗакупа,
	|	МАКСИМУМ(ДеньгиНаЗакупкуИКоличествоТоваровОстаток0.КоличествоТоваров0) КАК Остаток0,
	|	МАКСИМУМ(КоличествоТоваровОстаток1.КоличествоТоваров1) КАК Остаток1,
	|	МАКСИМУМ(КоличествоТоваровОстаток2.КоличествоТоваров2) КАК Остаток2,
	|	МАКСИМУМ(КоличествоТоваровОстаток3.КоличествоТоваров3) КАК Остаток3,
	|	КОЛИЧЕСТВО(ГотоваяТаблица.Товар) КАК КоличествоТоваров,
	|	Сумма(ГотоваяТаблица.Сумма) КАК СуммаОстатков,
	|	МАКСИМУМ(ГотоваяТаблица.Товар.ПроцентМенеджераНаНеЛиквид) КАК ПроцентМенеджера
	|ИЗ
	|	ГотоваяТаблица КАК ГотоваяТаблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ ДеньгиНаЗакупкуИКоличествоТоваровОстаток0 КАК ДеньгиНаЗакупкуИКоличествоТоваровОстаток0
	|		ПО (ГотоваяТаблица.Категория = ДеньгиНаЗакупкуИКоличествоТоваровОстаток0.Категория)
	|		ЛЕВОЕ СОЕДИНЕНИЕ КоличествоТоваровОстаток1 КАК КоличествоТоваровОстаток1
	|		ПО (ГотоваяТаблица.Категория = КоличествоТоваровОстаток1.Категория)
	|		ЛЕВОЕ СОЕДИНЕНИЕ КоличествоТоваровОстаток2 КАК КоличествоТоваровОстаток2
	|		ПО (ГотоваяТаблица.Категория = КоличествоТоваровОстаток2.Категория)
	|		ЛЕВОЕ СОЕДИНЕНИЕ КоличествоТоваровОстаток3 КАК КоличествоТоваровОстаток3
	|		ПО (КоличествоТоваровОстаток3.Категория = ГотоваяТаблица.Категория)
	|СГРУППИРОВАТЬ ПО
	|	ГотоваяТаблица.Категория";
	
	
	СписокНоменклатурыКоэффицент.ПроизвольныйЗапрос = Истина;
	СписокНоменклатурыКоэффицент.ТекстЗапроса = Текст;
	
	КоличествоТоваровВКатегрии.ПроизвольныйЗапрос = Истина;
	КоличествоТоваровВКатегрии.ТекстЗапроса = ТекстСГруппировкой;
	
	Элементы.СписокНоменклатурыКоэффицент.Обновить();
	Элементы.КоличествоТоваровВКатегрии.Обновить();
	/// Комлев АА 19/11/24 ---
КонецПроцедуры

Процедура КоэффицентПоГоду()
	/// Комлев АА 19/11/24 +++
	Текст = "ВЫБРАТЬ
	|	ЗаказКлиентаТовары.Номенклатура КАК Номенклатура,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказКлиентаТовары.Ссылка) КАК КоличествоЗаявок
	|ПОМЕСТИТЬ ТоварыИзЗаявок
	|ИЗ
	|	Документ.ЗаказКлиента.Товары КАК ЗаказКлиентаТовары
	|ГДЕ
	|	ЗаказКлиентаТовары.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|	И НАЧАЛОПЕРИОДА(ЗаказКлиентаТовары.Ссылка.Дата, Год) = НачалоПериода(&Дата, Год)
	|СГРУППИРОВАТЬ ПО
	|	ЗаказКлиентаТовары.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РегистрНакопления1Остатки.Товар КАК Товар,
	|	КОЛИЧЕСТВО(РегистрНакопления1Остатки.КолвоОстаток) КАК КолвоОстаток,
	|	СУММА(ИндНомер.Цена) КАК Сумма
	|ПОМЕСТИТЬ ОстаткиСумма
	|ИЗ
	|	РегистрНакопления.РегистрНакопления1.Остатки КАК РегистрНакопления1Остатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИндНомер КАК ИндНомер
	|		ПО ИндНомер.индкод = РегистрНакопления1Остатки.индкод
	|ГДЕ
	|	РегистрНакопления1Остатки.КолвоОстаток > 0
	|СГРУППИРОВАТЬ ПО
	|	РегистрНакопления1Остатки.Товар
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СпрНоменклатура.Ссылка КАК Товар,
	|	СпрНоменклатура.Артикул КАК Артикул,
	|	ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) КАК КоличествоЗаявок,
	|	12 КАК Месяцев,
	|	ВЫРАЗИТЬ(ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) / 12 КАК ЧИСЛО(10, 2)) КАК Коэффицент,
	|	ЕстьNULL(ОстаткиСумма.КолвоОстаток, 0) КАК КолвоОстаток,
	|	ОстаткиСумма.Сумма КАК Сумма,
	|	ВЫБОР
	|		КОГДА СпрНоменклатура.ДатаСоздания > &ДатаПолгодаНазад
	|			ТОГДА ""Новые""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) = 0
	|			ТОГДА ""Низкий спрос (Нет заявок)""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) > 0
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) <= 1
	|			ТОГДА ""Категория 8 (1 Заявка)""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) > 1
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) <= 3
	|			ТОГДА ""Категория 7 (от 2 до 3)""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) > 3
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) <= 7
	|			ТОГДА ""Категория 6 (от 3 до 7)""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) > 7
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) <= 13
	|			ТОГДА ""Категория 5 (от 7 до 13)""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) > 13
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) <= 33
	|			ТОГДА ""Категория 4 (от 13 до 33)""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) > 33
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) <= 50
	|			ТОГДА ""Категория 3 (от 33 до 50)""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) > 50
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) <= 100
	|			ТОГДА ""Категория 2 (от 50 до 100)""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) > 100
	|			ТОГДА ""Высокий спрос (от 100)""
	|	КОНЕЦ КАК Категория,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ОстаткиСумма.КолвоОстаток, 0) = 0
	|		ИЛИ ЕСТЬNULL(ОстаткиСумма.КолвоОстаток, 0) = 1
	|		ИЛИ ЕСТЬNULL(ОстаткиСумма.КолвоОстаток, 0) = 2
	|		ИЛИ ЕСТЬNULL(ОстаткиСумма.КолвоОстаток, 0) = 3
	|			ТОГДА СпрНоменклатура.РекомендованаяЦена
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК РекомендованаяЦена,
	|	СпрНоменклатура.Код,
	|	СпрНоменклатура.ОстатокСовпадает,
	|	дт_МестаХраненияНоменклатурыСрезПоследних.МестоХранения,
	|	СпрНоменклатура.ПроцентМенеджераНаНеЛиквид КАК ПроцентМенеджера, 
	|	СпрНоменклатура.ОписаниеЗаполнено
	|ИЗ
	|	Справочник.Номенклатура КАК СпрНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТоварыИзЗаявок КАК ТоварыИзЗаявок
	|		ПО ТоварыИзЗаявок.Номенклатура = СпрНоменклатура.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ ОстаткиСумма КАК ОстаткиСумма
	|		ПО ОстаткиСумма.Товар = СпрНоменклатура.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.дт_МестаХраненияНоменклатуры.СрезПоследних(, Склад = &Склад) КАК
	|			дт_МестаХраненияНоменклатурыСрезПоследних
	|		ПО дт_МестаХраненияНоменклатурыСрезПоследних.Номенклатура = СпрНоменклатура.Ссылка";
	
	
	ТекстСГруппировкой = "ВЫБРАТЬ
	|	ЗаказКлиентаТовары.Номенклатура КАК Номенклатура,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказКлиентаТовары.Ссылка) КАК КоличествоЗаявок
	|ПОМЕСТИТЬ ТоварыИзЗаявок
	|ИЗ
	|	Документ.ЗаказКлиента.Товары КАК ЗаказКлиентаТовары
	|ГДЕ
	|	ЗаказКлиентаТовары.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|	И НАЧАЛОПЕРИОДА(ЗаказКлиентаТовары.Ссылка.Дата, Год) = НачалоПериода(&Дата, Год)
	|СГРУППИРОВАТЬ ПО
	|	ЗаказКлиентаТовары.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РегистрНакопления1Остатки.Товар КАК Товар,
	|	КОЛИЧЕСТВО(РегистрНакопления1Остатки.КолвоОстаток) КАК КолвоОстаток,
	|	СУММА(ИндНомер.Цена) КАК Сумма
	|ПОМЕСТИТЬ ОстаткиСумма
	|ИЗ
	|	РегистрНакопления.РегистрНакопления1.Остатки КАК РегистрНакопления1Остатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИндНомер КАК ИндНомер
	|		ПО ИндНомер.индкод = РегистрНакопления1Остатки.индкод
	|ГДЕ
	|	РегистрНакопления1Остатки.КолвоОстаток > 0
	|СГРУППИРОВАТЬ ПО
	|	РегистрНакопления1Остатки.Товар
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СпрНоменклатура.Ссылка КАК Товар,
	|	СпрНоменклатура.Артикул КАК Артикул,
	|	ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) КАК КоличествоЗаявок,
	|	12 КАК Месяцев,
	|	ВЫРАЗИТЬ(ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) / 12 КАК ЧИСЛО(10, 2)) КАК Коэффицент,
	|	ЕСТЬNULL(ОстаткиСумма.КолвоОстаток, 0) КАК КолвоОстаток,
	|	ОстаткиСумма.Сумма КАК Сумма,
	|	ВЫБОР
	|		КОГДА СпрНоменклатура.ДатаСоздания > &ДатаПолгодаНазад
	|			ТОГДА ""Новые""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) = 0
	|			ТОГДА ""Низкий спрос (Нет заявок)""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) > 0
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) <= 1
	|			ТОГДА ""Категория 8 (1 Заявка)""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) > 1
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) <= 3
	|			ТОГДА ""Категория 7 (от 2 до 3)""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) > 3
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) <= 7
	|			ТОГДА ""Категория 6 (от 3 до 7)""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) > 7
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) <= 13
	|			ТОГДА ""Категория 5 (от 7 до 13)""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) > 13
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) <= 33
	|			ТОГДА ""Категория 4 (от 13 до 33)""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) > 33
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) <= 50
	|			ТОГДА ""Категория 3 (от 33 до 50)""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) > 50
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) <= 100
	|			ТОГДА ""Категория 2 (от 50 до 100)""
	|		КОГДА СпрНоменклатура.ДатаСоздания < &ДатаПолгодаНазад
	|		И ЕСТЬNULL(ТоварыИзЗаявок.КоличествоЗаявок, 0) > 100
	|			ТОГДА ""Высокий спрос (от 100)""
	|	КОНЕЦ КАК Категория,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ОстаткиСумма.КолвоОстаток, 0) = 0
	|		ИЛИ ЕСТЬNULL(ОстаткиСумма.КолвоОстаток, 0) = 1
	|		ИЛИ ЕСТЬNULL(ОстаткиСумма.КолвоОстаток, 0) = 2
	|		ИЛИ ЕСТЬNULL(ОстаткиСумма.КолвоОстаток, 0) = 3
	|			ТОГДА СпрНоменклатура.РекомендованаяЦена
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК РекомендованаяЦена
	|ПОМЕСТИТЬ ГотоваяТаблица
	|ИЗ
	|	Справочник.Номенклатура КАК СпрНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТоварыИзЗаявок КАК ТоварыИзЗаявок
	|		ПО (ТоварыИзЗаявок.Номенклатура = СпрНоменклатура.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ОстаткиСумма КАК ОстаткиСумма
	|		ПО (ОстаткиСумма.Товар = СпрНоменклатура.Ссылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ГотоваяТаблица.Категория КАК Категория,
	|	СУММА(ГотоваяТаблица.РекомендованаяЦена) КАК СуммаДенегНаЗакуп,
	|	КОЛИЧЕСТВО(ГотоваяТаблица.Товар) КАК КоличествоТоваров0
	|ПОМЕСТИТЬ ДеньгиНаЗакупкуИКоличествоТоваровОстаток0
	|ИЗ
	|	ГотоваяТаблица КАК ГотоваяТаблица
	|ГДЕ
	|	ГотоваяТаблица.КолвоОстаток = 0
	|СГРУППИРОВАТЬ ПО
	|	ГотоваяТаблица.Категория
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ГотоваяТаблица.Категория КАК Категория,
	|	КОЛИЧЕСТВО(ГотоваяТаблица.Товар) КАК КоличествоТоваров1
	|ПОМЕСТИТЬ КоличествоТоваровОстаток1
	|ИЗ
	|	ГотоваяТаблица КАК ГотоваяТаблица
	|ГДЕ
	|	ГотоваяТаблица.КолвоОстаток = 1
	|СГРУППИРОВАТЬ ПО
	|	ГотоваяТаблица.Категория
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ГотоваяТаблица.Категория КАК Категория,
	|	КОЛИЧЕСТВО(ГотоваяТаблица.Товар) КАК КоличествоТоваров2
	|ПОМЕСТИТЬ КоличествоТоваровОстаток2
	|ИЗ
	|	ГотоваяТаблица КАК ГотоваяТаблица
	|ГДЕ
	|	ГотоваяТаблица.КолвоОстаток = 2
	|СГРУППИРОВАТЬ ПО
	|	ГотоваяТаблица.Категория
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ГотоваяТаблица.Категория КАК Категория,
	|	КОЛИЧЕСТВО(ГотоваяТаблица.Товар) КАК КоличествоТоваров3
	|ПОМЕСТИТЬ КоличествоТоваровОстаток3
	|ИЗ
	|	ГотоваяТаблица КАК ГотоваяТаблица
	|ГДЕ
	|	ГотоваяТаблица.КолвоОстаток = 3
	|СГРУППИРОВАТЬ ПО
	|	ГотоваяТаблица.Категория
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ГотоваяТаблица.Категория КАК Категория,
	|	МАКСИМУМ(ДеньгиНаЗакупкуИКоличествоТоваровОстаток0.СуммаДенегНаЗакуп) КАК СуммаЗакупа,
	|	МАКСИМУМ(ДеньгиНаЗакупкуИКоличествоТоваровОстаток0.КоличествоТоваров0) КАК Остаток0,
	|	МАКСИМУМ(КоличествоТоваровОстаток1.КоличествоТоваров1) КАК Остаток1,
	|	МАКСИМУМ(КоличествоТоваровОстаток2.КоличествоТоваров2) КАК Остаток2,
	|	МАКСИМУМ(КоличествоТоваровОстаток3.КоличествоТоваров3) КАК Остаток3,
	|	КОЛИЧЕСТВО(ГотоваяТаблица.Товар) КАК КоличествоТоваров,
	|	Сумма(ГотоваяТаблица.Сумма) КАК СуммаОстатков,
	|	МАКСИМУМ(ГотоваяТаблица.Товар.ПроцентМенеджераНаНеЛиквид) КАК ПроцентМенеджера
	|ИЗ
	|	ГотоваяТаблица КАК ГотоваяТаблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ ДеньгиНаЗакупкуИКоличествоТоваровОстаток0 КАК ДеньгиНаЗакупкуИКоличествоТоваровОстаток0
	|		ПО (ГотоваяТаблица.Категория = ДеньгиНаЗакупкуИКоличествоТоваровОстаток0.Категория)
	|		ЛЕВОЕ СОЕДИНЕНИЕ КоличествоТоваровОстаток1 КАК КоличествоТоваровОстаток1
	|		ПО (ГотоваяТаблица.Категория = КоличествоТоваровОстаток1.Категория)
	|		ЛЕВОЕ СОЕДИНЕНИЕ КоличествоТоваровОстаток2 КАК КоличествоТоваровОстаток2
	|		ПО (ГотоваяТаблица.Категория = КоличествоТоваровОстаток2.Категория)
	|		ЛЕВОЕ СОЕДИНЕНИЕ КоличествоТоваровОстаток3 КАК КоличествоТоваровОстаток3
	|		ПО (КоличествоТоваровОстаток3.Категория = ГотоваяТаблица.Категория)
	|СГРУППИРОВАТЬ ПО
	|	ГотоваяТаблица.Категория";
	
	СписокНоменклатурыКоэффицент.ПроизвольныйЗапрос = Истина;
	СписокНоменклатурыКоэффицент.ТекстЗапроса = Текст;
	СписокНоменклатурыКоэффицент.Параметры.УстановитьЗначениеПараметра("Дата", Год);
	
	КоличествоТоваровВКатегрии.ПроизвольныйЗапрос = Истина;
	КоличествоТоваровВКатегрии.ТекстЗапроса = ТекстСГруппировкой;
	КоличествоТоваровВКатегрии.Параметры.УстановитьЗначениеПараметра("Дата", Год);
	
	Элементы.СписокНоменклатурыКоэффицент.Обновить();
	Элементы.КоличествоТоваровВКатегрии.Обновить();
	/// Комлев АА 19/11/24 ---
КонецПроцедуры
#КонецОбласти

