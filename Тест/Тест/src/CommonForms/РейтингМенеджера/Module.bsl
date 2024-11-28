
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СУММА(ВЫБОР
		|		КОГДА ПриходДенегНаСчет.Счет.ВидПеречисления = ЗНАЧЕНИЕ(перечисление.ВидыПоступлений.НаличныйРасчет)
		|			ТОГДА ПриходДенегНаСчет.СуммаДокумента
		|		ИНАЧЕ 0
		|	КОНЕЦ) КАК Наличные,
		|	СУММА(ВЫБОР
		|		КОГДА ПриходДенегНаСчет.Счет.ВидПеречисления = ЗНАЧЕНИЕ(перечисление.ВидыПоступлений.БезналичныйРасчет)
		|			ТОГДА ПриходДенегНаСчет.СуммаДокумента
		|		ИНАЧЕ 0
		|	КОНЕЦ) КАК Безнал,
		|	СУММА(ВЫБОР
		|		КОГДА ПриходДенегНаСчет.Счет.ВидПеречисления = ЗНАЧЕНИЕ(перечисление.ВидыПоступлений.БезналичныйРасчет)
		|			ТОГДА ВЫБОР
		|				КОГДА ПриходДенегНаСчет.Счет.Владелец.Налог = 20
		|				И ПриходДенегНаСчет.Дата >= &ДатаНачалаБезналБезНДС
		|					ТОГДА ВЫРАЗИТЬ(ПриходДенегНаСчет.СуммаДокумента / 1.2 КАК ЧИСЛО(20, 0))
		|				ИНАЧЕ ПриходДенегНаСчет.СуммаДокумента
		|			КОНЕЦ
		|		ИНАЧЕ 0
		|	КОНЕЦ) КАК БезналБезНДС,
		|	ПриходДенегНаСчет.Менеджер КАК Менеджер
		|ПОМЕСТИТЬ НалБезнал
		|ИЗ
		|	Документ.ПриходДенегНаСчет КАК ПриходДенегНаСчет
		|ГДЕ
		|	ПриходДенегНаСчет.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
		|СГРУППИРОВАТЬ ПО
		|	ПриходДенегНаСчет.Менеджер
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЗаписиЗвонков.Менеджер КАК Менеджер,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаписиЗвонков.Дата) КАК КоличествоЗвонков
		|ПОМЕСТИТЬ ЗвонкиМенеджера
		|ИЗ
		|	РегистрСведений.ЗаписиЗвонков КАК ЗаписиЗвонков
		|ГДЕ
		|	ЗаписиЗвонков.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
		|СГРУППИРОВАТЬ ПО
		|	ЗаписиЗвонков.Менеджер
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказКлиента.Ссылка) КАК КолвоЗаявок,
		|	ЗаказКлиента.Ответственный КАК Ответственный
		|ПОМЕСТИТЬ ВсеЗаявкиМенеджера
		|ИЗ
		|	Документ.ЗаказКлиента КАК ЗаказКлиента
		|ГДЕ
		|	ЗаказКлиента.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
		|СГРУППИРОВАТЬ ПО
		|	ЗаказКлиента.Ответственный
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказКлиента.Ссылка) КАК КолвоЗаявокОтказ,
		|	ЗаказКлиента.Ответственный КАК Ответственный
		|ПОМЕСТИТЬ ЗаявкиМенеджераОтказ
		|ИЗ
		|	Документ.ЗаказКлиента КАК ЗаказКлиента
		|ГДЕ
		|	ЗаказКлиента.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
		|	И (ЗаказКлиента.Состояние = ЗНАЧЕНИЕ(Перечисление.дт_СостоянияЗаказовКлиента.Отказ)
		|	ИЛИ ЗаказКлиента.Состояние = ЗНАЧЕНИЕ(Перечисление.дт_СостоянияЗаказовКлиента.Дорого))
		|СГРУППИРОВАТЬ ПО
		|	ЗаказКлиента.Ответственный
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказКлиента.Ссылка) КАК КолвоЗаявокДумает,
		|	ЗаказКлиента.Ответственный КАК Ответственный
		|ПОМЕСТИТЬ ЗаявкиМенеджераДумает
		|ИЗ
		|	Документ.ЗаказКлиента КАК ЗаказКлиента
		|ГДЕ
		|	ЗаказКлиента.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
		|	И ЗаказКлиента.Состояние = ЗНАЧЕНИЕ(Перечисление.дт_СостоянияЗаказовКлиента.Думает)
		|СГРУППИРОВАТЬ ПО
		|	ЗаказКлиента.Ответственный
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказКлиента.Ссылка) КАК КолвоЗаявокОжидание,
		|	ЗаказКлиента.Ответственный КАК Ответственный
		|ПОМЕСТИТЬ ЗаявкиМенеджераОжидание
		|ИЗ
		|	Документ.ЗаказКлиента КАК ЗаказКлиента
		|ГДЕ
		|	ЗаказКлиента.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
		|	И ЗаказКлиента.Состояние = ЗНАЧЕНИЕ(Перечисление.дт_СостоянияЗаказовКлиента.Ожидание)
		|СГРУППИРОВАТЬ ПО
		|	ЗаказКлиента.Ответственный
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ПродажаЗапчастей.Ссылка) КАК КолвоПродаж,
		|	ПродажаЗапчастей.КтоПродал КАК КтоПродал,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ПродажаЗапчастей.Клиент) КАК КлиентыАктивные,
		|	СУММА(ПродажаЗапчастей.ИтогоРекв) КАК ИтогоРекв
		|ПОМЕСТИТЬ ВсеПродажиМенеджера
		|ИЗ
		|	Документ.ПродажаЗапчастей КАК ПродажаЗапчастей
		|ГДЕ
		|	ПродажаЗапчастей.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
		|СГРУППИРОВАТЬ ПО
		|	ПродажаЗапчастей.КтоПродал
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Клиенты.Ссылка) КАК ОбщееКоличествоКлиентов,
		|	Клиенты.Ответственный КАК Ответственный,
		|	СУММА(Клиенты.КоличествоАвтомобилей) КАК КоличествоАвтомобилей
		|ПОМЕСТИТЬ КлиентыМенеджера
		|ИЗ
		|	Справочник.Клиенты КАК Клиенты
		|СГРУППИРОВАТЬ ПО
		|	Клиенты.Ответственный
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПриходДенегНаСчет.Менеджер КАК Менеджер,
		|	СУММА(ПриходДенегНаСчет.СуммаДокумента) КАК СуммаДокумента
		|ПОМЕСТИТЬ ПоступленияМенеджера
		|ИЗ
		|	Документ.ПриходДенегНаСчет КАК ПриходДенегНаСчет
		|ГДЕ
		|	ПриходДенегНаСчет.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
		|СГРУППИРОВАТЬ ПО
		|	ПриходДенегНаСчет.Менеджер
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Расходы.Инициатор.Пользователь КАК Инициатор,
		|	СУММА(Расходы.Сумма) КАК Сумма
		|ПОМЕСТИТЬ ВТ_Расходы
		|ИЗ
		|	Документ.Расходы КАК Расходы
		|ГДЕ
		|	Расходы.ВидРасхода = &ВидРасхода
		|	И Расходы.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
		|СГРУППИРОВАТЬ ПО
		|	Расходы.Инициатор.Пользователь
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЗаписиЗвонков.Менеджер КАК Менеджер,
		|	МАКСИМУМ(ЗаписиЗвонков.Дата) КАК ДатаПоследнегоЗвонка
		|ПОМЕСТИТЬ ПоследнийЗвонокМенеджера
		|ИЗ
		|	РегистрСведений.ЗаписиЗвонков КАК ЗаписиЗвонков
		|СГРУППИРОВАТЬ ПО
		|	ЗаписиЗвонков.Менеджер
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДополнительныеНомера.Менеджер КАК Менеджер,
		|	ВсеЗаявкиМенеджера.КолвоЗаявок КАК КолвоВсехЗаявок,
		|	ВсеПродажиМенеджера.КолвоПродаж КАК КолвоПродаж,
		|	ВсеПродажиМенеджера.ИтогоРекв КАК СуммаПродаж,
		|	ПриходДенегНаСчет.СуммаДокумента КАК СуммаПоступлений,
		|	ПриходДенегНаСчет.СуммаДокумента * 0.03 КАК ЗПМенеджера,
		|	КлиентыМенеджера.ОбщееКоличествоКлиентов КАК КоличествоКлиентов,
		|	ВсеПродажиМенеджера.КлиентыАктивные КАК Клиентыобработанные,
		|	ЗвонкиМенеджера.КоличествоЗвонков КАК КоличествоЗвонков,
		|	КлиентыМенеджера.КоличествоАвтомобилей КАК КоличествоАвтомобилей,
		|	НалБезнал.Наличные КАК Наличные,
		|	НалБезнал.Безнал КАК Безнал,
		|	3000000 - ПриходДенегНаСчет.СуммаДокумента КАК ДоПлана,
		|	ЗаявкиМенеджераОтказ.КолвоЗаявокОтказ КАК КолвоЗаявокОтказ,
		|	ЗаявкиМенеджераДумает.КолвоЗаявокДумает КАК КолвоЗаявокДумает,
		|	ЗаявкиМенеджераОжидание.КолвоЗаявокОжидание КАК КолвоЗаявокОжидание
		|ИЗ
		|	РегистрСведений.ДополнительныеНомера КАК ДополнительныеНомера
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВсеЗаявкиМенеджера КАК ВсеЗаявкиМенеджера
		|		ПО (ДополнительныеНомера.Менеджер = ВсеЗаявкиМенеджера.Ответственный)
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПоступленияМенеджера КАК ПриходДенегНаСчет
		|		ПО (ДополнительныеНомера.Менеджер = ПриходДенегНаСчет.Менеджер)
		|		ЛЕВОЕ СОЕДИНЕНИЕ КлиентыМенеджера КАК КлиентыМенеджера
		|		ПО (ДополнительныеНомера.Менеджер = КлиентыМенеджера.Ответственный)
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВсеПродажиМенеджера КАК ВсеПродажиМенеджера
		|		ПО (ДополнительныеНомера.Менеджер = ВсеПродажиМенеджера.КтоПродал)
		|		ЛЕВОЕ СОЕДИНЕНИЕ ЗвонкиМенеджера КАК ЗвонкиМенеджера
		|		ПО (ДополнительныеНомера.Менеджер = ЗвонкиМенеджера.Менеджер)
		|		ЛЕВОЕ СОЕДИНЕНИЕ НалБезнал КАК НалБезнал
		|		ПО (ДополнительныеНомера.Менеджер = НалБезнал.Менеджер)
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Расходы КАК ВТ_Расходы
		|		ПО (ДополнительныеНомера.Менеджер = ВТ_Расходы.Инициатор)
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПоследнийЗвонокМенеджера КАК ПоследнийЗвонокМенеджера
		|		ПО (ДополнительныеНомера.Менеджер = ПоследнийЗвонокМенеджера.Менеджер)
		|		ЛЕВОЕ СОЕДИНЕНИЕ ЗаявкиМенеджераОтказ КАК ЗаявкиМенеджераОтказ
		|		ПО (ДополнительныеНомера.Менеджер = ЗаявкиМенеджераОтказ.Ответственный)
		|		ЛЕВОЕ СОЕДИНЕНИЕ ЗаявкиМенеджераДумает КАК ЗаявкиМенеджераДумает
		|		ПО (ЗаявкиМенеджераДумает.Ответственный = ДополнительныеНомера.Менеджер)
		|		ЛЕВОЕ СОЕДИНЕНИЕ ЗаявкиМенеджераОжидание КАК ЗаявкиМенеджераОжидание
		|		ПО (ДополнительныеНомера.Менеджер = ЗаявкиМенеджераОжидание.Ответственный)
		|ГДЕ
		|	ДополнительныеНомера.Менеджер = &Менеджер
		|СГРУППИРОВАТЬ ПО
		|	ДополнительныеНомера.Менеджер,
		|	ПриходДенегНаСчет.СуммаДокумента,
		|	КлиентыМенеджера.ОбщееКоличествоКлиентов,
		|	ВсеПродажиМенеджера.КолвоПродаж / ВсеЗаявкиМенеджера.КолвоЗаявок * 100,
		|	ВсеЗаявкиМенеджера.КолвоЗаявок,
		|	ВсеПродажиМенеджера.КолвоПродаж,
		|	ВсеПродажиМенеджера.КлиентыАктивные,
		|	ВсеПродажиМенеджера.ИтогоРекв,
		|	ЗвонкиМенеджера.КоличествоЗвонков,
		|	КлиентыМенеджера.КоличествоАвтомобилей,
		|	НалБезнал.Наличные,
		|	НалБезнал.Безнал,
		|	ВТ_Расходы.Сумма,
		|	РАЗНОСТЬДАТ(ПоследнийЗвонокМенеджера.ДатаПоследнегоЗвонка, &ТекДата, МИНУТА),
		|	НалБезнал.БезналБезНДС,
		|	ПриходДенегНаСчет.СуммаДокумента * 0.03,
		|	3000000 - ПриходДенегНаСчет.СуммаДокумента,
		|	ВсеПродажиМенеджера.ИтогоРекв - ВТ_Расходы.Сумма,
		|	ЗаявкиМенеджераОтказ.КолвоЗаявокОтказ,
		|	ЗаявкиМенеджераДумает.КолвоЗаявокДумает,
		|	ЗаявкиМенеджераОжидание.КолвоЗаявокОжидание";
	
	Запрос.УстановитьПараметр("ДатаНачалаБезналБезНДС", Дата(2024, 11, 01));
	Запрос.УстановитьПараметр("ДатаНачала", НачалоМесяца(ТекущаяДата()));
	Запрос.УстановитьПараметр("ДатаОкончания", КонецМесяца(ТекущаяДата()));
	Запрос.УстановитьПараметр("ВидРасхода", Справочники.ВидыРасходов.НайтиПоКоду("000000041"));
	Запрос.УстановитьПараметр("Менеджер", Справочники.Пользователи.НайтиПоНаименованию(ПользователиИнформационнойБазы.ТекущийПользователь().ПолноеИмя));
	Запрос.УстановитьПараметр("ТекДата", ТекущаяДата());
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		КоличествоЗаявок = Выборка.КолвоВсехЗаявок;
		ЗаявкиОтказ = Выборка.КолвоЗаявокОтказ;
		ЗаявкиДумает = Выборка.КолвоЗаявокДумает;
		ЗаявкиОжидание = Выборка.КолвоЗаявокОжидание;
		КоличествоПродаж = Выборка.КолвоПродаж;
		КоличествоЗвонков = Выборка.КоличествоЗвонков;
		КоличествоКлиентов = Выборка.КоличествоКлиентов;
		КлиентыОбработанные = Выборка.КлиентыОбработанные;
		СуммаПродаж = Выборка.СуммаПродаж;
		СуммаПоступлений = Выборка.СуммаПоступлений;
		Зарплата = Выборка.ЗПМенеджера;
		Наличные = Выборка.Наличные;
		Безнал =  Выборка.Безнал;
		ДоПлана = Выборка.ДоПлана;
	КонецЦикла;
	
	Заголовок = Строка(ПользователиИнформационнойБазы.ТекущийПользователь().ПолноеИмя);
//	ПоказателиМенеджера.Параметры.УстановитьЗначениеПараметра("ВидРасхода", Справочники.ВидыРасходов.НайтиПоКоду("000000041"));
//	ПоказателиМенеджера.Параметры.УстановитьЗначениеПараметра("ДатаНачалаБезналБезНДС", Дата(2024, 11, 01));
//	ПоказателиМенеджера.Параметры.УстановитьЗначениеПараметра("ТекДата", ТекущаяДата());
//	ПоказателиМенеджера.Параметры.УстановитьЗначениеПараметра("ДатаНачала", НачалоМесяца(ТекущаяДата()));
//	ПоказателиМенеджера.Параметры.УстановитьЗначениеПараметра("ДатаОкончания", КонецМесяца(ТекущаяДата()));
//	ПоказателиМенеджера.Параметры.УстановитьЗначениеПараметра("Менеджер", Справочники.Пользователи.НайтиПоНаименованию(ПользователиИнформационнойБазы.ТекущийПользователь().ПолноеИмя));
	
КонецПроцедуры
