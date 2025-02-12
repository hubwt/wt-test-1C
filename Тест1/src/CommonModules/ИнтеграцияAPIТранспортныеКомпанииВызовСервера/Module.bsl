
Процедура УзнатьСтатусДоставки(ТрекНомерЧерезПродажу = Неопределено, ТранспортнаяКомпанияЧерезПродажу = Неопределено) Экспорт

	///+ГомзМА 03.11.2023
	МассивТранспортныхКомпаний = Новый Массив;
	
	Если ТранспортнаяКомпанияЧерезПродажу = Неопределено Тогда
		МассивТранспортныхКомпаний.Добавить(Справочники.ТранспротнаяКомпания.НайтиПоКоду("000000001")); //Деловые Линии
		МассивТранспортныхКомпаний.Добавить(Справочники.ТранспротнаяКомпания.НайтиПоКоду("000000003")); //ПЭК
		МассивТранспортныхКомпаний.Добавить(Справочники.ТранспротнаяКомпания.НайтиПоКоду("000000020")); //СДЭК
		МассивТранспортныхКомпаний.Добавить(Справочники.ТранспротнаяКомпания.НайтиПоКоду("000000004")); //Байкал-Сервис
	Иначе
		МассивТранспортныхКомпаний.Добавить(ТранспортнаяКомпанияЧерезПродажу);
	КонецЕсли;
	
	Для каждого ТранспортнаяКомпания Из МассивТранспортныхКомпаний Цикл
		
		Если ТрекНомерЧерезПродажу = Неопределено Тогда
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	ПродажаЗапчастей.Ссылка КАК Ссылка,
			|	ПродажаЗапчастей.ТрекНомер КАК ТрекНомер
			|ИЗ
			|	Документ.ПродажаЗапчастей КАК ПродажаЗапчастей
			|ГДЕ
			|	ПродажаЗапчастей.ТрекНомер <> """"
			|	И ПродажаЗапчастей.ТранспортнаяКомпания = &ТранспортныеКомпании
			|	И ПродажаЗапчастей.СтатусЗаказаВТК <> ""Вручен""";
			
			Запрос.УстановитьПараметр("ТранспортныеКомпании", ТранспортнаяКомпания); 
		Иначе
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	ПродажаЗапчастей.Ссылка КАК Ссылка,
			|	ПродажаЗапчастей.ТрекНомер КАК ТрекНомер
			|ИЗ
			|	Документ.ПродажаЗапчастей КАК ПродажаЗапчастей
			|ГДЕ
			|	ПродажаЗапчастей.ТрекНомер = &ТрекНомерЧерезПродажу;";
			
			Запрос.УстановитьПараметр("ТрекНомерЧерезПродажу", ТрекНомерЧерезПродажу);
		КонецЕсли;
		
		РезультатЗапроса = Запрос.Выполнить().Выгрузить();
		
		Если РезультатЗапроса.Количество() > 0 Тогда
			
			МассивТрекНомеров = Новый Массив;
			
			Для каждого ТрекНомер Из РезультатЗапроса Цикл
				МассивТрекНомеров.Добавить(ТрекНомер.ТрекНомер);		
			КонецЦикла;
			
			Если ТранспортнаяКомпания = Справочники.ТранспротнаяКомпания.НайтиПоКоду("000000001") Тогда //Деловые Линии
				
				ОтветЗапроса = ПолучитьОтветPostЗапросаDellin(МассивТрекНомеров);
				Если ОтветЗапроса <> Неопределено Тогда
					Для каждого ДанныеТрекНомеров Из ОтветЗапроса Цикл
						ПараметрОтбора = Новый Структура("ТрекНомер", ДанныеТрекНомеров.Ключ);
						СтрокаТЗ = РезультатЗапроса.НайтиСтроки(ПараметрОтбора);
						ДокументОбъект = СтрокаТЗ[0].Ссылка.ПолучитьОбъект();
						
						ИндексПоследнейЗаписиВИстории = ДанныеТрекНомеров.Значение.Количество() - 1;
						
						Статус = ДанныеТрекНомеров.Значение[ИндексПоследнейЗаписиВИстории].Получить("state");
						СтатусЗаказаВТК = ПолучитьСтатусЗаказаВТК(ТранспортнаяКомпания, Статус, ДокументОбъект.СтатусЗаказаВТК);
						ДокументОбъект.СтатусЗаказаВТК = СтатусЗаказаВТК;
						
						ДокументОбъект.ИсторияОтслеживанияЗаказа = "";
						Для каждого ИсторияОтслеживания Из ДанныеТрекНомеров.Значение Цикл
							ИмяСтатуса 	= ИсторияОтслеживания.Получить("stateName");
							ДатаСтатуса = СтрЗаменить(Лев(ИсторияОтслеживания.Получить("stateDate"), 19), "T", " ");
							ДокументОбъект.ИсторияОтслеживанияЗаказа = ДокументОбъект.ИсторияОтслеживанияЗаказа + " " + ИмяСтатуса + " " + ДатаСтатуса + Символы.ПС;
						КонецЦикла;
						ДокументОбъект.Записать();
					КонецЦикла;
				КонецЕсли;
			ИначеЕсли ТранспортнаяКомпания = Справочники.ТранспротнаяКомпания.НайтиПоКоду("000000004") Тогда //Байкал-Сервис
				Для каждого ТрекНомер Из МассивТрекНомеров Цикл
					ОтветЗапроса = ПолучитьОтветGetЗапросаБайкалСервис(ТрекНомер);
					Если ОтветЗапроса <> Неопределено Тогда
						ЕстьСтруктура = Ложь;
						Для каждого Структура Из ОтветЗапроса Цикл
							Если Структура.Ключ = "status" Тогда
								ЕстьСтруктура = Истина;
							КонецЕсли;
						КонецЦикла;
						Если ЕстьСтруктура Тогда
							ПараметрОтбора = Новый Структура("ТрекНомер", ТрекНомер);
							СтрокаТЗ = РезультатЗапроса.НайтиСтроки(ПараметрОтбора);
							
							ДокументОбъект = СтрокаТЗ[0].Ссылка.ПолучитьОбъект();
							
							Статус = ОтветЗапроса.status.statusName;
							СтатусЗаказаВТК = ПолучитьСтатусЗаказаВТК(ТранспортнаяКомпания, Статус, ДокументОбъект.СтатусЗаказаВТК);
							ДокументОбъект.СтатусЗаказаВТК = СтатусЗаказаВТК;
							
							ДокументОбъект.ИсторияОтслеживанияЗаказа = ДокументОбъект.ИсторияОтслеживанияЗаказа + ОтветЗапроса.status.text + Символы.ПС;
							ДокументОбъект.Записать();
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;
			ИначеЕсли ТранспортнаяКомпания = Справочники.ТранспротнаяКомпания.НайтиПоКоду("000000020") Тогда //СДЭК
				
				Токен = ПолучитьТокенДляАвторизацииСДЭК();
				Для каждого ТрекНомер Из МассивТрекНомеров Цикл
					ОтветЗапроса = ПолучитьОтветGetЗапросаСДЭК(ТрекНомер, Токен);
					Если ОтветЗапроса <> Неопределено Тогда
						ПараметрОтбора = Новый Структура("ТрекНомер", ТрекНомер);
						СтрокаТЗ = РезультатЗапроса.НайтиСтроки(ПараметрОтбора);
						
						ДокументОбъект = СтрокаТЗ[0].Ссылка.ПолучитьОбъект();
						ИндексПоследнего = ОтветЗапроса.ВГраница();
						ДокументОбъект.ИсторияОтслеживанияЗаказа = "";
						
						Статус = ОтветЗапроса[0].code;
						СтатусЗаказаВТК = ПолучитьСтатусЗаказаВТК(ТранспортнаяКомпания, Статус, ДокументОбъект.СтатусЗаказаВТК);
						ДокументОбъект.СтатусЗаказаВТК = СтатусЗаказаВТК;
						
						Для Индекс = -ИндексПоследнего По 0 Цикл
							ИмяСтатуса 	= ОтветЗапроса[-Индекс].name;
							ДатаСтатуса = СтрЗаменить(Лев(ОтветЗапроса[-Индекс].date_time, 19), "T", " ");
							ГородСтатуса = ОтветЗапроса[-Индекс].city;
							
							ДокументОбъект.ИсторияОтслеживанияЗаказа = ДокументОбъект.ИсторияОтслеживанияЗаказа + ИмяСтатуса + " " + ГородСтатуса + " " + ДатаСтатуса + Символы.ПС;
						КонецЦикла;
						ДокументОбъект.Записать();
					КонецЕсли;
				КонецЦикла;
			ИначеЕсли ТранспортнаяКомпания = Справочники.ТранспротнаяКомпания.НайтиПоКоду("000000003") Тогда //ПЭК
				
				ОтветЗапроса = ПолучитьОтветPostЗапросаПЭК(МассивТрекНомеров);
				ДанныеПоТрекНомерам = ОтветЗапроса.Получить("cargos");
				
				Для каждого ДанныеПоТрекНомеру Из ДанныеПоТрекНомерам Цикл
					ТрекНомер = ДанныеПоТрекНомеру.Получить("cargo").Получить("cargoBarCode");
					Статусы = ДанныеПоТрекНомеру.Получить("info").Получить("statuses");
					ИсторияОтслеживания = "";
					
					Для каждого Статус Из Статусы Цикл
						ИсторияОтслеживания = ИсторияОтслеживания + Статус.Получить("name") + " " + Лев(Статус.Получить("date"), 10) + Символы.ПС;
					КонецЦикла;
					
					ПараметрОтбора = Новый Структура("ТрекНомер", ТрекНомер);
					СтрокаТЗ = РезультатЗапроса.НайтиСтроки(ПараметрОтбора);
					ДокументОбъект = СтрокаТЗ[0].Ссылка.ПолучитьОбъект();
					
					ИндексПоследнейЗаписиВИстории = Статусы.Количество() - 1;
					
					Статус = Статусы[ИндексПоследнейЗаписиВИстории].Получить("name");
					СтатусЗаказаВТК = ПолучитьСтатусЗаказаВТК(ТранспортнаяКомпания, Статус, ДокументОбъект.СтатусЗаказаВТК);
					ДокументОбъект.СтатусЗаказаВТК = СтатусЗаказаВТК;
					ДокументОбъект.ИсторияОтслеживанияЗаказа = ИсторияОтслеживания;
					ДокументОбъект.Записать();
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	///-ГомзМА 03.11.2023

КонецПроцедуры


&НаСервере
Функция ПолучитьОтветPostЗапросаDellin(МассивТрекНомеров)

	///+ГомзМА 01.11.2023
	Структура = Новый Структура;
	Структура.Вставить("appkey", "97C1CE5A-88D8-4609-8347-19403B175A91");
	Структура.Вставить("docIds", МассивТрекНомеров);
	
	СтрокаJSON = ПреобразоватьВJSON(Структура);
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	
	Соединение = Новый HTTPСоединение("api.dellin.ru", 443,,,,, Новый ЗащищенноеСоединениеOpenSSL());
	Запрос = Новый HTTPЗапрос("/v3/orders/statuses_history.json", Заголовки);
	Запрос.УстановитьТелоИзСтроки(СтрокаJSON);
	//В запросе можно обратиться к нужному ресурсу и с нужными параметрами 
	Ответ = Соединение.ОтправитьДляОбработки(Запрос);
	
	Если Ответ.КодСостояния = 200 Тогда
		Тело = Ответ.ПолучитьТелоКакСтроку();  
		ЧтениеJSON = Новый ЧтениеJSON();
		ЧтениеJSON.УстановитьСтроку(Тело); 
		Ответ  = ПрочитатьJSON(ЧтениеJSON, Истина); 
		Ответ = Ответ.Получить("data").Получить("statusHistory");
	Иначе //Сообщить("Код ответа: " + Ответ.КодСостояния); //анализируем код состояния и делаем выводы 
		Ответ = Неопределено;
	КонецЕсли;
	
	Возврат Ответ;
	///-ГомзМА 01.11.2023

КонецФункции // ПолучитьОтветPostЗапросаDellin()


&НаСервере
Функция ПолучитьОтветGetЗапросаБайкалСервис(ТрекНомер)

	///+ГомзМА 01.11.2023
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	Заголовки.Вставить("Authorization", "Basic M2U1NzYxNGIxOWJhNjY4NmU1MGUyOTBiZTQ3MDZmMWE6");
	
	Соединение = Новый HTTPСоединение("api.baikalsr.ru", 443,,,,, Новый ЗащищенноеСоединениеOpenSSL());
	Запрос = Новый HTTPЗапрос("/v1/tracking?number=" + ТрекНомер, Заголовки);
	//В запросе можно обратиться к нужному ресурсу и с нужными параметрами 
	Ответ = Соединение.Получить(Запрос);
	
	Если Ответ.КодСостояния = 200 Тогда
		Тело = Ответ.ПолучитьТелоКакСтроку();  
		ЧтениеJSON = Новый ЧтениеJSON();
		ЧтениеJSON.УстановитьСтроку(Тело); 
		Ответ  = ПрочитатьJSON(ЧтениеJSON); 
	Иначе //Сообщить("Код ответа: " + Ответ.КодСостояния); //анализируем код состояния и делаем выводы 
		Ответ = Неопределено;
	КонецЕсли;
	
	Возврат Ответ;
	///-ГомзМА 01.11.2023

КонецФункции // ПолучитьОтветGetЗапросаБайкалСервис()

&НаСервере
Функция ПолучитьТокенДляАвторизацииСДЭК()

	///+ГомзМА 02.11.2023	
	Соединение = Новый HTTPСоединение("api.cdek.ru", 443,,,,, Новый ЗащищенноеСоединениеOpenSSL());
	Запрос = Новый HTTPЗапрос("/v2/oauth/token?grant_type=client_credentials&client_id=uKpk66IlNs5qS0Yh2Bv3sXsT7SJizMub&client_secret=QNV4rlOG7Hr5BIkNnU66TBC4BIM0Xp3g");
	//В запросе можно обратиться к нужному ресурсу и с нужными параметрами 
	Ответ = Соединение.ОтправитьДляОбработки(Запрос);
	
	Если Ответ.КодСостояния = 200 Тогда
		Тело = Ответ.ПолучитьТелоКакСтроку();  
		ЧтениеJSON = Новый ЧтениеJSON();
		ЧтениеJSON.УстановитьСтроку(Тело); 
		Ответ  = ПрочитатьJSON(ЧтениеJSON, Истина);
		Ответ = Ответ.Получить("access_token");
	Иначе //Сообщить("Код ответа: " + Ответ.КодСостояния); //анализируем код состояния и делаем выводы 
		Ответ = Неопределено;
	КонецЕсли;
	
	Возврат Ответ;	
	///-ГомзМА 02.11.2023

КонецФункции // ПолучитьТокенДляАвторизацииСДЭК()

&НаСервере
Функция ПолучитьОтветGetЗапросаСДЭК(ТрекНомер, Токен)

	///+ГомзМА 01.11.2023
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Authorization", "Bearer " + Токен);
	
	Соединение = Новый HTTPСоединение("api.cdek.ru", 443,,,,, Новый ЗащищенноеСоединениеOpenSSL());
	Запрос = Новый HTTPЗапрос("/v2/orders?cdek_number=" + ТрекНомер, Заголовки);
	//В запросе можно обратиться к нужному ресурсу и с нужными параметрами 
	Ответ = Соединение.Получить(Запрос);
	
	Если Ответ.КодСостояния = 200 Тогда
		Тело = Ответ.ПолучитьТелоКакСтроку();  
		ЧтениеJSON = Новый ЧтениеJSON();
		ЧтениеJSON.УстановитьСтроку(Тело); 
		Ответ  = ПрочитатьJSON(ЧтениеJSON);
		Если Ответ <> Неопределено Тогда
			Ответ = Ответ.entity.statuses;
		КонецЕсли;
	Иначе //Сообщить("Код ответа: " + Ответ.КодСостояния); //анализируем код состояния и делаем выводы 
		Ответ = Неопределено;
	КонецЕсли;
	
	Возврат Ответ;
	///-ГомзМА 01.11.2023

КонецФункции // ПолучитьОтветGetЗапросаСДЭК()


&НаСервере
Функция ПолучитьОтветPostЗапросаПЭК(МассивТрекНомеров)

	///+ГомзМА 01.11.2023
	Структура = Новый Структура;
	Структура.Вставить("cargoCodes", МассивТрекНомеров);
	
	СтрокаJSON = ПреобразоватьВJSON(Структура);
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	Заголовки.Вставить("Authorization", "Basic V29ya3RydWNrUzpFMUQ5NTcxNjFDOTRFNENGRUMyRDhGNDkxOEQ1RjUyNDg0NENEQkIy");
	
	Соединение = Новый HTTPСоединение("kabinet.pecom.ru", 443,,,,, Новый ЗащищенноеСоединениеOpenSSL());
	Запрос = Новый HTTPЗапрос("/api/v1/cargos/status", Заголовки);
	Запрос.УстановитьТелоИзСтроки(СтрокаJSON);
	//В запросе можно обратиться к нужному ресурсу и с нужными параметрами 
	Ответ = Соединение.ОтправитьДляОбработки(Запрос);
	
	Если Ответ.КодСостояния = 200 Тогда
		Тело = Ответ.ПолучитьТелоКакСтроку();  
		ЧтениеJSON = Новый ЧтениеJSON();
		ЧтениеJSON.УстановитьСтроку(Тело); 
		Ответ  = ПрочитатьJSON(ЧтениеJSON, Истина); 
		//Ответ = Ответ.Получить("data").Получить("statusHistory");
	Иначе //Сообщить("Код ответа: " + Ответ.КодСостояния); //анализируем код состояния и делаем выводы 
		Ответ = Неопределено;
	КонецЕсли;
	
	Возврат Ответ;
	///-ГомзМА 01.11.2023

КонецФункции // ПолучитьОтветPostЗапросаПЭК()

&НаСервере
Функция ПолучитьСтатусЗаказаВТК(ТранспортнаяКомпания, Статус, СтатусВДокументе)

	///+ГомзМА 01.11.2023
	Если ТранспортнаяКомпания = Справочники.ТранспротнаяКомпания.НайтиПоКоду("000000001") Тогда //Деловые Линии
		Если Статус = "processing" ИЛИ Статус = "pickup" ИЛИ Статус = "waiting" ИЛИ Статус = "received" ИЛИ Статус = "received_warehousing" Тогда
			Возврат "Создан";
		ИначеЕсли Статус = "inway" Тогда
			Возврат "В пути";
		ИначеЕсли Статус = "arrived" ИЛИ Статус = "warehousing" ИЛИ Статус = "arrived_to_airport" ИЛИ Статус = "airport_warehousing" ИЛИ Статус = "delivery" Тогда
			Возврат "Готов к выдаче";
		ИначеЕсли Статус = "finished" Тогда
			Возврат "Вручен";
		Иначе
			Возврат СтатусВДокументе;
		КонецЕсли;
	ИначеЕсли ТранспортнаяКомпания = Справочники.ТранспротнаяКомпания.НайтиПоКоду("000000004") Тогда //Байкал-Сервис
		Если Статус = "" Тогда
			Возврат "Создан";
		ИначеЕсли Статус = "" Тогда
			Возврат "В пути";
		ИначеЕсли Статус = "" Тогда
			Возврат "Готов к выдаче";
		ИначеЕсли Статус = "Груз выдан" Тогда
			Возврат "Вручен";
		Иначе Возврат СтатусВДокументе;
		КонецЕсли;	
	ИначеЕсли ТранспортнаяКомпания = Справочники.ТранспротнаяКомпания.НайтиПоКоду("000000020") Тогда //СДЭК
		Если Статус = "ACCEPTED" ИЛИ Статус = "CREATED" Тогда
			Возврат "Создан";
		ИначеЕсли Статус = "TAKEN_BY_TRANSPORTER_FROM_SENDER_CITY" ИЛИ Статус = "SENT_TO_TRANSIT_CITY" ИЛИ Статус = "TAKEN_BY_TRANSPORTER_FROM_TRANSIT_CITY" ИЛИ Статус = "SENT_TO_SENDER_CITY" ИЛИ Статус = "SENT_TO_RECIPIENT_CITY" Тогда
			Возврат "В пути";
		ИначеЕсли Статус = "RECEIVED_AT_SHIPMENT_WAREHOUSE" ИЛИ Статус = "ACCEPTED_AT_RECIPIENT_CITY_WAREHOUSE" ИЛИ Статус = "ACCEPTED_AT_PICK_UP_POINT" ИЛИ Статус = "TAKEN_BY_COURIER" ИЛИ Статус = "POSTOMAT_POSTED " Тогда
			Возврат "Готов к выдаче";
		ИначеЕсли Статус = "DELIVERED" Тогда
			Возврат "Вручен";
		Иначе Возврат СтатусВДокументе;
		КонецЕсли;
	ИначеЕсли ТранспортнаяКомпания = Справочники.ТранспротнаяКомпания.НайтиПоКоду("000000003") Тогда //ПЭК
		Если Статус = "Принят" ИЛИ Статус = "Оформлен" ИЛИ Статус = "Принят на ПВЗ" Тогда
			Возврат "Создан";
		ИначеЕсли Статус = "В пути" ИЛИ Статус = "В пути на терминал" Тогда
			Возврат "В пути";
		ИначеЕсли Статус = "Прибыл" ИЛИ Статус = "Прибыл частично" Тогда
			Возврат "Готов к выдаче";
		ИначеЕсли Статус = "Выдан на складе" ИЛИ Статус = "Доставлен" ИЛИ Статус = "Доставлен" ИЛИ Статус = "Выдан" Тогда
			Возврат "Вручен";
		Иначе Возврат СтатусВДокументе;
		КонецЕсли;
	КонецЕсли;	
	///-ГомзМА 01.11.2023

КонецФункции // ПолучитьСтатусЗаказаВТК()


&НаСервере
Функция ПреобразоватьВJSON(Данные)

	///+ГомзМА 01.11.2023
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	ЗаписатьJSON(ЗаписьJSON, Данные);
	СтрокаJSON = ЗаписьJSON.Закрыть();
	
	Возврат СтрокаJSON;
	///-ГомзМА 01.11.2023

КонецФункции // ПреобразоватьВJSON()

