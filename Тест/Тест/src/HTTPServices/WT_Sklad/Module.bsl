Функция ПолучитьТоварыЗаявки1(НомерЗаявки)
	Запросзаявки = Новый Запрос;
	Запросзаявки.Текст =  "ВЫБРАТЬ
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
	Пока выборка.Следующий()  Цикл
		СтруктураТоваров = Новый Структура;
		СтруктураТоваров.Вставить("position", Строка(выборка.НомерСтроки));
		Если выборка.Партия <> Справочники.ИндКод.ПустаяСсылка() Тогда
			СтруктураТоваров.Вставить("id", Строка(выборка.Партия));
		Иначе
			СтруктураТоваров.Вставить("id", Строка(выборка.НоменклатураКод));	
		КонецЕсли;
		СуммаТоваров = СуммаТоваров + (выборка.Цена*выборка.Количество);
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


Функция ПолучитьВсеЗаявкиGetAllApp(Запрос)
	МассивЗаявок = Новый Массив;
	Попытка

		СтрокаПоиска = "	И (ЗаказКлиента.Номер ПОДОБНО &Наименование СПЕЦСИМВОЛ ""~""" + Символы.ПС
			+ " ИЛИ ЗаказКлиента.КлиентНаименование ПОДОБНО &Наименование СПЕЦСИМВОЛ ""~""" + Символы.ПС
			+ " ИЛИ ЗаказКлиента.Клиент.ПолноеНаименование ПОДОБНО &Наименование СПЕЦСИМВОЛ ""~""" + Символы.ПС
			+ " ИЛИ ЗаказКлиента.НомерТелефона ПОДОБНО &Наименование СПЕЦСИМВОЛ ""~"")";
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
				|ВЫБРАТЬ ПЕРВЫЕ 10000
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
				|	ЗаказКлиента.ОтветственныйЗаОбработку КАК ОтветственныйЗаОбработку,
				|	ЗаказКлиента.Комментарий КАК Комментарий,
				|	ЗаказКлиента.ПодстатусОбработки КАК ПодстатусОбработки,
				|	ЗаказКлиента.НомерТелефона КАК Телефон,
				|	ЗаказКлиента.WTPanel КАК WTPanel,
				|	АвтономерЗаписи() КАК НомерЗаписи,
				|ЗаказКлиента.СтатусыДействия.Порядок КАК СтатусыДействия,
				|ЗаказКлиента.ФинансовыеСтатусы.Порядок КАК ФинансовыеСтатусы,
				|ЗаказКлиента.СтатусОбработкиЗаявкиКладовщиком.Ссылка КАК СтатусОбработкиЗаявкиКладовщикомСсылка,
				|ЗаказКлиента.СтатусОбработкиЗаявкиКладовщиком.Порядок КАК СтатусОбработкиЗаявкиКладовщикомПорядок
				|ПОМЕСТИТЬ ВТ_ДанныеЗаявки
				|ИЗ
				|	Документ.ЗаказКлиента КАК ЗаказКлиента
				|		ЛЕВОЕ Соединение ТелефоныСлужебные КАк ТелефоныСлужебные
				|		По ЗаказКлиента.Ответственный = ТелефоныСлужебные.ссылка.пользователь
				|Где ЗаказКлиента.Дата > &ДатаОтсчёта
				|
				|%2
				|
				|УПОРЯДОЧИТЬ ПО
				|	Номер УБЫВ
				|ИНДЕКСИРОВАТЬ ПО
				|	Дата
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
				|	ВТ_ДанныеЗаявки.ТелефонСлужебный КАК ТелефонСлужебный,
				|	ВТ_ДанныеЗаявки.КодСотрудника КАК КодСотрудника,
				|	ВТ_ДанныеЗаявки.КлиентКод КАК КлиентКод,
				|	ВТ_ДанныеЗаявки.Телефон КАК Телефон,
				|ВТ_ДанныеЗаявки.СтатусОбработкиЗаявкиКладовщикомСсылка КАК СтатусОбработки,
				|ЕстьNull(ВТ_ДанныеЗаявки.СтатусОбработкиЗаявкиКладовщикомПорядок, 0) КАК СтатусОбработкиПорядок
				|ИЗ
				|	ВТ_ДанныеЗаявки КАК ВТ_ДанныеЗаявки
				|ГДЕ
				|	ВТ_ДанныеЗаявки.НомерЗаписи >= &НачинаяСЗаписи
				|	УПОРЯДОЧИТЬ ПО
				|	Дата УБЫВ";
		Если Запрос.ПараметрыURL["text"] = "00" Тогда
			ЗапросЗаявок.Текст =  СтрШаблон(Текст, Формат(10000, "ЧГ="), " ");
		Иначе
			ЗапросЗаявок.Текст =  СтрШаблон(Текст, Формат(10000, "ЧГ="), СтрокаПоиска);
			ЗапросЗаявок.УстановитьПараметр("Наименование", "%" + ОбщегоНазначения.СформироватьСтрокуДляПоискаВЗапросе(
				Строка(
		Запрос.ПараметрыURL["text"])) + "%");
		КонецЕсли;
		ДатаОтсчёта = ТекущаяДата() - (3600 * 24 * 180);
		ЗапросЗаявок.УстановитьПараметр("ДатаОтсчёта", ДатаОтсчёта);
		ЗапросЗаявок.УстановитьПараметр("НачинаяСЗаписи", 0);

		ОбщееКолво = 10000;

		Если Запрос.ПараметрыURL["text"] = "00" Тогда
			ЗапросЗаявок.Текст =  СтрШаблон(Текст, Формат(?(Число(Запрос.ПараметрыURL["count"]) > 0,
				Запрос.ПараметрыURL["count"], 10000), "ЧГ="), " ");
		Иначе
			ЗапросЗаявок.Текст =  СтрШаблон(Текст, Формат(?(Число(Запрос.ПараметрыURL["count"]) > 0,
				Запрос.ПараметрыURL["count"], 10000), "ЧГ="), СтрокаПоиска);
			ЗапросЗаявок.УстановитьПараметр("Наименование", "%" + ОбщегоНазначения.СформироватьСтрокуДляПоискаВЗапросе(
				Строка(
		Запрос.ПараметрыURL["text"])) + "%");
		КонецЕсли;
		ЗапросЗаявок.УстановитьПараметр("ДатаОтсчёта", ДатаОтсчёта);

		Если Число(((Запрос.ПараметрыURL["count"]) * (Запрос.ПараметрыURL["page"]))) > 0 И Число(
		Запрос.ПараметрыURL["page"]) > 1 Тогда
			ЗапросЗаявок.УстановитьПараметр("НачинаяСЗаписи", Число(((Запрос.ПараметрыURL["count"])
				* (Запрос.ПараметрыURL["page"] - 1) + 1)));

		Иначе
			ЗапросЗаявок.УстановитьПараметр("НачинаяСЗаписи", 0);
		КонецЕсли;
	
	
		ОбщееКолво = 10000;
		
		СписокПоиска = ЗапросЗаявок.Выполнить().Выгрузить();

		Для Каждого Результат Из СписокПоиска Цикл

			СтруктураЗаявок = Новый Структура;
			СтруктураЗаявок.Вставить("id", Строка(Результат.Номер));
			СтруктураЗаявок.Вставить("date", Строка(Результат.Дата));
			СтруктураСтатуса = Новый Структура;
			СтруктураСтатуса.Вставить("state_name", Строка(Результат.СтатусОбработки) );
			СтруктураСтатуса.Вставить("state_number", Число(Результат.СтатусОбработкиПорядок) + 1);
			СтруктураЗаявок.Вставить("state", СтруктураСтатуса);
			
			СтруктураКлиента = Новый Структура;
			СтруктураКлиента.Вставить("name", Строка(Результат.Клиент));
			СтруктураКлиента.Вставить("id", Результат.КлиентКод);
			СтруктураКлиента.Вставить("phone", Результат.Телефон);
			СтруктураЗаявок.Вставить("client", СтруктураКлиента);

			СтруктураМенеджера = Новый Структура;
			СтруктураМенеджера.Вставить("name", Строка(Результат.Ответственный));
	//Менеджер = Справочники.Сотрудники.НайтиПоРеквизиту("Пользователь", выборка.Ответственный).Код;
			СтруктураМенеджера.Вставить("id", Строка(Результат.КодСотрудника));
			СтруктураМенеджера.Вставить("phone", Строка(Результат.ТелефонСлужебный));
			СтруктураЗаявок.Вставить("manager", СтруктураМенеджера);
	
		//@skip-check query-in-loop
			//СтруктураВремени = ПолучитьВремяЗК(Результат.Ссылка);
			СтруктураЗаявок.Вставить("workers", 0);
			СтруктураЗаявок.Вставить("in_work", 0);
			//@skip-check query-in-loop

			СтруктураЗаявок.Вставить("summ", Результат.СуммаДокумента);
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
		Ответ = Новый HTTPСервисОтвет(500);
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
КонецФункции

Функция ПоказателиСкладаGET(Запрос)
	/// +++ Комлев 30/09/24 +++
Попытка
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаказКлиентаТовары.Номенклатура КАК Товар,
	|	ЕСТЬNULL(КОЛИЧЕСТВО(ЗаказКлиентаТовары.Номенклатура), 0) КАК Количество,
	|	ЕСТЬNULL(МАКСИМУМ(РегистрНакопления1ОстаткиИОбороты.КолвоКонечныйОстаток), 0) КАК КолвоКонечныйОстаток
	|ПОМЕСТИТЬ ТоварыСпрашивают
	|ИЗ
	|	Документ.ЗаказКлиента.Товары КАК ЗаказКлиентаТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РегистрНакопления1.ОстаткиИОбороты(НАЧАЛОПЕРИОДА(&Дата, ДЕНЬ),
	|			КОНЕЦПЕРИОДА(&Дата, ДЕНЬ), Авто,,) КАК РегистрНакопления1ОстаткиИОбороты
	|		ПО (ЗаказКлиентаТовары.Номенклатура = РегистрНакопления1ОстаткиИОбороты.Товар)
	|ГДЕ
	|	ЗаказКлиентаТовары.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|	И ЗаказКлиентаТовары.Ссылка.Дата МЕЖДУ НАЧАЛОПЕРИОДА(&Дата, ДЕНЬ) И КОНЕЦПЕРИОДА(&Дата, ДЕНЬ)
	|	И НАЧАЛОПЕРИОДА(РегистрНакопления1ОстаткиИОбороты.ПериодДень, ДЕНЬ) = НАЧАЛОПЕРИОДА(ЗаказКлиентаТовары.Ссылка.Дата,
	|		ДЕНЬ)
	|СГРУППИРОВАТЬ ПО
	|	ЗаказКлиентаТовары.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПоступлениеЗапчастейТаблица.Товар КАК Товар,
	|	ЕСТЬNULL(КОЛИЧЕСТВО(ПоступлениеЗапчастейТаблица.Код), 0) КАК Количество
	|ПОМЕСТИТЬ УчтенныйТоварИзСпискаСпрашивают
	|ИЗ
	|	Документ.ПоступлениеЗапчастей.Таблица КАК ПоступлениеЗапчастейТаблица
	|ГДЕ
	|	ПоступлениеЗапчастейТаблица.Ссылка.Дата МЕЖДУ НАЧАЛОПЕРИОДА(&Дата, ДЕНЬ) И КОНЕЦПЕРИОДА(&Дата, ДЕНЬ)
	|	И ПоступлениеЗапчастейТаблица.Товар В
	|		(ВЫБРАТЬ
	|			ТоварыСпрашивают.Товар КАК Товар
	|		ИЗ
	|			ТоварыСпрашивают КАК ТоварыСпрашивают)
	|СГРУППИРОВАТЬ ПО
	|	ПоступлениеЗапчастейТаблица.Товар
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫРАЗИТЬ(СРЕДНЕЕ(ЕСТЬNULL(ВЫБОР
	|		КОГДА ТоварыСпрашивают.КолвоКонечныйОстаток > ТоварыСпрашивают.Количество
	|			ТОГДА 1
	|		КОГДА ТоварыСпрашивают.КолвоКонечныйОстаток >= ТоварыСпрашивают.Количество
	|		И УчтенныйТоварИзСпискаСпрашивают.Количество = 0
	|			ТОГДА 0
	|		ИНАЧЕ ВЫБОР
	|			КОГДА (ВЫРАЗИТЬ(УчтенныйТоварИзСпискаСпрашивают.Количество / ТоварыСпрашивают.Количество КАК ЧИСЛО(10, 2))) > 1
	|				ТОГДА 1
	|			ИНАЧЕ ВЫРАЗИТЬ(УчтенныйТоварИзСпискаСпрашивают.Количество / ТоварыСпрашивают.Количество КАК ЧИСЛО(10, 2))
	|		КОНЕЦ
	|	КОНЕЦ, 0)) КАК ЧИСЛО(10, 2)) КАК КоэфДень,
	|	СУММА(ТоварыСпрашивают.Количество) КАК КоличествоСпрашиваютДень,
	|	СУММА(УчтенныйТоварИзСпискаСпрашивают.Количество) КАК КоличествоУчтенногоДень
	|ПОМЕСТИТЬ ПоказателиДень
	|ИЗ
	|	ТоварыСпрашивают КАК ТоварыСпрашивают
	|		ПОЛНОЕ СОЕДИНЕНИЕ УчтенныйТоварИзСпискаСпрашивают КАК УчтенныйТоварИзСпискаСпрашивают
	|		ПО ТоварыСпрашивают.Товар = УчтенныйТоварИзСпискаСпрашивают.Товар
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ЗаказКлиентаТовары.Номенклатура) КАК Товар,
	|	ЕСТЬNULL(КОЛИЧЕСТВО(ЗаказКлиентаТовары.Номенклатура), 0) КАК Количество,
	|	ЕСТЬNULL(РегистрНакопления1ОстаткиИОбороты.КолвоКонечныйОстаток, 0) КАК КолвоКонечныйОстаток
	|ПОМЕСТИТЬ ТоварыСпрашиваютНЕДЕЛЯ
	|ИЗ
	|	Документ.ЗаказКлиента.Товары КАК ЗаказКлиентаТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РегистрНакопления1.ОстаткиИОбороты(НАЧАЛОПЕРИОДА(&Дата, НЕДЕЛЯ),
	|			КОНЕЦПЕРИОДА(&Дата, НЕДЕЛЯ), Авто,,) КАК РегистрНакопления1ОстаткиИОбороты
	|		ПО ЗаказКлиентаТовары.Номенклатура = РегистрНакопления1ОстаткиИОбороты.Товар
	|ГДЕ
	|	ЗаказКлиентаТовары.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|	И ЗаказКлиентаТовары.Ссылка.Дата МЕЖДУ НАЧАЛОПЕРИОДА(&Дата, НЕДЕЛЯ) И КОНЕЦПЕРИОДА(&Дата, НЕДЕЛЯ)
	|	И НАЧАЛОПЕРИОДА(РегистрНакопления1ОстаткиИОбороты.ПериодДень, ДЕНЬ) = НАЧАЛОПЕРИОДА(ЗаказКлиентаТовары.Ссылка.Дата,
	|		ДЕНЬ)
	|СГРУППИРОВАТЬ ПО
	|	ЗаказКлиентаТовары.Номенклатура,
	|	ЕСТЬNULL(РегистрНакопления1ОстаткиИОбороты.КолвоКонечныйОстаток, 0)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПоступлениеЗапчастейТаблица.Товар КАК Товар,
	|	ЕСТЬNULL(КОЛИЧЕСТВО(ПоступлениеЗапчастейТаблица.Код), 0) КАК Количество
	|ПОМЕСТИТЬ УчтенныйТоварИзСпискаСпрашиваютНЕДЕЛЯ
	|ИЗ
	|	Документ.ПоступлениеЗапчастей.Таблица КАК ПоступлениеЗапчастейТаблица
	|ГДЕ
	|	ПоступлениеЗапчастейТаблица.Ссылка.Дата МЕЖДУ НАЧАЛОПЕРИОДА(&Дата, НЕДЕЛЯ) И КОНЕЦПЕРИОДА(&Дата, НЕДЕЛЯ)
	|	И ПоступлениеЗапчастейТаблица.Товар В
	|		(ВЫБРАТЬ
	|			ТоварыСпрашивают.Товар КАК Товар
	|		ИЗ
	|			ТоварыСпрашиваютНЕДЕЛЯ КАК ТоварыСпрашивают)
	|СГРУППИРОВАТЬ ПО
	|	ПоступлениеЗапчастейТаблица.Товар
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫРАЗИТЬ(СРЕДНЕЕ(ЕСТЬNULL(ВЫБОР
	|		КОГДА ТоварыСпрашивают.КолвоКонечныйОстаток > ТоварыСпрашивают.Количество
	|			ТОГДА 1
	|		КОГДА ТоварыСпрашивают.КолвоКонечныйОстаток >= ТоварыСпрашивают.Количество
	|		И УчтенныйТоварИзСпискаСпрашивают.Количество = 0
	|			ТОГДА 0
	|		ИНАЧЕ ВЫБОР
	|			КОГДА (ВЫРАЗИТЬ(УчтенныйТоварИзСпискаСпрашивают.Количество / ТоварыСпрашивают.Количество КАК ЧИСЛО(10, 2))) > 1
	|				ТОГДА 1
	|			ИНАЧЕ ВЫРАЗИТЬ(УчтенныйТоварИзСпискаСпрашивают.Количество / ТоварыСпрашивают.Количество КАК ЧИСЛО(10, 2))
	|		КОНЕЦ
	|	КОНЕЦ, 0)) КАК ЧИСЛО(10, 2)) КАК КоэфДень,
	|	СУММА(ТоварыСпрашивают.Количество) КАК КоличествоСпрашиваютДень,
	|	СУММА(УчтенныйТоварИзСпискаСпрашивают.Количество) КАК КоличествоУчтенногоДень
	|ПОМЕСТИТЬ ПоказателиНЕДЕЛЯ
	|ИЗ
	|	ТоварыСпрашиваютНЕДЕЛЯ КАК ТоварыСпрашивают
	|		ПОЛНОЕ СОЕДИНЕНИЕ УчтенныйТоварИзСпискаСпрашиваютНЕДЕЛЯ КАК УчтенныйТоварИзСпискаСпрашивают
	|		ПО ТоварыСпрашивают.Товар = УчтенныйТоварИзСпискаСпрашивают.Товар
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ЗаказКлиентаТовары.Номенклатура) КАК Товар,
	|	ЕСТЬNULL(КОЛИЧЕСТВО(ЗаказКлиентаТовары.Номенклатура), 0) КАК Количество,
	|	ЕСТЬNULL(РегистрНакопления1ОстаткиИОбороты.КолвоКонечныйОстаток, 0) КАК КолвоКонечныйОстаток
	|ПОМЕСТИТЬ ТоварыСпрашиваютМЕСЯЦ
	|ИЗ
	|	Документ.ЗаказКлиента.Товары КАК ЗаказКлиентаТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.РегистрНакопления1.ОстаткиИОбороты(НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ),
	|			КОНЕЦПЕРИОДА(&Дата, МЕСЯЦ), Авто,,) КАК РегистрНакопления1ОстаткиИОбороты
	|		ПО ЗаказКлиентаТовары.Номенклатура = РегистрНакопления1ОстаткиИОбороты.Товар
	|ГДЕ
	|	ЗаказКлиентаТовары.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|	И ЗаказКлиентаТовары.Ссылка.Дата МЕЖДУ НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ) И КОНЕЦПЕРИОДА(&Дата, МЕСЯЦ)
	|	И НАЧАЛОПЕРИОДА(РегистрНакопления1ОстаткиИОбороты.ПериодДень, ДЕНЬ) = НАЧАЛОПЕРИОДА(ЗаказКлиентаТовары.Ссылка.Дата,
	|		ДЕНЬ)
	|СГРУППИРОВАТЬ ПО
	|	ЗаказКлиентаТовары.Номенклатура,
	|	ЕСТЬNULL(РегистрНакопления1ОстаткиИОбороты.КолвоКонечныйОстаток, 0)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПоступлениеЗапчастейТаблица.Товар КАК Товар,
	|	ЕСТЬNULL(КОЛИЧЕСТВО(ПоступлениеЗапчастейТаблица.Код), 0) КАК Количество
	|ПОМЕСТИТЬ УчтенныйТоварИзСпискаСпрашиваютМЕСЯЦ
	|ИЗ
	|	Документ.ПоступлениеЗапчастей.Таблица КАК ПоступлениеЗапчастейТаблица
	|ГДЕ
	|	ПоступлениеЗапчастейТаблица.Ссылка.Дата МЕЖДУ НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ) И КОНЕЦПЕРИОДА(&Дата, МЕСЯЦ)
	|	И ПоступлениеЗапчастейТаблица.Товар В
	|		(ВЫБРАТЬ
	|			ТоварыСпрашивают.Товар КАК Товар
	|		ИЗ
	|			ТоварыСпрашиваютМЕСЯЦ КАК ТоварыСпрашивают)
	|СГРУППИРОВАТЬ ПО
	|	ПоступлениеЗапчастейТаблица.Товар
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫРАЗИТЬ(СРЕДНЕЕ(ЕСТЬNULL(ВЫБОР
	|		КОГДА ТоварыСпрашивают.КолвоКонечныйОстаток > ТоварыСпрашивают.Количество
	|			ТОГДА 1
	|		КОГДА ТоварыСпрашивают.КолвоКонечныйОстаток >= ТоварыСпрашивают.Количество
	|		И УчтенныйТоварИзСпискаСпрашивают.Количество = 0
	|			ТОГДА 0
	|		ИНАЧЕ ВЫБОР
	|			КОГДА (ВЫРАЗИТЬ(УчтенныйТоварИзСпискаСпрашивают.Количество / ТоварыСпрашивают.Количество КАК ЧИСЛО(10, 2))) > 1
	|				ТОГДА 1
	|			ИНАЧЕ ВЫРАЗИТЬ(УчтенныйТоварИзСпискаСпрашивают.Количество / ТоварыСпрашивают.Количество КАК ЧИСЛО(10, 2))
	|		КОНЕЦ
	|	КОНЕЦ, 0)) КАК ЧИСЛО(10, 2)) КАК КоэфДень,
	|	СУММА(ТоварыСпрашивают.Количество) КАК КоличествоСпрашиваютДень,
	|	СУММА(УчтенныйТоварИзСпискаСпрашивают.Количество) КАК КоличествоУчтенногоДень
	|ПОМЕСТИТЬ ПоказателиМЕСЯЦ
	|ИЗ
	|	ТоварыСпрашиваютМЕСЯЦ КАК ТоварыСпрашивают
	|		ПОЛНОЕ СОЕДИНЕНИЕ УчтенныйТоварИзСпискаСпрашиваютМЕСЯЦ КАК УчтенныйТоварИзСпискаСпрашивают
	|		ПО ТоварыСпрашивают.Товар = УчтенныйТоварИзСпискаСпрашивают.Товар
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(ПоказателиДень.КоэфДень, 0) КАК КоэфДень,
	|	ЕСТЬNULL(ПоказателиДень.КоличествоСпрашиваютДень, 0) КАК КоличествоСпрашиваютДень,
	|	ЕСТЬNULL(ПоказателиДень.КоличествоУчтенногоДень, 0) КАК КоличествоУчтенногоДень,
	|	ЕСТЬNULL(ПоказателиНЕДЕЛЯ.КоличествоСпрашиваютДень, 0) КАК КоличествоСпрашиваютНеделя,
	|	ЕСТЬNULL(ПоказателиНЕДЕЛЯ.КоличествоУчтенногоДень, 0) КАК КоличествоУчтенногоНеделя,
	|	ЕСТЬNULL(ПоказателиМЕСЯЦ.КоэфДень, 0) КАК КоэфМесяц,
	|	ЕСТЬNULL(ПоказателиМЕСЯЦ.КоличествоСпрашиваютДень, 0) КАК КоличествоСпрашиваютМесяц,
	|	ЕСТЬNULL(ПоказателиМЕСЯЦ.КоличествоУчтенногоДень, 0) КАК КоличествоУчтенногоМесяц,
	|	ЕСТЬNULL(ПоказателиНЕДЕЛЯ.КоэфДень, 0) КАК КоэфНеделя
	|ИЗ
	|	ПоказателиДень КАК ПоказателиДень,
	|	ПоказателиНЕДЕЛЯ КАК ПоказателиНЕДЕЛЯ,
	|	ПоказателиМЕСЯЦ КАК ПоказателиМЕСЯЦ";

	Запрос.УстановитьПараметр("Дата", ТекущаяДата());

	РезультатЗапроса = Запрос.Выполнить();

	Выборка = РезультатЗапроса.Выбрать();
	СтруктураПоказатели = Новый Структура;
	Пока Выборка.Следующий() Цикл
		СтруктураПоказатели.Вставить("ratio_day", Число(Выборка.КоэфДень));
		СтруктураПоказатели.Вставить("count_from_app_day", Число(Выборка.КоличествоСпрашиваютДень));
		СтруктураПоказатели.Вставить("count_registered_day", Число(Выборка.КоличествоУчтенногоДень));

		СтруктураПоказатели.Вставить("ratio_week", Число(Выборка.КоэфДень));
		СтруктураПоказатели.Вставить("count_from_app_week", Число(Выборка.КоличествоСпрашиваютНеделя));
		СтруктураПоказатели.Вставить("count_registered_week", Число(Выборка.КоличествоУчтенногоНеделя));
		СтруктураПоказатели.Вставить("ratio_month", Число(Выборка.КоэфМесяц));
		СтруктураПоказатели.Вставить("count_from_app_month", Число(Выборка.КоличествоСпрашиваютМесяц));
		СтруктураПоказатели.Вставить("count_registered_month", Число(Выборка.КоличествоУчтенногоМесяц));
	КонецЦикла;
	
	Ответ = Новый HTTPСервисОтвет(200);
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	ЗаписатьJSON(ЗаписьJSON, СтруктураПоказатели);
	СтрокаДляОтвета = ЗаписьJSON.Закрыть();
	Ответ.УстановитьТелоИзСтроки(СтрокаДляОтвета);
	Ответ.Заголовки.Вставить("Content-type", "application/json;  charset=utf-8");
	Возврат Ответ;
Исключение
	Инфо = ИнформацияОбОшибке();
	Ответ = Новый HTTPСервисОтвет(500);
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	ТекстОшибки = "" + Инфо.Описание + ?(Инфо.Причина <> Неопределено, Инфо.Причина.Описание, " ");
	ЗаписатьJSON(ЗаписьJSON, ТекстОшибки);
	СтрокаДляОтвета = ЗаписьJSON.Закрыть();
	Ответ.УстановитьТелоИзСтроки(СтрокаДляОтвета);
	Ответ.Заголовки.Вставить("Content-type", "application/json;  charset=utf-8");
	Возврат Ответ;
КонецПопытки;
/// --- Комлев 30/09/24 ---
КонецФункции
Функция ПолучитьВсеЗаявкиПоСтатусамИПоискомGET(Запрос)
	/// +++ Комлев 30/09/24 +++
	Попытка

		СтрокаПоиска = "	И (ЗаказКлиента.Номер ПОДОБНО &Наименование СПЕЦСИМВОЛ ""~""" + Символы.ПС
			+ " ИЛИ ЗаказКлиента.КлиентНаименование ПОДОБНО &Наименование СПЕЦСИМВОЛ ""~""" + Символы.ПС
			+ " ИЛИ ЗаказКлиента.Клиент.ПолноеНаименование ПОДОБНО &Наименование СПЕЦСИМВОЛ ""~""" + Символы.ПС
			+ " ИЛИ ЗаказКлиента.НомерТелефона ПОДОБНО &Наименование СПЕЦСИМВОЛ ""~"")";
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
				|ВЫБРАТЬ ПЕРВЫЕ 10000
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
				|	ЗаказКлиента.СтатусОбработкиЗаявкиКладовщиком КАК СтатусОбработкиЗаявкиКладовщиком,
				|	ЗаказКлиента.ОтветственныйЗаОбработку КАК ОтветственныйЗаОбработку,
				|	ЗаказКлиента.Комментарий КАК Комментарий,
				|	ЗаказКлиента.ПодстатусОбработки КАК ПодстатусОбработки,
				|	ЗаказКлиента.НомерТелефона КАК Телефон,
				|	ЗаказКлиента.WTPanel КАК WTPanel,
				|	АвтономерЗаписи() КАК НомерЗаписи,
				|ЗаказКлиента.СтатусыДействия.Порядок КАК СтатусыДействия,
				|ЗаказКлиента.ФинансовыеСтатусы.Порядок КАК ФинансовыеСтатусы,
				|ЗаказКлиента.СтатусОбработкиЗаявкиКладовщиком.Ссылка КАК СтатусОбработкиЗаявкиКладовщикомСсылка,
				|ЗаказКлиента.СтатусОбработкиЗаявкиКладовщиком.Порядок КАК СтатусОбработкиЗаявкиКладовщикомПорядок
				|ПОМЕСТИТЬ ВТ_ДанныеЗаявки
				|ИЗ
				|	Документ.ЗаказКлиента КАК ЗаказКлиента
				|		ЛЕВОЕ Соединение ТелефоныСлужебные КАк ТелефоныСлужебные
				|		По ЗаказКлиента.Ответственный = ТелефоныСлужебные.ссылка.пользователь
				|Где ЗаказКлиента.Дата > &ДатаОтсчёта
				|
				|%2
				|%3
				|УПОРЯДОЧИТЬ ПО
				|	Номер УБЫВ
				|ИНДЕКСИРОВАТЬ ПО
				|	Дата
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
				|	ВТ_ДанныеЗаявки.СтатусОбработкиЗаявкиКладовщиком КАК СтатусОбработкиЗаявкиКладовщиком,
				|	ЕСТЬNULL(ВТ_ДанныеЗаявки.СтатусОбработкиЗаявкиКладовщикомПорядок, 0) КАК СтатусОбработкиЗаявкиКладовщикомПорядок,
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
				|	УПОРЯДОЧИТЬ ПО
				|	Дата УБЫВ";
				
		СтрокаФильтра = " ";
		ЗначениеФильтра = Число(Запрос.ПараметрыURL["filter_status"]);
		Если ЗначениеФильтра = 3 Тогда
			СтрокаФильтра = " И ЗаказКлиента.СтатусОбработкиЗаявкиКладовщиком = ЗНАЧЕНИЕ(Перечисление.СтатусыОбработкиЗаявокКладовщиком.Завершено)";
		ИначеЕсли ЗначениеФильтра = 1 Тогда
			СтрокаФильтра = " И ЗаказКлиента.СтатусОбработкиЗаявкиКладовщиком = ЗНАЧЕНИЕ(Перечисление.СтатусыОбработкиЗаявокКладовщиком.НоваяЗаявка)";
		ИначеЕсли ЗначениеФильтра = 2 Тогда
			СтрокаФильтра = " И ЗаказКлиента.СтатусОбработкиЗаявкиКладовщиком = ЗНАЧЕНИЕ(Перечисление.СтатусыОбработкиЗаявокКладовщиком.ВРаботе)";
		ИначеЕсли ЗначениеФильтра = 4 Тогда
			СтрокаФильтра = " И ЗаказКлиента.СтатусОбработкиЗаявкиКладовщиком = ЗНАЧЕНИЕ(Перечисление.СтатусыОбработкиЗаявокКладовщиком.Отменено)";
		КонецЕсли;
		
		Если Запрос.ПараметрыURL["text"] = "00" Тогда
			ЗапросЗаявок.Текст =  СтрШаблон(Текст, Формат(10000, "ЧГ="), " ", СтрокаФильтра);
		Иначе
			ЗапросЗаявок.Текст =  СтрШаблон(Текст, Формат(10000, "ЧГ="), СтрокаПоиска, СтрокаФильтра);
			ЗапросЗаявок.УстановитьПараметр("Наименование", "%" + ОбщегоНазначения.СформироватьСтрокуДляПоискаВЗапросе(
				Строка(
		Запрос.ПараметрыURL["text"])) + "%");
		КонецЕсли;
		ДатаОтсчёта = ТекущаяДата() - (3600 * 24 * 2000);
		ЗапросЗаявок.УстановитьПараметр("ДатаОтсчёта", ДатаОтсчёта);
		ЗапросЗаявок.УстановитьПараметр("НачинаяСЗаписи", 0);
		ОбщееКолво = ЗапросЗаявок.Выполнить().Выбрать().Количество();
		
		Если Запрос.ПараметрыURL["text"] = "00"  Тогда
			ЗапросЗаявок.Текст =  СтрШаблон(Текст, Формат(?(Число(Запрос.ПараметрыURL["count"]) > 0,
				Запрос.ПараметрыURL["count"], 10000), "ЧГ="), " ", СтрокаФильтра);
		Иначе
			ЗапросЗаявок.Текст =  СтрШаблон(Текст, Формат(?(Число(Запрос.ПараметрыURL["count"]) > 0,
				Запрос.ПараметрыURL["count"], 10000), "ЧГ="), СтрокаПоиска, СтрокаФильтра);
			ЗапросЗаявок.УстановитьПараметр("Наименование", "%" + ОбщегоНазначения.СформироватьСтрокуДляПоискаВЗапросе(
				Строка(
		Запрос.ПараметрыURL["text"])) + "%");
		КонецЕсли;
		ЗапросЗаявок.УстановитьПараметр("ДатаОтсчёта", ДатаОтсчёта);

		Если Число(((Запрос.ПараметрыURL["count"]) * (Запрос.ПараметрыURL["page"]))) > 0 И Число(
		Запрос.ПараметрыURL["page"]) > 1 Тогда
			ЗапросЗаявок.УстановитьПараметр("НачинаяСЗаписи", Число(((Запрос.ПараметрыURL["count"])
				* (Запрос.ПараметрыURL["page"] - 1) + 1)));

		Иначе
			ЗапросЗаявок.УстановитьПараметр("НачинаяСЗаписи", 0);
		КонецЕсли;
		
		СписокПоиска = ЗапросЗаявок.Выполнить().Выгрузить();
		МассивЗаявок = Новый Массив;
		Для Каждого Результат Из СписокПоиска Цикл

			СтруктураЗаявок = Новый Структура;
			СтруктураЗаявок.Вставить("id", Строка(Результат.Номер));
			СтруктураЗаявок.Вставить("date", Строка(Результат.Дата));
			СтруктураСтатуса = Новый Структура;
			СтруктураСтатуса.Вставить("state_name", Строка(Результат.СтатусОбработкиЗаявкиКладовщиком) );
			СтруктураСтатуса.Вставить("state_number", Число(Результат.СтатусОбработкиЗаявкиКладовщикомПорядок) + 1);
			СтруктураЗаявок.Вставить("state", СтруктураСтатуса);
			
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
	
			СтруктураЗаявок.Вставить("workers", 0);
			СтруктураЗаявок.Вставить("in_work", 0);
			

			СтруктураЗаявок.Вставить("summ", Результат.СуммаДокумента);
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
		Ответ = Новый HTTPСервисОтвет(500);
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
	/// --- Комлев 30/09/24 ---
КонецФункции

Функция ПроверкаНаТоварProductOrNot(Запрос)
	// ++ МазинЕС 14-10-24
	
	Товар = Строка(Запрос.ПараметрыURL["product"]);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ИндКод.Код КАК Код
		|ИЗ
		|	Справочник.ИндКод КАК ИндКод
		|ГДЕ
		|	ИндКод.Наименование = &Товар";
	
	Запрос.УстановитьПараметр("Товар", Товар);
	
	
	Структура = Новый Структура();
	
	ЕСли НЕ Запрос.Выполнить().Пустой()   ТОгда 
		Структура.Вставить("status",Истина);
	Иначе 
		Структура.Вставить("status",Ложь);	
	КонецЕсли; 
		
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	
	ЗаписатьJSON(ЗаписьJSON, Структура);
	СтрокаДляОтвета = ЗаписьJSON.Закрыть();

	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.Заголовки.Вставить("Content-Type", "application/json; charset=utf-8");
	Ответ.УстановитьТелоИзСтроки(СтрокаДляОтвета, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);
	
	Возврат Ответ;
// -- МазинЕС 14-10-24
КонецФункции

Функция ПроверкаНаПолкуИлиСтелажShelfOrShelving(Запрос)
		// ++ МазинЕС 14-10-24
	Место = Строка(Запрос.ПараметрыURL["place"]);

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Стеллаж.Код КАК Код
		|ИЗ
		|	Справочник.Стеллаж КАК Стеллаж
		|ГДЕ
		|	Стеллаж.Наименование = &Наименование";
	
	Запрос.УстановитьПараметр("Наименование", Место);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Структура = Новый Структура();
	
	Если НЕ РезультатЗапроса.Пустой() ТОгда 
		
		Структура.Вставить("status",Число(2));	
		ЗаписьJSON = Новый ЗаписьJSON;
		ЗаписьJSON.УстановитьСтроку();
	
		ЗаписатьJSON(ЗаписьJSON, Структура);
		СтрокаДляОтвета = ЗаписьJSON.Закрыть();

		Ответ = Новый HTTPСервисОтвет(200);
		Ответ.Заголовки.Вставить("Content-Type", "application/json; charset=utf-8");
		Ответ.УстановитьТелоИзСтроки(СтрокаДляОтвета, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);
		Возврат Ответ;
	КонецЕсли; 


	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Поддоны.Код КАК Код
	|ИЗ
	|	Справочник.Поддоны КАК Поддоны
	|ГДЕ
	|	Поддоны.Наименование = &Поддон";

	Запрос.УстановитьПараметр("Поддон", Место);

	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() ТОгда 
		
		Структура.Вставить("status",Число(1));	
		ЗаписьJSON = Новый ЗаписьJSON;
		ЗаписьJSON.УстановитьСтроку();
	
		ЗаписатьJSON(ЗаписьJSON, Структура);
		СтрокаДляОтвета = ЗаписьJSON.Закрыть();

		Ответ = Новый HTTPСервисОтвет(200);
		Ответ.Заголовки.Вставить("Content-Type", "application/json; charset=utf-8");
		Ответ.УстановитьТелоИзСтроки(СтрокаДляОтвета, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);
		Возврат Ответ;
	Иначе 
		Структура.Вставить("status",Число(0));	
		ЗаписьJSON = Новый ЗаписьJSON;
		ЗаписьJSON.УстановитьСтроку();
	
		ЗаписатьJSON(ЗаписьJSON, Структура);
		СтрокаДляОтвета = ЗаписьJSON.Закрыть();

		Ответ = Новый HTTPСервисОтвет(200);
		Ответ.Заголовки.Вставить("Content-Type", "application/json; charset=utf-8");
		Ответ.УстановитьТелоИзСтроки(СтрокаДляОтвета, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);
		Возврат Ответ;
	КонецЕсли; 

// -- МазинЕС 14-10-24
КонецФункции
Функция ПолучитьКоличествоСвободныхЗаявокИЗаказНарядовget_count_free_apps_orders(Запрос)

	Попытка
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(ЗаказКлиента.Ссылка) КАК КоличествоЗаявок
		|ИЗ
		|	Документ.ЗаказКлиента КАК ЗаказКлиента
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказКлиента.Ответственные КАК ЗаказКлиентаОтветственные
		|		ПО ЗаказКлиента.Ссылка = ЗаказКлиентаОтветственные.Ссылка
		|ГДЕ
		|	ЗаказКлиентаОтветственные.Ссылка ЕСТЬ NULL
		|	И ЗаказКлиента.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(ЗаказНаряд.Ссылка) КАК КоличествоНарядов
		|ИЗ
		|	Документ.ЗаказНаряд КАК ЗаказНаряд
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказНаряд.Ответственные КАК ЗаказНарядОтветственные
		|		ПО (ЗаказНаряд.Ссылка = ЗаказНарядОтветственные.Ссылка)
		|ГДЕ
		|	ЗаказНарядОтветственные.Ссылка ЕСТЬ NULL
		|	И ЗаказНаряд.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания";
		Запрос.УстановитьПараметр("ДатаНачала", ТекущаяДата() - 2419200);
		Запрос.УстановитьПараметр("ДатаОкончания", КонецДня(ТекущаяДата()));

		Пакеты = Запрос.ВыполнитьПакет();
		СтруктураОтвета = Новый Структура;
		СтруктураОтвета.Вставить("count_free_app", 0);
		СтруктураОтвета.Вставить("count_free_order", 0);

		ВыборкаЗаявки = Пакеты[0].Выбрать();
		ВыборкаНаряды = Пакеты[1].Выбрать();
		Пока ВыборкаЗаявки.Следующий() Цикл
			СтруктураОтвета.count_free_app = ВыборкаЗаявки.КоличествоЗаявок;
		КонецЦикла;

		Пока ВыборкаНаряды.Следующий() Цикл
			СтруктураОтвета.count_free_order = ВыборкаНаряды.КоличествоНарядов;
		КонецЦикла;
		Ответ = Новый HTTPСервисОтвет(200);
		Ответ.Заголовки.Вставить("Content-type", "application/json;  charset=utf-8");
		ЗаписьJSON = Новый ЗаписьJSON;
		ЗаписьJSON.УстановитьСтроку();
		ЗаписатьJSON(ЗаписьJSON, СтруктураОтвета);
		СтрокаДляОтвета = ЗаписьJSON.Закрыть();
		Ответ.УстановитьТелоИзСтроки(СтрокаДляОтвета);

		Возврат Ответ;
	Исключение
		Ответ = Новый HTTPСервисОтвет(500);
		Ответ.Заголовки.Вставить("Content-type", "application/json;  charset=utf-8");
		Информация = ИнформацияОбОшибке();
		ЗаписьJSON = Новый ЗаписьJSON;
		ЗаписьJSON.УстановитьСтроку();
		Информация = ИнформацияОбОшибке();
		ЗаписатьJSON(ЗаписьJSON,  Информация.Описание);
		СтрокаДляОтвета = ЗаписьJSON.Закрыть();
		Ответ.УстановитьТелоИзСтроки(СтрокаДляОтвета);
	Возврат Ответ;
	КонецПопытки;
	
КонецФункции
Функция ИзменитьСтатусСборкиСhange_build_status_app(Запрос)
	
	Попытка 
		Тело = Запрос.ПолучитьТелоКакСтроку();
		ЧтениеJSON = Новый ЧтениеJSON;
		ЧтениеJSON.УстановитьСтроку(Тело);
		Структура  = ПрочитатьJSON(ЧтениеJSON);
		Автор =  Справочники.Сотрудники.НайтиПоКоду(Структура.author).Наименование;
		Заявка =  Документы.ЗаказКлиента.НайтиПоНомеру(Структура.id);
		Статус = Перечисления.СтатусыОбработкиЗаявокКладовщиком.Получить(Число(Структура.state_build) - 1);
		
		ЗаявкаОбъект = Заявка.ПолучитьОбъект();
		ЗаявкаОбъект.СтатусОбработкиЗаявкиКладовщиком = Статус;
		Событие = " изменил статус обработки кладовщиком " + Статус;
		ЗаписьЛога(Событие, Заявка, Автор);
		ЗаявкаОбъект.Записать();
		Ответ = Новый HTTPСервисОтвет(204);
		Возврат Ответ;
	Исключение
		Инфо = ИнформацияОбОшибке();
		Ответ = Новый HTTPСервисОтвет(500);
		СтрокаОшибки = "" + Инфо.Описание + ?(Инфо.Причина <> Неопределено, Инфо.Причина.Описание, "");
		Ответ.УстановитьТелоИзСтроки("" + СтрокаОшибки);
		Ответ.Заголовки.Вставить("Content-type", "application/json;  charset=utf-8");
		Возврат Ответ;
	КонецПопытки;
КонецФункции

Процедура ЗаписьЛога(Событие, Ссылка, Автор)
	
	ТекстЛога =  "----------------------------------------------------" + Символы.ПС + ТекущаяДата() + Символы.ПС + Автор + Символы.ПС +" "+ Событие + Символы.ПС ;
	
	Запись = РегистрыСведений.ЛогЗаявок.СоздатьМенеджерЗаписи();
	Запись.Заявка		 = Ссылка;
	Запись.Дата 		 = ТекущаяДата();
	Запись.Автор	     = Автор;
	Запись.Текст         = ТекстЛога;
	Запись.Записать();
	
КонецПроцедуры
