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
		Для Каждого Перечисление Из Перечисления.дт_СостоянияЗаказовКлиента Цикл
			Если Строка(Перечисление) = Запрос.ПараметрыURL["status"] Тогда
				Статус = Перечисление;
			КонецЕсли;
		КонецЦикла;
				
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
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 100000
		|	ЗаказКлиента.Номер КАК Номер,
		|	ЗаказКлиента.Дата КАК Дата,
		|	ВЫБОР
		|		КОГДА ЗаказКлиента.Клиент <> ЗНАЧЕНИЕ(Справочник.Клиенты.ПустаяСсылка)
		|			ТОГДА ЗаказКлиента.Клиент
		|		ИНАЧЕ ЗаказКлиента.КлиентНаименование
		|	КОНЕЦ КАК Клиент,
		|	ВЫБОР
		|		КОГДА ЗаказКлиента.Клиент <> ЗНАЧЕНИЕ(Справочник.Клиенты.ПустаяСсылка)
		|			ТОГДА ЗаказКлиента.Клиент.Код
		|		ИНАЧЕ ""Не авторизован""
		|	КОНЕЦ КАК КлиентКод,
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
		|	АВТОНОМЕРЗАПИСИ() КАК НомерЗаписи,
		|	ПорядокЗаявок.ПорядковыйНомер КАК ПорядковыйНомер
		|ПОМЕСТИТЬ ВТ_ДанныеЗаявки
		|ИЗ
		|	Документ.ЗаказКлиента КАК ЗаказКлиента
		|		ЛЕВОЕ СОЕДИНЕНИЕ ТелефоныСлужебные КАК ТелефоныСлужебные
		|		ПО ЗаказКлиента.Ответственный = ТелефоныСлужебные.Ссылка.Пользователь
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПорядокЗаявок КАК ПорядокЗаявок
		|		ПО ЗаказКлиента.Ссылка = ПорядокЗаявок.Заявка
		|ГДЕ
		|	ЗаказКлиента.Состояние = &Состояние
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
		|	ВТ_ДанныеЗаявки.Телефон КАК Телефон,
		|	ВТ_ДанныеЗаявки.ПорядковыйНомер КАК ПорядковыйНомер
		|ИЗ
		|	ВТ_ДанныеЗаявки КАК ВТ_ДанныеЗаявки
		|ГДЕ
		|	ВТ_ДанныеЗаявки.ПорядковыйНомер >= &НачинаяСЗаписи
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПорядковыйНомер УБЫВ";
		
		ЗапросЗаявок.Текст =  СтрШаблон(Текст, Формат(10000, "ЧГ="));
		
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
		НачальнаяПозиция = СписокПоиска[0].ПорядковыйНомер; 
		КонечнаяПозиция  = СписокПоиска[СписокПоиска.Количество() - 1].ПорядковыйНомер;
			
		Для Каждого Результат Из СписокПоиска Цикл

			СтруктураЗаявок = Новый Структура;
			СтруктураЗаявок.Вставить("id", Строка(Результат.Номер));

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
	
			СтруктураЗаявок.Вставить("summ", Результат.СуммаДокумента);
			СтруктураЗаявок.Вставить("pose_app", Строка(Результат.ПорядковыйНомер));
			
			МассивЗаявок.Добавить(СтруктураЗаявок);
				
		КонецЦикла;

		Итог = ОбщееКолво / ?(Число(Запрос.ПараметрыURL["count"]) = 0, ОбщееКолво, Число(Запрос.ПараметрыURL["count"]));
		Итог = ?((Итог - Цел(Итог)) > 0, Цел(Итог) + 1, Цел(Итог));

		СтруктураИнфо= Новый Структура;
		СтруктураИнфо.Вставить("pages", 		Итог);
		СтруктураИнфо.Вставить("count", 		ОбщееКолво);
		СтруктураИнфо.Вставить("start_index", 	Число(НачальнаяПозиция));
		СтруктураИнфо.Вставить("end_index", 	Число(КонечнаяПозиция));
		СтруктураИнфо.Вставить("applications", 	МассивЗаявок);

		СтруктураОтвета = Новый Структура;
		СтруктураОтвета.Вставить("info", 		 СтруктураИнфо);
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

Функция ИзменитьСтатусЗаявкиchangestatusapp(Запрос)
	
	///+ТатарМА 31.10.2024
	НомерЗаявки = Запрос.ПараметрыURL["id"];
	
	//Перемещение заявки на сайте между группами по статусам и актуализирует порядковые номера
	ЗапросЗаявки = Новый Запрос;
	ЗапросЗаявки.Текст = "ВЫБРАТЬ
	|	ЗаказКлиента.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ЗаказКлиента КАК ЗаказКлиента
	|ГДЕ
	|	ЗаказКлиента.Номер = &Номер";
	
	ЗапросЗаявки.УстановитьПараметр("Номер", НомерЗаявки);
	Попытка
		Выборка = ЗапросЗаявки.Выполнить().Выбрать();
		Тело = Запрос.ПолучитьТелоКакстроку();
		ЧтениеJSON = Новый ЧтениеJSON;
		ЧтениеJSON.УстановитьСтроку(Тело);

		Массив  = ПрочитатьJSON(ЧтениеJSON);
		
		Если Массив.start_status = Массив.end_status Тогда
			Для Каждого Статус Из Перечисления.дт_СостоянияЗаказовКлиента Цикл
				Если Строка(Статус) = Массив.start_status Тогда
					НачальныйСтатус = Статус;
					КонечныйСтатус 	= Статус;
				КонецЕсли;
			КонецЦикла;
		Иначе
			Для Каждого Статус Из Перечисления.дт_СостоянияЗаказовКлиента Цикл
				Если Строка(Статус) = Массив.start_status Тогда
					НачальныйСтатус = Статус;
				ИначеЕсли Строка(Статус) = Массив.end_status Тогда
					КонечныйСтатус 	= Статус;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;

		НачальнаяПозиция 	= Массив.start_pose_app;
		КонечнаяПозиция 	= Массив.end_pose_app;
		НачальныйИндекс 	= Массив.start_index;
		КонечныйИндекс 		= Массив.end_index;
		Автор 				= Массив.author;

		Выборка.Следующий();

		//Записать актуальный статус и порядковый номер заявки
		ЗаписьВРегистреСведений = РегистрыСведений.ПорядокЗаявок.СоздатьМенеджерЗаписи();
		ЗаписьВРегистреСведений.Заявка = Документы.ЗаказКлиента.НайтиПоНомеру(НомерЗаявки);
		ЗаписьВРегистреСведений.Прочитать();
		ЗаписьВРегистреСведений.ПорядковыйНомер = КонечнаяПозиция;
		ЗаписьВРегистреСведений.Статус = КонечныйСтатус;
		ЗаписьВРегистреСведений.Записать();
		
		Если НачальныйСтатус = КонечныйСтатус Тогда
			АктуализироватьНумерациюВНачалеИКонцеСписка(НомерЗаявки, КонечнаяПозиция, КонечныйСтатус, НачальныйИндекс, КонечныйИндекс);
		Иначе
			//Актуализировать номера начальной группы заявок
			АктуализироватьНумерациюВКонцеСпискаАсинх(НомерЗаявки, НачальнаяПозиция, НачальныйСтатус, Ложь);
		
			//Актуализировать номера конечной группы заявок
			АктуализироватьНумерациюВКонцеСпискаАсинх(НомерЗаявки, КонечнаяПозиция, КонечныйСтатус, Истина);
		КонецЕсли;
		
		ТекстЛога = " Сменил статус заявки с " + Строка(НачальныйСтатус) + " на " + Строка(КонечныйСтатус);
		ЛогированиеWT10(Выборка.ссылка, Автор, ТекстЛога);
		
		Ответ = Новый HTTPСервисОтвет(200);
		Ответ.Заголовки.Вставить("Content-Type", "application/json; charset=utf-8");
		Ответ.УстановитьТелоИзСтроки("Успех. Заявка №" + НомерЗаявки + " перемещена с " + Строка(НачальныйСтатус) + " на " + Строка(КонечныйСтатус));
		
	Исключение
		ЗаписьJSON = Новый ЗаписьJSON;
		ЗаписьJSON.УстановитьСтроку();
		Информация = ИнформацияОбОшибке();
		ЗаписатьJSON(ЗаписьJSON, СформироватьСтруктуруОшибки( , "Ошибка выполнения запроса", Информация.Описание));

		СтрокаДляОтвета = ЗаписьJSON.Закрыть();

		Ответ = Новый HTTPСервисОтвет(500);
		Ответ.Заголовки.Вставить("Content-type", "application/json;  charset=utf-8");

		Ответ.УстановитьТелоИзСтроки(СтрокаДляОтвета);
		
		Возврат Ответ;
	КонецПопытки;
	
	Возврат Ответ;
	///-ТатарМА 31.10.2024
	
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

Процедура АктуализироватьНумерациюВКонцеСпискаАсинх(НомерЗаявки, ПозицияЗаявки, Статус, ЭтоКонечныйСтатус)
	
	///+ТатарМА 31.10.2024
	ЗапросНачальнаяГруппаЗаявки = Новый Запрос;
	ЗапросНачальнаяГруппаЗаявки.Текст = "ВЫБРАТЬ
	|	ЗаказКлиента.Ссылка КАК Ссылка,
	|	ПорядокЗаявок.ПорядковыйНомер КАК ПорядковыйНомер
	|ИЗ
	|	Документ.ЗаказКлиента КАК ЗаказКлиента
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПорядокЗаявок КАК ПорядокЗаявок
	|		ПО (ЗаказКлиента.Ссылка = ПорядокЗаявок.Заявка)
	|ГДЕ
	|	ПорядокЗаявок.ПорядковыйНомер >= &ПозицияЗаявки
	|	И ЗаказКлиента.Состояние = &Статус
	|	И ПорядокЗаявок.Заявка.Номер <> &Номер
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПорядокЗаявок.ПорядковыйНомер";

	ЗапросНачальнаяГруппаЗаявки.УстановитьПараметр("ПозицияЗаявки", ПозицияЗаявки);
	ЗапросНачальнаяГруппаЗаявки.УстановитьПараметр("Статус", 		Статус);
	ЗапросНачальнаяГруппаЗаявки.УстановитьПараметр("Номер", 		НомерЗаявки);

	ВыборкаНачальнаяГруппаЗаявки = ЗапросНачальнаяГруппаЗаявки.Выполнить().Выбрать();
	Если ВыборкаНачальнаяГруппаЗаявки.Количество() > 0 Тогда
		Если ЭтоКонечныйСтатус Тогда
			ПозицияВСписке = ПозицияЗаявки + 1;
		Иначе
			ПозицияВСписке = ПозицияЗаявки;
		КонецЕсли;
		
		Пока ВыборкаНачальнаяГруппаЗаявки.Следующий() Цикл
			ЗаписьВРегистреСведений = РегистрыСведений.ПорядокЗаявок.СоздатьМенеджерЗаписи();
			ЗаписьВРегистреСведений.Заявка = ВыборкаНачальнаяГруппаЗаявки.Ссылка;
			ЗаписьВРегистреСведений.Прочитать();
			ЗаписьВРегистреСведений.ПорядковыйНомер = ПозицияВСписке;
			ЗаписьВРегистреСведений.Записать();
			ПозицияВСписке = ПозицияВСписке + 1;
		КонецЦикла;
	КонецЕсли;
	///-ТатарМА 31.10.2024
	
КонецПроцедуры

Процедура АктуализироватьНумерациюВНачалеИКонцеСписка(НомерЗаявки, ПозицияЗаявки, Статус, НачальныйИндекс, КонечныйИндекс)
	
	///+ТатарМА 31.10.2024
	//Актуализировать нумерацию в выбранной части списка
	ЗапросНачалоСписка = Новый Запрос;
	ЗапросНачалоСписка.Текст = "ВЫБРАТЬ
	|	ПорядокЗаявок.Заявка КАК Заявка,
	|	ПорядокЗаявок.ПорядковыйНомер КАК ПорядковыйНомер
	|ИЗ
	|	РегистрСведений.ПорядокЗаявок КАК ПорядокЗаявок
	|ГДЕ
	|	ПорядокЗаявок.ПорядковыйНомер >= &КонечныйИндекс
	|	И ПорядокЗаявок.Заявка.Номер <> &Номер
	|	И ПорядокЗаявок.Статус = &Статус
	|	И ПорядокЗаявок.ПорядковыйНомер <= &НачальныйИндекс
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПорядокЗаявок.ПорядковыйНомер";

	ЗапросНачалоСписка.УстановитьПараметр("Номер", 				НомерЗаявки);
	ЗапросНачалоСписка.УстановитьПараметр("КонечныйИндекс", 	КонечныйИндекс);
	ЗапросНачалоСписка.УстановитьПараметр("Статус", 			Статус);
	ЗапросНачалоСписка.УстановитьПараметр("НачальныйИндекс", 	НачальныйИндекс);

	ВыборкаНачалоСписка = ЗапросНачалоСписка.Выполнить().Выбрать();
	Если ВыборкаНачалоСписка.Количество() > 0 Тогда
		ПозицияВСписке = КонечныйИндекс;
		Пока ВыборкаНачалоСписка.Следующий() Цикл
			Если ПозицияВСписке = ПозицияЗаявки Тогда
				ПозицияВСписке = ПозицияВСписке + 1;
			КонецЕсли;
			ЗаписьВРегистреСведений = РегистрыСведений.ПорядокЗаявок.СоздатьМенеджерЗаписи();
			ЗаписьВРегистреСведений.Заявка = ВыборкаНачалоСписка.Заявка;
			ЗаписьВРегистреСведений.Прочитать();
			ЗаписьВРегистреСведений.ПорядковыйНомер = ПозицияВСписке;
			ЗаписьВРегистреСведений.Записать();

			ПозицияВСписке = ПозицияВСписке + 1;
		КонецЦикла;
	КонецЕсли;
	///-ТатарМА 31.10.2024
	
КонецПроцедуры

Процедура ЛогированиеWT10(Заявка, Автор, Лог)
	Автор = Справочники.Сотрудники.НайтиПоКоду(Автор).Пользователь;
	МенеджерЗаписиЛога = РегистрыСведений.ЛогWT10.СоздатьМенеджерЗаписи();
	МенеджерЗаписиЛога.Источник = Заявка;
	МенеджерЗаписиЛога.Пользователь = Автор;
	МенеджерЗаписиЛога.Лог = "--------------------------" + Символы.ПС + Автор + Лог;
	МенеджерЗаписиЛога.Записать();
КонецПроцедуры

#КонецОбласти