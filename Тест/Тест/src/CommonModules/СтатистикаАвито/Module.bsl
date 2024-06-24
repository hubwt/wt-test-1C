
Процедура ЗагрузкаСтатистикиАвитоОбщее() Экспорт
	ПолучитьДанныеПоAPI();
КонецПроцедуры


Процедура ПолучитьДанныеПоAPI()
	// Client_id: h3Y0NLPluWhBOHEur8lW
	// Client_secret:ShPrNQWe0i8Ja9-48bAo8eRMOUI7IIR3UsIAp6Bl 
	
	КолвоПросмотры = 0;
	КолвоКонтакты = 0;
	КолвоЗвонки = 0;
	КолвоЗаказы = 0;
	КолвоОбъявления = 0;
	
	АккаунтАвито1 = Новый Структура;
	АккаунтАвито1.Вставить("Логин", "v4139638@yandex.ru");
	АккаунтАвито1.Вставить("Пароль", "AvitoWorkTruckNN32551201");
	АккаунтАвито1.Вставить("Кабинет", "12888398");
	АккаунтАвито1.Вставить("Ключи", "grant_type=client_credentials&client_id=h3Y0NLPluWhBOHEur8lW&client_secret=ShPrNQWe0i8Ja9-48bAo8eRMOUI7IIR3UsIAp6Bl"); 
	
	АккаунтАвито2 = Новый Структура;
	АккаунтАвито2.Вставить("Логин", "79527606909");
	АккаунтАвито2.Вставить("Пароль", "ZapchastiScania2023");
	АккаунтАвито2.Вставить("Кабинет", "360545860" );      
	АккаунтАвито2.Вставить("Ключи", "grant_type=client_credentials&client_id=Gk7B0OIRiEDmdqfegMK0&client_secret=fnumkg89Z32x7OhCe2_CELnZtDIszfSXi072P7jQ"); 
	
	АккаунтАвито3 = Новый Структура;
	АккаунтАвито3.Вставить("Логин", "a.volodin@worktruck.ru");
	АккаунтАвито3.Вставить("Пароль", "WorkTruckAvito3825912");
	АккаунтАвито3.Вставить("Кабинет", "233345896");  
	АккаунтАвито3.Вставить("Ключи", "grant_type=client_credentials&client_id=JyiEPUHfypxQYdcTG_lZ&client_secret=lowJHykP8FpUpsF4Rr3blYlXtbVpfH6sjEzSnXvF"); 
	
	МассивАккаунтов = Новый Массив;
	МассивАккаунтов.Добавить(АккаунтАвито1);
	МассивАккаунтов.Добавить(АккаунтАвито2);
	МассивАккаунтов.Добавить(АккаунтАвито3);
	
	Для каждого Аккаунт Из МассивАккаунтов Цикл
		Соединение = ПолучитьСоединение("api.avito.ru", Аккаунт.Логин, Аккаунт.Пароль);             
		
		
		Заголовки = Новый Соответствие;    
		Заголовки.Вставить("Content-Type", "application/x-www-form-urlencoded;");
		
		Запрос = Новый HTTPЗапрос("/token",Заголовки);
		
		
		СтрокаJSON = Аккаунт.Ключи;
		Запрос.УстановитьТелоИзСтроки(СтрокаJSON);	
		Попытка
			Ответ = Соединение.ОтправитьДляОбработки(Запрос);
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрШаблон("Не удалось получить список звонков. %1",
			ОписаниеОшибки()),
			,
			,
			,
			//Отказ
			);
			//Возврат Результат;
		КонецПопытки;
		ТекстОтвета = Ответ.ПолучитьТелоКакСтроку();
		
		Если Ответ.КодСостояния <> 200 Тогда
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ИзвлечьТекстИзHTML(ТекстОтвета);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			,
			,
			,
			//Отказ
			);
			
		КонецЕсли; 
		ЧтениеJSON = Новый ЧтениеJSON();
		ЧтениеJSON.УстановитьСтроку(ТекстОтвета);
		
		Ответ  = ПрочитатьJSON(ЧтениеJSON);
		//Сообщить(ответ.access_token);
		
		//////////////////////////////////////////////////////////////////////	
		
		//ПолучитьБаланс(Соединение,Ответ.access_token);
		ПросмотрыИКонтакты = ПолучитьПросмотрыИКонтакты(Соединение, Ответ.access_token, Аккаунт.Кабинет);
		КолвоПросмотры = КолвоПросмотры + ПросмотрыИКонтакты.Просмотры;
		КолвоКонтакты = КолвоКонтакты + ПросмотрыИКонтакты.Контакты;

		КолвоЗвонки = КолвоЗвонки + ПолучитьЗвонки(Соединение,Ответ.access_token); 
		КолвоЗаказы = КолвоЗаказы + ПолучитьКоличествоЗаказов(Соединение,Ответ.access_token);  
		КолвоОбъявления = КолвоОбъявления + ПолучитьКоличествоактуальныхОбъявлений(Соединение,Ответ.access_token, Аккаунт.Кабинет ); 
	КонецЦикла;
	   		 // Записываем в регистр сведений общую информацию
		 ЗаписьВРегистреСведений = РегистрыСведений.СтатистикаАвито.СоздатьМенеджерЗаписи();
         ЗаписьВРегистреСведений.Период = ТекущаяДата() - 86400;
		 ЗаписьВРегистреСведений.КоличествоПросмотров = КолвоПросмотры;
		 ЗаписьВРегистреСведений.КоличествоКонтактов = КолвоКонтакты;
		 ЗаписьВРегистреСведений.КоличествоЗвонков = КолвоЗвонки;
		 ЗаписьВРегистреСведений.КоличествоЗаказов = КолвоЗаказы;
		 ЗаписьВРегистреСведений.КоличествоОбъявлений = КолвоОбъявления;
		 ЗаписьВРегистреСведений.Записать();
		
КонецПроцедуры


функция ПолучитьКоличествоактуальныхОбъявлений(Соединение,access_token, Кабинет)
	
	Заголовки = Новый Соответствие;    
	Заголовки.Вставить("Content-Type", "application/json");
	Заголовки.Вставить("Authorization", "Bearer " + access_token); 
	Заголовки.Вставить("X-Source", "1C");
	
	Количество = 0;
	Условие = Истина;
	Страница = 1;
	
	Пока Условие = Истина Цикл
		Запрос = Новый HTTPЗапрос("/core/v1/items?status=active&per_page=100&page=" + Страница, Заголовки);
		
		Попытка
			Ответ = Соединение.ВызватьHTTPМетод("GET", Запрос);
		Исключение
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Не удалось выполнить запрос " + ОписаниеОшибки();
			Сообщение.Сообщить();
			Прервать; // Выход из цикла в случае ошибки
		КонецПопытки;
		
		Если Ответ.КодСостояния = 200 Тогда
			ТелоОтвета = Ответ.ПолучитьТелоКакСтроку();
			ЧтениеJSON = Новый ЧтениеJSON;
			ЧтениеJSON.УстановитьСтроку(ТелоОтвета);
			
			Данные = ПрочитатьJSON(ЧтениеJSON);
			Количество = Количество + Данные.resources.Количество();
			Страница = Страница + 1; 
			
			Если Данные.resources.Количество() = 0 Тогда
				Прервать; // Выход из цикла, если нет данных
			КонецЕсли;
		Иначе
			Сообщить("Не удалось выполнить запрос " + Ответ.КодСостояния);
			Прервать; // Выход из цикла в случае непредвиденного кода состояния
		КонецЕсли;
	КонецЦикла;
	Возврат Количество;
	
КонецФункции


Функция ПолучитьКоличествоЗаказов(Соединение, access_token)
	КоличествоЗаВчерашнийДень = 0;
	КоличествоСегодня = 0; 
	
	Заголовки = Новый Соответствие;    
	Заголовки.Вставить("Content-Type", "application/json");
	Заголовки.Вставить("Authorization", "Bearer " + access_token); 
	Заголовки.Вставить("X-Source", "1C");
	
	ВчерашнийДень 	= ТекущаяДатаСеанса() - 86400;
	НачалоВчерашнегоДня = НачалоДня(ВчерашнийДень); 
	НачалоЭтогоДня = НачалоДня(ТекущаяДата());
	
	unixtime1 = Формат(НачалоВчерашнегоДня - дата(1970,1,1,1,0,0), "ЧГ=0");
	unixtime2 = Формат(НачалоЭтогоДня - дата(1970,1,1,1,0,0), "ЧГ=0"); 
	
	МассивДат = Новый Массив;
	МассивДат.Добавить(unixtime1);
	МассивДат.Добавить(unixtime2);	
	
	Для каждого Элемент Из МассивДат Цикл 
		
		Запрос = Новый HTTPЗапрос("/order-management/1/orders?dateFrom=" + Элемент, Заголовки); 
		
		
		Попытка
			Ответ = Соединение.Получить(Запрос); 
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрШаблон("%1",
			ОписаниеОшибки()),
			,
			,
			,
			);
		КонецПопытки;
		
		Если Ответ.КодСостояния = 200 Тогда
			Тело = Ответ.ПолучитьТелоКакСтроку();  
			ЧтениеJSON = Новый ЧтениеJSON();
			ЧтениеJSON.УстановитьСтроку(Тело); 
			Ответ  = ПрочитатьJSON(ЧтениеJSON); 
			
			Если Элемент = МассивДат[0] Тогда
				КоличествоЗаВчерашнийДень = Ответ.orders.Количество(); 
			ИначеЕсли Элемент = МассивДат[1] Тогда
				КоличествоСегодня = Ответ.orders.Количество();
			КонецЕсли;
			
		Иначе  
			Сообщить("Не удалось выполнить запрос " + Ответ.КодСостояния);  
			
		КонецЕсли;
	КонецЦикла; 
	Возврат (КоличествоЗаВчерашнийДень - КоличествоСегодня);
	
КонецФункции


Функция ПолучитьПросмотрыИКонтакты(Соединение,access_token, Кабинет)     
	Заголовки = Новый Соответствие;    
	Заголовки.Вставить("Content-Type", "application/json");
	Заголовки.Вставить("Authorization", "Bearer " + access_token); 
	Заголовки.Вставить("X-Source", "1C");
	
	Запрос = Новый HTTPЗапрос("/stats/v1/accounts/" + Кабинет + "/items", Заголовки);
	
	ЗапросСтруктура = Новый Структура();	
	
	ВчерашнийДень 	= ТекущаяДатаСеанса() - 86400;
	ДатаНачала 		= НачалоДня(ВчерашнийДень);
	ДатаОкончания 	= КонецДня(ВчерашнийДень);
	
	ФорматRFC822dateTimeFrom 	= Формат(ДатаНачала, 	"ДФ=yyyy-MM-dd") + "T" + ?(Час(ДатаНачала) 			< 10, "0" + Час(ДатаНачала), 		Час(ДатаНачала)) + ":" + 
	?(Минута(ДатаНачала) 		< 10, "0" + Минута(ДатаНачала), 	Минута(ДатаНачала)) + ":" +  
	?(Секунда(ДатаНачала) 		< 10, "0" + Секунда(ДатаНачала), 	Секунда(ДатаНачала)) + "Z";  
	
	ФорматRFC822dateTimeTo 		= Формат(ДатаОкончания, "ДФ=yyyy-MM-dd") + "T" + ?(Час(ДатаОкончания) 		< 10, "0" + Час(ДатаОкончания), 	Час(ДатаОкончания)) + ":" + 
	?(Минута(ДатаОкончания)	< 10, "0" + Минута(ДатаОкончания), 	Минута(ДатаОкончания)) + ":" +  
	?(Секунда(ДатаОкончания) 	< 10, "0" + Секунда(ДатаОкончания), Секунда(ДатаОкончания)) + "Z";
	
	ЗапросСтруктура.Вставить("dateFrom", ФорматRFC822dateTimeFrom); //"2023-11-01T00:00:01Z");
	ЗапросСтруктура.Вставить("dateTo", 	 ФорматRFC822dateTimeTo); //"2023-11-04T00:00:01Z");
	
	ПотокJSON = Новый ЗаписьJSON();
	ПотокJSON.УстановитьСтроку();
	
	ЗаписатьJSON(ПотокJSON, ЗапросСтруктура);
	СтрокаJSON = ПотокJSON.Закрыть();
	Запрос.УстановитьТелоИзСтроки(СтрокаJSON);
	
	Ответ = Соединение.ОтправитьДляОбработки(Запрос);
	ТекстОтвета = Ответ.ПолучитьТелоКакСтроку();
	ЧтениеJSON = Новый ЧтениеJSON();
	ЧтениеJSON.УстановитьСтроку(ТекстОтвета); 
	
	Ответ  = ПрочитатьJSON(ЧтениеJSON); 
	
	КоличествоПросмотров = 0;
	КоличествоКонтактов = 0;
	
	Для каждого ЭллементКорневой из Ответ.result.items Цикл 
		
		Для каждого ЭлементВложенный Из ЭллементКорневой.stats Цикл
			КоличествоПросмотров = КоличествоПросмотров + ЭлементВложенный.uniqViews;
			КоличествоКонтактов = КоличествоКонтактов +  ЭлементВложенный.uniqContacts;
		КонецЦикла;  
		
	КонецЦикла;
	//Сообщить("КоличествоПросмотров " + КоличествоПросмотров + " ---- " + "КоличествоКонтактов " + КоличествоКонтактов);
	ПросмотрыИКонтактыСтр = Новый Структура;
	ПросмотрыИКонтактыСтр.Вставить("Просмотры", КоличествоПросмотров); 
	ПросмотрыИКонтактыСтр.Вставить("Контакты", КоличествоКонтактов);
	
	Возврат ПросмотрыИКонтактыСтр;
КонецФункции


Функция ПолучитьЗвонки(Соединение,access_token)
	
	Заголовки = Новый Соответствие;    
	Заголовки.Вставить("Content-Type", "application/json");
	Заголовки.Вставить("Authorization", "Bearer "+access_token); 
	Заголовки.Вставить("X-Source", "1C");
	
	Запрос = Новый HTTPЗапрос("/calltracking/v1/getCalls/",Заголовки);
	
	
	
	ЗапросСтруктура = Новый Структура();
	
	///+ГомзМА 23.05.2024
	ВчерашнийДень 	= ТекущаяДатаСеанса() - 86400;
	ДатаНачала 		= НачалоДня(ВчерашнийДень);
	ДатаОкончания 	= КонецДня(ВчерашнийДень);
	
	ФорматRFC822dateTimeFrom 	= Формат(ДатаНачала, 	"ДФ=yyyy-MM-dd") + "T" + ?(Час(ДатаНачала) 			< 10, "0" + Час(ДатаНачала), 		Час(ДатаНачала)) + ":" + 
	?(Минута(ДатаНачала) 		< 10, "0" + Минута(ДатаНачала), 	Минута(ДатаНачала)) + ":" +  
	?(Секунда(ДатаНачала) 		< 10, "0" + Секунда(ДатаНачала), 	Секунда(ДатаНачала)) + "Z";  
	
	ФорматRFC822dateTimeTo 		= Формат(ДатаОкончания, "ДФ=yyyy-MM-dd") + "T" + ?(Час(ДатаОкончания) 		< 10, "0" + Час(ДатаОкончания), 	Час(ДатаОкончания)) + ":" + 
	?(Минута(ДатаОкончания)	< 10, "0" + Минута(ДатаОкончания), 	Минута(ДатаОкончания)) + ":" +  
	?(Секунда(ДатаОкончания) 	< 10, "0" + Секунда(ДатаОкончания), Секунда(ДатаОкончания)) + "Z";
	///-ГомзМА 23.05.2024
	
	ЗапросСтруктура.Вставить("dateTimeFrom", ФорматRFC822dateTimeFrom); //"2023-11-01T00:00:01Z");
	ЗапросСтруктура.Вставить("dateTimeTo", 	 ФорматRFC822dateTimeTo); //"2023-11-04T00:00:01Z");
	ЗапросСтруктура.Вставить("limit", 100);
	ЗапросСтруктура.Вставить("offset", 0);
	
	// параметры запроса
	ПотокJSON = Новый ЗаписьJSON();
	ПотокJSON.УстановитьСтроку();
	
	ЗаписатьJSON(ПотокJSON, ЗапросСтруктура);
	СтрокаJSON = ПотокJSON.Закрыть();
	Запрос.УстановитьТелоИзСтроки(СтрокаJSON);
	
	Ответ = Соединение.ОтправитьДляОбработки(Запрос);
	ТекстОтвета = Ответ.ПолучитьТелоКакСтроку();
	ЧтениеJSON = Новый ЧтениеJSON();
	ЧтениеJSON.УстановитьСтроку(ТекстОтвета);
	
	Ответ  = ПрочитатьJSON(ЧтениеJSON);
	Для каждого звонок из Ответ.calls цикл
		//Сообщить("Звонок " + Строка(звонок.callId) + "/"+ звонок.buyerPhone + "/" + звонок.sellerPhone + "/"+ИзменитьФормат(звонок.callTime)+ "/"+звонок.talkDuration); 
		///+ГомзМА 23.05.2024
		//Создаем записи в регистре сведений за прошлый день
		ЗаписьВРегистреСведений = РегистрыСведений.ЗвонкиАвито.СоздатьМенеджерЗаписи();
		ЗаписьВРегистреСведений.Дата 					= ИзменитьФормат(звонок.callTime);
		ЗаписьВРегистреСведений.НомерПокупателя 		= "+" + звонок.buyerPhone;
		ЗаписьВРегистреСведений.НомерПродавца 			= "+" + звонок.sellerPhone;
		ЗаписьВРегистреСведений.ПродолжительностьЗвонка = звонок.talkDuration;
		ЗаписьВРегистреСведений.ИДЗвонка 				= звонок.callId;
		ЗаписьВРегистреСведений.Записать();
		///-ГомзМА 23.05.2024
	КонецЦикла;
	Возврат Ответ.calls.Количество();
КонецФункции

Функция ПреобразоватьRFC822КДате0(ДатаВФорматеRFC822) Экспорт
	
	КопияСтроки = ДатаВФорматеRFC822;
	
	СтруктураДаты = Новый Структура("Год,Месяц,День,Час,Минута,Секунда",  "","","","","","");
	
	Месяцы = Новый Структура("Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec",  "01","02","03","04","05","06","07","08","09","10","11","12");
	
	Для каждого КлючИЗначение Из Месяцы Цикл
		
		Позиция = Найти(КопияСтроки,КлючИЗначение.Ключ);
		
		Если Позиция > 0  Тогда
			
			СтруктураДаты.Месяц = КлючИЗначение.Значение;
			
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла; 
	
	Состояние = 0;
	
	Для ш=0 По СтрДлина(КопияСтроки) Цикл
		
		ТекущийСимвол = Сред(КопияСтроки, ш, 1); //ПолучитьСимвол(КопияСтроки, ш);
		
		ТекСимволЦифра= ЯвляетсяЧислом(ТекущийСимвол);
		
		Если ТекСимволЦифра И Состояние = 0  Тогда
			
			СтруктураДаты.День = СтруктураДаты.День + ТекущийСимвол;
			
			Состояние = 1; //начало день
			
		ИначеЕсли ТекСимволЦифра И Состояние = 1  Тогда
			
			СтруктураДаты.День = СтруктураДаты.День + ТекущийСимвол;
			
			Состояние = 2; //ждем год
			
		ИначеЕсли ТекСимволЦифра И Состояние = 2  Тогда
			
			СтруктураДаты.Год = СтруктураДаты.Год + ТекущийСимвол;
			
			Состояние = 3; //продолжаем год
			
		ИначеЕсли ТекСимволЦифра И Состояние = 3  Тогда
			
			СтруктураДаты.Год = СтруктураДаты.Год + ТекущийСимвол;
			
		ИначеЕсли ТекущийСимвол = " " И Состояние = 3 Тогда
			
			Состояние = 4; //дальше час    
			
		ИначеЕсли ТекСимволЦифра И Состояние = 4  Тогда
			
			СтруктураДаты.Час = СтруктураДаты.Час + ТекущийСимвол;
			
		ИначеЕсли ТекущийСимвол = ":" И Состояние = 4  Тогда
			
			Состояние = 5; //дальше минута
			
		ИначеЕсли ТекСимволЦифра И Состояние = 5  Тогда
			
			СтруктураДаты.Минута = СтруктураДаты.Минута +  ТекущийСимвол;
			
		ИначеЕсли ТекущийСимвол = ":" И Состояние = 5  Тогда
			
			Состояние = 6; //дальше секунда
			
		ИначеЕсли ТекСимволЦифра И Состояние = 6  Тогда
			
			СтруктураДаты.Секунда = СтруктураДаты.Секунда +  ТекущийСимвол;
			
		ИначеЕсли ТекущийСимвол = " " И Состояние = 6 Тогда
			
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Попытка
		
		Результат = Дата(СтруктураДаты.Год+СтруктураДаты.Месяц+СтруктураДаты.День
		
		+СтруктураДаты.Час+СтруктураДаты.Минута+СтруктураДаты.Секунда);
		
	Исключение
		
		Результат = Неопределено;    
		
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции // ПреобразоватьRFC822КДате()

функция ИзменитьФормат(ДатаВФорматеRFC822)
	
	исходнаяДата = ДатаВФорматеRFC822; // RFC 3339 
	
	части = СтрРазделить(исходнаяДата, "+"); 
	исходнаяДата = УдаляемНечисла(части[0]);
	//дата = части[0]; 
	// время = части[1];      
	// часы = Число(части[1]);
	//минуты = Число(части[2]);
	//секунды =  Число(части[3]);
	// преобразованнаяДата = ТекущаяДата();
	// Форматирование даты и времени в формате 1С
	// преобразованнаяДата= (Дата(Год(дата), Месяц(дата), День(дата), часы, минуты, секунды));
	возврат Дата(исходнаяДата);
Конецфункции

Функция УдаляемНечисла(НашаСтрокаДляРазбора)
	ОбработаннаяСтрокаСтр = СокрЛП(НашаСтрокаДляРазбора);
	РезультатРаботы = ОбработаннаяСтрокаСтр;
	Для н=1 по СтрДлина(ОбработаннаяСтрокаСтр) Цикл
		ТекСимвол = Сред(ОбработаннаяСтрокаСтр,н,1);
		Если Найти("0123456789",ТекСимвол) = 0 Тогда
			РезультатРаботы = СтрЗаменить(РезультатРаботы,ТекСимвол,""); 
		КонецЕсли; 
	КонецЦикла; 
	Возврат РезультатРаботы;
КонецФункции

Функция ЯвляетсяЧислом(Значение) Экспорт
	Если ТипЗнч(Значение) = Тип("Число") Тогда
		Возврат Истина
	Иначе
		Если ТипЗнч(Значение) = Тип("Строка") Тогда
			Если Значение = "" Тогда
				Возврат Ложь;
			КонецЕсли;
		КонецЕсли;
		
		Попытка
			Р = Число(Значение);
		Исключение
			Возврат Ложь;
		КонецПопытки;
		Возврат Истина;
	КонецЕсли;
КонецФункции
Функция ПолучитьСоединение(хост, Логин, Пароль) Экспорт
	
	//	СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(ПараметрыПодключения.АдресСервера);
	
	ЗащищенноеСоединение = Новый ЗащищенноеСоединениеOpenSSL(
	Новый СертификатКлиентаWindows(),
	Новый СертификатыУдостоверяющихЦентровWindows()
	);
	
	СоединениеHTTP = Новый HTTPСоединение(хост, 
	443, 
	Логин, 
	Пароль,
	Неопределено, 
	, 
	ЗащищенноеСоединение
	);
	
	//Исключение
	//	СоединениеHTTP = Неопределено;
	//	//ЗаписатьТекстОшибки(ОписаниеОшибки(), ПараметрыВыполнения);	
	//КонецПопытки;
	
	
	Возврат СоединениеHTTP;
	
	
КонецФункции // ПолучитьСоединениеHTTP()



