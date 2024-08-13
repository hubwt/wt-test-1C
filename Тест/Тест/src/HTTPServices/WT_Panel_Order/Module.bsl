#Область ОбработчикиСобытий
Функция ПолучитьСписокНарядовgetlistorders(Запрос)
	ЗапросНарядов = Новый Запрос;

	ЗапросНарядов.Текст =  СтрШаблон(текстДляСпискаНарядов(), Формат(10000, "ЧГ="));

//	Если Строка(Запрос.ПараметрыURL["type"]) = "1" Тогда
//		ЗапросНарядов.Текст = СтрЗаменить(ЗапросНарядов.Текст, "&Фильтр", "Где ВТ_Выдача.КоличествоСтрок > 0");
//	Иначе
//		ЗапросНарядов.Текст = СтрЗаменить(ЗапросНарядов.Текст, "&Фильтр", "Где ВТ_Сборка.КоличествоСтрок > 0");
//
//	КонецЕсли;

	ЗапросНарядов.УстановитьПараметр("НачинаяСЗаписи", 0);
	Выборкаобщ = ЗапросНарядов.Выполнить().Выбрать().Количество();

	ЗапросНарядов.Текст =  СтрШаблон(текстДляСпискаНарядов(), Формат(?(Число(Запрос.ПараметрыURL["count"]) > 0,
		Запрос.ПараметрыURL["count"], 10000), "ЧГ="));
//	Если Строка(Запрос.ПараметрыURL["type"]) = "1" Тогда
//		ЗапросНарядов.Текст = СтрЗаменить(ЗапросНарядов.Текст, "&Фильтр", "Где ВТ_Выдача.КоличествоСтрок > 0");
//	Иначе
//		ЗапросНарядов.Текст = СтрЗаменить(ЗапросНарядов.Текст, "&Фильтр", "Где ВТ_Сборка.КоличествоСтрок > 0");
//
//	КонецЕсли;

	Если Число(((Запрос.ПараметрыURL["count"]) * (Запрос.ПараметрыURL["page"]))) > 0 И Число(
		Запрос.ПараметрыURL["page"]) > 1 Тогда
		ЗапросНарядов.УстановитьПараметр("НачинаяСЗаписи", Число(((Запрос.ПараметрыURL["count"])
			* (Запрос.ПараметрыURL["page"] - 1) + 1)));
	Иначе
		ЗапросНарядов.УстановитьПараметр("НачинаяСЗаписи", 0);
	КонецЕсли;

	Выборка = ЗапросНарядов.Выполнить().Выбрать();

	МассивНарядов = Новый Массив;
	Пока выборка.Следующий() Цикл
		СтруктураИнфо = Новый Структура;
		СтруктураИнфо.Вставить("num", Строка(выборка.Номер));
		СтруктураИнфо.Вставить("date", Строка(выборка.Дата));
		СтруктураИнфо.Вставить("client", Строка(выборка.Клиент));
		СтруктураИнфо.Вставить("application", Строка(выборка.ЗаказКлиента));
		СтруктураИнфо.Вставить("processing", Строка(выборка.состояние));
		//СтруктураИнфо.Вставить("status",Строка(Выборка.СтатусЗаказаВТК)); 
		//СтруктураИнфо.Вставить("client_phone",Строка(Выборка.КлиентТелефон));                                      
		//СтруктураИнфо.Вставить("storekeeper",Строка(выборка.ОтветственныйКладовщик));
		СтруктураИнфо.Вставить("responsible", Строка(выборка.Ответственный));
		СтруктураИнфо.Вставить("comment", Строка(выборка.Комментарий));
		//@skip-check query-in-loop
		МассивТоваров = РаботаССайтомWT.ПолучитьСтруктуруТоваров(выборка.Номер);
		СтруктураИнфо.Вставить("state_product", МассивТоваров);

		МассивНарядов.Добавить(СтруктураИнфо);

	КонецЦикла;
	
	///+ГомзМА 16.04.2024
	Страница = Выборкаобщ / ?(Число(Запрос.ПараметрыURL["count"]) = 0, Выборкаобщ, Число(Запрос.ПараметрыURL["count"]));
	Страница = ?((Страница - Цел(Страница)) > 0, Цел(Страница) + 1, Цел(Страница));
	///-ГомзМА 16.04.2024

	СтруктураИнфо= Новый Структура;
	СтруктураИнфо.Вставить("pages", Страница);
	СтруктураИнфо.Вставить("count", Выборкаобщ);

	СтруктураОтвета = Новый Структура;
	СтруктураОтвета.Вставить("info", СтруктураИнфо);
	СтруктураОтвета.Вставить("data", МассивНарядов);
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();

	ЗаписатьJSON(ЗаписьJSON, СтруктураОтвета);

	СтрокаДляОтвета = ЗаписьJSON.Закрыть();

	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.Заголовки.Вставить("Content-type", "application/json;  charset=utf-8");

	Ответ.УстановитьТелоИзСтроки(СтрокаДляОтвета, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);

	Возврат Ответ;
КонецФункции

Функция ПолучитьЗаказНарядgetorder(Запрос)
	Запросзаявки = Новый Запрос;
	Запросзаявки.Текст = текстДляЗаказНаряда2();
	Запросзаявки.УстановитьПараметр("Номер", Запрос.ПараметрыURL["id"]);
	Выборка = Запросзаявки.Выполнить().Выбрать();
	МассивТоваров = Новый Массив;
	Выборка.Следующий();
		СтруктураИнфо = Новый Структура;
		СтруктураИнфо.Вставить("num", Строка(выборка.Номер));
		СтруктураИнфо.Вставить("date", Строка(выборка.Дата));
		СтруктураИнфо.Вставить("client", Строка(выборка.Клиент));
		СтруктураИнфо.Вставить("application", Строка(выборка.ЗаказКлиента));
		СтруктураИнфо.Вставить("processing", Строка(выборка.состояние));
		//СтруктураИнфо.Вставить("status",Строка(Выборка.СтатусЗаказаВТК)); 
		//СтруктураИнфо.Вставить("client_phone",Строка(Выборка.КлиентТелефон));                                      
		//СтруктураИнфо.Вставить("storekeeper",Строка(выборка.ОтветственныйКладовщик));
		СтруктураИнфо.Вставить("responsible", Строка(выборка.Ответственный));
		//СтруктураИнфо.Вставить("sum",Строка(выборка.ИтогоРекв));
		//@skip-check query-in-loop
		МассивТоваров = РаботаССайтомWT.ПолучитьСтруктуруТоваров(выборка.Номер);
		СтруктураИнфо.Вставить("state_product", МассивТоваров); 
		//	ВыборкаТоваров = выборка.Таблица.Выбрать();
		ТЗ_Товары = выборка.Таблица.Выгрузить();
//		Массивкодов = ТЗ_Товары.ВыгрузитьКолонку("Партия");
		ТЗ_Товары.Колонки.Добавить("колФото", Новый ОписаниеТипов("Число"));
		ТЗ_Товары.Колонки.Добавить("Фото", Новый ОписаниеТипов("Массив"));
		МассивТоваров = Новый Массив;

		ИндКоды = ТЗ_Товары.ВыгрузитьКолонку("Партия2");
		Фотки = РаботаССайтомWT.ПолучениеФото(ИндКоды);
		Итер = 0;
		Для Каждого стр Из ТЗ_Товары Цикл

			Если стр.Состояние = Перечисления.СтатусыТовараВЗаказНаряде.Срочно Или стр.Состояние
				= Перечисления.СтатусыТовараВЗаказНаряде.Планово Или стр.Состояние
				= Перечисления.СтатусыТовараВЗаказНаряде.Собрано Или стр.Состояние
				= Перечисления.СтатусыТовараВЗаказНаряде.Выдано Или стр.Состояние
				= Перечисления.СтатусыТовараВЗаказНаряде.Установлена Или стр.Состояние
				= Перечисления.СтатусыТовараВЗаказНаряде.НетВНаличии Тогда
				МассивФото = Новый массив;

				НайденныеФотки = Новый Массив;
				НайденныеФотки = Фотки[Итер].urls;
				МассивФото = Новый массив;
				Если НайденныеФотки <> Неопределено И НайденныеФотки.Количество() > 0 Тогда

					стр.колфото = 1;

					Для Каждого Фотка Из НайденныеФотки Цикл
						Текст = "";
						Текст = Фотка;
						МассивФото.Добавить(Текст);
					КонецЦикла;
				КонецЕсли;
				//Итер = Итер+1;

				Код = стр.Код;
				Пока Лев(Код, 1) = "0" Цикл
					Код = Прав(Код, СтрДлина(Код) - 1);
				КонецЦикла;
				СтруктураТоваров = Новый Структура;
				СтруктураТоваров.Вставить("name", Строка(стр.Товар));
				СтруктураТоваров.Вставить("position", Строка(стр.НомерСтроки));
				СтруктураТоваров.Вставить("cost", Строка(стр.Цена));
				СтруктураТоваров.Вставить("count", Строка(стр.Количество));
				СтруктураТоваров.Вставить("sum", Строка(стр.Сумма));
				СтруктураТоваров.Вставить("issued", Строка(стр.Состояние));
				СтруктураТоваров.Вставить("Code", Строка("00" + Код));
				СтруктураТоваров.Вставить("id", Строка(стр.Партия));
	 
				СтруктураТоваров.Вставить("sklad", Строка(стр.Склад));
				СтруктураТоваров.Вставить("photos", МассивФото);
				СтруктураТоваров.Вставить("state", Строка(стр.Состояние));
				СтруктураТоваров.Вставить("article", Строка(стр.Артикул));
				//СтруктураТоваров.Вставить("k", РаботаССайтомWT.ЕстьНаКСкладе(стр.Товар)); 
				//СтруктураТоваров.Вставить("rvr", РаботаССайтомWT.ЕстьНаПолкеРВРВ(стр.Товар));
				//СтруктураТоваров.Вставить("poddon", Строка(РаботаССайтомWT.ПолучитьПоддон(стр.Партия)));
				//СтруктураТоваров.Вставить("place", Строка(РаботаССайтомWT.ПолучитьМесто(стр.Партия)));
				МассивТоваров.Добавить(СтруктураТоваров);
			КонецЕсли;
			итер = итер + 1;
		КонецЦикла;
		ТЗ_Работы = выборка.Работы.Выгрузить();
		МассивРабот = Новый Массив;
		Для Каждого стр Из ТЗ_Работы Цикл
//			Строка = "		Ссылка,
//					 |		НомерСтроки,
//					 |		Работа,
//					 |		Количество,
//					 |		Нормочас,
//					 |		Цена,
//					 |		Сумма,
//					 |		СкидкаПроцент,
//					 |		СкидкаСумма,
//					 |		СуммаВсего,
//					 |		Содержание,
//					 |		ИдентификаторСтроки,
//					 |		ВремяФакт,
//					 |		ВремяПлан,
//					 |		СуммаНалог,
//					 |		СуммаЗп,
//					 |		ИдентификаторСтрока,
//					 |		СтатусРаботы)";

			СтруктураРаботы = Новый Структура;
			СтруктураРаботы.Вставить("name", Строка(стр.Работа));
			СтруктураРаботы.Вставить("position", Строка(стр.НомерСтроки));
			СтруктураРаботы.Вставить("cost", Строка(стр.Цена));
			СтруктураРаботы.Вставить("count", Строка(стр.Количество));
			СтруктураРаботы.Вставить("sum", Строка(стр.Сумма));
			СтруктураРаботы.Вставить("issued", Строка(стр.СтатусРаботы));
			МассивРабот.Добавить(СтруктураРаботы);
		КонецЦикла;
	

	СтруктураОтвета = Новый Структура;
	СтруктураОтвета.Вставить("info", СтруктураИнфо);
	СтруктураОтвета.Вставить("data", МассивТоваров);
	СтруктураОтвета.Вставить("works", МассивРабот);
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();

	ЗаписатьJSON(ЗаписьJSON, СтруктураОтвета);

	СтрокаДляОтвета = ЗаписьJSON.Закрыть();

	Ответ = Новый HTTPСервисОтвет(200);
	Ответ.Заголовки.Вставить("Content-type", "application/json;  charset=utf-8");

	Ответ.УстановитьТелоИзСтроки(СтрокаДляОтвета, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);

	Возврат Ответ;
КонецФункции

Функция НаполнитьЗаказНарядfillingorder(Запрос)
	Запросзаявки = Новый Запрос;
	Запросзаявки.Текст = текстДляЗаказНаряда2();
	Запросзаявки.УстановитьПараметр("Номер", Запрос.ПараметрыURL["id"]);
	Выборка = Запросзаявки.Выполнить().Выбрать();
	Тело = Запрос.ПолучитьТелоКакстроку();
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(Тело);

	Массив  = ПрочитатьJSON(ЧтениеJSON);
	ИндКод  = Массив.id;
	//Позиция = Число(Массив.pose);
	Автор 	= Массив.person;
	Партия = Справочники.ИндКод.НайтиПоНаименованию(ИндКод);

	Номенклатура = Справочники.ИндКод.НайтиПоНаименованию(ИндКод).Владелец;
	Отбор = Новый Структура;
	Отбор.Вставить("Номенклатура", Номенклатура);
	Отбор.Вставить("Партия", Партия);

	Пока выборка.Следующий() Цикл
		Если выборка.Состояние = Перечисления.СостоянияЗаказНаряда.Выполнен Тогда
			Ответ = Новый HTTPСервисОтвет(400);
			Ответ.Заголовки.Вставить("Content-Type", "application/json; charset=utf-8");
			Ответ.УстановитьТелоИзСтроки("Наряд закрыт!");
			Возврат Ответ;

		КонецЕсли;

		ОбъектНаряда = Выборка.ссылка.ПолучитьОбъект();
		//ОбъектНаряда = Документы.ЗаказНаряд.СоздатьДокумент();   

		НайденныеСтроки = ОбъектНаряда.Товары.НайтиСтроки(Отбор);
		Если НайденныеСтроки.количество() > 0 Тогда
			СтрокаТЧ = ОбъектНаряда.Товары[НайденныеСтроки[0].НомерСтроки - 1];
			СтрокаТЧ.Партия = Партия; 
			//@skip-check query-in-loop
			СтрокаТЧ.Автомобиль = РаботаССайтомWT.ПолучитьМашину(Партия);
			СтрокаТЧ.Склад = Справочники.Склады.НайтиПоКоду("000000002");
			СтрокаТЧ.Состояние = Перечисления.СтатусыТовараВЗаказНаряде.Установлена;

			ТекстЛога =  " В заказ-наряде " + ОбъектНаряда.номер + " установил партию в товаре "
				+ СтрокаТЧ.Номенклатура + " " + СтрокаТЧ.Партия;
			РаботаССайтомWT.ЛогированиеWT10(Выборка.ссылка, Автор, ТекстЛога);
			ОбъектНаряда.Записать(РежимЗаписиДокумента.Проведение);

			Ответ = Новый HTTPСервисОтвет(200);
			Ответ.Заголовки.Вставить("Content-Type", "application/json; charset=utf-8");
			Ответ.УстановитьТелоИзСтроки("Успех");
			Возврат Ответ;
		Иначе

			Отбор = Новый Структура;
			Отбор.Вставить("Номенклатура", Номенклатура);
			Отбор.Вставить("Партия", Справочники.ИндКод.ПустаяСсылка());
			ОбъектНаряда = Выборка.ссылка.ПолучитьОбъект();
		//ОбъектНаряда = Документы.ЗаказНаряд.СоздатьДокумент();   

			НайденныеСтроки = ОбъектНаряда.Товары.НайтиСтроки(Отбор);
			Если НайденныеСтроки.количество() > 0 Тогда

				СтрокаТЧ = ОбъектНаряда.Товары[НайденныеСтроки[0].НомерСтроки - 1];
				СтрокаТЧ.Партия = Партия; 
			//@skip-check query-in-loop
				СтрокаТЧ.Автомобиль = РаботаССайтомWT.ПолучитьМашину(Партия);
				СтрокаТЧ.Склад = Справочники.Склады.НайтиПоКоду("000000002");
				СтрокаТЧ.Состояние = Перечисления.СтатусыТовараВЗаказНаряде.Установлена;

				ТекстЛога =  " В заказ-наряде " + ОбъектНаряда.номер + " установил партию в товаре "
					+ СтрокаТЧ.Номенклатура + " " + СтрокаТЧ.Партия;
				РаботаССайтомWT.ЛогированиеWT10(Выборка.ссылка, Автор, ТекстЛога);
				ОбъектНаряда.Записать(РежимЗаписиДокумента.Проведение);

				Ответ = Новый HTTPСервисОтвет(200);
				Ответ.Заголовки.Вставить("Content-Type", "application/json; charset=utf-8");
				Ответ.УстановитьТелоИзСтроки("Успех");
				Возврат Ответ;
			ИначеЕсли Не ОбъектНаряда.ЗаблокироватьТЧТовары Тогда
				Новаястрока = ОбъектНаряда.Товары.Добавить();
				Новаястрока.Партия = Партия;
				Новаястрока.Номенклатура = Номенклатура;
				Новаястрока.Количество = 1;
				//@skip-check query-in-loop
				Новаястрока.Автомобиль = РаботаССайтомWT.ПолучитьМашину(Партия);
				Новаястрока.Состояние = Перечисления.СтатусыТовараВЗаказНаряде.Установлена;
				//@skip-check reading-attribute-from-database
				Новаястрока.Цена = Партия.Владелец.РекомендованаяЦена;
				Новаястрока.Склад = Справочники.Склады.НайтиПоКоду("000000002");

				ТекстЛога =  " В заказ-наряде " + ОбъектНаряда.номер + " установил партию в товаре "
					+ Новаястрока.Номенклатура + " " + Новаястрока.Партия;
				РаботаССайтомWT.ЛогированиеWT10(Выборка.ссылка, Автор, ТекстЛога);
				ОбъектНаряда.Записать(РежимЗаписиДокумента.Проведение);

				Ответ = Новый HTTPСервисОтвет(200);
				Ответ.Заголовки.Вставить("Content-Type", "application/json; charset=utf-8");
				Ответ.УстановитьТелоИзСтроки("Успех");
				Возврат Ответ;

				//Ответ = Новый HTTPСервисОтвет(400);
				//Ответ.Заголовки.Вставить("Content-Type","application/json; charset=utf-8");
				//Ответ.УстановитьТелоИзСтроки("Заказ-наряд закрыт!");
				//Возврат Ответ;	
			КонецЕсли;
			Ответ = Новый HTTPСервисОтвет(400);
			Ответ.Заголовки.Вставить("Content-Type", "application/json; charset=utf-8");
			Ответ.УстановитьТелоИзСтроки("Такой позиции в заказ-наряде нет или партия уже установлена!");
			Возврат Ответ;
		КонецЕсли;

	КонецЦикла;
	Ответ = Новый HTTPСервисОтвет(400);
	Ответ.Заголовки.Вставить("Content-Type", "application/json; charset=utf-8");
	Ответ.УстановитьТелоИзСтроки("Не прокатило");
	Возврат Ответ;

КонецФункции

Функция СменаCтатусаТоваровВЗНchangestateorder(Запрос)
	Запросзаявки = Новый Запрос;
	Запросзаявки.Текст = текстДляЗаказНаряда2();
	Запросзаявки.УстановитьПараметр("Номер", Запрос.ПараметрыURL["id"]);
	Выборка = Запросзаявки.Выполнить().Выбрать();
	Тело = Запрос.ПолучитьТелоКакстроку();
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(Тело);

	Массив  = ПрочитатьJSON(ЧтениеJSON);
	Тип   = Массив.type;
	Позиция = Число(Массив.pose);
	Автор 	= Массив.author;
	//партия = Справочники.ИндКод.НайтиПоНаименованию(ИндКод);
	//
	//Номенклатура = Справочники.ИндКод.НайтиПоНаименованию(ИндКод).Владелец;
	//Отбор = Новый Структура();
	//Отбор.Вставить("Номенклатура", Номенклатура);
	//Отбор.Вставить("Партия", Справочники.ИндКод.ПустаяСсылка());

	Пока выборка.Следующий() Цикл
		Если выборка.Состояние = Перечисления.СостоянияЗаказНаряда.Выполнен Тогда
			Ответ = Новый HTTPСервисОтвет(400);
			Ответ.Заголовки.Вставить("Content-Type", "application/json; charset=utf-8");
			Ответ.УстановитьТелоИзСтроки("Наряд закрыт!");
			Возврат Ответ;

		КонецЕсли;

		ОбъектНаряда = Выборка.ссылка.ПолучитьОбъект();
		//ОбъектНаряда = Документы.ЗаказНаряд.СоздатьДокумент();   
		
		//НайденныеСтроки = ОбъектНаряда.Товары.НайтиСтроки(Отбор);
		//Если НайденныеСтроки.количество() > 0 Тогда
		Попытка
			СтрокаТЧ = ОбъектНаряда.Товары[Позиция - 1];  
			//СтрокаТЧ.партия = партия; 
			//СтрокаТЧ.Автомобиль = ПолучитьМашину(партия);
			СтрокаТЧ.Склад = Справочники.Склады.НайтиПоКоду("000000002");
			Если тип = 0 Тогда
				СтрокаТЧ.Состояние = Перечисления.СтатусыТовараВЗаказНаряде.НетВНаличии;
				ТекстЛога =  " В заказ-наряде " + ОбъектНаряда.номер + " сменил статус в товаре "
					+ СтрокаТЧ.Номенклатура + " " + СтрокаТЧ.Партия;
			ИначеЕсли тип = 1 Тогда
				СтрокаТЧ.Состояние = Перечисления.СтатусыТовараВЗаказНаряде.Установлена;
				ТекстЛога =  " В заказ-наряде " + ОбъектНаряда.номер + " сменил статус в товаре "
					+ СтрокаТЧ.Номенклатура + " " + СтрокаТЧ.Партия;

			КонецЕсли;

			РаботаССайтомWT.ЛогированиеWT10(Выборка.ссылка, Автор, ТекстЛога);
			ОбъектНаряда.Записать(РежимЗаписиДокумента.Проведение);

			Ответ = Новый HTTPСервисОтвет(200);
			Ответ.Заголовки.Вставить("Content-Type", "application/json; charset=utf-8");
			Ответ.УстановитьТелоИзСтроки("Успех");
			Возврат Ответ;
			//Иначе
		Исключение
			///Если  Не ОбъектНаряда.ЗаблокироватьТЧТовары Тогда
			//	
			//	Новаястрока = ОбъектНаряда.Товары.Добавить();
			//	Новаястрока.Партия = партия;
			//	Новаястрока.Номенклатура = Номенклатура; 
			//	Новаястрока.Количество = 1;
			//	Новаястрока.Автомобиль = ПолучитьМашину(партия);
			//	Новаястрока.Состояние = Перечисления.СтатусыТовараВЗаказНаряде.Выдано;
			//	Новаястрока.Цена = Справочники.ИндКод.НайтиПоНаименованию(ИндКод).Владелец.РекомендованаяЦена;
			//	Новаястрока.Склад = Справочники.Склады.НайтиПоКоду("000000002"); 	
			//	
			//	ТекстЛога =  " В заказ-наряде " + ОбъектНаряда.номер + " установил партию в товаре " + Новаястрока.Номенклатура + " "+ Новаястрока.Партия; 
			//	ЛогированиеWT10(Выборка.ссылка,Автор,ТекстЛога);
			//	ОбъектНаряда.Записать(РежимЗаписиДокумента.Проведение); 
			//	
			//	Ответ = Новый HTTPСервисОтвет(200);
			//	Ответ.Заголовки.Вставить("Content-Type","application/json; charset=utf-8");
			//	Ответ.УстановитьТелоИзСтроки("Успех");
			//	Возврат Ответ;
			//Иначе
			//	Ответ = Новый HTTPСервисОтвет(400);
			//	Ответ.Заголовки.Вставить("Content-Type","application/json; charset=utf-8");
			//	Ответ.УстановитьТелоИзСтроки("Заказ-наряд закрыт!");
			//	Возврат Ответ;	
			//КонецЕсли; 

			Ответ = Новый HTTPСервисОтвет(400);
			Ответ.Заголовки.Вставить("Content-Type", "application/json; charset=utf-8");
			Ответ.УстановитьТелоИзСтроки("Не удалось сменить статус товара!");
			Возврат Ответ;
			//КонецЕсли;
		КонецПопытки;
	КонецЦикла;
	Ответ = Новый HTTPСервисОтвет(400);
	Ответ.Заголовки.Вставить("Content-Type", "application/json; charset=utf-8");
	Ответ.УстановитьТелоИзСтроки("Не верные данные");
	Возврат Ответ;
КонецФункции

Функция ОтправитьВРВРsendrvr(Запрос)
	Запросзаявки = Новый Запрос;
	Запросзаявки.Текст = текстДляЗаказНаряда2();
	Запросзаявки.УстановитьПараметр("Номер", Запрос.ПараметрыURL["id"]);
	Выборка = Запросзаявки.Выполнить().Выбрать();
	Тело = Запрос.ПолучитьТелоКакстроку();
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(Тело);

	Массив  = ПрочитатьJSON(ЧтениеJSON);
	ИндКод  = Массив.id;
	//Позиция = Число(Массив.pose);
	Автор 	= Массив.author;
	Партия = Справочники.ИндКод.НайтиПоНаименованию(ИндКод);

	Номенклатура = Справочники.ИндКод.НайтиПоНаименованию(ИндКод).Владелец;
	Отбор = Новый Структура;
	Отбор.Вставить("Номенклатура", Номенклатура);
	Отбор.Вставить("Партия", Справочники.ИндКод.ПустаяСсылка());

	Пока выборка.Следующий() Цикл
		ОбъектНаряда = Выборка.ссылка.ПолучитьОбъект();
		//ОбъектНаряда = Документы.ЗаказНаряд.СоздатьДокумент();   

		НайденныеСтроки = ОбъектНаряда.Товары.НайтиСтроки(Отбор);
		Если НайденныеСтроки.количество() > 0 Тогда
			СтрокаТЧ = ОбъектНаряда.Товары[НайденныеСтроки[0].НомерСтроки - 1];
			СтрокаТЧ.Партия = Партия; 
			//@skip-check query-in-loop
			СтрокаТЧ.Автомобиль = РаботаССайтомWT.ПолучитьМашину(Партия);
			СтрокаТЧ.Склад = Справочники.Склады.НайтиПоКоду("000000002");
			СтрокаТЧ.Состояние = Перечисления.СтатусыТовараВЗаказНаряде.Выдано;
			//@skip-check query-in-loop
			РаботаССайтомWT.РедактироватьПолку(ИндКод, "K-2-11-1", Автор);
			ТекстЛога =  " В заказ-наряде " + ОбъектНаряда.номер + " установил партию в товаре "
				+ СтрокаТЧ.Номенклатура + " " + СтрокаТЧ.Партия;
			РаботаССайтомWT.ЛогированиеWT10(Выборка.ссылка, Автор, ТекстЛога);
			ОбъектНаряда.Записать(РежимЗаписиДокумента.Проведение);
			Ответ = Новый HTTPСервисОтвет(200);
			Ответ.Заголовки.Вставить("Content-Type", "application/json; charset=utf-8");
			Ответ.УстановитьТелоИзСтроки("Успех");
			Возврат Ответ;

		Иначе
			//	Если  Не ОбъектНаряда.ЗаблокироватьТЧТовары Тогда
			//	
			//	Новаястрока = ОбъектНаряда.Товары.Добавить();
			//	Новаястрока.Партия = партия;
			//	Новаястрока.Номенклатура = Номенклатура; 
			//	Новаястрока.Количество = 1;
			//	Новаястрока.Автомобиль = ПолучитьМашину(партия);
			//	Новаястрока.Состояние = Перечисления.СтатусыТовараВЗаказНаряде.Выдано;
			//	Новаястрока.Цена = Справочники.ИндКод.НайтиПоНаименованию(ИндКод).Владелец.РекомендованаяЦена;
			//	Новаястрока.Склад = Справочники.Склады.НайтиПоКоду("000000002"); 	
			//	
			//	ТекстЛога =  " В заказ-наряде " + ОбъектНаряда.номер + " установил партию в товаре " + Новаястрока.Номенклатура + " "+ Новаястрока.Партия; 
			//	ЛогированиеWT10(Выборка.ссылка,Автор,ТекстЛога);
			//	ОбъектНаряда.Записать(РежимЗаписиДокумента.Проведение); 
			//	
			//	Ответ = Новый HTTPСервисОтвет(200);
			//	Ответ.Заголовки.Вставить("Content-Type","application/json; charset=utf-8");
			//	Ответ.УстановитьТелоИзСтроки("Успех");
			//	Возврат Ответ;
			//Иначе
			//	Ответ = Новый HTTPСервисОтвет(400);
			//	Ответ.Заголовки.Вставить("Content-Type","application/json; charset=utf-8");
			//	Ответ.УстановитьТелоИзСтроки("Заказ-наряд закрыт!");
			//	Возврат Ответ;	
			//КонецЕсли; 

			Ответ = Новый HTTPСервисОтвет(400);
			Ответ.Заголовки.Вставить("Content-Type", "application/json; charset=utf-8");
			Ответ.УстановитьТелоИзСтроки("Такой позиции в заказ-нарядде нет или партия уже установлена!");

		КонецЕсли;

	КонецЦикла;
	Ответ = Новый HTTPСервисОтвет(400);
	Ответ.Заголовки.Вставить("Content-Type", "application/json; charset=utf-8");
	Ответ.УстановитьТелоИзСтроки("Не прокатило");
	Возврат Ответ;
КонецФункции
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ТекстыДляЗапросов
Функция текстДляСпискаНарядов()
	Текст = "ВЫБРАТЬ
			|	ЗаказНарядТовары.Ссылка КАК Ссылка,
			|	КОЛИЧЕСТВО(ЗаказНарядТовары.НомерСтроки) КАК КоличествоСтрок,
			|	ЗаказНарядТовары.Состояние КАК Состояние
			|ПОМЕСТИТЬ ВТ_Условие
			|ИЗ
			|	Документ.ЗаказНаряд.Товары КАК ЗаказНарядТовары
			|СГРУППИРОВАТЬ ПО
			|	ЗаказНарядТовары.Состояние,
			|	ЗаказНарядТовары.Ссылка
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ВТ_Условие.Ссылка КАК Ссылка,
			|	СУММА(ВТ_Условие.КоличествоСтрок) КАК КоличествоСтрок
			|ПОМЕСТИТЬ ВТ_Сборка
			|ИЗ
			|	ВТ_Условие КАК ВТ_Условие
			|ГДЕ
			|	(ВТ_Условие.Состояние = ЗНАЧЕНИЕ(Перечисление.СтатусыТовараВЗаказНаряде.Планово)
			|	ИЛИ ВТ_Условие.Состояние = ЗНАЧЕНИЕ(Перечисление.СтатусыТовараВЗаказНаряде.Срочно))
			|СГРУППИРОВАТЬ ПО
			|	ВТ_Условие.Ссылка
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ВТ_Условие.Ссылка КАК Ссылка,
			|	СУММА(ВТ_Условие.КоличествоСтрок) КАК КоличествоСтрок
			|ПОМЕСТИТЬ ВТ_Выдача
			|ИЗ
			|	ВТ_Условие КАК ВТ_Условие
			|ГДЕ
			|	(ВТ_Условие.Состояние = ЗНАЧЕНИЕ(Перечисление.СтатусыТовараВЗаказНаряде.Собрано)
			|	ИЛИ ВТ_Условие.Состояние = ЗНАЧЕНИЕ(Перечисление.СтатусыТовараВЗаказНаряде.НетВНаличии))
			|СГРУППИРОВАТЬ ПО
			|	ВТ_Условие.Ссылка
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	Сотрудники.Код КАК Код,
			|	ЗаказНаряд.Номер КАК Номер,
			|	ЗаказНаряд.Ссылка КАК Ссылка,
			|	ЗаказНаряд.Дата КАК Дата,
			|	ЗаказНаряд.Клиент КАК Клиент,
			|	ЗаказНаряд.Ответственный КАК Ответственный,
			|	ЗаказНаряд.Состояние КАК Состояние,
			|	ЗаказНаряд.ЗаказКлиента КАК ЗаказКлиента,
			|	ЗаказНаряд.ВнутреннийЗаказНаряд КАК Внутр,
			|	АВТОНОМЕРЗАПИСИ() КАК НомерЗаписи,
			|	ВТ_Сборка.КоличествоСтрок КАК КоличествоСборка,
			|	ВТ_Выдача.КоличествоСтрок КАК КоличествоВыдача,
			|	ЗаказНаряд.Комментарий
			|ПОМЕСТИТЬ ВТ_Наряд
			|ИЗ
			|	Документ.ЗаказНаряд КАК ЗаказНаряд
			|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Сборка КАК ВТ_Сборка
			|		ПО (ВТ_Сборка.Ссылка = ЗаказНаряд.Ссылка)
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Сотрудники КАК Сотрудники
			|		ПО ЗаказНаряд.Инициатор = Сотрудники.Ссылка
			|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Выдача КАК ВТ_Выдача
			|		ПО ЗаказНаряд.Ссылка = ВТ_Выдача.Ссылка 
			|	ГДЕ
			|	 ЗаказНаряд.Дата > датавремя(2023, 07, 18)
			|	И не ЗаказНаряд.ВнутреннийЗаказНаряд
			|	И ЗаказНаряд.Состояние <> Значение(перечисление.СостоянияЗаказНаряда.Выполнен)
			//| &Фильтр
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ ПЕРВЫЕ %1
			|	ВТ_Наряд.Код КАК Код,
			|	ВТ_Наряд.Номер КАК Номер,
			|	ВТ_Наряд.Дата КАК Дата,
			|	ВТ_Наряд.Клиент КАК Клиент,
			|	ВТ_Наряд.Ответственный КАК Ответственный,
			|	ВТ_Наряд.Состояние КАК Состояние,
			|	ВТ_Наряд.ЗаказКлиента КАК ЗаказКлиента,
			|	ВТ_Наряд.НомерЗаписи КАК НомерЗаписи,
			|	ВТ_Наряд.КоличествоСборка КАК КоличествоСборка,
			|	ВТ_Наряд.КоличествоВыдача КАК КоличествоВыдача,
			|	ВТ_Наряд.Внутр КАК Внутр,
			|	ВТ_Наряд.Комментарий КАК Комментарий
			|ИЗ
			|	ВТ_Наряд КАК ВТ_Наряд
			|ГДЕ
			|	ВТ_Наряд.НомерЗаписи >= &НачинаяСЗаписи
			|
			|УПОРЯДОЧИТЬ ПО
			|	НомерЗаписи";
	Возврат текст;

КонецФункции

Функция текстДляЗаказНаряда2()
	Текст = "ВЫБРАТЬ
			|	Сотрудники.Код КАК Код,
			|	ЗаказНаряд.Номер КАК Номер,
			|	ЗаказНаряд.Ссылка КАК Ссылка,
			|	ЗаказНаряд.Дата КАК Дата,
			|	ЗаказНаряд.Клиент КАК Клиент,
			|	ЗаказНаряд.Ответственный КАК Ответственный,
			|	ЗаказНаряд.Состояние КАК Состояние,
			|	ЗаказНаряд.Товары.(
			|		Ссылка КАК Ссылка,
			|		НомерСтроки КАК НомерСтроки,
			|		Номенклатура КАК Товар,
			|		Количество КАК Количество,
			|		Цена КАК Цена,
			|		Автомобиль КАК Автомобиль,
			|		СкидкаСумма КАК СкидкаСумма,
			|		СкидкаПроцент КАК СкидкаПроцент,
			|		Сумма КАК Сумма,
			|		Партия КАК Партия,
			|		ПРЕДСТАВЛЕНИЕ(ЗаказНаряд.Товары.Партия) КАК Партия2,
			|		СуммаВсего КАК СуммаВсего,
			|		Склад КАК Склад,
			|		Ответственный КАК Ответственный,
			|		СуммаНалог КАК СуммаНалог,
			|		СуммаЗп КАК СуммаЗп,
			|		Состояние КАК Состояние,
			|		СуммаСНДС КАК СуммаСНДС,
			|		Номенклатура.Артикул КАК Артикул,
			|		Номенклатура.Код КАК Код) КАК Таблица,
			|	ЗаказНаряд.ЗаказКлиента КАК ЗаказКлиента,
			|	ЗаказНаряд.Работы.(
			|		Ссылка,
			|		НомерСтроки,
			|		Работа,
			|		Количество,
			|		Нормочас,
			|		Цена,
			|		Сумма,
			|		СкидкаПроцент,
			|		СкидкаСумма,
			|		СуммаВсего,
			|		Содержание,
			|		ИдентификаторСтроки,
			|		ВремяФакт,
			|		ВремяПлан,
			|		СуммаНалог,
			|		СуммаЗп,
			|		ИдентификаторСтрока,
			|		СтатусРаботы)
			|ИЗ
			|	Документ.ЗаказНаряд КАК ЗаказНаряд
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Сотрудники КАК Сотрудники
			|		ПО ЗаказНаряд.Инициатор = Сотрудники.Ссылка
			|ГДЕ
			|	ЗаказНаряд.Номер = &Номер";
	Возврат Текст;
КонецФункции
#КонецОбласти



#КонецОбласти