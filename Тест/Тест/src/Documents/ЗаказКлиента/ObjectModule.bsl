
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	
	///+ТатарМА 15.10.2024
	Префикс = "З-";
	///-ТатарМА 15.10.2024
	
КонецПроцедуры
	
	#Область ПрограммныйИнтерфейс
	
	
	
	#КонецОбласти
	
	#Область ОбработчикиСобытий
	
	Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
		WTPanel = Справочники.СтатусыWT.НайтиПоНаименованию("Обращение");
		СтатусОбработки = Перечисления.СтатусыОбработкиЗаявок.ВОбработке;

		ТипЗаявки = Перечисления.ТипЗаявки.Продажа;
		
		Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПродажаЗапчастей") Тогда
			
			//ЗаполнениеДокументов.ЗаполнитьПоОснованию(ЭтотОбъект, ДанныеЗаполнения);
			
			Запрос = Новый Запрос;
			Запрос.Текст =
			"ВЫБРАТЬ
			|	Док.Клиент,
			|	Док.Комментарий,
			|	Док.Проект,
			|	Док.Склад,
			|	Клиенты.Наименование КАК КлиентНаименование,
			|	Клиенты.Телефон КАК НомерТелефона
			|ИЗ
			|	Документ.ПродажаЗапчастей КАК Док
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Клиенты КАК Клиенты
			|		ПО Док.Клиент = Клиенты.Ссылка
			|ГДЕ
			|	Док.Ссылка = &Ссылка
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	Товары.НомерСтроки КАК НомерСтроки,
			|	Товары.Товар КАК Номенклатура,
			|	Товары.Количество,
			|	Товары.Цена,
			|	Товары.Сумма
			|ИЗ
			|	Документ.ПродажаЗапчастей.Таблица КАК Товары
			|ГДЕ
			|	Товары.Ссылка = &Ссылка
			|
			|УПОРЯДОЧИТЬ ПО
			|	НомерСтроки";
			
			
			Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
			
			РезультатЗапроса = Запрос.ВыполнитьПакет();
			
			Шапка = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(РезультатЗапроса[0].Выгрузить()[0]);
			
			ЗаполнениеДокументов.Заполнить(ЭтотОбъект, Шапка);
			Товары.Загрузить(РезультатЗапроса[1].Выгрузить());
			
		КонецЕсли;
		
		Если ТипЗнч(ДанныеЗаполнения) = Тип("строка") Тогда
			
			НомерТелефона = ДанныеЗаполнения;
			
		КонецЕсли;
		
		//ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
		
		Если Не ЗначениеЗаполнено(Состояние) Тогда
			Состояние = Перечисления.дт_СостоянияЗаказовКлиента.Ожидание;
		КонецЕсли;
		
		ДатаИзмененияСостояния = Дата;
		ДатаСвязи              = ТекущаяДата()+25;
		
		Если Не Пользователи.РолиДоступны("ТекстовыйМенеджер") тогда
			Ответственный      = Пользователи.ТекущийПользователь();
		КонецЕсли;
		 
		//Если Не ЗначениеЗаполнено(Склад) Тогда
		//	Склад = Справочники;
		//КонецЕсли;
		WTPanel = Справочники.СтатусыWT.НайтиПоКоду("000000014");
//ОткрытьВремяЗК(Ссылка, Справочники.Пользователи.ПустаяСсылка(), Справочники.СтатусыWT.НайтиПоКоду("000000009"))		
КонецПроцедуры


Процедура ОткрытьВремяЗК(ЗК, Ответственный, Статус)

	НаборЗаписей = РегистрыСведений.ВремяВыполненияЗаявок.СоздатьМенеджерЗаписи();

	НаборЗаписей.ЗаявкаПродажа = ЗК ;
	НаборЗаписей.Период        = ТекущаяДата();
	НаборЗаписей.НачалоЗамера  = ТекущаяДата();
	НаборЗаписей.КонецЗамера   = ТекущаяДата();
	НаборЗаписей.Ответственный = Ответственный;
	НаборЗаписей.Статус = Статус;
	НаборЗаписей.Записать();

КонецПроцедуры
	
	Процедура ПриКопировании(ОбъектКопирования)
		Дата = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
		Ответственный = Пользователи.ТекущийПользователь();
		
	КонецПроцедуры
	
	Процедура ОбработкаУдаленияПроведения(Отказ)
		ПроведениеСервер.ПодготовитьНаборыЗаписейКОтменеПроведения(ЭтотОбъект);
		Движения.Записать();
		
	КонецПроцедуры
	
	
	Процедура ОбработкаПроведения(Отказ, РежимПроведения)
		
		ДополнительныеСвойства.Вставить("ЭтоНовый",                    ЭтоНовый()); 
		ДополнительныеСвойства.Вставить("ДатаДокументаСдвинутаВперед", Ложь); 
		ПроведениеСервер.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);
		
		//	
		//	ПараметрыПроведения = Документы.ЗаказКлиента.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
		//	Если Отказ Тогда
		//		Возврат;
		//	КонецЕсли;
		
		
		// Формирование движений
		//	дт_Ценообразование.ОтразитьДвижения(ПараметрыПроведения, Движения, Отказ);
		
	ЭтапированиеЗаявки();	
	
	/// Комлев 24/05/24 +++
	Макаров = Справочники.Пользователи.НайтиПоНаименованию("Макаров Егор Вячеславович");
	Если Ответственный = Макаров Тогда
		Отказ = Истина;
	КонецЕсли;
	/// Комлев 24/05/24 +++
	КонецПроцедуры
	
	
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

		Если ОбменДанными.Загрузка Тогда
			Возврат;
		КонецЕсли;
		СуммаТоваров   = дт_ОбщегоНазначения.ИтоговаяСумма(ЭтотОбъект, "Товары", "Отменено");
		Если СуммаТоваров > 0 Тогда
			СуммаДокумента = СуммаТоваров;
		КонецЕсли;
		 // +++ Комлев 30/09/24 +++ 
//		Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
//			СтатусОбработкиЗаявкиКладовщиком = Перечисления.СтатусыОбработкиЗаявокКладовщиком.НоваяЗаявка;
//		КонецЕсли;
		 // --- Комлев 30/09/24 --- 
		
		///+ТатарМА 24.12.2024
		Если Состояние = Перечисления.дт_СостоянияЗаказовКлиента.СобираетсяНаСкладе И НЕ ЗначениеЗаполнено(СтатусОбработкиЗаявкиКладовщиком) Тогда
			СтатусОбработкиЗаявкиКладовщиком = Перечисления.СтатусыОбработкиЗаявокКладовщиком.НоваяЗаявка;
		КонецЕсли;
		///-ТатарМА 24.12.2024
		
		///+ГомзМА 27.12.2022 (Задача 000002652 от 03.02.2023)
		
//		Запрос = Новый Запрос;
//		Запрос.Текст = 
//		"ВЫБРАТЬ ПЕРВЫЕ 1
//		|	ЗаказКлиента.Ссылка КАК Ссылка,
//		|	ЗаказКлиента.Ответственный КАК Ответственный,
//		|	ЗаказКлиента.Дата
//		|ИЗ
//		|	Документ.ЗаказКлиента КАК ЗаказКлиента
//		|ГДЕ
//		|	ЗаказКлиента.Клиент = &Клиент
//		|	И (ЗаказКлиента.Состояние = ЗНАЧЕНИЕ(Перечисление.дт_СостоянияЗаказовКлиента.Ожидание)
//		|	ИЛИ ЗаказКлиента.Состояние = ЗНАЧЕНИЕ(Перечисление.дт_СостоянияЗаказовКлиента.Думает))
//		|	И НЕ ЗаказКлиента.Клиент.Дилер
//		|	И ЗаказКлиента.Ссылка <> &Ссылка";
//		
//		Запрос.УстановитьПараметр("Клиент", Клиент);
//		Запрос.УстановитьПараметр("Ссылка", Ссылка);
//		Запрос.УстановитьПараметр("Ответственный", Ответственный);
//		
//		РезультатЗапроса = Запрос.Выполнить();
//		
//		Если НЕ	ПользователиИнформационнойБазы.ТекущийПользователь().Роли.Содержит(Метаданные.Роли.Найти("Руководитель"))  Тогда 
//			
//			Если НЕ РезультатЗапроса.Пустой() Тогда
//				РезультатЗапроса = РезультатЗапроса.Выбрать();
//				Пока РезультатЗапроса.Следующий() Цикл
//					
//					Если (Состояние = Перечисления.дт_СостоянияЗаказовКлиента.Ожидание ИЛИ
//						Состояние = Перечисления.дт_СостоянияЗаказовКлиента.Думает) И 
//						Строка(РезультатЗапроса.Ответственный) <> ПользователиИнформационнойБазы.ТекущийПользователь().ПолноеИмя И 
//						НЕ ПользователиИнформационнойБазы.ТекущийПользователь().Роли.Содержит(Метаданные.Роли.Найти("Контролёр")) Тогда
//							Отказ = Истина;
//						ВызватьИсключение("Невозможно создать документ, существует открытая заявка! Дополните заявку, либо закройте её.");
//					КонецЕсли;
//				КонецЦикла;
//			КонецЕсли;
//		КонецЕсли;
		///-ГомзМА 27.12.2022 (Задача 000002652 от 03.02.2023)
		
		///+ГомзМА 11.08.2023
		СуммаПредлагаемойЦены = Товары.Итог("ПредлагаемаяЦена");
		///-ГомзМА 11.08.2023
		
		
		///+ГомзМА 24.08.2023
		Если Состояние = Перечисления.дт_СостоянияЗаказовКлиента.ЖдёмДенег Или Состояние
			= Перечисления.дт_СостоянияЗаказовКлиента.Продажа Тогда
			Целевая = Истина;
		КонецЕсли;
		///-ГомзМА 24.08.2023
		//
	/// Комлев 03/06/24 +++
//	Если Товары.Количество() <> 0 И ЗаявкаПоменялаЦену = Ложь Тогда
//		ТоварыТЗ = Товары.Выгрузить();
//		ТоварыТЗ.Свернуть("Номенклатура");
//
//		Для Каждого СтрокаТЧ Из ТоварыТЗ Цикл
//			Если СтрокаТЧ.Номенклатура.Состояние = Перечисления.Состояние.БУ Тогда
//
//				Запрос = Новый Запрос;
//				Запрос.Текст =
//				"ВЫБРАТЬ
//				|	дт_ЦеныНоменклатурыСрезПоследних.Цена КАК ЦенаДоИзменения,
//				|	дт_ЦеныНоменклатурыСрезПоследних.Период КАК Период,
//				|	дт_ЦеныНоменклатурыСрезПоследних.Номенклатура
//				|ПОМЕСТИТЬ ВТ_ДоИзменения
//				|ИЗ
//				|	РегистрСведений.дт_ЦеныНоменклатуры.СрезПоследних(, Номенклатура.Ссылка = &Номенклатура
//				|	И БылоАвтоИзменениеЦены = ЛОЖЬ) КАК дт_ЦеныНоменклатурыСрезПоследних
//				|;
//				|
//				|////////////////////////////////////////////////////////////////////////////////
//				|ВЫБРАТЬ
//				|	дт_ЦеныНоменклатурыСрезПоследних.Цена КАК ЦенаПослеИзменения,
//				|	дт_ЦеныНоменклатурыСрезПоследних.Период КАК Период
//				|ПОМЕСТИТЬ ВТ_ПослеИзменения
//				|ИЗ
//				|	РегистрСведений.дт_ЦеныНоменклатуры.СрезПоследних(, Номенклатура.Ссылка = &Номенклатура) КАК
//				|		дт_ЦеныНоменклатурыСрезПоследних
//				|ГДЕ
//				|	дт_ЦеныНоменклатурыСрезПоследних.БылоАвтоИзменениеЦены = ИСТИНА
//				|;
//				|
//				|////////////////////////////////////////////////////////////////////////////////
//				|ВЫБРАТЬ ПЕРВЫЕ 1
//				|	ВТ_ДоИзменения.ЦенаДоИзменения КАК ЦенаДоИзменения,
//				|	ЕСТЬNULL(ВТ_ПослеИзменения.ЦенаПослеИзменения, 0) КАК ЦенаПослеИзменения,
//				|	ВТ_ДоИзменения.Номенклатура
//				|ИЗ
//				|	ВТ_ДоИзменения КАК ВТ_ДоИзменения
//				|		ПОЛНОЕ СОЕДИНЕНИЕ ВТ_ПослеИзменения КАК ВТ_ПослеИзменения
//				|		ПО (ИСТИНА)
//				|
//				|УПОРЯДОЧИТЬ ПО
//				|	ВТ_ДоИзменения.Период УБЫВ,
//				|	ВТ_ПослеИзменения.Период УБЫВ";
//
//				Запрос.УстановитьПараметр("Номенклатура", СтрокаТЧ.Номенклатура.Ссылка);
//
//				РезультатЗапроса = Запрос.Выполнить();
//				Если РезультатЗапроса.Пустой() Тогда
//					Возврат;
//				КонецЕсли;
//
//				Выборка = РезультатЗапроса.Выбрать();
//				Пока Выборка.Следующий() Цикл
//
//					Продажа = Перечисления.дт_СостоянияЗаказовКлиента.Продажа;
//					ОтказДорого = Перечисления.дт_СостоянияЗаказовКлиента.Дорого;
//
//					КатегорияЦены = ?(Выборка.ЦенаПослеИзменения = 0, Выборка.ЦенаДоИзменения,
//						Выборка.ЦенаПослеИзменения);
//#Область До_10000
//					Если КатегорияЦены < 10000 И Состояние = Продажа Тогда
//						Дней = 86400 * 2;
//						УвеличитьЦену(Выборка.Номенклатура, Выборка.ЦенаДоИзменения, Выборка.ЦенаПослеИзменения, 5,
//							Дней);
//
//					ИначеЕсли КатегорияЦены < 10000 И Состояние = ОтказДорого Тогда
//						Дней = 86400 * 2;
//						СнизитьЦену(Выборка.Номенклатура, Выборка.ЦенаДоИзменения, Выборка.ЦенаПослеИзменения, 5, 35,
//							Дней);
//
//					КонецЕсли;
//#КонецОбласти
//#Область От_10000_До_50000
//					Если (КатегорияЦены >= 10000 И КатегорияЦены < 50000) И Состояние = Продажа Тогда
//						Дней = 86400 * 2;
//						УвеличитьЦену(Выборка.Номенклатура, Выборка.ЦенаДоИзменения, Выборка.ЦенаПослеИзменения, 4,
//							Дней);
//
//					ИначеЕсли (КатегорияЦены >= 10000 И КатегорияЦены < 50000) И Состояние = ОтказДорого Тогда
//						Дней = 86400 * 2;
//						СнизитьЦену(Выборка.Номенклатура, Выборка.ЦенаДоИзменения, Выборка.ЦенаПослеИзменения, 4, 30,
//							Дней);
//
//					КонецЕсли;
//
//#КонецОбласти
//#Область От_50000_До_100000
//					Если (КатегорияЦены >= 50000 И КатегорияЦены < 100000) И Состояние = Продажа Тогда
//						Дней = 86400 * 3;
//						УвеличитьЦену(Выборка.Номенклатура, Выборка.ЦенаДоИзменения, Выборка.ЦенаПослеИзменения, 3,
//							Дней);
//
//					ИначеЕсли (КатегорияЦены > 50000 И КатегорияЦены <= 100000) И Состояние = ОтказДорого Тогда
//						Дней = 86400 * 3;
//						СнизитьЦену(Выборка.Номенклатура, Выборка.ЦенаДоИзменения, Выборка.ЦенаПослеИзменения, 3, 25,
//							Дней);
//
//					КонецЕсли;
//#КонецОбласти
//#Область От_100000_До_200000
//					Если (КатегорияЦены >= 100000 И КатегорияЦены < 200000) И Состояние = Продажа Тогда
//						Дней = 86400 * 7;
//						УвеличитьЦену(Выборка.Номенклатура, Выборка.ЦенаДоИзменения, Выборка.ЦенаПослеИзменения, 2,
//							Дней);
//
//					ИначеЕсли (КатегорияЦены >= 100000 И КатегорияЦены < 200000) И Состояние = ОтказДорого Тогда
//						Дней = 86400 * 7;
//						СнизитьЦену(Выборка.Номенклатура, Выборка.ЦенаДоИзменения, Выборка.ЦенаПослеИзменения, 2, 20,
//							Дней);
//
//					КонецЕсли;
//#КонецОбласти
//#Область От_200000_До_500000
//					Если (КатегорияЦены >= 200000 И КатегорияЦены < 500000) И Состояние = Продажа Тогда
//						Дней = 86400 * 7;
//						УвеличитьЦену(Выборка.Номенклатура, Выборка.ЦенаДоИзменения, Выборка.ЦенаПослеИзменения, 2,
//							Дней);
//
//					ИначеЕсли (КатегорияЦены >= 200000 И КатегорияЦены < 500000) И Состояние = ОтказДорого Тогда
//						Дней = 86400 * 7;
//						СнизитьЦену(Выборка.Номенклатура, Выборка.ЦенаДоИзменения, Выборка.ЦенаПослеИзменения, 2, 15,
//							Дней);
//
//					КонецЕсли;
//
//#КонецОбласти
//
//				КонецЦикла;
//			КонецЕсли;
//		КонецЦикла;
//
//	КонецЕсли;
		
		/// Комлев 03/06/24 ---


	// Комлев АА 20/12/24 +++
	Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
		СтатусОбработкиЗаявкиКладовщиком = Перечисления.СтатусыОбработкиЗаявокКладовщиком.НоваяЗаявка;
	КонецЕсли;
	// Комлев АА 20/12/24 ---
КонецПроцедуры

	Процедура УвеличитьЦену(Номенклатура, ЦенаДоИзменения, ЦенаПослеИзменения, ПроцентЧисло, ДеньВСек)
	/// Комлев 04/06/24 +++
		Процент  = ЦенаДоИзменения / 100 * ПроцентЧисло;

		НоваяЦена = ?(ЦенаПослеИзменения = 0, ЦенаДоИзменения + Процент, ЦенаПослеИзменения + Процент);

		ДатаУстановки = НачалоДня((ТекущаяДата() + ДеньВСек));
		Ценообразование(Номенклатура, ДатаУстановки, НоваяЦена, Истина);
		ЗаявкаПоменялаЦену = Истина;
	/// Комлев 04/06/24 ---
КонецПроцедуры

Процедура СнизитьЦену(Номенклатура, ЦенаДоИзменения, ЦенаПослеИзменения, ПроцентЧисло, МаксПроцентЧисло, ДеньВСек)
	/// Комлев 04/06/24 +++
	Процент  = ЦенаДоИзменения / 100 * ПроцентЧисло;
	ПроцентМакс = ЦенаДоИзменения / 100 * МаксПроцентЧисло;
						
	НоваяЦена = ?(ЦенаПослеИзменения = 0, ЦенаДоИзменения - Процент, ЦенаПослеИзменения - Процент );
						
	ДатаУстановки = НачалоДня((ТекущаяДата() + ДеньВСек));
						
	Если -(НоваяЦена - ЦенаДоИзменения) >= ПроцентМакс Тогда
		ОтправитьУведомление(ДатаУстановки, Номенклатура, МаксПроцентЧисло );
		Возврат;
	КонецЕсли;
						
	Ценообразование(Номенклатура, ДатаУстановки,  НоваяЦена, Истина);
	ЗаявкаПоменялаЦену = Истина;
	/// Комлев 04/06/24 ---
КонецПроцедуры


Процедура ОтправитьУведомление(ДатаУведомления, Номенклатура, Процент) 
	/// Комлев 04/06/24 +++
	Шишов = Справочники.Пользователи.НайтиПоНаименованию("Шишов Евгений Викторович");
	НапоминаниеПользователю = РегистрыСведений.НапоминанияПользователя.СоздатьМенеджерЗаписи();
	НапоминаниеПользователю.Пользователь = Шишов;
	НапоминаниеПользователю.ВремяСобытия = ДатаУведомления + 20;
	НапоминаниеПользователю.СрокНапоминания = ДатаУведомления + 25;
	НапоминаниеПользователю.Описание = "" + Номенклатура + " " + Номенклатура.Код +  " стоимость снизилась на " +  Процент + "%";
	НапоминаниеПользователю.СпособУстановкиВремениНапоминания = Перечисления.СпособыУстановкиВремениНапоминания.ВУказанноеВремя;
	НапоминаниеПользователю.ИнтервалВремениНапоминания = 120;
	НапоминаниеПользователю.Записать();
	/// Комлев 04/06/24 ---
КонецПроцедуры

Процедура Ценообразование(НоменклатураСсылка, ДатаУстановкиЦены,  НоваяЦена, БылоАвтоИзменение = Истина)
	Попытка
		ДанныеЗаписи = Новый Структура("Номенклатура, ТипЦен",  НоменклатураСсылка, Справочники.ТипыЦен.Фиксированная);
		дт_Ценообразование.УстановитьЦену(ДанныеЗаписи, ДатаУстановкиЦены, НоваяЦена, , БылоАвтоИзменение);
	Исключение
		
	КонецПопытки;
		
КонецПроцедуры
	
	Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
		
		Если Состояние = Перечисления.дт_СостоянияЗаказовКлиента.Продажа тогда
			ПроверяемыеРеквизиты.Добавить("Товары");
		КонецЕсли;
		
		Если Дата >= НачалоДня(Дата("20230310")) И (ПользователиИнформационнойБазы.ТекущийПользователь().Роли.Содержит(Метаданные.Роли.Найти("ТекстовыйМенеджер")) И 
			НЕ (ПользователиИнформационнойБазы.ТекущийПользователь().Роли.Содержит(Метаданные.Роли.Найти("РКК")) ИЛИ 
			ПользователиИнформационнойБазы.ТекущийПользователь().Роли.Содержит(Метаданные.Роли.Найти("Контролёр")))) Тогда
			ПроверяемыеРеквизиты.Добавить("Канал");
		КонецЕсли;
		
	КонецПроцедуры
	
Процедура ПриЗаписи(Отказ)
	
	///+ТатарМА 26.11.2024
	Если ОбменДанными.Загрузка Тогда
			Возврат;
	КонецЕсли;
	
	//Проверка на существующую запись в новом конечном статусе
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПорядокЗаявок.Заявка
		|ИЗ
		|	РегистрСведений.ПорядокЗаявок КАК ПорядокЗаявок
		|ГДЕ
		|	ПорядокЗаявок.Заявка = &Заявка
		|	И ПорядокЗаявок.Статус = &Статус";
	
	Запрос.УстановитьПараметр("Заявка", Ссылка);
	Запрос.УстановитьПараметр("Статус", Состояние);
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	Если НЕ РезультатЗапроса.Количество() > 0 Тогда
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	ПорядокЗаявок.ПорядковыйНомер КАК ПорядковыйНомер
			|ИЗ
			|	РегистрСведений.ПорядокЗаявок КАК ПорядокЗаявок
			|ГДЕ
			|	ПорядокЗаявок.Статус = &Статус
			|
			|УПОРЯДОЧИТЬ ПО
			|	ПорядковыйНомер УБЫВ";
		
		Запрос.УстановитьПараметр("Статус", Состояние);
		
		РезультатЗапроса = Запрос.Выполнить().Выбрать();
		Если РезультатЗапроса.Количество() > 0 Тогда
			РезультатЗапроса.Следующий();
			ЗаписьВРегистреСведений = РегистрыСведений.ПорядокЗаявок.СоздатьМенеджерЗаписи();
			ЗаписьВРегистреСведений.Заявка = Ссылка;
			ЗаписьВРегистреСведений.Статус = Состояние;
			ЗаписьВРегистреСведений.ПорядковыйНомер = РезультатЗапроса.ПорядковыйНомер + 1;
			ЗаписьВРегистреСведений.Записать();
		Иначе
			ЗаписьВРегистреСведений = РегистрыСведений.ПорядокЗаявок.СоздатьМенеджерЗаписи();
			ЗаписьВРегистреСведений.Заявка = Ссылка;
			ЗаписьВРегистреСведений.Статус = Состояние;
			ЗаписьВРегистреСведений.ПорядковыйНомер = 1;
			ЗаписьВРегистреСведений.Записать();
		КонецЕсли;
	КонецЕсли;
			
	
	
//	НаборЗаписей = РегистрыСведений.ПорядокЗаявок.СоздатьНаборЗаписей();
//	НаборЗаписей.Отбор.Статус.Установить(Состояние);
//	НаборЗаписей.Прочитать();
//	ТЗ = НаборЗаписей.Выгрузить();
//	ТЗ.Сортировать("ПорядковыйНомер");
//	НаборЗаписей.Очистить();
//
//	ПостроительЗапр = Новый ПостроительЗапроса;
//	ПостроительЗапр.ИсточникДанных = Новый ОписаниеИсточникаДанных(ТЗ);
//
//	ТЗОтбор = ПостроительЗапр.Отбор.Добавить("Заявка");
//	ТЗОтбор.ВидСравнения = ВидСравнения.НеРавно;
//	ТЗОтбор.Значение = Ссылка;
//	ТЗОтбор.Использование = Истина;
//
//	ПостроительЗапр.Выполнить();
//	ТЗ = ПостроительЗапр.Результат.Выгрузить();
//
//	НоваяЗапись = НаборЗаписей.Добавить();
//	НоваяЗапись.Заявка = Ссылка;
//	НоваяЗапись.ПорядковыйНомер = 1;
//	НоваяЗапись.Статус = Состояние;
//
//	ПозицияВСписке = 2;
//	Для Каждого СтрокаТЗ Из ТЗ Цикл
//		НоваяЗапись = НаборЗаписей.Добавить();
//		НоваяЗапись.Заявка = СтрокаТЗ.Заявка;
//		НоваяЗапись.ПорядковыйНомер = ПозицияВСписке;
//		НоваяЗапись.Статус = Состояние;
//		ПозицияВСписке = ПозицияВСписке + 1;
//	КонецЦикла;
//	НаборЗаписей.Записать();
	///-ТатарМА 26.11.2024

КонецПроцедуры
	
	#КонецОбласти  
	Процедура ЭтапированиеЗаявки() 
		НаборЗаписей = РегистрыСведений.ЭтапированиеЗаказа.СоздатьНаборЗаписей();  			
		НаборЗаписей.Отбор.Заявка.Установить(Ссылка);
		НаборЗаписей.Прочитать(); 
		
		Если НаборЗаписей.Количество() = 0 Тогда
			НоваяЗапись = НаборЗаписей.Добавить();
			НоваяЗапись.Заявка = Ссылка;
			НоваяЗапись.ЗаявкаСформирована = Истина;	
		ИначеЕсли НаборЗаписей.Количество() = 1 Тогда
			
			НоваяЗапись = НаборЗаписей[0]; 		
			
		КонецЕсли; 
		
		Если ПроверкаПродаж(Ссылка) <> Неопределено тогда
			НоваяЗапись.Продажа = ПроверкаПродаж(Ссылка); 
			НоваяЗапись.ВыписанаПродажа = Истина 
		КонецЕсли;
		
		Если Состояние <> перечисления.дт_СостоянияЗаказовКлиента.Ожидание тогда
			НоваяЗапись.ЗаявкаВРаботе = Истина;
		КонецЕсли;
		
		НаборЗаписей.Записать();
		
	КонецПроцедуры  
	
	функция ПроверкаПродаж(Заявка)
	Запрос = Новый Запрос;
	запрос.Текст = "ВЫБРАТЬ
	               |	ПродажаЗапчастей.Ссылка КАК Ссылка
	               |ИЗ
	               |	Документ.ПродажаЗапчастей КАК ПродажаЗапчастей
	               |ГДЕ
	               |	ПродажаЗапчастей.ЗаказКлиента = &ЗаказКлиента
	               |	И ПродажаЗапчастей.ЗаказКлиента <> ЗНАЧЕНИЕ(Документ.заказКлиента.ПустаяСсылка)";
	Запрос.УстановитьПараметр("ЗаказКлиента",Заявка);
	Выборка = Запрос.Выполнить().Выбрать();
	Продажа =Неопределено;
	Если выборка.Количество() > 0 тогда
		Выборка.Следующий();
		Продажа = выборка.ссылка;	
	КонецЕсли;
	Возврат продажа;
КонецФункции

	
		
	
	#Область СлужебныеПроцедурыИФункции
	
	
	
	#КонецОбласти
	
#КонецЕсли