
Процедура ALX_ЗагрузкаЗвонковМанго() Экспорт
	
	ВыгрузитьЗвонки();
	
КонецПроцедуры

//

//10800 - Московский часовой пояс
Функция ДатуВTimestamp(пДата = Неопределено)
	Возврат Формат(Число(?(ТипЗнч(пДата) = Тип("Дата"), пДата, ТекущаяДата())-Дата("19700101") - 10800),"ЧН=0; ЧГ=0");
КонецФункции

Функция TimestampВДату(пДатаТС)
	Попытка
		Возврат Дата("19700101")+ 10800 +?(ТипЗнч(пДатаТС) = Тип("Строка"), Число(пДатаТС), пДатаТС);
	Исключение
		Возврат Неопределено;
	КонецПопытки;
КонецФункции

Процедура глПауза(Сек)
	
	////Сигнатура = Формат(ТекущаяДата(), "ДФ=yyyyMMddhhmmss");
	////	ПутьСкрипта = КаталогВременныхФайлов()+"SleepScript"+Сигнатура+".vbs";
	////	СкриптФайл = Новый ТекстовыйДокумент;
	////	СкриптФайл.ДобавитьСтроку("WScript.Sleep("+Формат(Сек*1000, "ЧГ=0")+")");
	////	СкриптФайл.Записать(ПутьСкрипта, КодировкаТекста.OEM);
	////	WSHShell = Новый COMОбъект("WScript.Shell");
	////	WSHShell.Run("wscript.exe """+ПутьСкрипта+"""", 0, 1);
	////	УдалитьФайлы(ПутьСкрипта);
	//
	//
	////Для к = 1 По Сек Цикл
	////		ПолучитьCOMОбъект("winmgmts:").ExecNotificationQuery("Select * from __instancemodificationevent where TargetInstance isa 'Win32_UTCTime'").NextEvent();
	////	КонецЦикла;
	//
	//scr = Новый COMОбъект("WScript.Shell");
	//scr.Run("ping 127.0.0.1 -n "+СокрЛП(Число(Сек)+1),0,1);
	ДатаКонец = ТекущаяДата() + Число(Сек);
	Пока ДатаКонец > ТекущаяДата() Цикл
		
	КонецЦикла;
	
КонецПроцедуры 



#Область ЗагрузкаОтчетаССервера

Процедура ВыгрузитьЗвонкиНаСервере()//Изменить период
	
	//Настройка = ПолучитьНастройки();
	//Если Настройка = Неопределено Тогда
	//	Настройка = ПолучитьСтруктуруНастроек();	
	//КонецЕсли;
	
	//Если Константы.ALX_ДатаНачалоМанго.Получить()= '00010101000000' ИЛИ Константы.ALX_КлючApiМанго.Получить() = "" ИЛИ Константы.ALX_ApiSaltМанго.Получить() = "" Тогда
	
	ЗаписьЖурналаРегистрации("Фоновая выгрузка звонков(Манго). Ошибка", ,,,"Настройки не заполнены", РежимТранзакцииЗаписиЖурналаРегистрации.Независимая); 
	
	
	//КонецЕсли;
	//Если Константы.ALX_РазрешеноЗагружатьМанго.Получить() = Ложь Тогда
	//	ЗаписьЖурналаРегистрации("Фоновая выгрузка звонков(Манго). Предупреждение", ,,,"Прошлый вызов не был завершен", РежимТранзакцииЗаписиЖурналаРегистрации.Независимая); 
	//	Возврат;
	//КонецЕсли;
	//МассивЗаданий = ФоновыеЗадания.ПолучитьФоновыеЗадания(Новый Структура("Состояние, ИмяМетода", СостояниеФоновогоЗадания.Активно, "ALX_РегламентнаяЗагрузкаЗвонковМанго.ALX_ЗагрузкаЗвонковМанго"));
	//
	//Если МассивЗаданий.Количество() > 0 Тогда
	//	ЗаписьЖурналаРегистрации("Фоновая выгрузка звонков(Манго). Предупреждение", ,,,"Прошлый вызов не был завершен", РежимТранзакцииЗаписиЖурналаРегистрации.Независимая); 
	//	Возврат;		
	//КонецЕсли;
	
	ПериодВСек = 60000;//432000;  //5 дней  
	ДатаНачалаВыгрузки = ТекущаяДата() - 60000;//Настройка.ДатаПоследнейЗагрузки - 60000;
	ДатаОкончанияВыгрузки = ТекущаяДата();
	ApiSalt = "8sut0olaju5mcy8mx3rprq3uo380vmfu";
	ApiKey = "ehffuh31k4j4dr3vk95f1x9od8aol1np";
	//Константы.ALX_РазрешеноЗагружатьМанго.Установить(Ложь);
	Пока ДатаОкончанияВыгрузки - ДатаНачалаВыгрузки > ПериодВСек Цикл	
		ВыгрузитьЗаПериод(ДатаНачалаВыгрузки, ДатаНачалаВыгрузки + ПериодВСек, ApiKey, ApiSalt);
		ДатаНачалаВыгрузки = ДатаНачалаВыгрузки + ПериодВСек;
		//Настройка.ДатаПоследнейЗагрузки = ДатаНачалаВыгрузки + ПериодВСек;
		//СохранитьНастройки(Настройка);
	КонецЦикла;
	
	ВыгрузитьЗаПериод(ДатаНачалаВыгрузки, ДатаОкончанияВыгрузки, ApiKey, ApiSalt);
	//Настройка.ДатаПоследнейЗагрузки = ДатаОкончанияВыгрузки;
	//СохранитьНастройки(Настройка);
	//Константы.ALX_РазрешеноЗагружатьМанго.Установить(Истина);
КонецПроцедуры

Процедура ВыгрузитьЗаПериод(ДатаНачала, ДатаОкончания, ApiKey, ApiSalt)
	
	КлючОтчета = ПолучитьКлюч(ДатаНачала, ДатаОкончания, ApiKey, ApiSalt);
	Если КлючОтчета = "" Тогда
		Возврат;
	КонецЕсли;
	Для Индекс = 1 По 10 Цикл
		
		глПауза(1);
		
		HTTPОтвет = ПолучитьОтветПоКлючу(КлючОтчета, ApiKey, ApiSalt);
		СостояниеОтвета = HTTPОтвет.КодСостояния;
		
		Если СостояниеОтвета <> 200 И СостояниеОтвета <> 204 Тогда
			Сообщить("Не удалось получить ответ. Код Состояния = " + СостояниеОтвета);
			ЗаписьЖурналаРегистрации("Фоновая выгрузка звонков(Манго). Ошибка", ,,,"При получении данных сервер вернул " + СостояниеОтвета, РежимТранзакцииЗаписиЖурналаРегистрации.Независимая); 
			Возврат;
		КонецЕсли;
		Если СостояниеОтвета = 200 Тогда
			ОбработкаОтвета(HTTPОтвет);
			Возврат
		КонецЕсли;
		
		Если Индекс > 10 Тогда
			Сообщить("Превышено время ожидания ответа");
			ЗаписьЖурналаРегистрации("Фоновая выгрузка звонков(Манго). Предупреждение", ,,,"Превышено время ожидания ответа", РежимТранзакцииЗаписиЖурналаРегистрации.Независимая); 
			Возврат;
		КонецЕсли;
		
	КонецЦикла;
	
	
КонецПроцедуры

Процедура ВыгрузитьЗвонки() Экспорт 
	
	ВыгрузитьЗвонкиНаСервере();	
	
КонецПроцедуры

Функция ВыполнитьЗапрос(АдресРесурса, ПараметрыЗапроса, ApiKey, ApiSalt) Экспорт
	
	
	Сервер = "app.mango-office.ru/vpbx/";
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку(Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Нет));
	ЗаписатьJSON(ЗаписьJSON, ПараметрыЗапроса);
	СтрокаJSON = ЗаписьJSON.Закрыть();
	
	ХД = Новый ХешированиеДанных(ХешФункция.SHA256);
	ХД.Добавить(ApiKey);
	ХД.Добавить(СтрокаJSON);
	ХД.Добавить(ApiSalt);
	Sign = НРег(СтрЗаменить(ХД.ХешСумма, " ", ""));
	
	HTTPСоединение = Новый HTTPСоединение(Сервер,,,,,, Новый ЗащищенноеСоединениеOpenSSL());
	
	СтрокаЗапроса = "vpbx_api_key="+КодироватьСтроку(ApiKey, СпособКодированияСтроки.КодировкаURL)+"&sign=" + КодироватьСтроку(Sign, СпособКодированияСтроки.КодировкаURL) + "&json=" + КодироватьСтроку(СтрокаJSON, СпособКодированияСтроки.КодировкаURL) + "";
	
	//Сообщить(СтрокаЗапроса);
	
	ЗаголовкиHTTP = Новый Соответствие;
	ЗаголовкиHTTP.Вставить("Content-type", "application/x-www-form-urlencoded");
	ЗаголовкиHTTP.Вставить("Accept-Language", "en");
	ЗаголовкиHTTP.Вставить("Accept-Charset", "utf-8");
	ЗаголовкиHTTP.Вставить("Content-Language", "en");
	ЗаголовкиHTTP.Вставить("Content-Charset", "utf-8");
	ЗаголовкиHTTP.Вставить("Content-Length",СтрДлина(СтрокаЗапроса)); 
	HTTPЗапрос = Новый HTTPЗапрос(АдресРесурса, ЗаголовкиHTTP);
	HTTPЗапрос.УстановитьТелоИзСтроки(СтрокаЗапроса);
	//глПауза(10);
	Тушка = HTTPЗапрос.ПолучитьТелоКакСтроку();
	Попытка
		Ответ = HTTPСоединение.ОтправитьДляОбработки(HTTPЗапрос);
		ТелоОтвета = Ответ.ПолучитьТелоКакСтроку(); 
	Исключение
		Сообщить("Не удалось отправить запрос на " + Сервер + АдресРесурса + ". " + ОписаниеОшибки());
		Возврат Неопределено;//Новый HTTPСервисОтвет(400);
	КонецПопытки;
	Возврат Ответ;
КонецФункции

Функция ПолучитьКлюч(ДатаНачала, ДатаОкончания, ApiKey, ApiSalt)
	
	Ресурс = "stats/request/";
	ПараметрыJSON = Новый Структура;
	ПараметрыJSON.Вставить("date_from", ДатуВTimestamp(ДатаНачала));
	ПараметрыJSON.Вставить("date_to", ДатуВTimestamp(ДатаОкончания));                                                          // records
	ПараметрыJSON.Вставить("fields", "start, answer, from_extension, from_number, to_extension, to_number, finish, line_number, entry_id");
	//1662722742;1662722754;22;sip:robotvoicia@vpbx400264382.mangosip.ru;;79004854878;1662722762;79585780301;[]
	HTTPОтвет = ВыполнитьЗапрос(Ресурс, ПараметрыJSON, ApiKey, ApiSalt); 
	Если HTTPОтвет.КодСостояния <> 200 Тогда
		Сообщить("Ошибка, ключ не получен. Код Состояния = " + HTTPОтвет.КодСостояния);
		ЗаписьЖурналаРегистрации("Фоновая выгрузка звонков(Манго). Ошибка", ,,,"Ключ не получен. Код Состояния " + HTTPОтвет.КодСостояния, РежимТранзакцииЗаписиЖурналаРегистрации.Независимая); 
		Возврат ""; 
	КонецЕсли;
	
	ТекстОтвета = HTTPОтвет.ПолучитьТелоКакСтроку(КодировкаТекста.UTF8);
	Данные = Неопределено;
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(ТекстОтвета);
	Данные = ПрочитатьJSON(ЧтениеJSON, Истина);
	ЧтениеJSON.Закрыть();
	
	ПолученныйКлюч = Данные.Получить("key");
	Возврат ПолученныйКлюч;
	
КонецФункции

Функция ПолучитьОтветПоКлючу(Ключ, ApiKey, ApiSalt)
	
	Ресурс = "stats/result/";
	
	ПараметрыJSON = Новый Структура;
	ПараметрыJSON.Вставить("key", Ключ);
	
	HTTPОтвет = ВыполнитьЗапрос(Ресурс, ПараметрыJSON, ApiKey, ApiSalt);
	Возврат HTTPОтвет;
	
КонецФункции

#КонецОбласти



#Область СозданиеДокументов

Процедура СоздатьДокументы(Результат)
	МассивРезультатов = СтрРазделить(Результат, Символы.ПС, Ложь);
	Для Индекс = 0 По МассивРезультатов.Количество() - 1 Цикл
		Строка = МассивРезультатов[Индекс];
		МассивСтрок = СтрРазделить(Строка, ";", Истина);
		Если Строка(МассивСтрок[1]) = Строка("0") Тогда
			//Результат.ЗаменитьСтроку(Индекс,Строка + " --- НЕДОБАВЛЕНО!");
			Успешность = Ложь;
			Длительность = 0;
		Иначе
			Успешность = Истина;
			Длительность = Число(МассивСтрок[6]) - Число(МассивСтрок[1]);
		КонецЕсли;
		
		Если Строка(МассивСтрок[2]) <> "" И Строка(МассивСтрок[4]) <> ""  Тогда
			//Результат.ЗаменитьСтроку(Индекс,Строка + " --- Не подходит!");
			
			//Продолжить; Заремил 2019-04-19
			
		КонецЕсли;
		Входящий = (СтрНайти(МассивСтрок[3],"@") = 0);
		TimeStamp =  дата(1970,1,1,1,0,0) + (число(МассивСтрок[0])+7200);
		ЛинияНомер = МассивСтрок[7];
		IDЗаписи = ПолучитьIDЗаписи(МассивСтрок[8]);
		Если Входящий Тогда
			ВнутрНомер = МассивСтрок[4];
			НомерКлиента = МассивСтрок[3];
			SIPНомер = Сред(МассивСтрок[5],5);
		Иначе
			ВнутрНомер = МассивСтрок[2];
			НомерКлиента = МассивСтрок[5];
			SIPНомер = Сред(МассивСтрок[3],5);
		КонецЕсли;
		Если ВнутрНомер = "" Тогда
			ВнутрНомер = -1;	
		КонецЕсли;
		
		//Если ЗаписанРанее(TimeStamp, НомерКлиента, IDЗаписи) Тогда
		//	//Результат.ЗаменитьСтроку(Индекс, Строка + " --- Записан ранее!");
		//	Продолжить;
		//КонецЕсли;
		
		СоздатьДокумент(TimeStamp, Входящий, НомерКлиента, ВнутрНомер, Длительность, ЛинияНомер, Успешность, IDЗаписи, SIPНомер);
		
		//Объект.Результат.ЗаменитьСтроку(Индекс, Строка + " --- Записан! Номер сотрудника = " + ВнутрНомер + " Номер клиента = " + НомерКлиента);
		
		
	КонецЦикла;	
	
КонецПроцедуры 

Функция ПолучитьIDЗаписи(ПолеЗаписей)
	ПолеЗаписей = Лев(ПолеЗаписей, СтрДлина(ПолеЗаписей) - 1);
	ПолеЗаписей = Прав(ПолеЗаписей, СтрДлина(ПолеЗаписей) - 1);
	ИдентификаторыРазговоров = СтрРазделить(ПолеЗаписей, ",", Истина);
	ИдентификаторРазговора = ИдентификаторыРазговоров[0];
	Возврат ИдентификаторРазговора;
КонецФункции

Функция ЗаписанРанее(TimeStamp, НомерКлиента, IDЗаписи)
	//Запрос = Новый Запрос;
	//Запрос.Текст = 
	//"ВЫБРАТЬ
	//|	ALX_ИсторияЗагрузкиТелефонныхЗвонков.TimeStamp КАК TimeStamp,
	//|	ALX_ИсторияЗагрузкиТелефонныхЗвонков.Карточка КАК Карточка
	//|ИЗ
	//|	РегистрСведений.ALX_ИсторияЗагрузкиТелефонныхЗвонков КАК ALX_ИсторияЗагрузкиТелефонныхЗвонков
	//|ГДЕ
	//|	ALX_ИсторияЗагрузкиТелефонныхЗвонков.TimeStamp = &TimeStamp
	//|	И ALX_ИсторияЗагрузкиТелефонныхЗвонков.НомерКлиента = &НомерКлиента";
	//
	//Запрос.УстановитьПараметр("TimeStamp", TimeStamp);
	//Запрос.УстановитьПараметр("НомерКлиента", НомерКлиента);
	//
	//РезультатЗапроса = Запрос.Выполнить();
	//
	//ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	//
	//Если ВыборкаДетальныеЗаписи.Следующий() Тогда
	//	Звонок = ВыборкаДетальныеЗаписи.Карточка.ПолучитьОбъект();
	//	Попытка
	//		Если Звонок =Неопределено тогда 
	//			Возврат Ложь; 
	//		Иначе
	//			Если НЕ ЗначениеЗаполнено(Звонок.ALX_IDЗаписи) Тогда
	//				Звонок.ALX_IDЗаписи = IDЗаписи;
	//				Звонок.Записать();
	//			КонецЕсли;
	//		КонецЕсли;
	//		Исключение
	//			Возврат Ложь; 
	//		КонецПопытки;
	//	
	//	Возврат Истина; 
	//Иначе
	//	Возврат Ложь; 
	//КонецЕсли;
	
КонецФункции

Процедура СоздатьДокумент(TimeStamp, Входящий, НомерКлиента, ВнутрНомер, Длительность, ЛинияНомер, Успешность, IDЗаписи, SIPНомер)
	
	Нашли = ложь;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МаршрутЗвонков.IDЗаписи КАК IDЗаписи
	|ИЗ
	|	РегистрСведений.МаршрутЗвонков КАК МаршрутЗвонков
	|ГДЕ
	|	МаршрутЗвонков.IDЗаписи = &IDЗаписи";
	
	Запрос.УстановитьПараметр("IDЗаписи", IDЗаписи);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Нашли = Истина;
		//		ЭлементДокумента = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
	КонецЦикла;
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	Если Нашли = Ложь Тогда
		МассивСтрок = Новый Массив;
		Для Сч = 1 По СтрДлина(НомерКлиента) Цикл
			МассивСтрок.Добавить(Сред(НомерКлиента, Сч, 1));
		КонецЦикла;
		МассивСтрок[0] = "+"+МассивСтрок[0];
		МассивСтрок[1] = " "+МассивСтрок[1];
		МассивСтрок[4] = " "+МассивСтрок[4];
		МассивСтрок[7] = "-"+МассивСтрок[7];
		МассивСтрок[9] = "-"+МассивСтрок[9];
		НомерКлиента = СтрСоединить(МассивСтрок,"");
		
		МассивСтрок = Новый Массив;
		Для Сч = 1 По СтрДлина(ЛинияНомер) Цикл
			МассивСтрок.Добавить(Сред(ЛинияНомер, Сч, 1));
		КонецЦикла;
		МассивСтрок[0] = "+"+МассивСтрок[0];
		МассивСтрок[1] = " "+МассивСтрок[1];
		МассивСтрок[4] = " "+МассивСтрок[4];
		МассивСтрок[7] = "-"+МассивСтрок[7];
		МассивСтрок[9] = "-"+МассивСтрок[9];
		ЛинияНомер = СтрСоединить(МассивСтрок,"");

		
		//ЭлементДокумента = Документы.ТелефонныйЗвонок.СоздатьДокумент();
		МенеджерЗаписи = РегистрыСведений.МаршрутЗвонков.СоздатьМенеджерЗаписи();
		
		МенеджерЗаписи.ВнутреннийНомер = ВнутрНомер;
		МенеджерЗаписи.ЗаявкаКлиента   = Получитьзаявку(НомерКлиента,TimeStamp);
		МенеджерЗаписи.Длительность    = Длительность;
		МенеджерЗаписи.ЛинияНомер 	   = ЛинияНомер;
		МенеджерЗаписи.Успешность	   = Успешность;
		МенеджерЗаписи.IDЗаписи 	   = IDЗаписи;
		МенеджерЗаписи.Входящий 	   = Входящий;
		МенеджерЗаписи.SIPНомер 	   = SIPНомер;
		МенеджерЗаписи.Телефон 		   = НомерКлиента;
		МенеджерЗаписи.Дата 		   = TimeStamp;
		
		МенеджерЗаписи.Записать();
		
	КонецЕсли;		
	//ЭлементДокумента.Дата = TimestampВДату(TimeStamp);
	//ЭлементДокумента.Входящий = Входящий;
	//ЭлементДокумента.ALX_Длительность = Длительность;
	//ЭлементДокумента.ALX_ЗвонокУспешен = Успешность;
	//ЭлементДокумента.ALX_ЛинияНомер = ЛинияНомер;
	//ЭлементДокумента.ALX_IDЗаписи = IDЗаписи;
	//ЭлементДокумента.ALX_SIPНомер = SIPНомер;
	//ЭлементДокумента.ALX_ЗагруженоАвтоматически = Истина;
	//
	//ЭлементДокумента.АбонентКонтакт = ПоискКонтактаПолный(НомерКлиента);
	//Если ЭлементДокумента.АбонентКонтакт = Неопределено или  НЕ ЭлементДокумента.АбонентКонтакт.Пустая() Тогда
	//	ВзаимодействияВызовСервера.ПредставлениеИВсяКонтактнаяИнформациюКонтакта(ЭлементДокумента.АбонентКонтакт,
	//	ЭлементДокумента.АбонентПредставление,
	//	ЭлементДокумента.АбонентКакСвязаться);
	//Иначе
	//	ЭлементДокумента.АбонентПредставление = "+" + Строка(НомерКлиента);
	//	ЭлементДокумента.АбонентКакСвязаться = "+" + Строка(НомерКлиента);	
	//КонецЕсли;
	//ЭлементДокумента.Тема = "Телефонный звонок";
	//ЭлементДокумента.Описание = "Загружено автоматически из Mango Office " + ТекущаяДата()+ " "+Число(ВнутрНомер);
	//ЭлементДокумента.Автор = Справочники.Пользователи.НайтиПоРеквизиту("ALX_ВнутреннийНомер", Число(ВнутрНомер)); //Пользователи.ТекущийПользователь();
	//
	//ЭлементДокумента.Ответственный = ПоискОтветственного(ВнутрНомер);		
	//ЭлементДокумента.Ответственный = Справочники.Пользователи.НайтиПоРеквизиту("ALX_ВнутреннийНомер", Число(ВнутрНомер));
	//ЭлементДокумента.ОбменДанными.Загрузка = Истина; //new 2019-03-25
	//ЭлементДокумента.ОТветственный = ПараметрыСеанса.ТекущийПользователь;  //new 2019-03-25
	//
	//ЭлементДокумента.Записать(РежимЗаписиДокумента.Запись);
	//Взаимодействия.ПриЗаписиПредметаИзФормы(ЭлементДокумента.Ссылка, ЭлементДокумента.Ссылка, Ложь);
	//
	//ВзаимодействияВызовСервера.ПредставлениеИВсяКонтактнаяИнформациюКонтакта(ЭлементДокумента.АбонентКонтакт,
	//	ЭлементДокумента.АбонентПредставление,
	//	ЭлементДокумента.АбонентКакСвязаться);
	
	
	Если ЗначениеЗаполнено(IDЗаписи) = Ложь И Успешность = Истина Тогда    //ЭлементДокумента.Ссылка
		ЗаписьЖурналаРегистрации("Фоновая выгрузка звонков(Манго). Предупреждение",,,,"ID записи не получен", РежимТранзакцииЗаписиЖурналаРегистрации.Независимая); 
	КонецЕсли;
КонецПроцедуры

Функция Получитьзаявку(НомерКлиента,TimeStamp)
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗаказКлиента.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ЗаказКлиента КАК ЗаказКлиента
	|ГДЕ
	|	ЗаказКлиента.Дата >= &Дата
	|	И ЗаказКлиента.ДатаИзмененияСостояния <= &ДатаИзмененияСостояния
	|	И ЗаказКлиента.НомерТелефона = &НомерТелефона";
	
	Запрос.УстановитьПараметр("Дата",НачалоДня(TimeStamp));
	Запрос.УстановитьПараметр("ДатаИзмененияСостояния",КонецДня(TimeStamp));
	Запрос.УстановитьПараметр("НомерТелефона",НомерКлиента);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	Возврат Выборка.ссылка;
КонецФункции




Функция ПоискКонтактаВСправочнике(НомерКлиента, НазваниеСправочника)
	
	//new 08.04.19
	//	Для каждого Измерение Из Метаданные.РегистрыСведений.КонтактнаяИнформация.Измерения Цикл
	//	РегистрСведенийСписок.Колонки.Добавить(Измерение.Имя);
	//КонецЦикла;
	//Для каждого Ресурс Из Метаданные.РегистрыСведений.КонтактнаяИнформация.Ресурсы Цикл
	//	РегистрСведенийСписок.Колонки.Добавить(Ресурс.Имя);
	//КонецЦикла;
	//Для каждого Реквизит Из Метаданные.РегистрыСведений.КонтактнаяИнформация.Реквизиты Цикл
	//	РегистрСведенийСписок.Колонки.Добавить(Реквизит.Имя);
	//КонецЦикла;
	
	
	АбонентКонтакт = Неопределено;
	//Ищем контакт по номеру
	ВариантНомера1 = НомерКлиента;
	ВариантНомера2 = "+" + Строка(НомерКлиента);
	ВариантНомера3 = Строка(8) + Сред(НомерКлиента,2);
	ВариантНомера4 = Сред(ВариантНомера1,1,1) + "-" + Сред(ВариантНомера1,2,3) + "-" + Сред(ВариантНомера1,5,3) + "-" + Сред(ВариантНомера1,8,2) + "-" + Сред(ВариантНомера1,10,2);
	ВариантНомера5 = Сред(ВариантНомера2,1,2) + "-" + Сред(ВариантНомера2,3,3) + "-" + Сред(ВариантНомера2,6,3) + "-" + Сред(ВариантНомера2,9,2) + "-" + Сред(ВариантНомера2,11,2);
	ВариантНомера6 = Сред(ВариантНомера3,1,1) + "-" + Сред(ВариантНомера3,2,3) + "-" + Сред(ВариантНомера3,5,3) + "-" + Сред(ВариантНомера3,8,2) + "-" + Сред(ВариантНомера3,10,2);
	ВариантНомера7 = Сред(НомерКлиента,2);
	ВариантНомера8 = Сред(ВариантНомера7,1,3) + "-" + Сред(ВариантНомера7,4,3) + "-" + Сред(ВариантНомера7,7,2) + "-" + Сред(ВариантНомера7,9,2);
	
	//	Попытка	 //new 2019-03-25 переделать на регистр сведений
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КонтактнаяИнформация.Объект КАК Ссылка
	|ИЗ
	|	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
	|ГДЕ
	|	КонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Телефон)
	|	И (КонтактнаяИнформация.Представление ПОДОБНО &ВариантНомера1
	|			ИЛИ КонтактнаяИнформация.Представление ПОДОБНО &ВариантНомера2
	|			ИЛИ КонтактнаяИнформация.Представление ПОДОБНО &ВариантНомера3
	|			ИЛИ КонтактнаяИнформация.Представление ПОДОБНО &ВариантНомера4
	|			ИЛИ КонтактнаяИнформация.Представление ПОДОБНО &ВариантНомера5
	|			ИЛИ КонтактнаяИнформация.Представление ПОДОБНО &ВариантНомера6
	|			ИЛИ КонтактнаяИнформация.Представление ПОДОБНО &ВариантНомера7
	|			ИЛИ КонтактнаяИнформация.Представление ПОДОБНО &ВариантНомера8)";
	
	Запрос.УстановитьПараметр("ВариантНомера1", ВариантНомера1);
	Запрос.УстановитьПараметр("ВариантНомера2", ВариантНомера2);
	Запрос.УстановитьПараметр("ВариантНомера3", ВариантНомера3);
	Запрос.УстановитьПараметр("ВариантНомера4", ВариантНомера4);
	Запрос.УстановитьПараметр("ВариантНомера5", ВариантНомера5);
	Запрос.УстановитьПараметр("ВариантНомера6", ВариантНомера6);
	Запрос.УстановитьПараметр("ВариантНомера7", ВариантНомера7);
	Запрос.УстановитьПараметр("ВариантНомера8", ВариантНомера8);
	
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда		
		
		АбонентКонтакт = ВыборкаДетальныеЗаписи.Ссылка;
		Сообщить("### "+АбонентКонтакт);
		Возврат АбонентКонтакт;
		
	КонецЕсли;
	//Исключение
	//	КонецПопытки;
	
	Если АбонентКонтакт = Неопределено Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ALX_ПотенциальныеПартнеры.Ссылка   как ссылка
		|ИЗ
		|	Справочник.ALX_ПотенциальныеПартнеры КАК ALX_ПотенциальныеПартнеры
		|ГДЕ
		|	ALX_ПотенциальныеПартнеры.Телефон подобно &ВариантНомера1
		|			ИЛИ ALX_ПотенциальныеПартнеры.Телефон ПОДОБНО &ВариантНомера2
		|			ИЛИ ALX_ПотенциальныеПартнеры.Телефон ПОДОБНО &ВариантНомера3
		|			ИЛИ ALX_ПотенциальныеПартнеры.Телефон ПОДОБНО &ВариантНомера4
		|			ИЛИ ALX_ПотенциальныеПартнеры.Телефон ПОДОБНО &ВариантНомера5
		|			ИЛИ ALX_ПотенциальныеПартнеры.Телефон ПОДОБНО &ВариантНомера6
		|			ИЛИ ALX_ПотенциальныеПартнеры.Телефон ПОДОБНО &ВариантНомера7
		|			ИЛИ ALX_ПотенциальныеПартнеры.Телефон ПОДОБНО &ВариантНомера8
		|";
		
		Запрос.УстановитьПараметр("ВариантНомера1", ВариантНомера1);
		Запрос.УстановитьПараметр("ВариантНомера2", ВариантНомера2);
		Запрос.УстановитьПараметр("ВариантНомера3", ВариантНомера3);
		Запрос.УстановитьПараметр("ВариантНомера4", ВариантНомера4);
		Запрос.УстановитьПараметр("ВариантНомера5", ВариантНомера5);
		Запрос.УстановитьПараметр("ВариантНомера6", ВариантНомера6);
		Запрос.УстановитьПараметр("ВариантНомера7", ВариантНомера7);
		Запрос.УстановитьПараметр("ВариантНомера8", ВариантНомера8);
		
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			АбонентКонтакт = ВыборкаДетальныеЗаписи.Ссылка;
			Сообщить("### "+АбонентКонтакт);
			Возврат АбонентКонтакт;
			
		КонецЦикла;
	КонецЕсли;	
	
	
	
	
	
	Возврат АбонентКонтакт;
	
	
	//		АбонентКонтакт = Неопределено;
	//		//Ищем контакт по номеру
	//		ВариантНомера1 = НомерКлиента;
	//		ВариантНомера2 = "+" + Строка(НомерКлиента);
	//		ВариантНомера3 = Строка(8) + Сред(НомерКлиента,2);
	//		ВариантНомера4 = Сред(ВариантНомера1,1,1) + "-" + Сред(ВариантНомера1,2,3) + "-" + Сред(ВариантНомера1,5,3) + "-" + Сред(ВариантНомера1,8,2) + "-" + Сред(ВариантНомера1,10,2);
	//		ВариантНомера5 = Сред(ВариантНомера2,1,2) + "-" + Сред(ВариантНомера2,3,3) + "-" + Сред(ВариантНомера2,6,3) + "-" + Сред(ВариантНомера2,9,2) + "-" + Сред(ВариантНомера2,11,2);
	//		ВариантНомера6 = Сред(ВариантНомера3,1,1) + "-" + Сред(ВариантНомера3,2,3) + "-" + Сред(ВариантНомера3,5,3) + "-" + Сред(ВариантНомера3,8,2) + "-" + Сред(ВариантНомера3,10,2);
	//		ВариантНомера7 = Сред(НомерКлиента,2);
	//		ВариантНомера8 = Сред(ВариантНомера7,1,3) + "-" + Сред(ВариантНомера7,4,3) + "-" + Сред(ВариантНомера7,7,2) + "-" + Сред(ВариантНомера7,9,2);
	
	//	Попытка	 //new 2019-03-25 переделать на регистр сведений
	//	Запрос = Новый Запрос;
	//	Запрос.Текст = 
	//		"ВЫБРАТЬ
	//		|	СправочникКонтактнаяИнформация.Ссылка КАК Ссылка
	//		|ИЗ
	//		|	Справочник." + НазваниеСправочника + ".КонтактнаяИнформация КАК СправочникКонтактнаяИнформация
	//		|ГДЕ
	//		|	СправочникКонтактнаяИнформация.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтактнойИнформации.Телефон)
	//		|	И (СправочникКонтактнаяИнформация.Представление = &ВариантНомера1
	//		|			ИЛИ СправочникКонтактнаяИнформация.Представление = &ВариантНомера2
	//		|			ИЛИ СправочникКонтактнаяИнформация.Представление = &ВариантНомера3
	//		|			ИЛИ СправочникКонтактнаяИнформация.Представление = &ВариантНомера4
	//		|			ИЛИ СправочникКонтактнаяИнформация.Представление = &ВариантНомера5
	//		|			ИЛИ СправочникКонтактнаяИнформация.Представление = &ВариантНомера6
	//		|			ИЛИ СправочникКонтактнаяИнформация.Представление = &ВариантНомера7
	//		|			ИЛИ СправочникКонтактнаяИнформация.Представление = &ВариантНомера8)";
	//	
	//	Запрос.УстановитьПараметр("ВариантНомера1", ВариантНомера1);
	//	Запрос.УстановитьПараметр("ВариантНомера2", ВариантНомера2);
	//	Запрос.УстановитьПараметр("ВариантНомера3", ВариантНомера3);
	//	Запрос.УстановитьПараметр("ВариантНомера4", ВариантНомера4);
	//	Запрос.УстановитьПараметр("ВариантНомера5", ВариантНомера5);
	//	Запрос.УстановитьПараметр("ВариантНомера6", ВариантНомера6);
	//	Запрос.УстановитьПараметр("ВариантНомера7", ВариантНомера7);
	//	Запрос.УстановитьПараметр("ВариантНомера8", ВариантНомера8);
	//	
	//	
	//	РезультатЗапроса = Запрос.Выполнить();
	//	
	//	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	//	
	//	Если ВыборкаДетальныеЗаписи.Следующий() Тогда		
	//		
	//		АбонентКонтакт = ВыборкаДетальныеЗаписи.Ссылка;
	//		Возврат АбонентКонтакт;
	//		
	//	КонецЕсли;
	//Исключение
	//	КонецПопытки;
	//	Возврат АбонентКонтакт;
	
КонецФункции

Функция ПоискКонтактаПолный(НомерКлиента)
	
	
	Контакт = ПоискКонтактаВСправочнике(НомерКлиента, "Пользователи");
	Если НЕ Контакт = Неопределено Тогда
		Возврат Контакт;
	КонецЕсли;
	
	//new 08.04.19
	//Контакт = ПоискКонтактаВСправочнике(НомерКлиента, "Партнеры");
	Контакт = ПоискКонтактаВСправочнике(НомерКлиента, "сбз_Клиенты");
	Если НЕ Контакт = Неопределено Тогда
		Возврат Контакт;
	КонецЕсли;
	
	
	//Контакт = ПоискКонтактаВСправочнике(НомерКлиента, "КонтактныеЛицаПартнеров");
	//Если НЕ Контакт = Неопределено Тогда
	//	Возврат Контакт;
	//КонецЕсли;
	
	//Контакт = ПоискКонтактаВСправочнике(НомерКлиента, "ФизическиеЛица");
	//Если НЕ Контакт = Неопределено Тогда
	//	Возврат Контакт;
	//КонецЕсли;
	
	Возврат Справочники.сбз_Клиенты.ПустаяСсылка();//СтроковыеКонтактыВзаимодействий.ПустаяСсылка();
	
КонецФункции

//Не используется
Функция ПоискОтветственного(ВнутрНомер)
	
	Ответственный = Справочники.Пользователи.ПустаяСсылка();
	//Ищем ответственного по внутреннему номеру
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПользователиКонтактнаяИнформация.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Пользователи.КонтактнаяИнформация КАК ПользователиКонтактнаяИнформация
	|ГДЕ
	|	ПользователиКонтактнаяИнформация.Вид = &ВидКИ
	|	И ПользователиКонтактнаяИнформация.Представление = &ВнутрНомер
	|	И ПользователиКонтактнаяИнформация.Тип = &ТипКИ";
	
	ВидКИ = Справочники.ВидыКонтактнойИнформации.EmailПользователя;   //!!! Установить тип и вид КИ в зависимости от того как реализован внутр номер.
	ТипКИ = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты;
	Запрос.УстановитьПараметр("ВидКИ", ВидКИ);
	Запрос.УстановитьПараметр("ТипКИ", ТипКИ);
	Запрос.УстановитьПараметр("ВнутрНомер", ВнутрНомер);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		
		Ответственный = ВыборкаДетальныеЗаписи.Ссылка;
		
	КонецЕсли;
	
	Возврат Ответственный;
	
КонецФункции

#КонецОбласти


#Область РаботаСНастройками

Функция ПолучитьСтруктуруНастроек() Экспорт 
	Настройки = Новый Структура;
	Настройки.Вставить("ДатаПоследнейЗагрузки", Константы.ALX_ДатаНачалоМанго.Получить());
	
	Возврат Настройки;
	
КонецФункции

Процедура СохранитьНастройки(СтруктураНастроек) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	ХранилищеОбщихНастроек.Удалить(ИдентификаторНастроек(), "Настройки", "Я");
	ХранилищеОбщихНастроек.Сохранить(ИдентификаторНастроек(), "Настройки", СтруктураНастроек,,"Я"); 
	УстановитьПривилегированныйРежим(Ложь);
КонецПроцедуры

Функция ИдентификаторНастроек() Экспорт	
	Возврат "b5d3241f-3f1c-46f2-8cfc-0641caddc704";
КонецФункции

Функция ПолучитьНастройки() Экспорт
	//
	//УстановитьПривилегированныйРежим(Истина);
	
	//Настройки = ХранилищеОбщихНастроек.Загрузить(ИдентификаторНастроек(),"Настройки",,"Я");
	
	//УстановитьПривилегированныйРежим(Ложь);
	//
	//Возврат Настройки;
КонецФункции
#КонецОбласти



// HTTPОтвет - HTTPОтвет с отчетом по звонкам
Процедура ОбработкаОтвета(HTTPОтвет)
	
	РезультатТекст = HTTPОтвет.ПолучитьТелоКакСтроку(КодировкаТекста.UTF8);
	
	//ТекстовыйДокИзФайла = Новый ТекстовыйДокумент;
	//ТекстовыйДокИзФайла.УстановитьТекст(РезультатТекст);
	
	СоздатьДокументы(РезультатТекст);
	
КонецПроцедуры

&НаСервере
Процедура ИнициироватьВызов(Телефон = "", Пользователь) Экспорт
	
	//Если Пользователь.ALX_ВнутреннийНомер <= 0 Тогда
	//	Сообщить("Внутренний номер сотрудника не заполнен");
	//	Возврат;
	//КонецЕсли;
	
	//
	//Ресурс = "commands/callback/";
	//ПараметрыJSON = Новый Структура; 
	//ПараметрыJSON.Вставить("command_id", "id" + Формат(ТекущаяДата(), "ДФ=yyyy_MM_dd_HH_mm_ss"));
	//ПараметрыJSON.Вставить("from", Новый Структура("extension", Пользователь.ALX_ВнутреннийНомер));
	//ПараметрыJSON.Вставить("to_number", Телефон);
	
	//HTTPОтвет = ALX_РегламентнаяЗагрузкаЗвонковМанго.ВыполнитьЗапрос(Ресурс, ПараметрыJSON, Константы.ALX_КлючApiМанго.Получить(), Константы.ALX_ApiSaltМанго.Получить());
	//Текст = HTTPОтвет.ПолучитьТелоКакСтроку();
	//	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("txt");
	//	ТекстовыйФайл = Новый ТекстовыйДокумент;
	//	ТекстовыйФайл.УстановитьТекст(Текст);
	//	ТекстовыйФайл.Записать(ИмяВременногоФайла,"UTF-8");
	//	Данные = ДесериализоватьJson(ИмяВременногоФайла);
	//	Если Данные.result <> 1000 Тогда
	//		Сообщить("Не удалось инициировать вызов. Код " + Данные.result);
	//	КонецЕсли;
	//
	
КонецПроцедуры

функция ДесериализоватьJson(ФайлРезультата) Экспорт 
	
	ЧтениеJSON = Новый ЧтениеJSON();
	ЧтениеJSON.ОткрытьФайл(ФайлРезультата);
	Данные = ПрочитатьJSON(ЧтениеJSON);
	ЧтениеJSON.Закрыть();
	
	Возврат Данные;
	
КонецФункции



//new 2019-05-13
Процедура API_ЗагрузкаЗвонковБитрикс_Часто() Экспорт
	
	//Обработки.РаботаСБитрикс24.Создать().ВыполнитьКомандуЧасто();
	
КонецПроцедуры

Процедура API_ЗагрузкаЗвонковБитрикс_Редко() Экспорт
	
	//Обработки.РаботаСБитрикс24.Создать().ВыполнитьКомандуРедко();
	
КонецПроцедуры


Процедура API_ЗагрузкаЗвонковБитрикс_Сутки() Экспорт
	
	//Обработки.РаботаСБитрикс24.Создать().ВыполнитьКомандуСутки();
	
КонецПроцедуры

