Функция СтатистикаПоЗаявкамGET(Запрос)
	/// Комлев 27/09/24 +++
	Ответ = Новый HTTPСервисОтвет(200);
	Попытка
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказКлиента.Ссылка) КАК КоличествоЗаявокДень,
		|	СУММА(ЗаказКлиента.СуммаДокумента) КАК СуммаДокументаДень
		|ПОМЕСТИТЬ День
		|ИЗ
		|	Документ.ЗаказКлиента КАК ЗаказКлиента
		|ГДЕ
		|	ЗаказКлиента.Дата МЕЖДУ НАЧАЛОПЕРИОДА(&ТекДата, ДЕНЬ) И КОНЕЦПЕРИОДА(&ТекДата, ДЕНЬ)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказКлиента.Ссылка) КАК КоличествоЗаявокНеделя,
		|	СУММА(ЗаказКлиента.СуммаДокумента) КАК СуммаДокументаНеделя
		|ПОМЕСТИТЬ Неделя
		|ИЗ
		|	Документ.ЗаказКлиента КАК ЗаказКлиента
		|ГДЕ
		|	ЗаказКлиента.Дата МЕЖДУ НАЧАЛОПЕРИОДА(&ТекДата, НЕДЕЛЯ) И КОНЕЦПЕРИОДА(&ТекДата, НЕДЕЛЯ)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказКлиента.Ссылка) КАК КоличествоЗаявокМесяц,
		|	СУММА(ЗаказКлиента.СуммаДокумента) КАК СуммаДокументаМесяц
		|ПОМЕСТИТЬ Месяц
		|ИЗ
		|	Документ.ЗаказКлиента КАК ЗаказКлиента
		|ГДЕ
		|	ЗаказКлиента.Дата МЕЖДУ НАЧАЛОПЕРИОДА(&ТекДата, МЕСЯЦ) И КОНЕЦПЕРИОДА(&ТекДата, МЕСЯЦ)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЕСТЬNULL(День.КоличествоЗаявокДень, 0) КАК КоличествоЗаявокДень,
		|	ЕСТЬNULL(День.СуммаДокументаДень, 0) КАК СуммаДокументаДень,
		|	ЕСТЬNULL(Неделя.КоличествоЗаявокНеделя, 0) КАК КоличествоЗаявокНеделя,
		|	ЕСТЬNULL(Неделя.СуммаДокументаНеделя, 0) КАК СуммаДокументаНеделя,
		|	ЕСТЬNULL(Месяц.КоличествоЗаявокМесяц, 0) КАК КоличествоЗаявокМесяц,
		|	ЕСТЬNULL(Месяц.СуммаДокументаМесяц, 0) КАК СуммаДокументаМесяц
		|ИЗ
		|	День КАК День,
		|	Неделя КАК Неделя,
		|	Месяц КАК Месяц";

		Запрос.УстановитьПараметр("ТекДата", ТекущаяДата());

		РезультатЗапроса = Запрос.Выполнить();

		Выборка = РезультатЗапроса.Выбрать();
		СтруктураОтвета = Новый Структура;
		Пока Выборка.Следующий() Цикл
			СтруктураОтвета.Вставить("count_day", (Выборка.КоличествоЗаявокДень));
			СтруктураОтвета.Вставить("sum_day", (Выборка.СуммаДокументаДень));

			СтруктураОтвета.Вставить("count_week", (Выборка.КоличествоЗаявокНеделя));
			СтруктураОтвета.Вставить("sum_week", (Выборка.СуммаДокументаНеделя));

			СтруктураОтвета.Вставить("count_month", (Выборка.КоличествоЗаявокМесяц));
			СтруктураОтвета.Вставить("sum_month", (Выборка.СуммаДокументаМесяц));
		КонецЦикла;
	Исключение
		Инфо = ИнформацияОбОшибке();
		Ответ = Новый HTTPСервисОтвет(500);
		Ответ.УстановитьТелоИзСтроки("" + Инфо.Описание);
		Ответ.Заголовки.Вставить("Content-type", "application/json;  charset=utf-8");
		Возврат Ответ;
	КонецПопытки;
	Запись = Новый ЗаписьJSON;
	Запись.УстановитьСтроку();
	ЗаписатьJSON(Запись, СтруктураОтвета);
	Данные = Запись.Закрыть();
	Ответ.УстановитьТелоИзСтроки(Данные);
	Ответ.Заголовки.Вставить("Content-type", "application/json;  charset=utf-8");
	Возврат Ответ;
	/// Комлев 27/09/24 +++
КонецФункции

Функция ПолучитьПланМенеджеровПоЗаявкамGET(Запрос)

	ТаблицаЦен = РегистрыСведений.ПланМенеджеровПоЗаявкам.СрезПоследних(ТекущаяДата());
	СтруктураОтвет = Новый Структура;

	Для Каждого Запись Из ТаблицаЦен Цикл
		СтруктураОтвет.Вставить("day_plan", Запись.ПланНаДень);
		СтруктураОтвет.Вставить("week_plan", Запись.ПланНаНеделю);
		СтруктураОтвет.Вставить("month_plan", Запись.ПланНаМесяц);
		СтруктураОтвет.Вставить("data", Запись.Период);
	КонецЦикла;

	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	ЗаписатьJSON(ЗаписьJSON, СтруктураОтвет);
	СтрокаДляОтвета = ЗаписьJSON.Закрыть();
	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.Заголовки.Вставить("Content-type", "application/json;  charset=utf-8");
	Ответ.УстановитьТелоИзСтроки(СтрокаДляОтвета, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);

	Возврат Ответ;
КонецФункции

Функция ОпубликоватьПланМенеджеровПоЗаявкамPostManagerPlan(Запрос)

	Тело = Запрос.ПолучитьТелоКакстроку();
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(Тело);
	Массив  = ПрочитатьJSON(ЧтениеJSON);

	ПланНаДень 		= Массив.day_plan;
	ПланНаНеделю	= Массив.week_plan;
	ПланНаМесяц 	= Массив.month_plan;
	//ДатаПериод	= Массив.data; 

	МенеджерЗаписи = РегистрыСведений.ПланМенеджеровПоЗаявкам.СоздатьМенеджерЗаписи();

	МенеджерЗаписи.ПланНаДень 	= ПланНаДень;
	МенеджерЗаписи.ПланНаНеделю = ПланНаНеделю;
	МенеджерЗаписи.ПланНаМесяц	= ПланНаМесяц;
	//МенеджерЗаписи.Период		= ДатаПериод; 
	МенеджерЗаписи.Период		= ТекущаяДата();

	МенеджерЗаписи.Записать();

	ТаблицаЦен = РегистрыСведений.ПланМенеджеровПоЗаявкам.СрезПоследних(ТекущаяДата());
	СтруктураОтвет = Новый Структура;

	Для Каждого Запись Из ТаблицаЦен Цикл
		СтруктураОтвет.Вставить("day_plan", Запись.ПланНаДень);
		;
		СтруктураОтвет.Вставить("week_plan", Запись.ПланНаНеделю);
		СтруктураОтвет.Вставить("month_plan", Запись.ПланНаМесяц);
		СтруктураОтвет.Вставить("data", Запись.Период);
	КонецЦикла;
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	ЗаписатьJSON(ЗаписьJSON, СтруктураОтвет);
	СтрокаДляОтвета = ЗаписьJSON.Закрыть();
	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.Заголовки.Вставить("Content-type", "application/json;  charset=utf-8");
	Ответ.УстановитьТелоИзСтроки(СтрокаДляОтвета, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);

	Возврат Ответ;

КонецФункции

Функция СтатистикаПоЗаявкамИПродажамget_statistic_app_sale(Запрос)
	/// +++ Комлев 04/10/24 +++
	Ответ = Новый HTTPСервисОтвет(200);
	Попытка
		ДатаНачала = Дата(Запрос.ПараметрыURL.Получить("date_start"));
		ДатаОкончания = Дата(Запрос.ПараметрыURL.Получить("date_end"));

		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ЕСТЬNULL(КОЛИЧЕСТВО(Заказы.Ссылка), 0) КАК КоличествоЗаявок,
		|	ЕСТЬNULL(СУММА(Заказы.СуммаДокумента) , 0) КАК СуммаЗаявок,
		|	ЕСТЬNULL(СУММА(ПродажаЗапчастей.ИтогоРекв) , 0) КАК СуммаПродаж,
		|	ЕСТЬNULL(КОЛИЧЕСТВО(ПродажаЗапчастей.Ссылка) , 0) КАК КоличествоПродаж
		|ИЗ
		|	Документ.ЗаказКлиента КАК Заказы
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПродажаЗапчастей КАК ПродажаЗапчастей
		|		ПО ПродажаЗапчастей.ЗаказКлиента = Заказы.Ссылка
		|ГДЕ
		|	Заказы.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания";

		Запрос.УстановитьПараметр("ДатаНачала", НачалоДня(ДатаНачала));
		Запрос.УстановитьПараметр("ДатаОкончания", КонецДня(ДатаОкончания));

		РезультатЗапроса = Запрос.Выполнить();

		Выборка = РезультатЗапроса.Выбрать();
		СтруктураОтвета = Новый Структура;
		Пока Выборка.Следующий() Цикл
			СтруктураОтвета.Вставить("count_app", (Выборка.КоличествоЗаявок));
			СтруктураОтвета.Вставить("sum_app", (Выборка.СуммаЗаявок));
			СтруктураОтвета.Вставить("count_sale", (Выборка.КоличествоПродаж));
			СтруктураОтвета.Вставить("sum_sale", (Выборка.СуммаПродаж));

		КонецЦикла;
	Исключение
		Инфо = ИнформацияОбОшибке();
		Ответ = Новый HTTPСервисОтвет(500);
		Ответ.УстановитьТелоИзСтроки("" + Инфо.Описание);
		Ответ.Заголовки.Вставить("Content-type", "application/json;  charset=utf-8");
		Возврат Ответ;
	КонецПопытки;
	Запись = Новый ЗаписьJSON;
	Запись.УстановитьСтроку();
	ЗаписатьJSON(Запись, СтруктураОтвета);
	Данные = Запись.Закрыть();
	Ответ.УстановитьТелоИзСтроки(Данные);
	Ответ.Заголовки.Вставить("Content-type", "application/json;  charset=utf-8");
	Возврат Ответ;
	
	/// --- Комлев 04/10/24 ---
КонецФункции

Функция ПолучитьПланПоЗаявкамНаДатуget_plan_app(Запрос)
	/// +++ Комлев 04/10/24 +++
	Попытка
		ДатаПлана = Дата(Запрос.ПараметрыURL.Получить("date"));
		ВидПлана = Перечисления.ВидыПлана.Получить(Число(Запрос.ПараметрыURL.Получить("view_plan")) - 1);

		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПланыМенеджеровСрезПоследних.План,
		|	ПланыМенеджеровСрезПоследних.Период,
		|	ПланыМенеджеровСрезПоследних.ВидПлана
		|ИЗ
		|	РегистрСведений.ПланыМенеджеров.СрезПоследних(&ДатаПлана, ВидПлана.Ссылка = &ВидПлана) КАК
		|		ПланыМенеджеровСрезПоследних";

		Запрос.УстановитьПараметр("ВидПлана", ВидПлана);
		Запрос.УстановитьПараметр("ДатаПлана", ДатаПлана);

		РезультатЗапроса = Запрос.Выполнить();

		СтруктураПлана = Новый Структура;
		СтруктураПлана.Вставить("date", Строка(ДатаПлана));
		СтруктураПлана.Вставить("view_plan", Строка(ВидПлана));
		СтруктураПлана.Вставить("plan", 0);

		Выборка = РезультатЗапроса.Выбрать();

		Пока Выборка.Следующий() Цикл
			СтруктураПлана.date = Строка(Выборка.Период);
			СтруктураПлана.view_plan = Строка(Выборка.ВидПлана);
			СтруктураПлана.plan = Число(Выборка.План);
		КонецЦикла;

		ЗаписьJSON = Новый ЗаписьJSON;
		ЗаписьJSON.УстановитьСтроку();
		ЗаписатьJSON(ЗаписьJSON, СтруктураПлана);
		СтрокаДляОтвета = ЗаписьJSON.Закрыть();
		Ответ = Новый HTTPСервисОтвет(200);
		Ответ.Заголовки.Вставить("Content-type", "application/json;  charset=utf-8");
		Ответ.УстановитьТелоИзСтроки(СтрокаДляОтвета, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);

		Возврат Ответ;
	Исключение
		Инфо = ИнформацияОбОшибке();
		Ответ = Новый HTTPСервисОтвет(500);
		Ответ.УстановитьТелоИзСтроки("" + Инфо.Описание);
		Ответ.Заголовки.Вставить("Content-type", "application/json;  charset=utf-8");
		Возврат Ответ;
	КонецПопытки;
	/// --- Комлев 04/10/24 ---
КонецФункции

Функция ИзменитьПланПоЗаявкамchange_plan_app(Запрос)
	/// +++ Комлев 04/10/24 +++
	Попытка
		Тело = Запрос.ПолучитьТелоКакстроку();
		ЧтениеJSON = Новый ЧтениеJSON;
		ЧтениеJSON.УстановитьСтроку(Тело);
		Массив  = ПрочитатьJSON(ЧтениеJSON);

		План 		= Массив.plan;
		ВидПлана	= Перечисления.ВидыПлана.Получить(Число(Массив.view_plan) - 1);
		ДатаПлана	= Дата(Массив.date);

		МенеджерЗаписи = РегистрыСведений.ПланыМенеджеров.СоздатьМенеджерЗаписи();

		МенеджерЗаписи.План = План;
		МенеджерЗаписи.ВидПлана = ВидПлана;
		НачалоДаты = ДатаПлана;
		Если Число(Массив.view_plan) = 1 Тогда
			МенеджерЗаписи.Период		= НачалоДня(ДатаПлана);
			НачалоДаты = НачалоДня(ДатаПлана);
		ИначеЕсли Число(Массив.view_plan) = 2 Тогда
			МенеджерЗаписи.Период		= НачалоНедели(ДатаПлана);
			НачалоДаты = НачалоНедели(ДатаПлана);
		ИначеЕсли Число(Массив.view_plan) = 3 Тогда
			МенеджерЗаписи.Период		= НачалоМесяца(ДатаПлана);
			НачалоДаты = НачалоМесяца(ДатаПлана);
		КонецЕсли;

		МенеджерЗаписи.Записать();

		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПланыМенеджеровСрезПоследних.План,
		|	ПланыМенеджеровСрезПоследних.Период,
		|	ПланыМенеджеровСрезПоследних.ВидПлана
		|ИЗ
		|	РегистрСведений.ПланыМенеджеров.СрезПоследних(&ДатаПлана, ВидПлана.Ссылка = &ВидПлана) КАК
		|		ПланыМенеджеровСрезПоследних";

		Запрос.УстановитьПараметр("ВидПлана", ВидПлана);
		Запрос.УстановитьПараметр("ДатаПлана", ДатаПлана);

		РезультатЗапроса = Запрос.Выполнить();

		СтруктураПлана = Новый Структура;
		СтруктураПлана.Вставить("date", Строка(ДатаПлана));
		СтруктураПлана.Вставить("view_plan", Строка(ВидПлана));
		СтруктураПлана.Вставить("plan", 0);

		Выборка = РезультатЗапроса.Выбрать();

		Пока Выборка.Следующий() Цикл
			СтруктураПлана.date = Строка(Выборка.Период);
			СтруктураПлана.view_plan = Строка(Выборка.ВидПлана);
			СтруктураПлана.plan = Число(Выборка.План);
		КонецЦикла;

		ЗаписьJSON = Новый ЗаписьJSON;
		ЗаписьJSON.УстановитьСтроку();
		ЗаписатьJSON(ЗаписьJSON, СтруктураПлана);
		СтрокаДляОтвета = ЗаписьJSON.Закрыть();
		Ответ = Новый HTTPСервисОтвет(200);
		Ответ.Заголовки.Вставить("Content-type", "application/json;  charset=utf-8");
		Ответ.УстановитьТелоИзСтроки(СтрокаДляОтвета, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);
		Возврат Ответ;
	Исключение
		Инфо = ИнформацияОбОшибке();
		Ответ = Новый HTTPСервисОтвет(500);
		СтрокаОшибки = "" + Инфо.Описание + ?(Инфо.Причина <> Неопределено, Инфо.Причина.Описание, "");
		Ответ.УстановитьТелоИзСтроки("" + СтрокаОшибки);
		Ответ.Заголовки.Вставить("Content-type", "application/json;  charset=utf-8");
		Возврат Ответ;
	КонецПопытки;
	/// --- Комлев 04/10/24 ---
КонецФункции