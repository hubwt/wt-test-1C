#Область ОбработчикиСобытий
Функция ПолучитьТоварыПоИндКодамGetProductsByIds(Запрос)
	///+ГомзМА 04.07.2024
	Тело = Запрос.ПолучитьТелоКакстроку();
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(Тело);

	Массив = ПрочитатьJSON(ЧтениеJSON);

	Индкода = Массив.ids;
	МассивИнфо = Новый Массив;

	Для Каждого Индкод Из Индкода Цикл
		Если стрНайти(Индкод, "_") <> 0 Тогда
			запросТовара = Новый Запрос;
			запросТовара.Текст =  СтрШаблон(текстДляТовара(), Формат(10000, "ЧГ="));

			запросТовара.УстановитьПараметр("Наименование", Строка(Индкод));
			запросТовара.УстановитьПараметр("НачинаяСЗаписи", 0);
	
		//@skip-check query-in-loop
			ТЗ = запросТовара.Выполнить().Выгрузить();
			ТЗ.Колонки.Добавить("колФото", Новый ОписаниеТипов("Число"));
			ТЗ.Колонки.Добавить("Фото", Новый ОписаниеТипов("Массив"));
			ИндКоды = тз.ВыгрузитьКолонку("индкод");
			Фотки = РаботаССайтомWT.ПолучениеФото(ИндКоды);
			итер = 0;

			Для Каждого стр Из ТЗ Цикл
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
				тз.Сортировать("колФото Убыв");

				СтруктураТоваров = Новый Структура;
				СтруктураТоваров.Вставить("name", Строка(стр.Наименование));
				СтруктураТоваров.Вставить("article", Строка(стр.Артикул));
				СтруктураТоваров.Вставить("price", стр.Цена);
				СтруктураТоваров.Вставить("comment", Строка(стр.Комментарий));
				СтруктураТоваров.Вставить("shelf", Строка(стр.Адрес));
				Попытка
					СтруктураТоваров.Вставить("yearcar", Число(стр.машинаГод));
				Исключение
					СтруктураТоваров.Вставить("yearcar", Число(0));
				КонецПопытки;
				СтруктураТоваров.Вставить("code", Строка(стр.Код));
				СтруктураТоваров.Вставить("id", Строка(стр.индкод));
				СтруктураТоваров.Вставить("poddon", Строка(стр.Поддон));

				СтруктураТоваров.Вставить("photos", МассивФото);

				МассивИнфо.Добавить(СтруктураТоваров);
			КонецЦикла;

		Иначе
			ОбъектНоменклатуры = Справочники.Номенклатура.НайтиПоКоду(Индкод).ПолучитьОбъект();
			СтруктураТоваров = Новый Структура;
			СтруктураТоваров.Вставить("name", Строка(ОбъектНоменклатуры.Наименование));
			СтруктураТоваров.Вставить("article", Строка(ОбъектНоменклатуры.Артикул));
			СтруктураТоваров.Вставить("price", ОбъектНоменклатуры.РекомендованаяЦена);
			СтруктураТоваров.Вставить("comment", Строка(ОбъектНоменклатуры.Комментарий));
			СтруктураТоваров.Вставить("shelf", Строка(ОбъектНоменклатуры.МестоНаСкладе2));
			СтруктураТоваров.Вставить("code", Строка(ОбъектНоменклатуры.Код));
			СтруктураТоваров.Вставить("type", "CARD_PRODUCT");
			Попытка
				//@skip-check query-in-loop
				Кодноменк = ПолучитьКоличествоУчтенногоТовара(ОбъектНоменклатуры.Код);

				СтруктураТоваров.Вставить("count_registered", Число(Кодноменк));
			Исключение
				СтруктураТоваров.Вставить("count_registered", Число(0));
			КонецПопытки;
			СтруктураТоваров.Вставить("id", Строка(ОбъектНоменклатуры.Код));
			СтруктураТоваров.Вставить("poddon", "");

			СтруктураТоваров.Вставить("photos", МассивФото);

			Код = ОбъектНоменклатуры.Код;
			ИндКоды =  Новый массив;
			ИндКоды.Добавить(Код);

			Попытка
				Попытка
					Фотки = РаботаССайтомWT.ПолучениеФотокарточек(ИндКоды);
					НайденныеФотки = Фотки[0].images.common;
					Если Фотки[0].images.main <> "" Тогда
						НайденныеФотки.Вставить(0, Фотки[0].images.main);
					КонецЕсли;
				Исключение
					НайденныеФотки = Новый Массив;
				КонецПопытки;
				МассивФото = Новый массив;

				Текст = НайденныеФотки;
				Если НайденныеФотки <> Неопределено И НайденныеФотки <> "" Тогда
					Для Каждого Фотка Из НайденныеФотки Цикл
						Текст = "";

						Текст = Фотка;
						МассивФото.Добавить(Текст);
					КонецЦикла;
				КонецЕсли;

			Исключение
				МассивФото.Добавить("");
			КонецПопытки;

			СтруктураТоваров.Вставить("photos", НайденныеФотки);

			МассивИнфо.Добавить(СтруктураТоваров);
		КонецЕсли;

	КонецЦикла;

	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();

	ЗаписатьJSON(ЗаписьJSON, МассивИнфо);

	СтрокаДляОтвета = ЗаписьJSON.Закрыть();

	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.Заголовки.Вставить("Content-Type", "application/json; charset=utf-8");
	Ответ.УстановитьТелоИзСтроки(СтрокаДляОтвета);

	Возврат Ответ;
	///-ГомзМА 04.07.2024
КонецФункции
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьКоличествоУчтенногоТовара(Код)

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СУММА(ЕСТЬNULL(РегистрНакопления1Остатки.КолвоОстаток, 0)) КАК КолвоОстаток
	|ИЗ
	|	РегистрНакопления.РегистрНакопления1.Остатки КАК РегистрНакопления1Остатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИндНомер КАК ИндНомер
	|		ПО РегистрНакопления1Остатки.индкод = ИндНомер.индкод
	|ГДЕ
	|	ИндНомер.АвитоЧастник
	|	и РегистрНакопления1Остатки.Товар.Код = &Код
	|СГРУППИРОВАТЬ ПО
	|	РегистрНакопления1Остатки.Товар";

	Запрос.УстановитьПараметр("Код", Код);

	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат 0;
	КонецЕсли;
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();

	Возврат Выборка.КолвоОстаток;
КонецФункции

Функция текстДляТовара()
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
КонецФункции
#КонецОбласти