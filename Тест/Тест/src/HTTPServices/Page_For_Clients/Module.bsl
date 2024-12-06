Функция ПолучитьТоварыКарточкиProductsCard(Запрос)
// Комлев АА 06/12/24 +++
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
// Комлев АА 06/12/24 ---
КонецФункции

Функция СоздатьЗаявкуCreateApp(Запрос)
// Комлев АА 06/12/24 +++
	Попытка
		ТелоЗапроса = Запрос.ПолучитьТелоКакСтроку();
		ЧтениеJSON = Новый ЧтениеJSON;
		ЧтениеJSON.УстановитьСтроку(ТелоЗапроса);
		СтруктураТела  = ПрочитатьJSON(ЧтениеJSON);

		ИмяКлиента = СтруктураТела.name;
		Телефон = СтруктураТела.phone;
		МассивКодовТоваров = СтруктураТела.id_products_card;
	
	// Найти Клинта по номеру, если не нашли, то создать.
		ЗапросКлиента = Новый Запрос;
		ЗапросКлиента.Текст =
		"ВЫБРАТЬ Первые 1
		|	Клиенты.Ссылка КАК НайденныйКлиент
		|ИЗ
		|	Справочник.Клиенты КАК Клиенты
		|ГДЕ
		|	Клиенты.Телефон = &Телефон";

		ЗапросКлиента.УстановитьПараметр("Телефон", Телефон);

		РезультатЗапроса = ЗапросКлиента.Выполнить();
		НовыйКлиент = Справочники.Клиенты.ПустаяСсылка();
		Если РезультатЗапроса.Пустой() Тогда
			НовыйКлиент = Справочники.Клиенты.СоздатьЭлемент();
			НовыйКлиент.Наименование = ИмяКлиента;
			НовыйКлиент.Телефон = Телефон;
			НовыйКлиент.Записать();
		Иначе
			Выборка = РезультатЗапроса.Выбрать();
			Выборка.Следующий();
		КонецЕсли;
		Клиент = ?(РезультатЗапроса.Пустой(), НовыйКлиент, Выборка.НайденныйКлиент);
	
	// Получить товары из массива кодов товаров
		ЗапросТоваров = Новый Запрос;
		ЗапросТоваров.Текст =
		"ВЫБРАТЬ
		|	Номенклатура.Ссылка,
		|	Номенклатура.Код,
		|	Номенклатура.Артикул,
		|	Номенклатура.РекомендованаяЦена
		|ИЗ
		|	Справочник.Номенклатура КАК Номенклатура
		|ГДЕ
		|	Номенклатура.Код В (&МассивКодовТоваров)";

		ЗапросТоваров.УстановитьПараметр("МассивКодовТоваров", МассивКодовТоваров);

		РезультатЗапроса = ЗапросТоваров.Выполнить();
		ВыборкаТоваров = РезультатЗапроса.Выбрать();
	
	// Создать док Заявка Клиента
		НоваяЗаявка = Документы.ЗаказКлиента.СоздатьДокумент();
		НоваяЗаявка.Дата = ТекущаяДатаСеанса();
		НоваяЗаявка.Клиент = Клиент.Ссылка;
		НоваяЗаявка.Состояние = Перечисления.дт_СостоянияЗаказовКлиента.Ожидание;
		НоваяЗаявка.НомерТелефона = Телефон;
		Пока ВыборкаТоваров.Следующий() Цикл
			НоваяСтрокаТовары = НоваяЗаявка.Товары.Добавить();
			НоваяСтрокаТовары.Номенклатура = ВыборкаТоваров.Ссылка;
			НоваяСтрокаТовары.Количество = 1;
			НоваяСтрокаТовары.Цена = ВыборкаТоваров.РекомендованаяЦена;
			НоваяСтрокаТовары.Сумма = НоваяСтрокаТовары.Цена;
		КонецЦикла;
		НоваяЗаявка.Записать();
		Ответ = Новый HTTPСервисОтвет(200);
		Ответ.Заголовки.Вставить("Content-Type", "application/json; charset=utf-8");
		Ответ.УстановитьТелоИзСтроки(НоваяЗаявка.Номер);
		Возврат Ответ;
	Исключение
		Инфо = ИнформацияОбОшибке();
		Ответ = Новый HTTPСервисОтвет(500);
		СтрокаОшибки = "" + Инфо.Описание + ?(Инфо.Причина <> Неопределено, Инфо.Причина.Описание, "");
		Ответ.УстановитьТелоИзСтроки("" + СтрокаОшибки);
		Ответ.Заголовки.Вставить("Content-type", "application/json;  charset=utf-8");
		Возврат Ответ;
	КонецПопытки;
// Комлев АА 06/12/24 ---

КонецФункции