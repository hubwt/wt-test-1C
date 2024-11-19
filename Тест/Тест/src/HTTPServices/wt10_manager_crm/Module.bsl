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
		
		Текст = "ВЫБРАТЬ ПЕРВЫЕ 100000
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
		|	ЗаказКлиента.СуммаДокумента КАК СуммаДокумента,
		|	ЗаказКлиента.ДатаСвязи КАК ДатаСвязи,
		|	ЗаказКлиента.Ссылка КАК Ссылка,
		|	ЗаказКлиента.ОтветственныйЗаОбработку КАК ОтветственныйЗаОбработку,
		|	ЗаказКлиента.Комментарий КАК Комментарий,
		|	ЗаказКлиента.ПодстатусОбработки КАК ПодстатусОбработки,
		|	ЗаказКлиента.НомерТелефона КАК Телефон,
		|	АВТОНОМЕРЗАПИСИ() КАК НомерЗаписи,
		|	ПорядокЗаявок.ПорядковыйНомер КАК ПорядковыйНомер,
		|	ЗаказКлиента.Клиент.Город2 КАК КлиентГород,
		|	ЗаказКлиента.Клиент.КоличествоАвтомобилей КАК КоличествоАвтомобилей
		|ПОМЕСТИТЬ ВТ_ДанныеЗаявки
		|ИЗ
		|	Документ.ЗаказКлиента КАК ЗаказКлиента
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПорядокЗаявок КАК ПорядокЗаявок
		|		ПО (ЗаказКлиента.Ссылка = ПорядокЗаявок.Заявка)
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
		|	ВТ_ДанныеЗаявки.ПодстатусОбработки КАК ПодстатусОбработки,
		|	ВТ_ДанныеЗаявки.КлиентКод КАК КлиентКод,
		|	ВТ_ДанныеЗаявки.Телефон КАК Телефон,
		|	ВТ_ДанныеЗаявки.ПорядковыйНомер КАК ПорядковыйНомер,
		|	ВТ_ДанныеЗаявки.КлиентГород КАК КлиентГород,
		|	ВТ_ДанныеЗаявки.КоличествоАвтомобилей КАК КоличествоАвтомобилей
		|ИЗ
		|	ВТ_ДанныеЗаявки КАК ВТ_ДанныеЗаявки
		|ГДЕ
		|	ВТ_ДанныеЗаявки.ПорядковыйНомер >= &НачинаяСЗаписи
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПорядковыйНомер";
				
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
			СтруктураКлиента.Вставить("city", Строка(Результат.КлиентГород));
			СтруктураКлиента.Вставить("count_car", Строка(Результат.КоличествоАвтомобилей));
			СтруктураЗаявок.Вставить("client", СтруктураКлиента);

			СтруктураМенеджера = Новый Структура;
			СтруктураМенеджера.Вставить("name", Строка(Результат.Ответственный));
			//СтруктураМенеджера.Вставить("id", Строка(Результат.КодСотрудника));
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
			АктуализироватьНумерациюВКонцеСписка(НомерЗаявки, НачальнаяПозиция, НачальныйСтатус, Ложь);
		
			//Актуализировать номера конечной группы заявок
			АктуализироватьНумерациюВКонцеСписка(НомерЗаявки, КонечнаяПозиция, КонечныйСтатус, Истина);
			
			ДокОбъект = Документы.ЗаказКлиента.НайтиПоНомеру(НомерЗаявки).ПолучитьОбъект();
			ДокОбъект.Состояние = КонечныйСтатус;
			ДокОбъект.Записать();
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


Функция СоздатьЗаявкуcreateApplication(Запрос)

	Тело = Запрос.ПолучитьТелоКакстроку();
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(Тело);

	Массив  = ПрочитатьJSON(ЧтениеJSON);

	НомерТелефона = Массив.phone;
	НомерТелефона = ПолучитьНормализованныйНомер(НомерТелефона);

	КодМенеджера = Массив.manager;
	ИмяКлиента 	 = Массив.client_name;
	Попытка
		НоваяЗаявка = Документы.ЗаказКлиента.СоздатьДокумент();
		НоваяЗаявка.Дата = ТекущаяДатаСеанса();
		НоваяЗаявка.НомерТелефона = НомерТелефона;
		НоваяЗаявка.WTPanel = Справочники.СтатусыWT.НайтиПоКоду("000000017"); //Ожидание
		НоваяЗаявка.Состояние = Перечисления.дт_СостоянияЗаказовКлиента.Ожидание;
		НоваяЗаявка.ПодстатусОбработки = Перечисления.ПодстатусыОбработкиЗаявок.Ожидание;
		НоваяЗаявка.Ответственный = Справочники.Сотрудники.НайтиПоКоду(КодМенеджера).Пользователь;
		НоваяЗаявка.КлиентНаименование = ИмяКлиента;
		НоваяЗаявка.КлиентССайта = Справочники.КлиентыССайта.НайтиПоКоду("000000001");

		Клиент = ПолучитьКлиентаПоТелефону(НомерТелефона);
		Если Клиент <> Справочники.Клиенты.ПустаяСсылка() Тогда
			НоваяЗаявка.Клиент = Клиент;
		Иначе
			НовыйКлиент = Справочники.Клиенты.СоздатьЭлемент();
			НовыйКлиент.Телефон = НомерТелефона;
			НовыйКлиент.Наименование = ИмяКлиента;
			НовыйКлиент.Записать();
			НоваяЗаявка.Клиент = НовыйКлиент.Ссылка;
		КонецЕсли;
		СуммаДокумента = 0;
		МассивОшибок = Новый Массив;

		Для Каждого покупка Из Массив.products Цикл

			Если СтрНайти(Покупка, "_") > 0 Тогда
				//@skip-check query-in-loop
				ИнформацияОпартии = ПолучитьИнформациюОПартии(покупка);

				Если ИнформацияОпартии.Партия <> 0 Тогда
					СтрокаТоваров = НоваяЗаявка.Товары.Добавить();
					СтрокаТоваров.Количество = 1;
				//@skip-check wrong-type-expression
					СтрокаТоваров.Партия = ИнформацияОпартии.Партия;
				//@skip-check wrong-type-expression
					СтрокаТоваров.Склад  = ИнформацияОпартии.Склад;
					СтрокаТоваров.Цена   = ИнформацияОпартии.Цена;
				//@skip-check wrong-type-expression
					СтрокаТоваров.Номенклатура   = ИнформацияОпартии.Товар;
					СуммаДокумента = СуммаДокумента + ИнформацияОпартии.Цена;
				Иначе
					МассивОшибок.Добавить(покупка);
				КонецЕсли;
			Иначе
			//@skip-check query-in-loop
				ИнформацияОТоваре = ПолучитьИнформациюОТоваре(покупка);

				Если ИнформацияОТоваре.Товар <> 0 Тогда
					СтрокаТоваров = НоваяЗаявка.Товары.Добавить();
					СтрокаТоваров.Количество = 1;
				//@skip-check wrong-type-expression
					СтрокаТоваров.Цена   = ИнформацияОТоваре.Цена;
				//@skip-check wrong-type-expression
					СтрокаТоваров.Номенклатура   = ИнформацияОТоваре.Товар;
					СуммаДокумента = СуммаДокумента + ИнформацияОТоваре.Цена;
				Иначе

					МассивОшибок.Добавить(покупка);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		НоваяЗаявка.СуммаДокумента = СуммаДокумента;
		/// Комлев 15/08/24+++
		НоваяЗаявка.ФинансовыеСтатусы = Перечисления.ФинансовыеСтатусыДляЗаявкиКлиента.НеОплачено;
		НоваяЗаявка.СтатусыДействия = Перечисления.дт_СостоянияЗаказовКлиента.Ожидание;
		НоваяЗаявка.Состояние = перечисления.дт_СостоянияЗаказовКлиента.Ожидание;
		НоваяЗаявка.ЗаявкаССайта = Истина;
		НоваяЗаявка.Записать();
		
		/// Комлев 15/08/24---
		ИмяКлиентаПерем = ?(Клиент <> Справочники.Клиенты.ПустаяСсылка(), Клиент.Наименование, НовыйКлиент.Наименование);
		КодКлиентаПерем = ?(Клиент <> Справочники.Клиенты.ПустаяСсылка(), Клиент.Код, НовыйКлиент.Код);
		КоличествоМашин = ?(Клиент <> Справочники.Клиенты.ПустаяСсылка(), Число(Клиент.КоличествоАвтомобилей), 0);
		Город = ?(Клиент <> Справочники.Клиенты.ПустаяСсылка(), Клиент.Город, 0);
		СтруктураЗаявок = Новый Структура;
		СтруктураЗаявок.Вставить("id", Строка(НоваяЗаявка.Номер));
		СтруктураКлиента = Новый Структура;
		СтруктураКлиента.Вставить("name", Строка(ИмяКлиентаПерем));
		СтруктураКлиента.Вставить("id", КодКлиентаПерем);
		СтруктураКлиента.Вставить("phone", НомерТелефона);
		СтруктураКлиента.Вставить("city", Город);
		СтруктураКлиента.Вставить("count_cars", КоличествоМашин);
		
		СтруктураЗаявок.Вставить("client", СтруктураКлиента);

		СтруктураМенеджера = Новый Структура;

		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	СотрудникиКонтактнаяИнформация.Ссылка КАК Ссылка,
		|	СотрудникиКонтактнаяИнформация.Представление КАК ТелефонСлужебный,
		|	СотрудникиКонтактнаяИнформация.Ссылка.Код КАК КодСотрудника
		|ИЗ
		|	Справочник.Сотрудники.КонтактнаяИнформация КАК СотрудникиКонтактнаяИнформация
		|ГДЕ
		|	СотрудникиКонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ТелефонСотрудникаСлужебный)
		|	И СотрудникиКонтактнаяИнформация.Ссылка.Пользователь = &Пользователь";
		Запрос.УстановитьПараметр("Пользователь", НоваяЗаявка.Ответственный);
		РезультатЗапроса = Запрос.Выполнить();

		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

		ВыборкаДетальныеЗаписи.Следующий();
		СтруктураМенеджера.Вставить("name", Строка(НоваяЗаявка.Ответственный));
		СтруктураМенеджера.Вставить("id", Строка(ВыборкаДетальныеЗаписи.КодСотрудника));
		СтруктураМенеджера.Вставить("phone", Строка(ВыборкаДетальныеЗаписи.ТелефонСлужебный));
		СтруктураЗаявок.Вставить("manager", СтруктураМенеджера);
		СтруктураЗаявок.Вставить("summ", НоваяЗаявка.СуммаДокумента);
		ЗаписьJSON = Новый ЗаписьJSON;
		ЗаписьJSON.УстановитьСтроку();

		ЗаписатьJSON(ЗаписьJSON, СтруктураЗаявок);

		СтрокаДляОтвета = ЗаписьJSON.Закрыть();

		Ответ = Новый HTTPСервисОтвет(200);
		Ответ.Заголовки.Вставить("Content-type", "application/json;  charset=utf-8");

		Ответ.УстановитьТелоИзСтроки(СтрокаДляОтвета, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);
	Исключение

		ЗаписьJSON = Новый ЗаписьJSON;
		ЗаписьJSON.УстановитьСтроку();

		Информация = ИнформацияОбОшибке();

		ЗаписатьJSON(ЗаписьJSON, СформироватьСтруктуруОшибки( , "Ошибка выполнения запроса", Информация.Описание));
		СтрокаДляОтвета = ЗаписьJSON.Закрыть();

		Ответ = Новый HTTPСервисОтвет(500);
		Ответ.Заголовки.Вставить("Content-type", "application/json;  charset=utf-8");

		Ответ.УстановитьТелоИзСтроки( СтрокаДляОтвета);

	КонецПопытки;

	Возврат Ответ;

КонецФункции

Функция ПолучитьТоварыКарточкиproductscard(Запрос)
	ЗапросТовара = Новый Запрос;
	Текстзапроса = "ВЫБРАТЬ первые 10000
				   |	РегИндНомер.индкод.Владелец.Наименование КАК Наименование,
				   |	РегИндНомер.индкод КАК индкод,
				   |	ВЫБОР
				   |		КОГДА РегИндНомер.Цена > 0
				   |			ТОГДА РегИндНомер.Цена
				   |		ИНАЧЕ РегИндНомер.индкод.Владелец.РекомендованаяЦена
				   |	КОНЕЦ КАК Цена,
				   |	РегИндНомер.Комментарий КАК Комментарий,
				   |	РегИндНомер.индкод.Владелец.Артикул КАК Артикул,
				   |	ПРЕДСТАВЛЕНИЕ(РегИндНомер.индкод.Владелец.Подкатегория2) КАК Подкатегория2,
				   |	ВЫБОР
				   |		КОГДА РегИндНомер.Стеллаж <> ЗНАЧЕНИЕ(справочник.Стеллаж.ПустаяСсылка)
				   |			ТОГДА ПРЕДСТАВЛЕНИЕ(РегИндНомер.Стеллаж)
				   |		ИНАЧЕ ПРЕДСТАВЛЕНИЕ(РегИндНомер.индкод.Владелец.МестоНаСкладе2)
				   |	КОНЕЦ КАК Адрес,
				   |	АВТОНОМЕРЗАПИСИ() КАК НомерЗаписи,
				   |	ПРЕДСТАВЛЕНИЕ(РегистрНакопления1Остатки.Склад) КАК Склад,
				   |	РегИндНомер.Поддон КАК Поддон,
				   |	РегистрНакопления1Остатки.Склад.Город КАК Город,
				   |   РегистрНакопления1Остатки.машина.Год КАК машинаГод,
				   |	РегИндНомер.индкод.Владелец.Код КАК индкодВладелецКод,
				   |	РегистрНакопления1Остатки.КолвоОстаток КАК КолвоОстаток,
				   |	РегИндНомер.индкод.Владелец.Комплектация КАК индкодВладелецКомплектация,
				   |	РегИндНомер.индкод.Владелец.АртикулПоиск КАК СтрокаПоиска,
				   |	РегИндНомер.индкод.Владелец.DirectText КАК СтрокаПоиска1
				   |ПОМЕСТИТЬ ВТ_данныеНоменклатур
				   |ИЗ
				   |	Справочник.Номенклатура КАК ИндНомер
				   |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ИндНомер КАК РегИндНомер
				   |			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.РегистрНакопления1.Остатки КАК РегистрНакопления1Остатки
				   |			ПО РегИндНомер.индкод = РегистрНакопления1Остатки.индкод
				   |		ПО ИндНомер.Ссылка = РегИндНомер.Индкод.Владелец
				   |ГДЕ
				   |	РегистрНакопления1Остатки.КолвоОстаток > 0
				   |И РегИндНомер.АвитоЧастник
				   |	И ИндНомер.Код = &Наименование
				   |%2
				   |;
				   |
				   |////////////////////////////////////////////////////////////////////////////////
				   |ВЫБРАТЬ ПЕРВЫЕ %1
				   |	ВТ_данныеНоменклатур.Наименование КАК Наименование,
				   |	ПРЕДСТАВЛЕНИЕ(ВТ_данныеНоменклатур.индкод) КАК индкод,
				   |	ВТ_данныеНоменклатур.Цена КАК Цена,
				   |	ВТ_данныеНоменклатур.Комментарий КАК Комментарий,
				   |	ВТ_данныеНоменклатур.Артикул КАК Артикул,
				   |	ВТ_данныеНоменклатур.Подкатегория2 КАК Подкатегория2,
				   |	ВТ_данныеНоменклатур.Адрес КАК Адрес,
				   |	ВТ_данныеНоменклатур.машинаГод КАК машинаГод,
				   |	ВТ_данныеНоменклатур.Склад КАК Склад,
				   |	ВТ_данныеНоменклатур.НомерЗаписи КАК НомерЗаписи,
				   |	ВТ_данныеНоменклатур.Поддон КАК Поддон,
				   |	ВТ_данныеНоменклатур.Город КАК Город,
				   |	ВТ_данныеНоменклатур.индкодВладелецКод КАК Код,
				   |	ВТ_данныеНоменклатур.КолвоОстаток КАК Остаток,
				   |	ВТ_данныеНоменклатур.индкодВладелецКомплектация КАК Комплектация,
				   |	ВТ_данныеНоменклатур.СтрокаПоиска КАК СтрокаПоиска,
				   |	ВТ_данныеНоменклатур.СтрокаПоиска1 КАК СтрокаПоиска1
				   |ИЗ
				   |	ВТ_данныеНоменклатур КАК ВТ_данныеНоменклатур
				   |ГДЕ
				   |	ВТ_данныеНоменклатур.НомерЗаписи >= &НачинаяСЗаписи
				   |
				   |УПОРЯДОЧИТЬ ПО
				   |	НомерЗаписи";

	Если Число(Запрос.ПараметрыURL["filter_stock"]) = 1 Тогда
		Склад = Справочники.Склады.НайтиПоКоду("000000002");
	ИначеЕсли Число(Запрос.ПараметрыURL["filter_stock"]) = 2 Тогда
		Склад = Справочники.Склады.НайтиПоКоду("000000005");
	ИначеЕсли Число(Запрос.ПараметрыURL["filter_stock"]) = 3 Тогда
		Склад = Справочники.Склады.НайтиПоКоду("000000008");
	КонецЕсли;
	 /// Комлев 7/08/24 
	ТекстФильтраПоСкладам =  "И РегистрНакопления1Остатки.Склад = &Склад";
	  /// Комлев 7/08/24 ---		
	ИндКод = Строка(Запрос.ПараметрыURL["id"]);
	Если Число(Запрос.ПараметрыURL["filter_stock"]) < 4 И Число(Запрос.ПараметрыURL["filter_stock"]) > 0 Тогда
		запросТовара.Текст =  СтрШаблон(Текстзапроса, Формат(10000, "ЧГ="), ТекстФильтраПоСкладам); // Добавить отбор по складу
		запросТовара.УстановитьПараметр("Склад", Склад);
	Иначе
		запросТовара.Текст =   СтрШаблон(Текстзапроса, Формат(10000, "ЧГ="), ""); // Убрать отбор по складу
	КонецЕсли;

	запросТовара.УстановитьПараметр("наименование", ИндКод);
	запросТовара.УстановитьПараметр("НачинаяСЗаписи", 0);
	Выборкаобщ = запросТовара.Выполнить().Выбрать().Количество();
		
// Фильтр по складам
/// Комлев 7/8/24 +++
	Если Число(Запрос.ПараметрыURL["filter_stock"]) < 4 И Число(Запрос.ПараметрыURL["filter_stock"]) > 0 Тогда
		запросТовара.Текст =  СтрШаблон(Текстзапроса, Формат(?(Число(Запрос.ПараметрыURL["count"]) > 0,
			Запрос.ПараметрыURL["count"], 10000), "ЧГ="), ТекстФильтраПоСкладам); // Добавить отбор по складу
		запросТовара.УстановитьПараметр("Склад", Склад);
	Иначе
		запросТовара.Текст =  СтрШаблон(Текстзапроса, Формат(?(Число(Запрос.ПараметрыURL["count"]) > 0,
			Запрос.ПараметрыURL["count"], 10000), "ЧГ="), ""); // Убрать отбор по складу
	КонецЕсли;
	
	/// Комлев 7/8/24 ---
	запросТовара.УстановитьПараметр("наименование", ИндКод);

	запросТовара.УстановитьПараметр("НачинаяСЗаписи", 0);

	Если Число(((Запрос.ПараметрыURL["count"]) * (Запрос.ПараметрыURL["page"]))) > 0 И Число(
		Запрос.ПараметрыURL["page"]) > 1 Тогда
		запросТовара.УстановитьПараметр("НачинаяСЗаписи", Число(((Запрос.ПараметрыURL["count"])
			* ((Запрос.ПараметрыURL["page"]) - 1) + 1)));
	Иначе
		запросТовара.УстановитьПараметр("НачинаяСЗаписи", 0);
	КонецЕсли;
	//Выборкаобщ = запросТовара.Выполнить().Выбрать().Количество();
	ТЗ_Товары = запросТовара.Выполнить().Выгрузить();
	//	Выборкаобщ = Тз.Количество();
	//Массивкодов = ТЗ.ВыгрузитьКолонку("индкод");
	ТЗ_Товары.Колонки.Добавить("колФото", Новый ОписаниеТипов("Число"));
	ТЗ_Товары.Колонки.Добавить("Фото", Новый ОписаниеТипов("Массив"));
	МассивТоваров = Новый Массив;

	ИндКоды = ТЗ_Товары.ВыгрузитьКолонку("индкод");
	Фотки = РаботаССайтомWT.ПолучениеФото(ИндКоды);
	Итер = 0;

	Для Каждого стр Из ТЗ_Товары Цикл
		НайденныеФотки = Новый Массив;
		//ПутьКФайлам = "W:\code\imageService\images\" + стр.индкод;
		НайденныеФотки = Фотки[итер].urls;
		МассивФото = Новый массив;
		Если НайденныеФотки <> Неопределено И НайденныеФотки.Количество() > 0 Тогда

			стр.колфото = 1;

			Для Каждого Фотка Из НайденныеФотки Цикл
				Текст = "";
				//Текст = "https://wt10.ru" + Фотка; 
				Текст = Фотка;
				МассивФото.Добавить(Текст);
			КонецЦикла;
		КонецЕсли;
		Итер = итер + 1;
		ТЗ_Товары.Сортировать("колФото Убыв");

		СтруктураТоваров = Новый Структура;
		СтруктураТоваров.Вставить("name", Строка(стр.Наименование));
		//СтруктураТоваров.Вставить("search", Строка(стр.СтрокаПоиска));
		//СтруктураТоваров.Вставить("search1", Строка(стр.СтрокаПоиска1));
		СтруктураТоваров.Вставить("article", Строка(стр.Артикул));
		СтруктураТоваров.Вставить("price", стр.Цена);
		СтруктураТоваров.Вставить("comment", Строка(стр.Комментарий));
		СтруктураТоваров.Вставить("shelf", Строка(стр.Адрес));
		СтруктураТоваров.Вставить("sklad", Строка(стр.Склад));
		СтруктураТоваров.Вставить("code", Строка(стр.Код));
		СтруктураТоваров.Вставить("type", "PRODUCT");
		//СтруктураТоваров.Вставить("count", Строка(стр.Остаток));
		//СтруктураТоваров.Вставить("stack", стр.Комплектация);

		СтруктураТоваров.Вставить("city", Строка(стр.Город));

		СтруктураТоваров.Вставить("id", Строка(стр.индкод));
		СтруктураТоваров.Вставить("poddon", Строка(стр.Поддон));
		СтруктураТоваров.Вставить("yearcar", число(стр.машинаГод));
		СтруктураТоваров.Вставить("photos", МассивФото);
		МассивТоваров.Добавить(СтруктураТоваров);
	КонецЦикла;
	Итог = Выборкаобщ / ?(Число(Запрос.ПараметрыURL["count"]) = 0, Выборкаобщ, Число(Запрос.ПараметрыURL["count"]));
	Итог = ?((Итог - Цел(Итог)) > 0, Цел(Итог) + 1, Цел(Итог));

	СтруктураИнфо= Новый Структура;
	СтруктураИнфо.Вставить("pages", Итог);
	СтруктураИнфо.Вставить("count", Выборкаобщ);
//	Если Лев(Запрос.ПараметрыURL["id"],1) = "П" Тогда
//		СтруктураИнфо.Вставить("polka",Строка(ПолучитьПолку(Строка(Запрос.ПараметрыURL["id"])))); 
//		//	Иначе
//		//		СтруктураТоваров.Вставить("polka",Строка(ПолучитьПолку(Строка(стр.Поддон)))); 
//	КонецЕсли;
//	

	СтруктураОтвета = Новый Структура;
	//СтруктураОтвета.Вставить("info", СтруктураИнфо);
	СтруктураОтвета.Вставить("pages", Итог);
	СтруктураОтвета.Вставить("count", Выборкаобщ);
	СтруктураОтвета.Вставить("products", МассивТоваров);

	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();

	ЗаписатьJSON(ЗаписьJSON, СтруктураОтвета);

	СтрокаДляОтвета = ЗаписьJSON.Закрыть();

	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.Заголовки.Вставить("Content-type", "application/json;  charset=utf-8");

	Ответ.УстановитьТелоИзСтроки(СтрокаДляОтвета, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);

	Возврат Ответ;
КонецФункции

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Функция ПолучитьКлиентаПоТелефону(Номер)

	//Сергеев Ф.В. ++ Дата: 14.05.2024
	Результат = Справочники.Клиенты.ПустаяСсылка();

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Клиенты.Ссылка
	|ИЗ
	|	Справочник.Клиенты КАК Клиенты
	|ГДЕ
	|	Клиенты.Телефон = &Телефон";

	Запрос.УстановитьПараметр("Телефон", Номер);

	РезультатЗапроса = Запрос.Выполнить().Выбрать();

	Если РезультатЗапроса.Количество() > 0 Тогда
		РезультатЗапроса.Следующий();
		Результат = РезультатЗапроса.Ссылка;
	КонецЕсли;
	Возврат Результат;
	//Сергеев Ф.В. -- Дата: 14.05.2024

КонецФункции


Функция ПолучитьНормализованныйНомер(Номер)

	//Сергеев Ф.В. ++ Дата: 14.05.2024
	ПромежуточныйНомер = "";
	ДопустимыеСимволы = "0123456789";
	ДлинаНомера = СтрДлина(СокрЛП(Номер));
	Для Сч1 = 1 По ДлинаНомера Цикл
		ТекСимвол = Сред(СокрЛП(Номер), Сч1, 1);
		Если СтрНайти(ДопустимыеСимволы, ТекСимвол) > 0 Тогда
			ПромежуточныйНомер = ПромежуточныйНомер + ТекСимвол;
			Если Лев(ПромежуточныйНомер, 1) = "8" Тогда
				ПромежуточныйНомер = "7";
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Если Лев(ПромежуточныйНомер, 1) = "7" Тогда
		ПромежуточныйНомер = "+" + ПромежуточныйНомер;
	КонецЕсли;

	ФорматированныйНомер = Лев(ПромежуточныйНомер, 2) + " " + Сред(ПромежуточныйНомер, 3, 3) + " " + Сред(
		ПромежуточныйНомер, 6, 3) + "-" + Сред(ПромежуточныйНомер, 9, 2) + "-" + Сред(ПромежуточныйНомер, 11);

	Возврат ФорматированныйНомер;
	//Сергеев Ф.В. -- Дата: 14.05.2024

КонецФункции

Функция ПолучитьИнформациюОТоваре(Code)

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Ссылка,
	|	Номенклатура.РекомендованаяЦена КАК РекомендованаяЦена
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Код = &Код";
	
	Запрос.УстановитьПараметр("Код", code);
	
	Выборка = Запрос.Выполнить().Выбрать();
	СтруктураОтвета = Новый Структура;
	Если Выборка.Количество() > 0 Тогда
		Выборка.Следующий();
		СтруктураОтвета.Вставить("Цена",   Выборка.РекомендованаяЦена);
		СтруктураОтвета.Вставить("Товар",  Выборка.Ссылка);
	Иначе
		СтруктураОтвета.Вставить("Цена",   0);
		СтруктураОтвета.Вставить("Товар",  0);
	КонецЕсли;

	Возврат СтруктураОтвета;
КонецФункции

Функция ПолучитьИнформациюОПартии(Ind_code)

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ИндНомер.индкод КАК индкод
	|ПОМЕСТИТЬ ВТ_предКоды
	|ИЗ
	|	РегистрСведений.ИндНомер КАК ИндНомер
	|ГДЕ
	|	ИндНомер.индкод.Наименование ПОДОБНО &Наименование СПЕЦСИМВОЛ ""~""
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РегИндНомер.индкод.Владелец КАК Наименование,
	|	РегИндНомер.индкод КАК индкод,
	|	ВЫБОР
	|		КОГДА РегИндНомер.Цена > 0
	|			ТОГДА РегИндНомер.Цена
	|		ИНАЧЕ РегИндНомер.индкод.Владелец.РекомендованаяЦена
	|	КОНЕЦ КАК Цена,
	|	РегИндНомер.Комментарий КАК Комментарий,
	|	РегИндНомер.индкод.Владелец.Артикул КАК Артикул,
	|	ПРЕДСТАВЛЕНИЕ(РегИндНомер.индкод.Владелец.Подкатегория2) КАК Подкатегория2,
	|	ВЫБОР
	|		КОГДА РегИндНомер.Стеллаж <> ЗНАЧЕНИЕ(справочник.Стеллаж.ПустаяСсылка)
	|			ТОГДА ПРЕДСТАВЛЕНИЕ(РегИндНомер.Стеллаж)
	|		ИНАЧЕ ПРЕДСТАВЛЕНИЕ(РегИндНомер.индкод.Владелец.МестоНаСкладе2)
	|	КОНЕЦ КАК Адрес,
	|	РегистрНакопления1Остатки.Склад КАК Склад,
	|	РегИндНомер.Поддон КАК Поддон,
	|	РегИндНомер.АвитоЧастник КАК АвитоЧастник,
	|	РегИндНомер.индкод.Владелец.Размеры КАК Размеры,
	|	РегИндНомер.индкод.Владелец.Вес КАК Вес,
	|	РегИндНомер.индкод.Владелец.выс КАК выс,
	|	РегИндНомер.индкод.Владелец.длин КАК длин,
	|	РегИндНомер.индкод.Владелец.шир КАК шир,
	|	РегистрНакопления1Остатки.машина
	|ИЗ
	|	ВТ_предКоды КАК ИндНомер
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.РегистрНакопления1.Остатки КАК РегистрНакопления1Остатки
	|		ПО ИндНомер.индкод = РегистрНакопления1Остатки.индкод
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ИндНомер КАК РегИндНомер
	|		ПО ИндНомер.индкод = РегИндНомер.индкод";
	
	Запрос.УстановитьПараметр("Наименование", Ind_code);
	Выборка = Запрос.Выполнить().Выбрать();
	СтруктураОтвета = Новый Структура;
	Если Выборка.Количество() > 0 Тогда
		Выборка.Следующий();
		СтруктураОтвета.Вставить("Цена",   Выборка.Цена);
		СтруктураОтвета.Вставить("Склад",  Выборка.Склад);
		СтруктураОтвета.Вставить("Партия", Выборка.индкод);
		СтруктураОтвета.Вставить("Машина", Выборка.Машина);
		СтруктураОтвета.Вставить("Товар",  Выборка.Наименование);
	Иначе
		СтруктураОтвета.Вставить("Цена",   0);
		СтруктураОтвета.Вставить("Склад",  0);
		СтруктураОтвета.Вставить("Партия", 0);
		СтруктураОтвета.Вставить("Машина", 0);
		СтруктураОтвета.Вставить("Товар",  0);
	КонецЕсли;

	Возврат СтруктураОтвета;
КонецФункции

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


Процедура АктуализироватьНумерациюВКонцеСписка(НомерЗаявки, ПозицияЗаявки, Статус, ЭтоКонечныйСтатус)
	
	///+ТатарМА 31.10.2024
	ЗапросНачальнаяГруппаЗаявки = Новый Запрос;
	ЗапросНачальнаяГруппаЗаявки.Текст = "ВЫБРАТЬ
	|	ЗаказКлиента.Ссылка КАК Заявка,
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

	//ВыборкаНачальнаяГруппаЗаявки = ЗапросНачальнаяГруппаЗаявки.Выполнить().Выбрать();
	ВыборкаНачальнаяГруппаЗаявки = ЗапросНачальнаяГруппаЗаявки.Выполнить().Выгрузить();
	Если ВыборкаНачальнаяГруппаЗаявки.Количество() > 0 Тогда
		Если ЭтоКонечныйСтатус Тогда
			ПозицияВСписке = ПозицияЗаявки + 1;
		Иначе
			ПозицияВСписке = ПозицияЗаявки;
		КонецЕсли;
		
//		Пока ВыборкаНачальнаяГруппаЗаявки.Следующий() Цикл
//			ЗаписьВРегистреСведений = РегистрыСведений.ПорядокЗаявок.СоздатьМенеджерЗаписи();
//			ЗаписьВРегистреСведений.Заявка = ВыборкаНачальнаяГруппаЗаявки.Ссылка;
//			ЗаписьВРегистреСведений.Прочитать();
//			ЗаписьВРегистреСведений.ПорядковыйНомер = ПозицияВСписке;
//			ЗаписьВРегистреСведений.Записать();
//			ПозицияВСписке = ПозицияВСписке + 1;
//		КонецЦикла;

	НаборЗаписей = РегистрыСведений.ПорядокЗаявок.СоздатьНаборЗаписей();
	Для Каждого Заявка Из ВыборкаНачальнаяГруппаЗаявки Цикл
			НоваяЗапись = НаборЗаписей.Добавить();
			НоваяЗапись.Заявка = Заявка.Заявка;
			НоваяЗапись.ПорядковыйНомер = ПозицияВСписке;
			ПозицияВСписке = ПозицияВСписке + 1;
	КонецЦикла;
	НаборЗаписей.Записать();
	
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

	//ВыборкаНачалоСписка = ЗапросНачалоСписка.Выполнить().Выбрать();
	ВыборкаНачалоСписка = ЗапросНачалоСписка.Выполнить().Выгрузить();
	Если ВыборкаНачалоСписка.Количество() > 0 Тогда
		ПозицияВСписке = КонечныйИндекс;
		//Пока ВыборкаНачалоСписка.Следующий() Цикл
			НаборЗаписей = РегистрыСведений.ПорядокЗаявок.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.
		Для каждого Заявка ИЗ ВыборкаНачалоСписка Цикл
			Если ПозицияВСписке = ПозицияЗаявки Тогда
				ПозицияВСписке = ПозицияВСписке + 1;
			КонецЕсли;
//			ЗаписьВРегистреСведений = РегистрыСведений.ПорядокЗаявок.СоздатьМенеджерЗаписи();
//			ЗаписьВРегистреСведений.Заявка = ВыборкаНачалоСписка.Заявка;
//			ЗаписьВРегистреСведений.Прочитать();
//			ЗаписьВРегистреСведений.ПорядковыйНомер = ПозицияВСписке;
//			ЗаписьВРегистреСведений.Записать();
//
//			ПозицияВСписке = ПозицияВСписке + 1;

			НоваяЗапись = НаборЗаписей.Добавить();
			НоваяЗапись.Заявка = Заявка.Заявка;
			НоваяЗапись.ПорядковыйНомер = ПозицияВСписке;
			ПозицияВСписке = ПозицияВСписке + 1;
	КонецЦикла;
	НаборЗаписей.Записать();
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






