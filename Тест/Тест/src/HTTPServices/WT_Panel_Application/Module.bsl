#Область ОбработчикиСобытий

Функция ПолучитьЗаявкуgetapplication(Запрос)
	Запросзаявки = Новый Запрос;
	Запросзаявки.Текст = текстДляЗаявки();
	Запросзаявки.УстановитьПараметр("Номер", Запрос.ПараметрыURL["Num"]);
	Выборка = Запросзаявки.Выполнить().Выбрать();
	КоличествоСФото   = 0;
	КоличествоТоваров = 0;
	МассивТоваров = Новый Массив;
	СтруктураИнфо = Новый Структура;
	
	//Пока выборка.Следующий() Цикл 
	выборка.Следующий();

	Счет = ПроверкаСчета(Выборка.Ссылка);

	СтруктураИнфо.Вставить("id", Строка(выборка.Номер));
	СтруктураИнфо.Вставить("date", Строка(выборка.Дата));
	СтруктураИнфо.Вставить("client", Строка(выборка.Клиент));
	СтруктураИнфо.Вставить("condition", Строка(выборка.Состояние));
	СтруктураИнфо.Вставить("responsible", Строка(выборка.Ответственный));
	СтруктураИнфо.Вставить("sum", Строка(выборка.СуммаДокумента));
	СтруктураИнфо.Вставить("callDate", Строка(выборка.ДатаСвязи));
	СтруктураИнфо.Вставить("processing", Строка(выборка.СтатусОбработки));
	СтруктураИнфо.Вставить("sub_processing", Строка(выборка.подСтатусОбработки));
	СтруктураИнфо.Вставить("porter", Строка(выборка.ОтветственныйЗаОбработку));
	СтруктураИнфо.Вставить("comment", Строка(выборка.Комментарий));
	СтруктураИнфо.Вставить("numCheck", Строка(?(Счет.Ссылка = Неопределено, "", Счет.Ссылка.Номер)));
	//ВыборкаТоваров = выборка.Товары.Выбрать();

	ТЗ = выборка.Товары.Выгрузить();
	
	ТЗ.Колонки.Добавить("колФото", Новый ОписаниеТипов("Число"));
	ТЗ.Колонки.Добавить("Фото", Новый ОписаниеТипов("Массив"));
	МассивТоваров = Новый Массив;

	ИндКоды = тз.ВыгрузитьКолонку("Партия2");
	Фотки = РаботаССайтомWT.ПолучениеФото(ИндКоды);
	Итер = 0;

	Для Каждого стр Из ТЗ Цикл
		МассивФото = Новый массив;
		Если стр.Партия <> Справочники.ИндКод.ПустаяСсылка() Тогда
			Если фотки <> Неопределено И фотки.Количество() > 0 Тогда
				НайденныеФотки = Новый Массив;
				КоличествоСФото = КоличествоСФото + 1;
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
				итер = итер + 1;

			КонецЕсли;

		КонецЕсли;

		Код = стр.Код;
		Пока Лев(Код, 1) = "0" Цикл
			Код = Прав(Код, СтрДлина(Код) - 1);
		КонецЦикла;
		СтруктураТоваров = Новый Структура;
		СтруктураТоваров.Вставить("position", Строка(стр.НомерСтроки));
		СтруктураТоваров.Вставить("name", Строка(стр.Номенклатура));
		СтруктураТоваров.Вставить("article", Строка(стр.Номенклатура.Артикул));
		СтруктураТоваров.Вставить("cost", Строка(стр.Цена));
		СтруктураТоваров.Вставить("comment", Строка(стр.Комментарий));
		СтруктураТоваров.Вставить("code", Строка("00" + Код));
		СтруктураТоваров.Вставить("id", Строка(стр.Партия));
		СтруктураТоваров.Вставить("stat", стр.Отменено);
		СтруктураТоваров.Вставить("sklad", Строка(стр.Склад)); 
		//СтруктураТоваров.Вставить("place", Строка(ПолучитьМесто(стр.Партия)));	 
		//@skip-check query-in-loop
		СтруктураТоваров.Вставить("poddon", Строка(ПолучитьПоддон(стр.Партия)));
		//@skip-check query-in-loop
		СтруктураТоваров.Вставить("k", ЕстьНаКСкладе(стр.Номенклатура));
		Если стр.Партия <> Справочники.ИндКод.ПустаяСсылка() Тогда
			НаборЗаписей = РегистрыСведений.ИндНомер.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.индкод.Установить(стр.Партия);
			НаборЗаписей.Прочитать();
			Товар = НаборЗаписей[0];
			СтруктураТоваров.Вставить("place", Строка(Товар.стеллаж));
		Иначе
			СтруктураТоваров.Вставить("place", Строка(стр.Номенклатура.МестоНаСкладе2));
		КонецЕсли;

		Если Не стр.Отменено Тогда
			КоличествоТоваров = КоличествоТоваров + 1;
		КонецЕсли;
		СтруктураТоваров.Вставить("photos", МассивФото);
		МассивТоваров.Добавить(СтруктураТоваров);
	КонецЦикла;

	Если КоличествоТоваров <= КоличествоСФото И КоличествоТоваров > 0 Тогда
		СтруктураИнфо.Вставить("stat", Истина);
	Иначе
		СтруктураИнфо.Вставить("stat", Ложь);
	КонецЕсли;
	
	//КонецЦикла;
	
	
	//СтруктураИнфо= новый Структура;
	//СтруктураИнфо.Вставить("Count",Цел(Выборкаобщ/?(Число(Запрос.ПараметрыURL["Count"])=0,Выборкаобщ,Число(Запрос.ПараметрыURL["Count"])+1)));
	СтруктураОтвета = Новый Структура;
	СтруктураОтвета.Вставить("info", СтруктураИнфо);
	СтруктураОтвета.Вставить("data", МассивТоваров);

	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();

	ЗаписатьJSON(ЗаписьJSON, СтруктураОтвета);

	СтрокаДляОтвета = ЗаписьJSON.Закрыть();

	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.Заголовки.Вставить("Content-type", "application/json;  charset=utf-8");

	Ответ.УстановитьТелоИзСтроки(СтрокаДляОтвета, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);

	Возврат Ответ;
КонецФункции

Функция ПолучитьДашбордДляСкладаGetDashStorage(Запрос)
//ПолнотекстовыйПоиск.ОбновитьИндекс();
//ПолнотекстовыйПоиск.УстановитьКоличествоЗаданийИндексирования(5);
	ПоисковаяСтрока = Строка(Запрос.ПараметрыURL["state"]);

//	СписокПоиска=ПолнотекстовыйПоиск.СоздатьСписок();
//	СписокПоиска.ПолучатьОписание = Ложь;
//	МассивОтбор = Новый Массив;
	МассивТоваров = Новый Массив;
//	СписокПоиска.РазмерПорции = КолВо;
//
//	ТекущаяПозиция = КолВо * (Страница - 1);
//	//Если ЕстьНижнийПробел(ПоисковаяСтрока) Тогда
//	МассивОтбор.Добавить(Метаданные.Документы.ЗаказКлиента);
//	СписокПоиска.ОбластьПоиска = МассивОтбор;
//	
//	СписокПоиска.СтрокаПоиска=ПоисковаяСтрока;
//
//	Если Страница = 1 Тогда
//		СписокПоиска.ПерваяЧасть();
//	Иначе
//		СписокПоиска.СледующаяЧасть(ТекущаяПозиция);
//	КонецЕсли;
//
//	ОбщееКолво = СписокПоиска.ПолноеКоличество();
	
	
	СостояниеСборки = Справочники.СтатусыWT.НайтиПоНаименованию(ПоисковаяСтрока); 
			
			
ЗапросЗаявок = Новый Запрос;

Текст = "ВЫБРАТЬ ПЕРВЫЕ 100000
|	ЗаказКлиента.WTPanel КАК СтатусОбработки,
|	ЗаказКлиента.Состояние КАК Состояние,
|	ЗаказКлиента.Ссылка КАК Ссылка,
|	ЗаказКлиента.Номер КАК Номер,
|	ЗаказКлиента.Дата КАК Дата,
|	ЗаказКлиента.Клиент КАК Клиент,
|	ЗаказКлиента.Ответственный КАК Ответственный,
|	ЗаказКлиента.СуммаДокумента КАК СуммаДокумента,
|	ЗаказКлиента.ДатаСвязи КАК ДатаСвязи,
|	ЗаказКлиента.Комментарий КАК Комментарий,
|	АВТОНОМЕРЗАПИСИ() КАК НомерЗаписи,
|	ЗаказКлиента.ОтветственныйЗаОбработку КАК ОтветственныйЗаОбработку,
|	ЗаказКлиента.ПодстатусОбработки КАК ПодстатусОбработки,
|	ЗаказКлиента.WTPanel КАК WTPanel
|ПОМЕСТИТЬ ВТ_ДанныеЗаявки
|ИЗ
|	Документ.ЗаказКлиента КАК ЗаказКлиента
|ГДЕ
|	ЗаказКлиента.WTPanel = &СостояниеСборки
|
|УПОРЯДОЧИТЬ ПО
|	Номер УБЫВ
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
|	ВТ_ДанныеЗаявки.WTPanel КАК WTPanel
|ИЗ
|	ВТ_ДанныеЗаявки КАК ВТ_ДанныеЗаявки
|ГДЕ
|	ВТ_ДанныеЗаявки.НомерЗаписи >= &НачинаяСЗаписи";
			
	ЗапросЗаявок.Текст =  СтрШаблон(Текст, Формат(10000, "ЧГ="));
	ЗапросЗаявок.УстановитьПараметр("СостояниеСборки", состояниеСборки);
	ЗапросЗаявок.УстановитьПараметр("НачинаяСЗаписи", 0);
	
	ОбщееКолво = ЗапросЗаявок.Выполнить().Выбрать().Количество();
	
	ЗапросЗаявок.Текст =  СтрШаблон(Текст, Формат(?(Число(Запрос.ПараметрыURL["count"]) > 0,
		Запрос.ПараметрыURL["count"], 10000), "ЧГ="));
	ЗапросЗаявок.УстановитьПараметр("СостояниеСборки", состояниеСборки);
	Если Число(((Запрос.ПараметрыURL["count"]) * (Запрос.ПараметрыURL["page"]))) > 0 И Число(
		Запрос.ПараметрыURL["page"]) > 1 Тогда
		ЗапросЗаявок.УстановитьПараметр("НачинаяСЗаписи", Число(((Запрос.ПараметрыURL["count"])
			* (Запрос.ПараметрыURL["page"] - 1) + 1)));

	Иначе
		ЗапросЗаявок.УстановитьПараметр("НачинаяСЗаписи", 0);
	КонецЕсли;
	СписокПоиска = ЗапросЗаявок.Выполнить().Выгрузить();
	

	Для Каждого Результат Из СписокПоиска Цикл

		СтруктураТоваров = Новый Структура;
		СтруктураТоваров.Вставить("num", Строка(Результат.Номер));
		СтруктураТоваров.Вставить("date", Строка(Результат.Дата));
		СтруктураТоваров.Вставить("state", Строка(Результат.WTPanel));
		СтруктураТоваров.Вставить("saler", Строка(Результат.Ответственный));
		СтруктураТоваров.Вставить("client", Строка(Результат.Клиент));
		//@skip-check query-in-loop
		СтруктураВремени = ПолучитьВремяЗК(Результат.Ссылка);
		СтруктураТоваров.Вставить("time_work",СтруктураВремени.time_work);
		СтруктураТоваров.Вставить("time_wait",СтруктураВремени.time);
		СтруктураТоваров.Вставить("workers",СтруктураВремени.workers);
		СтруктураТоваров.Вставить("in_work",СтруктураВремени.in_work);
		МассивТоваров.Добавить(СтруктураТоваров);
	КонецЦикла;

	Итог = ОбщееКолво / ?(Число(Запрос.ПараметрыURL["count"]) = 0, ОбщееКолво, Число(Запрос.ПараметрыURL["count"]));
	Итог = ?((Итог - Цел(Итог)) > 0, Цел(Итог) + 1, Цел(Итог));

	СтруктураИнфо= Новый Структура;
	СтруктураИнфо.Вставить("pages", Итог);
	СтруктураИнфо.Вставить("count", ОбщееКолво);

	СтруктураОтвета = Новый Структура;
	СтруктураОтвета.Вставить("info", СтруктураИнфо);
	СтруктураОтвета.Вставить("data", МассивТоваров);

	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.Заголовки.Вставить("Content-type", "application/json;  charset=utf-8");

	Ответ.УстановитьТелоИзСтроки(РаботаССайтомWT.СформироватьОтветСтруктурой(Истина, "Запрос успешно выполнен", СтруктураОтвета, ));

	Возврат Ответ;
КонецФункции

Функция СменаСтатусаЗаявкиChangeStateApp(Запрос)
	
	Тело = Запрос.ПолучитьТелоКакстроку();
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(Тело);

	Массив  = ПрочитатьJSON(ЧтениеJSON);

	Заявка  = Документы.ЗаказКлиента.НайтиПоНомеру(Массив.id).ПолучитьОбъект();
	Автор   = Справочники.Сотрудники.НайтиПоКоду(Массив.author).Пользователь;
	Статус  = Массив.state;
	
	Если Статус = 1 Тогда 
		ЗакрытьВремяЗК(Автор);	
		ОткрытьВремяЗК(Заявка.Ссылка, Автор, Справочники.СтатусыWT.НайтиПоКоду("000000010"));	
	КонецЕсли;
	
	Если Статус = 2 Тогда 
		ЗакрытьВремяЗК(Автор);
		Если Не ПолучитьВремяЗК(Заявка.Ссылка).in_work И НЕ (
		Заявка.Номер = "54204"
		ИЛИ Заявка.Номер = "54206"
		ИЛИ Заявка.Номер = "54207"
		ИЛИ Заявка.Номер = "54208"
		ИЛИ Заявка.Номер = "54195") Тогда
			Заявка.WTPanel = Справочники.СтатусыWT.НайтиПоКоду("000000011");	
		КонецЕсли;	
	КонецЕсли;
	
	Если Статус = 3  И НЕ (
		Заявка.Номер = "54204"
		ИЛИ Заявка.Номер = "54206"
		ИЛИ Заявка.Номер = "54207"
		ИЛИ Заявка.Номер = "54208"
		ИЛИ Заявка.Номер = "54195")Тогда 
		ЗакрытьВремяЗКОбщ(Заявка.Ссылка);
		Заявка.WTPanel = Справочники.СтатусыWT.НайтиПоКоду("000000011");	
	КонецЕсли;
	
	Заявка.Записать();
	Ответ = Новый HTTPСервисОтвет(200);
	Возврат Ответ;
КонецФункции




//Функция СменаСтатусаЗаявкиChangeStateApp(Запрос)
//	
//	Тело = Запрос.ПолучитьТелоКакстроку();
//	ЧтениеJSON = Новый ЧтениеJSON;
//	ЧтениеJSON.УстановитьСтроку(Тело);
//
//	Массив  = ПрочитатьJSON(ЧтениеJSON);
//
//	Заявка  = Документы.ЗаказКлиента.НайтиПоНомеру(Массив.id).ПолучитьОбъект();
//	Автор   = Справочники.Сотрудники.НайтиПоКоду(Массив.author).Пользователь;
//	WTPanel = Справочники.СтатусыWT.НайтиПоНаименованию(Массив.state);
//	
//	Если WTPanel = Справочники.СтатусыWT.НайтиПоКоду("000000013") Тогда
//			ЗакрытьВремяЗК(Автор);
//		Иначе 
//			
//			ЗакрытьВремяЗК(Автор);
//		    ОткрытьВремяЗК(Заявка.Ссылка, Автор, WTPanel);
//	КонецЕсли;
//	Заявка.WTPanel = WTPanel;
//	
//	Заявка.Записать();
//	
//	Ответ = Новый HTTPСервисОтвет(200);
//	Возврат Ответ;
//КонецФункции

Функция КоличествоЗаявокПоСтатусамgetcountapp(Запрос)
//	СписокПоиска=ПолнотекстовыйПоиск.СоздатьСписок();
//	СписокПоиска.ПолучатьОписание = Ложь;
	МассивОтбор = Новый Массив;
//	МассивОтбор.Добавить(Метаданные.Документы.ЗаказКлиента);
//	СписокПоиска.ОбластьПоиска = МассивОтбор;
	МассивЗаявок = Новый Массив;
//
//	СписокПоиска.СтрокаПоиска = "WT_ВСЕ_ЗАЯВКИ";
//	СписокПоиска.ПерваяЧасть();
//	ОбщееКолво = СписокПоиска.ПолноеКоличество();
//	СтруктураТоваров = Новый Структура;
//	СтруктураТоваров.Вставить("count", ОбщееКолво);
//	СтруктураТоваров.Вставить("state", "WT_ВСЕ_ЗАЯВКИ");
//
//	МассивЗаявок.Добавить(СтруктураТоваров);
//
//	СписокПоиска.СтрокаПоиска = "WT_СБОРКА";
//	СписокПоиска.ПерваяЧасть();
//	ОбщееКолво = СписокПоиска.ПолноеКоличество();
//	СтруктураТоваров = Новый Структура;
//	СтруктураТоваров.Вставить("count", ОбщееКолво);
//	СтруктураТоваров.Вставить("state", "WT_СБОРКА");
//
//	МассивЗаявок.Добавить(СтруктураТоваров);
//
//	СписокПоиска.СтрокаПоиска = "WT_СОБРАННО";
//	СписокПоиска.ПерваяЧасть();
//	ОбщееКолво = СписокПоиска.ПолноеКоличество();
//	СтруктураТоваров = Новый Структура;
//	СтруктураТоваров.Вставить("count", ОбщееКолво);
//	СтруктураТоваров.Вставить("state", "WT_СОБРАННО");
//
//	МассивЗаявок.Добавить(СтруктураТоваров);
//
//	СписокПоиска.СтрокаПоиска = "WT_РАЗНЕСТИ";
//	СписокПоиска.ПерваяЧасть();
//	ОбщееКолво = СписокПоиска.ПолноеКоличество();
//	СтруктураТоваров = Новый Структура;
//	СтруктураТоваров.Вставить("count", ОбщееКолво);
//	СтруктураТоваров.Вставить("state", "WT_РАЗНЕСТИ");
//
//	МассивЗаявок.Добавить(СтруктураТоваров);
//
//	СписокПоиска.СтрокаПоиска = "WT_АРХИВ";
//	СписокПоиска.ПерваяЧасть();
//	ОбщееКолво = СписокПоиска.ПолноеКоличество();

	ЗапросГруппЗаявок = Новый Запрос;

	ЗапросГруппЗаявок.Текст = "ВЫБРАТЬ
	|	ЗаказКлиента.Ссылка КАК Ссылка,
	|	ЗаказКлиента.WTPanel КАК СтатусОбработки
	|ПОМЕСТИТЬ ВТ_ЗаявкиИПродажи
	|ИЗ
	|	Документ.ЗаказКлиента КАК ЗаказКлиента
	|ГДЕ
	|	ЗаказКлиента.WTPanel В (&ПроверкаПродажи)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВТ_ЗаявкиИПродажи.Ссылка) КАК Количество,
	|	СтатусыWT.Ссылка КАК СтатусОбработки
	|ПОМЕСТИТЬ ВТ_Итоги
	|ИЗ
	|	Справочник.СтатусыWT КАК СтатусыWT
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ЗаявкиИПродажи КАК ВТ_ЗаявкиИПродажи
	|		ПО СтатусыWT.Ссылка = ВТ_ЗаявкиИПродажи.СтатусОбработки
	|ГДЕ
	|	НЕ СтатусыWT.ПометкаУдаления
	|	И СтатусыWT.Ссылка В (&ПроверкаПродажи)
	|СГРУППИРОВАТЬ ПО
	|	СтатусыWT.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Итоги.Количество КАК Количество,
	|	ВТ_Итоги.СтатусОбработки.Наименование КАК СтатусОбработки,
	|	ВТ_Итоги.СтатусОбработки.Код КАК Код
	|ИЗ
	|	ВТ_Итоги КАК ВТ_Итоги
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВТ_Итоги.СтатусОбработки.Код";

	МассивОтбор.Добавить(Справочники.СтатусыWT.НайтиПоКоду("000000009"));
	МассивОтбор.Добавить(Справочники.СтатусыWT.НайтиПоКоду("000000010"));
	МассивОтбор.Добавить(Справочники.СтатусыWT.НайтиПоКоду("000000011"));
	МассивОтбор.Добавить(Справочники.СтатусыWT.НайтиПоКоду("000000012"));
	МассивОтбор.Добавить(Справочники.СтатусыWT.НайтиПоКоду("000000013"));

	ЗапросГруппЗаявок.УстановитьПараметр("ПроверкаПродажи", МассивОтбор);
	Выборка = ЗапросГруппЗаявок.Выполнить().Выбрать();
	Пока ВЫборка.Следующий() Цикл
		СтруктураТоваров = Новый Структура;
		СтруктураТоваров.Вставить("count", Выборка.Количество);
		СтруктураТоваров.Вставить("state", Выборка.СтатусОбработки);

		МассивЗаявок.Добавить(СтруктураТоваров);
	КонецЦикла;
	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.Заголовки.Вставить("Content-type", "application/json;  charset=utf-8");

	Ответ.УстановитьТелоИзСтроки(РаботаССайтомWT.СформироватьОтветСтруктурой(Истина, "Запрос успешно выполнен",
		МассивЗаявок, ));

	Возврат Ответ;
КонецФункции

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура ЗакрытьВремяЗКОбщ(ЗаявкаПродажа)
	Запрос = Новый запрос;
	Запрос.Текст = "ВЫБРАТЬ
				   |	ВремяВыполненияЗаявок.ЗаявкаПродажа КАК Задача,
				   |	ВремяВыполненияЗаявок.Период КАК ДатаСреза
				   |ИЗ
				   |	РегистрСведений.ВремяВыполненияЗаявок КАК ВремяВыполненияЗаявок
				   |ГДЕ
				   |	 ВремяВыполненияЗаявок.КонецЗамера < ДАТАВРЕМЯ(2000, 1, 1)
				   |И ВремяВыполненияЗаявок.ЗаявкаПродажа = &ЗаявкаПродажа
				   |УПОРЯДОЧИТЬ ПО
				   |	ВремяВыполненияЗаявок.Период УБЫВ";
	Запрос.УстановитьПараметр("ЗаявкаПродажа", ЗаявкаПродажа);
	Выборка = Запрос.Выполнить().Выбрать();
	Если выборка.Количество() > 0 Тогда
		Пока Выборка.Следующий() Цикл
			НаборЗаписей = РегистрыСведений.ВремяВыполненияЗаявок.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.ЗаявкаПродажа.Установить(Выборка.Задача);
			НаборЗаписей.Отбор.Период.Установить(Выборка.ДатаСреза);
			НаборЗаписей.Прочитать();
			Если НаборЗаписей.Количество() = 1 Тогда
				НашЗамер = НаборЗаписей[0];
				НашЗамер.КонецЗамера = ТекущаяДата();
				НашЗамер.Срок		 = НашЗамер.КонецЗамера - НашЗамер.НачалоЗамера;
				НаборЗаписей.Записать();
			КонецЕсли;
		КонецЦикла;

	КонецЕсли;

КонецПроцедуры


Процедура ЗакрытьВремяЗК(Ответственный)
	Запрос = Новый запрос;
	Запрос.Текст = "ВЫБРАТЬ
				   |	ВремяВыполненияЗаявок.ЗаявкаПродажа КАК Задача,
				   |	ВремяВыполненияЗаявок.Период КАК ДатаСреза
				   |ИЗ
				   |	РегистрСведений.ВремяВыполненияЗаявок КАК ВремяВыполненияЗаявок
				   |ГДЕ
				   |	 ВремяВыполненияЗаявок.КонецЗамера < ДАТАВРЕМЯ(2000, 1, 1)
				   |И ВремяВыполненияЗаявок.Ответственный = &Ответственный
				   |УПОРЯДОЧИТЬ ПО
				   |	ВремяВыполненияЗаявок.Период УБЫВ";
	Запрос.УстановитьПараметр("Ответственный", Ответственный);
	Выборка = Запрос.Выполнить().Выбрать();
	Если выборка.Количество() > 0 Тогда
		Выборка.Следующий();
		НаборЗаписей = РегистрыСведений.ВремяВыполненияЗаявок.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ЗаявкаПродажа.Установить(Выборка.Задача);
		НаборЗаписей.Отбор.Период.Установить(Выборка.ДатаСреза);
		НаборЗаписей.Прочитать();
		Если НаборЗаписей.Количество() = 1 Тогда
			НашЗамер = НаборЗаписей[0];
			НашЗамер.КонецЗамера = ТекущаяДата();
			НашЗамер.Срок		 = НашЗамер.КонецЗамера - НашЗамер.НачалоЗамера;
			НаборЗаписей.Записать();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ОткрытьВремяЗК(ЗК, Ответственный, Статус)

	НаборЗаписей = РегистрыСведений.ВремяВыполненияЗаявок.СоздатьМенеджерЗаписи();

	НаборЗаписей.ЗаявкаПродажа = ЗК ;
	НаборЗаписей.Период = ТекущаяДата();
	НаборЗаписей.НачалоЗамера = ТекущаяДата();
	НаборЗаписей.Ответственный = Ответственный;
	НаборЗаписей.Статус = Статус;
	НаборЗаписей.Записать();

КонецПроцедуры

Функция ПолучитьВремяЗК(ЗаказКлиента)
	ЗапросРаботника = Новый запрос;
	ЗапросРаботника.Текст = "ВЫБРАТЬ
	|	СУММА(ВремяВыполненияЗН.Срок) КАК Срок,
	|	ВремяВыполненияЗН.Ответственный КАК Ответственный
	|ИЗ
	|	РегистрСведений.ВремяВыполненияЗаявок КАК ВремяВыполненияЗН
	|ГДЕ
	|	ВремяВыполненияЗН.ЗаявкаПродажа = &ЗаказНаряд
	|	И ВремяВыполненияЗН.Ответственный <> Значение(Справочник.Пользователи.ПустаяСсылка)
	|СГРУППИРОВАТЬ ПО
	|	ВремяВыполненияЗН.Ответственный";

	ЗапросРаботника.УстановитьПараметр("ЗаказНаряд", ЗаказКлиента);
	ВыборкаРаботника = ЗапросРаботника.Выполнить().Выбрать();
	Время = 0;
	ВремяОбщ = 0;
	ВРаботе = 0;
	МассивРаботников = Новый Массив;
	Если ВыборкаРаботника.Количество() > 0 Тогда

		Пока ВыборкаРаботника.Следующий() Цикл
			СтруктураРаботника = Новый Структура;
			СтруктураРаботника.Вставить("worker", Строка(ВыборкаРаботника.Ответственный));
				//@skip-check reading-attribute-from-database
			СтруктураРаботника.Вставить("id_worker", Справочники.Сотрудники.НайтиПоРеквизиту("Пользователь",ВыборкаРаботника.Ответственный).Код); 
			Запрос = Новый запрос;
			Запрос.Текст = "ВЫБРАТЬ
			|	ВремяВыполненияЗН.ЗаявкаПродажа КАК Задача,
			|	ВремяВыполненияЗН.НачалоЗамера КАК НачалоЗамера
			|ИЗ
			|	РегистрСведений.ВремяВыполненияЗаявок КАК ВремяВыполненияЗН
			|ГДЕ
			|	ВремяВыполненияЗН.КонецЗамера < ДАТАВРЕМЯ(2000, 1, 1)
			|	И ВремяВыполненияЗН.Ответственный = &Ответственный
			|	И ВремяВыполненияЗН.ЗаявкаПродажа = &ЗаказНаряд";
			Запрос.УстановитьПараметр("Ответственный", ВыборкаРаботника.Ответственный);
			Запрос.УстановитьПараметр("ЗаказНаряд", ЗаказКлиента);
			//@skip-check query-in-loop
			Выборка = Запрос.Выполнить().Выбрать();
			
			Статус = ЛОЖЬ;
			Время = ВыборкаРаботника.Срок;
			Если Выборка.Количество() > 0 Тогда
				Выборка.Следующий();
				Время =  (ТекущаяДата() - Выборка.НачалоЗамера);
				Статус = ИСТИНА;
				ВРаботе = ВРаботе + 1;
			КонецЕсли;
             ВремяОбщ = ВремяОбщ + Время;
			СтруктураРаботника.Вставить("time", Время);
			СтруктураРаботника.Вставить("state", Статус);
			//Время = выборка.срок;
			МассивРаботников.Добавить(СтруктураРаботника);
		КонецЦикла;

	КонецЕсли;

	Запрос = Новый запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ВремяВыполненияЗН.ЗаявкаПродажа КАК Задача,
	|	ВремяВыполненияЗН.НачалоЗамера КАК НачалоЗамера,
	|	ВремяВыполненияЗН.ЗаявкаПродажа.Дата КАК Дата,
	|	ВремяВыполненияЗН.КонецЗамера,
	|	ВремяВыполненияЗН.Ответственный
	|ИЗ
	|	РегистрСведений.ВремяВыполненияЗаявок КАК ВремяВыполненияЗН
	|ГДЕ
	|	ВремяВыполненияЗН.ЗаявкаПродажа = &ЗаказКлиента
	|	И ВремяВыполненияЗН.Статус = &Статус
	|
	|УПОРЯДОЧИТЬ ПО
	|	НачалоЗамера";

	Запрос.УстановитьПараметр("ЗаказКлиента", ЗаказКлиента);
	Запрос.УстановитьПараметр("Статус", Справочники.СтатусыWT.НайтиПоКоду("000000010")); 
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() > 0 Тогда
		Выборка.Следующий();
		Если Выборка.Ответственный = Справочники.Пользователи.ПустаяСсылка() Тогда
			Время =  ТекущаяДата() - Выборка.НачалоЗамера;
		ИначеЕсли Выборка.Количество() > 1 Тогда

			Если Выборка.КонецЗамера < Дата(2000, 01, 01) Тогда
				Время =  Выборка.НачалоЗамера - ЗаказКлиента.Дата;
			Иначе
				Время =  Выборка.КонецЗамера - ЗаказКлиента.Дата;
			КонецЕсли;
		КонецЕсли;

	Иначе
		Время = ТекущаяДата() - ЗаказКлиента.Дата;

	КонецЕсли;
	
	СтруктураОтвета = Новый Структура;
	СтруктураОтвета.Вставить("time_work", ВремяОбщ);
	СтруктураОтвета.Вставить("time", Время);
	СтруктураОтвета.Вставить("workers", МассивРаботников);
	СтруктураОтвета.Вставить("in_work", ?(ВРаботе >0,Истина,Ложь));
	Возврат СтруктураОтвета;

КонецФункции



#Область ТекстыЗапросов

Функция текстДляСпискаЗаявок()
	Текст = "ВЫБРАТЬ
			|	ИндНомер.индкод.Владелец КАК индкодВладелец,
			|	МАКСИМУМ(ВЫБОР
			|			КОГДА ИндНомер.Стеллаж.Наименование ПОДОБНО &кСклады
			|				ТОГДА 1
			|			ИНАЧЕ 0
			|		КОНЕЦ) КАК Поле1
			|ПОМЕСТИТЬ ВТ_КСклад
			|ИЗ
			|	РегистрСведений.ИндНомер КАК ИндНомер
			|ГДЕ
			|	ИндНомер.Стеллаж.Наименование ПОДОБНО &кСклады
			|
			|СГРУППИРОВАТЬ ПО
			|	ИндНомер.индкод.Владелец
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ЗаказКлиентаТовары.Ссылка КАК Ссылка,
			|	МАКСИМУМ(ВТ_КСклад.Поле1) КАК Поле1
			|ПОМЕСТИТЬ ВТ_НаКСкладе
			|ИЗ
			|	Документ.ЗаказКлиента.Товары КАК ЗаказКлиентаТовары
			|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_КСклад КАК ВТ_КСклад
			|		ПО ЗаказКлиентаТовары.Номенклатура = ВТ_КСклад.индкодВладелец
			|
			|СГРУППИРОВАТЬ ПО
			|	ЗаказКлиентаТовары.Ссылка
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ ПЕРВЫЕ 100000
			|	ЗаказКлиента.WTPanel КАК СтатусОбработки,
			|	ЗаказКлиента.Состояние КАК Состояние,
			|	ЗаказКлиента.Ссылка КАК Ссылка,
			|	ЗаказКлиента.Номер КАК Номер,
			|	ЗаказКлиента.Дата КАК Дата,
			|	ЗаказКлиента.Клиент КАК Клиент,
			|	ЗаказКлиента.Ответственный КАК Ответственный,
			|	ЗаказКлиента.СуммаДокумента КАК СуммаДокумента,
			|	ЗаказКлиента.ДатаСвязи КАК ДатаСвязи,
			|	ЗаказКлиента.Комментарий КАК Комментарий,
			|	АВТОНОМЕРЗАПИСИ() КАК НомерЗаписи,
			|	ЗаказКлиента.ОтветственныйЗаОбработку КАК ОтветственныйЗаОбработку,
			|	ЗаказКлиента.ПодстатусОбработки КАК ПодстатусОбработки
			|ПОМЕСТИТЬ ВТ_ДанныеЗаявки
			|ИЗ
			|	Документ.ЗаказКлиента КАК ЗаказКлиента
			|ГДЕ
			|	ЗаказКлиента.WTPanel В (&СостояниеСборки)  
			|
			|УПОРЯДОЧИТЬ ПО
			|	Номер УБЫВ
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
			|	ВТ_НаКСкладе.Поле1 КАК НаКскладе,
			|	ВТ_ДанныеЗаявки.ПодстатусОбработки КАК ПодстатусОбработки
			|ИЗ
			|	ВТ_ДанныеЗаявки КАК ВТ_ДанныеЗаявки
			|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_НаКСкладе КАК ВТ_НаКСкладе
			|		ПО ВТ_ДанныеЗаявки.Ссылка = ВТ_НаКСкладе.Ссылка
			|ГДЕ
			|	ВТ_ДанныеЗаявки.НомерЗаписи >= &НачинаяСЗаписи";
	Возврат текст;
КонецФункции

Функция текстДляЗаявки()
	Текст = "ВЫБРАТЬ
			|	ЗаказКлиента.Номер КАК Номер,
			|	ЗаказКлиента.Дата КАК Дата,
			|	ЗаказКлиента.Клиент КАК Клиент,
			|	ЗаказКлиента.Состояние КАК Состояние,
			|	ЗаказКлиента.Ответственный КАК Ответственный,
			|	ЗаказКлиента.СуммаДокумента КАК СуммаДокумента,
			|	ЗаказКлиента.ДатаСвязи КАК ДатаСвязи,
			|	ЗаказКлиента.Товары.(
			|		Ссылка КАК Ссылка,
			|		НомерСтроки КАК НомерСтроки,
			|		Номенклатура КАК Номенклатура,
			|		ЦенаОригинала КАК ЦенаОригинала,
			|		Количество КАК Количество,
			|		Цена КАК Цена,
			|		Сумма КАК Сумма,
			|		Отменено КАК Отменено,
			|		Склад КАК Склад,
			|		СуммаНДС КАК СуммаНДС,
			|		Комментарий КАК Комментарий,
			|		ПредлагаемаяЦена КАК ПредлагаемаяЦена,
			|		Партия КАК Партия,
			|		ПРЕДСТАВЛЕНИЕ(ЗаказКлиента.Товары.Партия) КАК Партия2,
			|		Номенклатура.Код КАК Код
			|	) КАК Товары,
			|	ЗаказКлиента.Ссылка КАК Ссылка,
			|	ЗаказКлиента.WTPanel КАК СтатусОбработки,
			|	ЗаказКлиента.ОтветственныйЗаОбработку КАК ОтветственныйЗаОбработку,
			|	ЗаказКлиента.Комментарий КАК Комментарий,
			|	ЗаказКлиента.ПодстатусОбработки КАК ПодстатусОбработки
			|ИЗ
			|	Документ.ЗаказКлиента КАК ЗаказКлиента
			|ГДЕ
			|	ЗаказКлиента.Номер = &Номер";
	Возврат Текст;
КонецФункции


#КонецОбласти

Функция ПроверкаСчета(Заявка)
	Запрос = Новый Запрос;
	запрос.Текст = "ВЫБРАТЬ
				   |	ПредварительныйСчет.Ссылка КАК Ссылка
				   |ИЗ
				   |	Документ.ПредварительныйСчет КАК ПредварительныйСчет
				   |ГДЕ
				   |	ПредварительныйСчет.Основание = &ЗаказКлиента";
	Запрос.УстановитьПараметр("ЗаказКлиента", Заявка);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	Возврат Выборка;

КонецФункции

Функция ПолучитьПоддон(Партия)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
				   |	ИндНомер.поддон КАК поддон
				   |ИЗ
				   |	РегистрСведений.ИндНомер КАК ИндНомер
				   |ГДЕ
				   |	ИндНомер.индкод = &индкод";
	Запрос.УстановитьПараметр("индкод", Партия);
	Выборка = запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	Возврат Выборка.поддон;
КонецФункции

Функция ЕстьНаКСкладе(Номенклатура)
	Запрос = Новый запрос;
	Запрос.Текст = "ВЫБРАТЬ
				   |	ИндНомер.индкод КАК индкод
				   |ИЗ
				   |	РегистрСведений.ИндНомер КАК ИндНомер
				   |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.РегистрНакопления1.Остатки КАК РегистрНакопления1Остатки
				   |		ПО ИндНомер.индкод = РегистрНакопления1Остатки.индкод
				   |ГДЕ
				   |	(ИндНомер.Стеллаж.Наименование ПОДОБНО ""%K-%""
				   |			ИЛИ ИндНомер.Стеллаж.Наименование ПОДОБНО ""%К-%"")
				   |	И ИндНомер.индкод.Владелец = &Владелец
				   |	И РегистрНакопления1Остатки.КолвоОстаток > 0";

	Запрос.УстановитьПараметр("Владелец", Номенклатура);
	Выборка = запрос.Выполнить().Выбрать();
	Если выборка.Количество() > 0 Тогда
		Возврат 1;
	Иначе
		Возврат 0;
	КонецЕсли;
КонецФункции

#КонецОбласти

