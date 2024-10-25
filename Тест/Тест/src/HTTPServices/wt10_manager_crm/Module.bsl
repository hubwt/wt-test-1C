#Область ОбработчикиСобытий
Функция ПолучитьСтатусыЗаявкиgetstatusapp(Запрос)
	
	///+ТатарМА 25.10.2024
	МассивСтатусов = Новый Массив;
	
	Для Каждого Статус Из Перечисления.дт_СостоянияЗаказовКлиента Цикл
		МассивСтатусов.Добавить(Строка(Статус));
	КонецЦикла;

	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	ЗаписатьJSON(ЗаписьJSON, МассивСтатусов);
	СтруктураОтвета = ЗаписьJSON.Закрыть();
	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.Заголовки.Вставить("Content-Type", "application/json; charset=utf-8");
	Ответ.УстановитьТелоИзСтроки(СтруктураОтвета);
	Возврат Ответ;
	///-ТатарМА 25.10.2024
	
КонецФункции

Функция ПолучитьЗаявкиПоСтатусуgetappbystatus(Запрос)
	
	///+ТатарМА 25.10.2024
	МассивЗаявок = Новый Массив;
	Попытка
		
		ЗапросЗаявок = Новый Запрос;
		Текст = "ВЫБРАТЬ
		|	СотрудникиКонтактнаяИнформация.Ссылка КАК Ссылка,
		|	СотрудникиКонтактнаяИнформация.Представление КАК Представление,
		|	СотрудникиКонтактнаяИнформация.Представление КАК ТелефонСлужебный
		|ПОМЕСТИТЬ ТелефоныСлужебные
		|ИЗ
		|	Справочник.Сотрудники.КонтактнаяИнформация КАК СотрудникиКонтактнаяИнформация
		|ГДЕ
		|	СотрудникиКонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ТелефонСотрудникаСлужебный)
		|;
		|/////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 100000
		|	ЗаказКлиента.Номер КАК Номер,
		|	ЗаказКлиента.Дата КАК Дата,
		|	Выбор
		|		Когда ЗаказКлиента.Клиент <> Значение(Справочник.Клиенты.ПустаяСсылка)
		|			Тогда ЗаказКлиента.Клиент
		|		Иначе ЗаказКлиента.КлиентНаименование
		|	Конец КАК Клиент,
		|	Выбор
		|		Когда ЗаказКлиента.Клиент <> Значение(Справочник.Клиенты.ПустаяСсылка)
		|			Тогда ЗаказКлиента.Клиент.Код
		|		Иначе ""Не авторизован""
		|	Конец КАК КлиентКод,
		|	ЗаказКлиента.Состояние КАК Состояние,
		|	ЗаказКлиента.Ответственный КАК Ответственный,
		|	ТелефоныСлужебные.ТелефонСлужебный КАК ТелефонСлужебный,
		|	ЗаказКлиента.СуммаДокумента КАК СуммаДокумента,
		|	ЗаказКлиента.ДатаСвязи КАК ДатаСвязи,
		|	ТелефоныСлужебные.Ссылка.Код КАК КодСотрудника,
		|	ЗаказКлиента.Ссылка КАК Ссылка,
		|	ЗаказКлиента.WTPanel КАК СтатусОбработки,
		|	ЗаказКлиента.ОтветственныйЗаОбработку КАК ОтветственныйЗаОбработку,
		|	ЗаказКлиента.Комментарий КАК Комментарий,
		|	ЗаказКлиента.ПодстатусОбработки КАК ПодстатусОбработки,
		|	ЗаказКлиента.НомерТелефона КАК Телефон,
		|	ЗаказКлиента.WTPanel КАК WTPanel,
		|	АвтономерЗаписи() КАК НомерЗаписи
		|ПОМЕСТИТЬ ВТ_ДанныеЗаявки
		|ИЗ
		|	Документ.ЗаказКлиента КАК ЗаказКлиента
		|		ЛЕВОЕ Соединение ТелефоныСлужебные КАк ТелефоныСлужебные
		|		По ЗаказКлиента.Ответственный = ТелефоныСлужебные.ссылка.пользователь
		|ГДЕ
		|	ЗаказКлиента.Состояние = &Состояние
		|
		|УПОРЯДОЧИТЬ ПО
		|	Номер УБЫВ
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Ответственный
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ %1
		|	ВТ_ДанныеЗаявки.НомерЗаписи КАК НомерЗаписи,
		|	ВТ_ДанныеЗаявки.Ссылка КАК Ссылка,
		|	ВТ_ДанныеЗаявки.Номер КАК Номер,
		|	ВТ_ДанныеЗаявки.Дата КАК Дата,
		|	ВТ_ДанныеЗаявки.Клиент КАК Клиент,
		|	ВТ_ДанныеЗаявки.Комментарий КАК Комментарий,
		|	ВТ_ДанныеЗаявки.Ответственный КАК Ответственный,
		|	ВТ_ДанныеЗаявки.СуммаДокумента КАК СуммаДокумента,
		|	ВТ_ДанныеЗаявки.ДатаСвязи КАК ДатаСвязи,
		|	ВТ_ДанныеЗаявки.Состояние КАК Состояние,
		|	ВТ_ДанныеЗаявки.ОтветственныйЗаОбработку КАК ОтветственныйЗаОбработку,
		|	ВТ_ДанныеЗаявки.СтатусОбработки КАК СтатусОбработки,
		|	ВТ_ДанныеЗаявки.ПодстатусОбработки КАК ПодстатусОбработки,
		|	ВТ_ДанныеЗаявки.ТелефонСлужебный КАК ТелефонСлужебный,
		|	ВТ_ДанныеЗаявки.КодСотрудника КАК КодСотрудника,
		|	ВТ_ДанныеЗаявки.WTPanel КАК WTPanel,
		|	ВТ_ДанныеЗаявки.КлиентКод КАК КлиентКод,
		|	ВТ_ДанныеЗаявки.Телефон КАК Телефон
		|ИЗ
		|	ВТ_ДанныеЗаявки КАК ВТ_ДанныеЗаявки
		|ГДЕ
		|	ВТ_ДанныеЗаявки.НомерЗаписи >= &НачинаяСЗаписи
		|
		|УПОРЯДОЧИТЬ ПО
		|	Дата УБЫВ";
		
		ЗапросЗаявок.Текст =  СтрШаблон(Текст, Формат(10000, "ЧГ="));
		
		
		Для Каждого Перечисление Из Перечисления.дт_СостоянияЗаказовКлиента Цикл
			Если Строка(Перечисление) = Запрос.ПараметрыURL["status"] Тогда
				Статус = Перечисление;
			КонецЕсли;
		КонецЦикла;
		
		ЗапросЗаявок.УстановитьПараметр("Состояние", Статус);
		
		ЗапросЗаявок.УстановитьПараметр("НачинаяСЗаписи", 0);
		ОбщееКолво = ЗапросЗаявок.Выполнить().Выбрать().Количество();
	
		ЗапросЗаявок.Текст =  СтрШаблон(Текст, Формат(?(Число(Запрос.ПараметрыURL["count"]) > 0,
		Запрос.ПараметрыURL["count"], 10000), "ЧГ="));
		
		ЗапросЗаявок.УстановитьПараметр("Состояние", Статус);

		Если Число(((Запрос.ПараметрыURL["count"]) * (Запрос.ПараметрыURL["page"]))) > 0 И Число(
		Запрос.ПараметрыURL["page"]) > 1 Тогда
			ЗапросЗаявок.УстановитьПараметр("НачинаяСЗаписи", Число(((Запрос.ПараметрыURL["count"])
				* (Запрос.ПараметрыURL["page"] - 1) + 1)));

		Иначе
			ЗапросЗаявок.УстановитьПараметр("НачинаяСЗаписи", 0);
		КонецЕсли;
		СписокПоиска = ЗапросЗаявок.Выполнить().Выгрузить();
		Для Каждого Результат Из СписокПоиска Цикл

			СтруктураЗаявок = Новый Структура;
			СтруктураЗаявок.Вставить("id", Строка(Результат.Номер));
			//СтруктураЗаявок.Вставить("date", Строка(Результат.Дата));
			//СтруктураЗаявок.Вставить("state", Строка(Результат.WTPanel));
			//СтруктураЗаявок.Вставить("sub_state", Строка(Результат.ПодстатусОбработки));
			//СтруктураЗаявок.Вставить("state", Строка(Результат.Состояние));

			СтруктураКлиента = Новый Структура;
			СтруктураКлиента.Вставить("name", Строка(Результат.Клиент));
			СтруктураКлиента.Вставить("id", Результат.КлиентКод);
			СтруктураКлиента.Вставить("phone", Результат.Телефон);
			СтруктураЗаявок.Вставить("client", СтруктураКлиента);

			СтруктураМенеджера = Новый Структура;
			СтруктураМенеджера.Вставить("name", Строка(Результат.Ответственный));
			СтруктураМенеджера.Вставить("id", Строка(Результат.КодСотрудника));
			СтруктураМенеджера.Вставить("phone", Строка(Результат.ТелефонСлужебный));
			СтруктураЗаявок.Вставить("manager", СтруктураМенеджера);
	
			//СтруктураЗаявок.Вставить("time_work", 0);
			//СтруктураЗаявок.Вставить("time_wait", 0);
			//СтруктураЗаявок.Вставить("workers", 0);
			//СтруктураЗаявок.Вставить("in_work", 0);
			//СтруктураТоваров = ПолучитьТоварыЗаявки1(Результат.Номер);
			//СтруктураЗаявок.Вставить("productsIds", СтруктураТоваров.Товары);
			//СтруктураЗаявок.Вставить("summ", СтруктураТоваров.СуммаТоваров);
			МассивЗаявок.Добавить(СтруктураЗаявок);
		КонецЦикла;

		Итог = ОбщееКолво / ?(Число(Запрос.ПараметрыURL["count"]) = 0, ОбщееКолво, Число(Запрос.ПараметрыURL["count"]));
		Итог = ?((Итог - Цел(Итог)) > 0, Цел(Итог) + 1, Цел(Итог));

		СтруктураИнфо= Новый Структура;
		СтруктураИнфо.Вставить("pages", Итог);
		СтруктураИнфо.Вставить("count", ОбщееКолво);
		СтруктураИнфо.Вставить("applications", МассивЗаявок);

		СтруктураОтвета = Новый Структура;
		СтруктураОтвета.Вставить("info", СтруктураИнфо);
		СтруктураОтвета.Вставить("applications", МассивЗаявок);

		Ответ = Новый HTTPСервисОтвет(200);
		Ответ.Заголовки.Вставить("Content-type", "application/json;  charset=utf-8");
		ЗаписьJSON = Новый ЗаписьJSON;
		ЗаписьJSON.УстановитьСтроку();
		Информация = ИнформацияОбОшибке();
		ЗаписатьJSON(ЗаписьJSON, СтруктураИнфо);
		СтрокаДляОтвета = ЗаписьJSON.Закрыть();
		Ответ.УстановитьТелоИзСтроки(СтрокаДляОтвета);

		Возврат Ответ;
	Исключение
		Ответ = Новый HTTPСервисОтвет(200);
		Ответ.Заголовки.Вставить("Content-type", "application/json;  charset=utf-8");
		Информация = ИнформацияОбОшибке();
		ЗаписьJSON = Новый ЗаписьJSON;
		ЗаписьJSON.УстановитьСтроку();
		Информация = ИнформацияОбОшибке();
		ЗаписатьJSON(ЗаписьJSON, СформироватьСтруктуруОшибки( , "Ошибка выполнения запроса", Информация.Описание));
		СтрокаДляОтвета = ЗаписьJSON.Закрыть();
		Ответ.УстановитьТелоИзСтроки(СтрокаДляОтвета);

	КонецПопытки;
	Возврат Ответ;
	///-ТатарМА 25.10.2024
	
КонецФункции

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Функция ПолучитьТоварыЗаявки1(НомерЗаявки)
	Запросзаявки = Новый Запрос;
	Запросзаявки.Текст = "ВЫБРАТЬ
						 |	ЗаказКлиентаТовары.НомерСтроки КАК НомерСтроки,
						 |	ЗаказКлиентаТовары.Партия КАК Партия,
						 |	ЗаказКлиентаТовары.Номенклатура.Код КАК НоменклатураКод,
						 |	ЗаказКлиентаТовары.Сумма КАК Сумма,
						 |	ЗаказКлиентаТовары.Цена КАК Цена,
						 |	ЗаказКлиентаТовары.Количество КАК Количество
						 |ИЗ
						 |	Документ.ЗаказКлиента.Товары КАК ЗаказКлиентаТовары
						 |ГДЕ
						 |	ЗаказКлиентаТовары.Ссылка.Номер = &Номер";

	Запросзаявки.УстановитьПараметр("Номер", НомерЗаявки);

	Выборка = Запросзаявки.Выполнить().Выбрать();
	МассивТоваров = Новый Массив;

	// ТЗ_Товары = выборка.Выгрузить();
	МассивТоваров = Новый Массив;

	СуммаТоваров = 0;
	Пока выборка.Следующий() Цикл
		СтруктураТоваров = Новый Структура;
		СтруктураТоваров.Вставить("position", Строка(выборка.НомерСтроки));
		Если выборка.Партия <> Справочники.ИндКод.ПустаяСсылка() Тогда
			СтруктураТоваров.Вставить("id", Строка(выборка.Партия));
		Иначе
			СтруктураТоваров.Вставить("id", Строка(выборка.НоменклатураКод));
		КонецЕсли;
		СуммаТоваров = СуммаТоваров + (выборка.Цена * выборка.Количество);
		МассивТоваров.Добавить(СтруктураТоваров);
	КонецЦикла;

	СтруктураОтвета = Новый Структура;
	СтруктураОтвета.Вставить("Товары", МассивТоваров);
	СтруктураОтвета.Вставить("СуммаТоваров", СуммаТоваров);
	Возврат СтруктураОтвета;
КонецФункции

Функция СформироватьСтруктуруОшибки(Сode, Message, Details)

	СтруктураОтвета = Новый Структура;
	СтруктураОтвета.Вставить("code", Сode);
	СтруктураОтвета.Вставить("message", Message);
	СтруктураОтвета.Вставить("details", Details);

	Возврат СтруктураОтвета;
КонецФункции

#КонецОбласти