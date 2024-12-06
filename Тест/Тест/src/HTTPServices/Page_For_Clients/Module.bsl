#Область ОбработчикиСобытий

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
Функция ПолучитьТоварGetProduct(Запрос)
/// МазинЕС-06-12-20-24	
	ЗапросТовара = Новый Запрос;
	ЗапросТовара.Текст =  СтрШаблон(текстДляТовараGetProduct(), Формат(10000, "ЧГ=")); 
	ЗапросТовара.УстановитьПараметр("Наименование", Строка(Запрос.ПараметрыURL["id"]));
	ЗапросТовара.УстановитьПараметр("НачинаяСЗаписи", 0);

	ТЗ_Товары = ЗапросТовара.Выполнить().Выгрузить();
	ТЗ_Товары.Колонки.Добавить("колФото", Новый ОписаниеТипов("Число"));
	ТЗ_Товары.Колонки.Добавить("Фото", Новый ОписаниеТипов("Массив"));
	МассивТоваров = Новый Массив;

	ИндКоды = ТЗ_Товары.ВыгрузитьКолонку("индкод");
	Фотки = РаботаССайтомWT.ПолучениеФото(ИндКоды);
	Итер = 0;
	

	Фотограф = ПолучитьФотографаGetProduct(Запрос.ПараметрыURL["id"]); 
	ФИОФотографа = "";
	ТабНомФотографа = "";
	Если Фотограф <> Неопределено Тогда
		ФИОФотографа = Справочники.Сотрудники.НайтиПоКоду(Фотограф.tabnum);
		ТабНомФотографа = Фотограф.tabnum;
	КонецЕсли;
	
	
	Если ТЗ_Товары.Количество() > 0 Тогда
		Для Каждого стр Из ТЗ_Товары Цикл
			
			НайденныеФотки = Новый Массив;
		
			НайденныеФотки = Фотки[итер].urls;
			МассивФото = Новый массив;
			Если НайденныеФотки <> Неопределено И НайденныеФотки.Количество() > 0 Тогда

				стр.колфото = 1;

				Для Каждого Фотка Из НайденныеФотки Цикл
					Текст = "";
					Текст = Фотка;
					МассивФото.Добавить(Текст);
				КонецЦикла;
			КонецЕсли;
			итер = итер + 1;
			ТЗ_Товары.Сортировать("колФото Убыв");
			РекомендованноеМестоХранения = Новый Массив;
			ЗапросРекомендованноеМесто = Новый Запрос;
			ЗапросРекомендованноеМесто.Текст = текстРекомендуемоеМестоХраненияGetProduct();
			ЗапросРекомендованноеМесто.УстановитьПараметр("Наименование", Строка(стр.код));
			РезультатЗапросаРекомендованноеМесто = ЗапросРекомендованноеМесто.Выполнить().Выбрать();
			РезультатЗапросаРекомендованноеМесто.Следующий();
			СтруктураРекомендованноеМесто = Новый Структура;
			СтруктураРекомендованноеМесто.Вставить("sklad", Строка(РезультатЗапросаРекомендованноеМесто.Склад));
			СтруктураРекомендованноеМесто.Вставить("shelf", Строка(РезультатЗапросаРекомендованноеМесто.Адрес));
			СтруктураРекомендованноеМесто.Вставить("poddon", Строка(РезультатЗапросаРекомендованноеМесто.Поддон));
			СтруктураРекомендованноеМесто.Вставить("count", Строка(РезультатЗапросаРекомендованноеМесто.Количество));
			РекомендованноеМестоХранения.Добавить(СтруктураРекомендованноеМесто);
			СтруктураТоваров = Новый Структура;	
			Структура = ПолучитьДанныеОТовареGetProduct(стр.индкод);
			СтруктураТоваров.Вставить(" yearcar", Число(стр.машинаГод));
			СтруктураТоваров.Вставить("name", Строка(стр.Наименование));
			СтруктураТоваров.Вставить("article", Строка(стр.Артикул));
			СтруктураТоваров.Вставить("price", стр.Цена);
			СтруктураТоваров.Вставить("sklad", Строка(стр.Склад));
			СтруктураТоваров.Вставить("id", Строка(стр.индкод));
			СтруктураТоваров.Вставить("photos", МассивФото);
			МассивТоваров.Добавить(СтруктураТоваров);
		
		КонецЦикла;

		ЗаписьJSON = Новый ЗаписьJSON;
		ЗаписьJSON.УстановитьСтроку();

		ЗаписатьJSON(ЗаписьJSON, СтруктураТоваров);

		СтрокаДляОтвета = ЗаписьJSON.Закрыть();

		Ответ = Новый HTTPСервисОтвет(200);
		Ответ.Заголовки.Вставить("Content-type", "application/json;  charset=utf-8");

		Ответ.УстановитьТелоИзСтроки(СтрокаДляОтвета, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);
	Иначе
		ЗаписьJSON = Новый ЗаписьJSON;
		ЗаписьJSON.УстановитьСтроку();
		
	

		ЗаписатьJSON(ЗаписьJSON, СформироватьСтруктуруОшибкиGetProduct("Товар не найден",
			"Ошибка при вызове метода контекста (Выполнить)"));
		СтрокаДляОтвета = ЗаписьJSON.Закрыть();

		Ответ = Новый HTTPСервисОтвет(500);
		Ответ.Заголовки.Вставить("Content-type", "application/json;  charset=utf-8");

		Ответ.УстановитьТелоИзСтроки( СтрокаДляОтвета);
	КонецЕсли;
	Возврат Ответ;
/// МазинЕС-06-12-20-24	
КонецФункции

Функция текстДляТовараGetProduct()
/// МазинЕС-06-12-20-24	
	Текстзапроса = "ВЫБРАТЬ
				   |	ИндНомер.индкод КАК индкод
				   |ПОМЕСТИТЬ ВТ_предКоды
				   |ИЗ
				   |	РегистрСведений.ИндНомер КАК ИндНомер
				   |ГДЕ
				   |	ИндНомер.индкод.Наименование = &Наименование
				   |
				   |;
				   |
				   |////////////////////////////////////////////////////////////////////////////////
				   |ВЫБРАТЬ
				   |	РегИндНомер.индкод.Владелец.Наименование КАК Наименование,
				   |	РегИндНомер.индкод КАК индкод,
				   |	РегИндНомер.Состояние КАК Состояние,
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
				   |	РегИндНомер.Ответственный КАК Учетчик,
				   |	АВТОНОМЕРЗАПИСИ() КАК НомерЗаписи,
				   |	ПРЕДСТАВЛЕНИЕ(РегистрНакопления1Остатки.Склад) КАК Склад,
				   |	РегИндНомер.Поддон КАК Поддон,
				   |	РегИндНомер.АвитоЧастник КАК АвитоЧастник,
				   |	НоменклатураТовар.Размеры КАК Размеры,
				   |	НоменклатураТовар.Вес КАК Вес,
				   |	НоменклатураТовар.выс КАК выс,
				   |	НоменклатураТовар.длин КАК длин,
				   |	НоменклатураТовар.шир КАК шир,
				   |
				   |	НоменклатураТовар.Код КАК НоменклатураКод,
				   |
				   |РегистрНакопления1Остатки.КолвоОстаток Как Остаток,
				   |ЕстьNULL(РегистрНакопления1Остатки.машина.Год,0 )КАК машинаГод,
				   |	РегИндНомер.индкод.Владелец.Код КАК Код,
				   |ВЫБОР
				   |Когда регистрНакопления1Остатки.КолвоОстаток > 0 Тогда
				   |""Есть в наличии""
				   |Иначе
				   |""Товар продан""
				   |
				   |КОНЕЦ КАК ФактНаличия
				   |ПОМЕСТИТЬ ВТ_данныеНоменклатур
				   |ИЗ
				   |	ВТ_предКоды КАК ИндНомер
				   |		Левое СОЕДИНЕНИЕ РегистрНакопления.РегистрНакопления1.Остатки КАК РегистрНакопления1Остатки
				   |		ПО ИндНомер.индкод = РегистрНакопления1Остатки.индкод
				   |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК НоменклатураТовар
				   |		ПО ИндНомер.индкод.Владелец.Ссылка = НоменклатураТовар.Ссылка
				   |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ИндНомер КАК РегИндНомер
				   |		ПО ИндНомер.индкод = РегИндНомер.индкод
				   |{ГДЕ
				   |	(РегИндНомер.АвитоЧастник = &Ач) КАК Поле2}
				   |;
				   |
				   |////////////////////////////////////////////////////////////////////////////////
				   |ВЫБРАТЬ ПЕРВЫЕ %1
				   |	ВТ_данныеНоменклатур.Наименование КАК Наименование,
				   |	ПРЕДСТАВЛЕНИЕ(ВТ_данныеНоменклатур.индкод) КАК индкод,
				   |	ВТ_данныеНоменклатур.Цена КАК Цена,
				   |	ВТ_данныеНоменклатур.Состояние КАК Состояние,
				   |	ВТ_данныеНоменклатур.Комментарий КАК Комментарий,
				   |	ВТ_данныеНоменклатур.Артикул КАК Артикул,
				   |	ВТ_данныеНоменклатур.Подкатегория2 КАК Подкатегория2,
				   |	ВТ_данныеНоменклатур.Адрес КАК Адрес,
				   |	ВТ_данныеНоменклатур.Учетчик КАК Учетчик,
				   |	ВТ_данныеНоменклатур.Склад КАК Склад,
				   |	ВТ_данныеНоменклатур.НомерЗаписи КАК НомерЗаписи,
				   |	ВТ_данныеНоменклатур.Поддон КАК Поддон,
				   |	ВТ_данныеНоменклатур.АвитоЧастник КАК АвитоЧастник,
				   |	ВТ_данныеНоменклатур.ФактНаличия КАК ФактНаличия,
				   |ВТ_данныеНоменклатур.Остаток КАК Остаток,
				   |ВТ_данныеНоменклатур.машинаГод КАК машинаГод,
				   |	ВТ_данныеНоменклатур.Код КАК Код,
				   |	ВТ_данныеНоменклатур.Размеры КАК Размеры,
				   |	ВТ_данныеНоменклатур.Вес КАК Вес,
				   |	ВТ_данныеНоменклатур.выс КАК выс,
				   |	ВТ_данныеНоменклатур.длин КАК длин,
				   |	ВТ_данныеНоменклатур.НоменклатураКод КАК НоменклатураКод,
				   |	ВТ_данныеНоменклатур.шир КАК шир
				   |ИЗ
				   |	ВТ_данныеНоменклатур КАК ВТ_данныеНоменклатур
				   |ГДЕ
				   |	ВТ_данныеНоменклатур.НомерЗаписи >= &НачинаяСЗаписи
				   |
				   |УПОРЯДОЧИТЬ ПО
				   |	НомерЗаписи";

	Возврат Текстзапроса;
/// МазинЕС-06-12-20-24
КонецФункции

Функция ПолучитьФотографаGetProduct(ИндКод)
/// МазинЕС-06-12-20-24	
	
	Попытка
		Соединение = Новый HTTPСоединение("192.168.0.245", 8085);

		СтрокаЗапроса = "v1/product/" + ИндКод + "/last_date/tabnum";
		Заголовки = Новый Соответствие;
		Заголовки.Вставить("Content-Type", "application/json");

		Запрос = Новый HTTPЗапрос(СтрокаЗапроса, Заголовки);	
	
		Ответ = Соединение.Получить(Запрос);

		Если Ответ.КодСостояния = 200 Тогда
			Тело = Ответ.ПолучитьТелоКакСтроку();
			ЧтениеJSON = Новый ЧтениеJSON;
			ЧтениеJSON.УстановитьСтроку(Тело);

			Ответ  = ПрочитатьJSON(ЧтениеJSON);
			
		Иначе
			
			тело = Ответ.ПолучитьТелоКакСтроку();
			ЧтениеJSON = Новый ЧтениеJSON;
			ЧтениеJSON.УстановитьСтроку(Тело);

			Ответ  = ПрочитатьJSON(ЧтениеJSON);
			
			ответ = Неопределено;
		КонецЕсли;
		Возврат Ответ;
	Исключение

		Возврат Неопределено;
	КонецПопытки;
	
/// МазинЕС-06-12-20-24
КонецФункции

Функция текстРекомендуемоеМестоХраненияGetProduct()
/// МазинЕС-06-12-20-24	
	
	Текстзапроса = "ВЫБРАТЬ
				   |	Номенклатура.Ссылка КАК Ссылка
				   |ПОМЕСТИТЬ ВТ_Номенклатура
				   |ИЗ
				   |	Справочник.Номенклатура КАК Номенклатура
				   |ГДЕ
				   |	Номенклатура.Код = &Наименование
				   |;
				   |
				   |////////////////////////////////////////////////////////////////////////////////
				   |ВЫБРАТЬ
				   |	ИндНомер.индкод КАК индкод
				   |ПОМЕСТИТЬ ВТ_предКоды
				   |ИЗ
				   |	РегистрСведений.ИндНомер КАК ИндНомер
				   |ГДЕ
				   |	ИндНомер.Поддон.Наименование = &Наименование
				   |
				   |ОБЪЕДИНИТЬ ВСЕ
				   |
				   |ВЫБРАТЬ
				   |	ИндНомер.индкод
				   |ИЗ
				   |	РегистрСведений.ИндНомер КАК ИндНомер
				   |ГДЕ
				   |	ИндНомер.Стеллаж.Наименование = &Наименование
				   |
				   |ОБЪЕДИНИТЬ ВСЕ
				   |
				   |ВЫБРАТЬ
				   |	ИндНомер.индкод
				   |ИЗ
				   |	РегистрСведений.ИндНомер КАК ИндНомер
				   |ГДЕ
				   |	ИндНомер.индкод.Наименование = &Наименование
				   |
				   |ОБЪЕДИНИТЬ ВСЕ
				   |
				   |ВЫБРАТЬ
				   |	ИндНомер.индкод
				   |ИЗ
				   |	РегистрСведений.ИндНомер КАК ИндНомер
				   |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Номенклатура КАК ВТ_Номенклатура
				   |		ПО ИндНомер.индкод.Владелец = ВТ_Номенклатура.Ссылка
				   |;
				   |
				   |////////////////////////////////////////////////////////////////////////////////
				   |ВЫБРАТЬ
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
				   |	РегистрНакопления1Остатки.Склад.Город КАК Город
				   |ПОМЕСТИТЬ ВТ_данныеНоменклатур
				   |ИЗ
				   |	ВТ_предКоды КАК ИндНомер
				   |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.РегистрНакопления1.Остатки КАК РегистрНакопления1Остатки
				   |		ПО ИндНомер.индкод = РегистрНакопления1Остатки.индкод
				   |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ИндНомер КАК РегИндНомер
				   |		ПО ИндНомер.индкод = РегИндНомер.индкод
				   |ГДЕ
				   |	РегистрНакопления1Остатки.КолвоОстаток > 0
				   |;
				   |
				   |////////////////////////////////////////////////////////////////////////////////
				   |ВЫБРАТЬ ПЕРВЫЕ 1
				   |	ВТ_данныеНоменклатур.Адрес КАК Адрес,
				   |	ВТ_данныеНоменклатур.Склад КАК Склад,
				   |	ВТ_данныеНоменклатур.Город КАК Город,
				   |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВТ_данныеНоменклатур.индкод) КАК Количество,
				   |	ВТ_данныеНоменклатур.Поддон КАК Поддон
				   |ИЗ
				   |	ВТ_данныеНоменклатур КАК ВТ_данныеНоменклатур
				   |СГРУППИРОВАТЬ ПО
				   |	ВТ_данныеНоменклатур.Адрес,
				   |	ВТ_данныеНоменклатур.Склад,
				   |	ВТ_данныеНоменклатур.Город,
				   |	ВТ_данныеНоменклатур.Поддон
				   |
				   |УПОРЯДОЧИТЬ ПО
				   |	Количество УБЫВ";
	Возврат Текстзапроса;

/// МазинЕС-06-12-20-24
КонецФункции

Функция ПолучитьДанныеОТовареGetProduct(Партия)
/// МазинЕС-06-12-20-24

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПродажаЗапчастейТаблица.Товар КАК Товар,
	|	ПродажаЗапчастейТаблица.Партия КАК Партия,
	|	ПродажаЗапчастейТаблица.Ссылка КАК Ссылка,
	|	ПродажаЗапчастейТаблица.СтатусТовара КАК СтатусТовара,
	|	ПродажаЗапчастей.ЗаказКлиента.Номер КАК ЗаказКлиентаНомер
	|ИЗ
	|	Документ.ПродажаЗапчастей.Таблица КАК ПродажаЗапчастейТаблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПродажаЗапчастей КАК ПродажаЗапчастей
	|		ПО ПродажаЗапчастейТаблица.Ссылка = ПродажаЗапчастей.Ссылка
	|ГДЕ
	|	ПродажаЗапчастейТаблица.Партия.Наименование = &Наименование";

	Запрос.УстановитьПараметр("Наименование", Партия);

	РезультатЗапроса = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();


	Структура = Новый Структура;

	Если РезультатЗапроса.Пустой() Тогда
		Структура.Вставить("Продан", "");
		Структура.Вставить("Выдан", "");
		Структура.Вставить("ЗаказКлиентаНомер", "");
	КонецЕсли;

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Структура.Вставить("Продан", "В продаже");
		Структура.Вставить("ЗаказКлиентаНомер", ВыборкаДетальныеЗаписи.ЗаказКлиентаНомер);
		Если ВыборкаДетальныеЗаписи.СтатусТовара Тогда
			Структура.Вставить("Выдан", "Выдан");
		Иначе
			Структура.Вставить("Выдан", "На складе");
		КонецЕсли;
	КонецЦикла;

	Возврат Структура;
	 
/// МазинЕС-06-12-20-24	
КонецФункции

Функция СформироватьСтруктуруОшибкиGetProduct(Message, Details)
/// МазинЕС-06-12-20-24
	СтруктураОтвета = Новый Структура;
	СтруктураОтвета.Вставить("message", Message);
	СтруктураОтвета.Вставить("details", Details);

	Возврат СтруктураОтвета;
/// МазинЕС-06-12-20-24
КонецФункции

Функция ПроверитьНаличиеТовараGETCheckTheProduct(Запрос)
/// МазинЕС-06-12-20-24	

	Партия = Строка(Запрос.ПараметрыURL["id"]); 
	МестоХранения = Число(Запрос.ПараметрыURL["place"]);
	СправочникИндНомер = Справочники.ИндКод.НайтиПоНаименованию(Партия); 	
	
		Если МестоХранения = 0  Тогда
		
			НаборЗаписей = РегистрыСведений.ИндНомер.СоздатьНаборЗаписей(); 
			НаборЗаписей.Отбор.индкод.Установить(СправочникИндНомер); 
			НаборЗаписей.Прочитать();
			
			Для Каждого Запись Из НаборЗаписей Цикл 
		    	
		    	Запись.ДатаПроверкиЕстьВНаличии = ТекущаяДата(); 
		    	
			КонецЦикла; 
			
			Попытка
				НаборЗаписей.Записать();
				СтруктураОтвета = НОвый Структура();
				СтруктураОтвета.Вставить("Ответ","Все гуд!");
				
				ЗаписьJSON = Новый ЗаписьJSON;
				ЗаписьJSON.УстановитьСтроку();
				ЗаписатьJSON(ЗаписьJSON, СтруктураОтвета.Ответ);
				СтрокаДляОтвета = ЗаписьJSON.Закрыть();
				Ответ = Новый HTTPСервисОтвет(200);
				Ответ.Заголовки.Вставить("Content-type", "application/json;  charset=utf-8");
				Ответ.УстановитьТелоИзСтроки(СтрокаДляОтвета, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);
				
				Возврат Ответ;
			Исключение
				ЗаписьJSON = Новый ЗаписьJSON;
				ЗаписьJSON.УстановитьСтроку();
				ЗаписатьJSON(ЗаписьJSON, СформироватьСтруктуруОшибкиGetProduct("Не удалось проставить отметку ""Товар найден""",
					""));
				СтрокаДляОтвета = ЗаписьJSON.Закрыть();
				Ответ = Новый HTTPСервисОтвет(500);
				Ответ.Заголовки.Вставить("Content-type", "application/json;  charset=utf-8");
				Ответ.УстановитьТелоИзСтроки( СтрокаДляОтвета);
				Возврат Ответ;
			КонецПопытки;
		Иначе 
			Попытка 
				СтруктураОтвета = НОвый Структура();
				
				Запрос = Новый Запрос;
				Запрос.Текст =
					"ВЫБРАТЬ
					|	ИндНомер.Стеллаж КАК Стелаж
					|ИЗ
					|	РегистрСведений.ИндНомер КАК ИндНомер
					|ГДЕ
					|	ИндНомер.индкод = &индкод";
				
				Запрос.УстановитьПараметр("индкод",СправочникИндНомер);
				
				РезультатЗапроса = Запрос.Выполнить();
				
				Если РезультатЗапроса.Пустой() ТОгда 
					ЗаписьJSON = Новый ЗаписьJSON;
					ЗаписьJSON.УстановитьСтроку();
					ЗаписатьJSON(ЗаписьJSON, СформироватьСтруктуруОшибкиGetProduct("Не удалось найти место хранения товара",
						""));
					СтрокаДляОтвета = ЗаписьJSON.Закрыть();
					Ответ = Новый HTTPСервисОтвет(500);
					Ответ.Заголовки.Вставить("Content-type", "application/json;  charset=utf-8");
					Ответ.УстановитьТелоИзСтроки( СтрокаДляОтвета);
					Возврат Ответ;	
				КонецЕсли; 
				
				ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
			
				
				Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
					СтруктураОтвета.Вставить("place",Строка(ВыборкаДетальныеЗаписи.Стелаж));
				КонецЦикла;
				
				ЗаписьJSON = Новый ЗаписьJSON;
				ЗаписьJSON.УстановитьСтроку();
				ЗаписатьJSON(ЗаписьJSON, СтруктураОтвета);
				СтрокаДляОтвета = ЗаписьJSON.Закрыть();
				Ответ = Новый HTTPСервисОтвет(200);
				Ответ.Заголовки.Вставить("Content-type", "application/json;  charset=utf-8");
				Ответ.УстановитьТелоИзСтроки(СтрокаДляОтвета, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);
				Возврат Ответ;
			Исключение
				ЗаписьJSON = Новый ЗаписьJSON;
				ЗаписьJSON.УстановитьСтроку();
				ЗаписатьJSON(ЗаписьJSON, СформироватьСтруктуруОшибкиGetProduct("Не удалось найти место хранения товара",
					""));
				СтрокаДляОтвета = ЗаписьJSON.Закрыть();
				Ответ = Новый HTTPСервисОтвет(500);
				Ответ.Заголовки.Вставить("Content-type", "application/json;  charset=utf-8");
				Ответ.УстановитьТелоИзСтроки( СтрокаДляОтвета);
				Возврат Ответ;
			КонецПопытки;	
		
		КонецЕсли; 
/// МазинЕС-06-12-20-24	
КонецФункции

Функция ПолучитьКатегорииТовараgetproductcategories(Запрос)
	
	///+ТатарМА 06.12.2024
	Попытка
		ЗапросКатегории = Новый Запрос;
		ЗапросКатегории.Текст = "ВЫБРАТЬ
		|	Категории.Ссылка КАК Категория,
		|	Категории.Код КАК Код
		|ИЗ
		|	Справочник.Категории КАК Категории
		|ГДЕ
		|	Категории.Родитель = ЗНАЧЕНИЕ(Справочник.Категории.ПустаяСсылка)";

		РезультатТЗ = ЗапросКатегории.Выполнить().Выгрузить();

		МассивКатегорий = Новый Массив;
		Для Каждого Результат Из РезультатТЗ Цикл
			СтруктураКатегорий = Новый Структура;
			СтруктураКатегорий.Вставить("name", Строка(Результат.Категория));
			СтруктураКатегорий.Вставить("id", Результат.Код);
			МассивКатегорий.Добавить(СтруктураКатегорий);
		КонецЦикла;

		СтруктураИнфо= Новый Структура;
		СтруктураИнфо.Вставить("cities", МассивКатегорий);

		Ответ = Новый HTTPСервисОтвет(200);
		Ответ.Заголовки.Вставить("Content-type", "application/json;  charset=utf-8");
		ЗаписьJSON = Новый ЗаписьJSON;
		ЗаписьJSON.УстановитьСтроку();
		ЗаписатьJSON(ЗаписьJSON, СтруктураИнфо);
		СтрокаДляОтвета = ЗаписьJSON.Закрыть();
		Ответ.УстановитьТелоИзСтроки(СтрокаДляОтвета);

		Возврат Ответ;
	Исключение
		Ответ = Новый HTTPСервисОтвет(500);
		Ответ.Заголовки.Вставить("Content-type", "application/json;  charset=utf-8");
		//Информация = ИнформацияОбОшибке();
		ЗаписьJSON = Новый ЗаписьJSON;
		ЗаписьJSON.УстановитьСтроку();
		ЗаписатьJSON(ЗаписьJSON, "Не удалось получить список категорий!");
		СтрокаДляОтвета = ЗаписьJSON.Закрыть();
		Ответ.УстановитьТелоИзСтроки(СтрокаДляОтвета);
		Возврат Ответ;
	КонецПопытки;
	///-ТатарМА 06.12.2024
КонецФункции

Функция ПолучитьТоварыПоКатегорииgetproductbycategories(Запрос)
	
	///+ТатарМА 06.12.2024
	ЗапросТовара = Новый Запрос;
	Текстзапроса = "ВЫБРАТЬ ПЕРВЫЕ 10000
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
	|	РегистрНакопления1Остатки.машина.Год КАК машинаГод,
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
	|			ПО (РегИндНомер.индкод = РегистрНакопления1Остатки.индкод)
	|		ПО (ИндНомер.Ссылка = РегИндНомер.индкод.Владелец)
	|ГДЕ
	|	РегистрНакопления1Остатки.КолвоОстаток > 0
	|	И РегИндНомер.АвитоЧастник
	|	И РегИндНомер.индкод.Владелец.Подкатегория2 В ИЕРАРХИИ (&Категория)
	|	И РАЗНОСТЬДАТ(РегИндНомер.ДатаПроверкиЕстьВНаличии, &ТекДата, ДЕНЬ) <= 30
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

	Категория = Справочники.Категории.НайтиПоКоду(Запрос.ПараметрыURL["categories"]);
	
	запросТовара.Текст =   СтрШаблон(Текстзапроса, Формат(10000, "ЧГ=")); 


	запросТовара.УстановитьПараметр("Категория", Категория);
	запросТовара.УстановитьПараметр("НачинаяСЗаписи", 0);
	ЗапросТовара.УстановитьПараметр("ТекДата", ТекущаяДатаСеанса());
	
	Выборкаобщ = запросТовара.Выполнить().Выбрать().Количество();

	запросТовара.Текст =  СтрШаблон(Текстзапроса, Формат(?(Число(Запрос.ПараметрыURL["count"]) > 0,
	Запрос.ПараметрыURL["count"], 10000), "ЧГ=")); 

	запросТовара.УстановитьПараметр("Категория", Категория);

	запросТовара.УстановитьПараметр("НачинаяСЗаписи", 0);

	Если Число(((Запрос.ПараметрыURL["count"]) * (Запрос.ПараметрыURL["page"]))) > 0 И Число(
		Запрос.ПараметрыURL["page"]) > 1 Тогда
		запросТовара.УстановитьПараметр("НачинаяСЗаписи", Число(((Запрос.ПараметрыURL["count"])
			* ((Запрос.ПараметрыURL["page"]) - 1) + 1)));
	Иначе
		запросТовара.УстановитьПараметр("НачинаяСЗаписи", 0);
	КонецЕсли;
	
	ТЗ_Товары = запросТовара.Выполнить().Выгрузить();
//	ТЗ_Товары.Колонки.Добавить("колФото", Новый ОписаниеТипов("Число"));
//	ТЗ_Товары.Колонки.Добавить("Фото", Новый ОписаниеТипов("Массив"));
	МассивТоваров = Новый Массив;

	//ИндКоды = ТЗ_Товары.ВыгрузитьКолонку("индкод");
	//Фотки = РаботаССайтомWT.ПолучениеФото(ИндКоды);
	//Итер = 0;

	Для Каждого стр Из ТЗ_Товары Цикл
//		НайденныеФотки = Новый Массив;
//		//ПутьКФайлам = "W:\code\imageService\images\" + стр.индкод;
//		НайденныеФотки = Фотки[итер].urls;
//		МассивФото = Новый массив;
//		Если НайденныеФотки <> Неопределено И НайденныеФотки.Количество() > 0 Тогда
//
//			стр.колфото = 1;
//
//			Для Каждого Фотка Из НайденныеФотки Цикл
//				Текст = "";
//				//Текст = "https://wt10.ru" + Фотка; 
//				Текст = Фотка;
//				МассивФото.Добавить(Текст);
//			КонецЦикла;
//		КонецЕсли;
//		Итер = итер + 1;
//		ТЗ_Товары.Сортировать("колФото Убыв");

		СтруктураТоваров = Новый Структура;
		СтруктураТоваров.Вставить("name", Строка(стр.Наименование));
		СтруктураТоваров.Вставить("article", Строка(стр.Артикул));
		СтруктураТоваров.Вставить("price", стр.Цена);
		СтруктураТоваров.Вставить("comment", Строка(стр.Комментарий));
		СтруктураТоваров.Вставить("shelf", Строка(стр.Адрес));
		СтруктураТоваров.Вставить("sklad", Строка(стр.Склад));
		СтруктураТоваров.Вставить("code", Строка(стр.Код));
		СтруктураТоваров.Вставить("categories", Строка(стр.Подкатегория2));
		//СтруктураТоваров.Вставить("type", "PRODUCT");

		СтруктураТоваров.Вставить("city", Строка(стр.Город));

		СтруктураТоваров.Вставить("id", Строка(стр.индкод));
		СтруктураТоваров.Вставить("poddon", Строка(стр.Поддон));
		СтруктураТоваров.Вставить("yearcar", число(стр.машинаГод));
		//СтруктураТоваров.Вставить("photos", МассивФото);
		МассивТоваров.Добавить(СтруктураТоваров);
	КонецЦикла;
	Итог = Выборкаобщ / ?(Число(Запрос.ПараметрыURL["count"]) = 0, Выборкаобщ, Число(Запрос.ПараметрыURL["count"]));
	Итог = ?((Итог - Цел(Итог)) > 0, Цел(Итог) + 1, Цел(Итог));

	СтруктураИнфо= Новый Структура;
	СтруктураИнфо.Вставить("pages", Итог);
	СтруктураИнфо.Вставить("count", Выборкаобщ);

	СтруктураОтвета = Новый Структура;
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
	///-ТатарМА 06.12.2024
	
КонецФункции
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти