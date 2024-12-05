#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс



#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, Режим)
	//{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	// регистр Баланс Приход 
	ТаблицаСделки =  ТабличнаяЧасть1.Выгрузить();
	Если ТаблицаСделки.Количество() = 0 Тогда
		НоваяСтрока = ТаблицаСделки.Добавить();
		НоваяСтрока.Документ = Сделка;
		НоваяСтрока.Сумма = СуммаДокумента;
		НоваяСтрока.Счет = Счет; 
	КонецЕсли;
	
	//Волков ИО 07.12.23 ++
	// РН БалансКлиента Приход
	Движения.БалансКлиента.Записывать = Истина;
	Движение = Движения.БалансКлиента.Добавить();
	движение.ВидДвижения = ВидДвиженияНакопления.Приход;
	Движение.Период = Дата; 
	Движение.Клиент = Контрагент;	
	Движение.Баланс = СуммаДокумента;
	//Волков ИО 07.12.23 --
	
	Движения.Баланс.Записывать = Истина;
	Для Каждого ТекСтрокаТабличнаяЧасть1 Из ТаблицаСделки Цикл
		Движение = Движения.Баланс.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.Измерение1 = ТекСтрокаТабличнаяЧасть1.Счет;
		Движение.Баланс = ТекСтрокаТабличнаяЧасть1.Сумма;
		// ++ obrv 17.09.19
		//Если ТекСтрокаТабличнаяЧасть1.Счет = Справочники.Счета.ПустаяСсылка() Тогда
		//	Отказ = Истина;
		//КонецЕсли;
		// -- obrv 17.09.19
	КонецЦикла;
///+++МазинЕС 14.08.2024 Начислить бонусы Кладовщикам и менеджеру
	
//	Если ЗначениеЗаполнено(Сделка) И ТипЗнч(Сделка) = Тип("ДокументСсылка.ПродажаЗапчастей") Тогда
//		Если Дата > '20240701' Тогда //Дата начала действия бонусов	
//			НаборЗаписей = РегистрыСведений.БонусыСотрудниковОтПродажи.СоздатьНаборЗаписей();
//			НаборЗаписей.Отбор.ДокументРег.Установить(Ссылка);
//			НаборЗаписей.Прочитать();
//			
//			Если НаборЗаписей.Количество() <> 0 Тогда 
//				НаборЗаписей.Очистить();
//				НаборЗаписей.Записать();
//			КонецЕсли; 
			
//		Стуктура = БонусыКладовщикиСПродажи(Сделка);
		
//		Если Стуктура <> Неопределено Тогда 
	
//			Если НаборЗаписей.Количество() = 0 Тогда
//				Менеджер = Сделка.КтоПродал;
//				
//				ЗаписьВРегистреСведений 			= РегистрыСведений.БонусыСотрудниковОтПродажи.СоздатьМенеджерЗаписи();
//				ЗаписьВРегистреСведений.Период 		= Дата;
//				ЗаписьВРегистреСведений.Сотрудник 	= Менеджер;
//				ЗаписьВРегистреСведений.Сумма 		= СуммаДокумента;
//				ЗаписьВРегистреСведений.ДокументРег = ссылка;
//				ЗаписьВРегистреСведений.Продажа 	= Сделка;
//				ЗаписьВРегистреСведений.Роль 		= Справочники.ДолжностиДляУК.НайтиПоКоду("000000001"); //Менеджер
//				ЗаписьВРегистреСведений.Бонус 		= СуммаДокумента * 0.03;
//				ЗаписьВРегистреСведений.Записать();

//				СписокУчастниковРаботы = Стуктура.ТаблицаОтветственные;
//				Итер = 1;
//				
//				МестоРаботыННКод			= "000000003";
//				МестоРаботыМСККод			= "000000002";
//				МестоРаботыЕКБКод			= "000000004";
				
//				Для Каждого СтрокаТЧ Из СписокУчастниковРаботы Цикл 
//					
//					Если СтрокаТЧ.МестоРаботыКод 			= МестоРаботыННКод И Стуктура.ДоляКладовщикаНН <> 0 Тогда 
//						ЗаписьВРегистреСведений 			= РегистрыСведений.БонусыСотрудниковОтПродажи.СоздатьМенеджерЗаписи();
//						ЗаписьВРегистреСведений.Период 		= Дата + Итер;
//						ЗаписьВРегистреСведений.Сотрудник 	= СтрокаТЧ.Сотрудник;
//						ЗаписьВРегистреСведений.Сумма 		= СуммаДокумента;
//						ЗаписьВРегистреСведений.ДокументРег = ссылка;
//						ЗаписьВРегистреСведений.Продажа 	= Сделка;
//						ЗаписьВРегистреСведений.Роль 		= Справочники.ДолжностиДляУК.НайтиПоКоду("000000003"); //Кладовщик
//						ЗаписьВРегистреСведений.Бонус 		= СуммаДокумента *  Стуктура.ДоляКладовщикаНН * 0.005;
//						ЗаписьВРегистреСведений.Записать();
//						Итер = Итер +1;
//					КонецЕсли;
//					Если СтрокаТЧ.МестоРаботыКод 			= МестоРаботыМСККод И Стуктура.ДоляКладовщикаМСК <> 0 Тогда
//						ЗаписьВРегистреСведений 			= РегистрыСведений.БонусыСотрудниковОтПродажи.СоздатьМенеджерЗаписи();
//						ЗаписьВРегистреСведений.Период 		= Дата + Итер;
//						ЗаписьВРегистреСведений.Сотрудник 	= СтрокаТЧ.Сотрудник;
//						ЗаписьВРегистреСведений.Сумма 		= СуммаДокумента;
//						ЗаписьВРегистреСведений.ДокументРег = ссылка;
//						ЗаписьВРегистреСведений.Продажа 	= Сделка;
//						ЗаписьВРегистреСведений.Роль 		= Справочники.ДолжностиДляУК.НайтиПоКоду("000000003"); //Кладовщик
//						ЗаписьВРегистреСведений.Бонус 		= СуммаДокумента * Стуктура.ДоляКладовщикаМСК * 0.005; 
//						ЗаписьВРегистреСведений.Записать();
//						Итер = Итер +1;	
//					КонецЕсли;
//					
//					Если СтрокаТЧ.МестоРаботыКод 			= МестоРаботыЕКБКод И Стуктура.ДоляКладовщикаЕКБ <> 0 Тогда
//						ЗаписьВРегистреСведений 			= РегистрыСведений.БонусыСотрудниковОтПродажи.СоздатьМенеджерЗаписи();
//						ЗаписьВРегистреСведений.Период 		= Дата + Итер;
//						ЗаписьВРегистреСведений.Сотрудник 	= СтрокаТЧ.Сотрудник;
//						ЗаписьВРегистреСведений.Сумма 		= СуммаДокумента;
//						ЗаписьВРегистреСведений.ДокументРег = ссылка;
//						ЗаписьВРегистреСведений.Продажа 	= Сделка;
//						ЗаписьВРегистреСведений.Роль 		= Справочники.ДолжностиДляУК.НайтиПоКоду("000000003"); //Кладовщик
//						ЗаписьВРегистреСведений.Бонус 		= СуммаДокумента * Стуктура.ДоляКладовщикаЕКБ * 0.005;
//						ЗаписьВРегистреСведений.Записать();
//						Итер = Итер +1;	
//					КонецЕсли;
//					
//				КонецЦикла; 
//			КонецЕсли;
//		КонецЕсли;
//		КонецЕсли;
//КонецЕсли;		
///---МазинЕС 14.08.2024
	///---МазинЕС 14.08.2024
	Если Дата >= дт_Зарплата.ДатаНачалаУчетаОплатПоСделкам() Тогда
		СформироватьДвиженияОплатыПоСделкам(Отказ);
		СформироватьДвиженияРасчетыСКомитентом(Отказ);
		Возврат
	КонецЕсли;
	
	// регистр БаланПоНакладной Приход
	Если ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеДенежныхСредств.ОплатаПокупателя") Тогда
		Движения.БаланПоНакладной.Записывать = Истина;
		Для Каждого ТекСтрокаТабличнаяЧасть1 Из ТаблицаСделки Цикл
			Движение = Движения.БаланПоНакладной.Добавить();
			Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
			Движение.Период = Дата;
			Движение.Измерение1 = ТекСтрокаТабличнаяЧасть1.Документ;
			Движение.Сумма = ТекСтрокаТабличнаяЧасть1.Сумма;
			Если ТекСтрокаТабличнаяЧасть1.Документ = Документы.ПродажаЗапчастей.ПустаяСсылка() Тогда
				Отказ = Истина;
			Иначе
				з = новый запрос;
				з.Текст="ВЫБРАТЬ
				|	Сумма(БаланПоНакладнойОстатки.СуммаОстаток) как сумма
				|ИЗ
				|	РегистрНакопления.БаланПоНакладной.Остатки КАК БаланПоНакладнойОстатки
				|ГДЕ
				|	БаланПоНакладнойОстатки.Измерение1 = &изм";
				з.УстановитьПараметр("изм",ТекСтрокаТабличнаяЧасть1.Документ);
				б = з.Выполнить().Выгрузить().Итог("сумма");
				c1 = 0;
				Для Каждого c Из ТабличнаяЧасть1 Цикл
					c1 = c1 + c.Сумма;
				КонецЦикла;
				
				// ++ obrv 04.09.19
				//Если ТипЗнч(ТекСтрокаТабличнаяЧасть1.Документ) = Тип("ДокументСсылка.ПродажаЗапчастей") Тогда
				//	Если (ТекСтрокаТабличнаяЧасть1.Документ.ИтогоРекв-б-c1) < 0 Тогда
				//		Отказ = Истина;
				//		Сообщить("Попытка вывести больше чем есть в накладной "+ТекСтрокаТабличнаяЧасть1.Документ);
				//	КонецЕсли;			
				//КонецЕсли;
				
				// -- obrv 04.09.19
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
	
КонецПроцедуры


Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Счет) 
		И ТабличнаяЧасть1.Количество() = 1 Тогда
		Счет = ТабличнаяЧасть1[0].Счет;
	КонецЕсли;
	
	//Если ТабличнаяЧасть1.Итог("Сумма") <> 0 Тогда
	//	ОбщаяСумма = ТабличнаяЧасть1.Итог("Сумма");
	//КонецЕсли;
	
	Если ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеДенежныхСредств.Прочее") Тогда
		Контрагент = Неопределено;
	КонецЕсли;
	
	
	///+ГомзМА 28.08.2023
	Если Ответственный = Справочники.Пользователи.ПустаяСсылка() Тогда
		Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;
	///-ГомзМА 28.08.2023
	
	
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)

Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Функция БонусыКладовщикиСПродажи(Сделка)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПродажаЗапчастейТаблица.Партия КАК Партия,
		|	ПродажаЗапчастейТаблица.Товар КАК Товар,
		|	ПродажаЗапчастейТаблица.Сумма КАК Сумма,
		|	ПродажаЗапчастейТаблица.Склад.Код КАК СкладКод,
		|	ПродажаЗапчастейТаблица.Ссылка.ИтогоРекв КАК СуммаДокументПродажа
		|ИЗ
		|	Документ.ПродажаЗапчастей.Таблица КАК ПродажаЗапчастейТаблица
		|ГДЕ
		|	ПродажаЗапчастейТаблица.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка",Сделка);
	
	ТаблицаТовары = Запрос.Выполнить().Выгрузить();
	
	Запрос2 = Новый Запрос;
	Запрос2.Текст =
		"ВЫБРАТЬ
		|	Сотрудники.МестоРаботы.Код КАК МестоРаботыКод,
		|	Сотрудники.Пользователь КАК Пользователь
		|ПОМЕСТИТЬ ВТ_Сотрудник
		|ИЗ
		|	Справочник.Сотрудники КАК Сотрудники
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПродажаЗапчастейОтветственные.Сотрудник КАК Сотрудник,
		|	ПродажаЗапчастейОтветственные.Роль КАК Роль,
		|	ВТ_Сотрудник.МестоРаботыКод КАК МестоРаботыКод
		|ИЗ
		|	Документ.ПродажаЗапчастей.Ответственные КАК ПродажаЗапчастейОтветственные
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Сотрудник КАК ВТ_Сотрудник
		|		ПО (ПродажаЗапчастейОтветственные.Сотрудник = ВТ_Сотрудник.Пользователь.Ссылка)
		|ГДЕ
		|	ПродажаЗапчастейОтветственные.Ссылка = &Ссылка
		|	И ПродажаЗапчастейОтветственные.Роль = ЗНАЧЕНИЕ(Перечисление.дт_РолиВПродаже.Кладовщик)";
	
	
	Запрос2.УстановитьПараметр("Ссылка", Сделка);
	ТаблицаОтветственные = Запрос2.Выполнить().Выгрузить();
	
	МестоРаботыННКод			= "000000003"; 
	СкладНН 					= "000000002";
	СуммаСтрокиТовараНН			= 0;
	КоличествоКладовщиковНН 	= 0;
				
	МестоРаботыМСККод			= "000000002";
	СкладМСК					= "000000005";
	СуммаСтрокиТовараМСК		= 0;
	КоличествоКладовщиковМСК 	= 0;
	
	МестоРаботыЕКБКод			= "000000004";
	СкладЕКБ					= "000000008";
	СуммаСтрокиТовараЕКБ		= 0;
	КоличествоКладовщиковЕКБ 	= 0;
	
	СуммаДокументПродажа = 0; 
	
Если ТаблицаТовары.Количество() <> 0 Тогда 
	Если ТаблицаОтветственные.Количество() <> 0 Тогда 
	
	Для Каждого Строка ИЗ ТаблицаОтветственные Цикл 
		Если  Строка.МестоРаботыКод = МестоРаботыННКод Тогда  		
			КоличествоКладовщиковНН = КоличествоКладовщиковНН +1; 		
		КонецЕсли;
		Если  Строка.МестоРаботыКод = МестоРаботыМСККод Тогда  		
			КоличествоКладовщиковМСК = КоличествоКладовщиковМСК +1; 		
		КонецЕсли;
		Если  Строка.МестоРаботыКод = МестоРаботыЕКБКод Тогда  		
			КоличествоКладовщиковЕКБ = КоличествоКладовщиковЕКБ +1; 		
		КонецЕсли;
	КонецЦикла; 
	
	
	Для Каждого СтрокаТовары ИЗ ТаблицаТовары Цикл 
		Если  СтрокаТовары.СкладКод = СкладНН   Тогда  		
			СуммаСтрокиТовараНН = СуммаСтрокиТовараНН + СтрокаТовары.Сумма; 		
		КонецЕсли;
		Если  СтрокаТовары.СкладКод = СкладМСК  Тогда  		
			СуммаСтрокиТовараМСК = СуммаСтрокиТовараМСК + СтрокаТовары.Сумма;		
		КонецЕсли;
		Если  СтрокаТовары.СкладКод = СкладЕКБ  Тогда  		
			СуммаСтрокиТовараЕКБ = СуммаСтрокиТовараЕКБ + СтрокаТовары.Сумма		
		КонецЕсли;
		СуммаДокументПродажа = СуммаДокументПродажа + СтрокаТовары.Сумма; 
	КонецЦикла;  
	
	Структура  = Новый Структура; 
	
	
	Если СуммаСтрокиТовараНН <> 0  И КоличествоКладовщиковНН <> 0 Тогда 
		Структура.Вставить("ДоляКладовщикаНН",	СуммаСтрокиТовараНН 	/ СуммаДокументПродажа / КоличествоКладовщиковНН);
	Иначе 
		Структура.Вставить("ДоляКладовщикаНН",	0);
	КонецЕсли; 
	
	Если СуммаСтрокиТовараМСК <> 0 И КоличествоКладовщиковМСК <> 0 Тогда 
		Структура.Вставить("ДоляКладовщикаМСК",	СуммаСтрокиТовараМСК 	/ СуммаДокументПродажа / КоличествоКладовщиковМСК);
	Иначе 
		Структура.Вставить("ДоляКладовщикаМСК",	0);	
	КонецЕсли; 
	
	Если СуммаСтрокиТовараЕКБ <> 0  И КоличествоКладовщиковЕКБ <> 0 Тогда 
		Структура.Вставить("ДоляКладовщикаЕКБ",	СуммаСтрокиТовараЕКБ 	/ СуммаДокументПродажа / КоличествоКладовщиковЕКБ);
	Иначе 
		Структура.Вставить("ДоляКладовщикаЕКБ",	0);
	КонецЕсли; 
	
	Если ТаблицаОтветственные.Количество() <> 0 Тогда 
		Структура.Вставить("ТаблицаОтветственные",ТаблицаОтветственные);
	Иначе 
		Структура.Вставить("ТаблицаОтветственные",	ТаблицаОтветственные = Новый ТаблицаЗначений);	 
	КонецЕсли; 
	
	Если Структура.Количество() <> 0 Тогда 
		Возврат Структура;
	КонецЕсли; 

КонецЕсли; 	
КонецЕсли; 

КонецФункции 


Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если Контрагент = Неопределено Тогда
		Контрагент = Справочники.Клиенты.ПустаяСсылка();
	КонецЕсли;
	
	//Волков ИО 06.12.23++
    Клиент = Контрагент;
	//Волков ИО 06.12.23

	
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказНаряд") 
		ИЛИ ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказНаДоставку") Тогда
		
		ЗаполнитьПоЗаказНаряду(ДанныеЗаполнения);
		//ТабличнаяЧасть1.Очистить();
		//
		//НоваяСтрока = ТабличнаяЧасть1.Добавить();
		//НоваяСтрока.Документ = ДанныеЗаполнения;
		//НоваяСтрока.Сумма = ОбщаяСумма;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПродажаЗапчастей") Тогда	
		
		ОписаниеРеквизитов = Новый Структура("Организация,ИтогоРекв,Клиент");
		ОписаниеРеквизитов.Вставить("Счет", "TipOplati.Счет");
		
		СвойстваОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения, ОписаниеРеквизитов);
		
		ВидОперации = Перечисления.ВидыОперацийПоступлениеДенежныхСредств.ОплатаПокупателя;
		СуммаДокумента = СвойстваОснования.ИтогоРекв;
		Контрагент = СвойстваОснования.Клиент; 
		Сделка = ДанныеЗаполнения;
		Организация = СвойстваОснования.Организация;
		Счет = СвойстваОснования.Счет;
		Менеджер = ДанныеЗаполнения.КтоПродал;
//		Если ЗначениеЗаполнено(ДанныеЗаполнения.Основание) Тогда
//			Поступление = Перечисления.ВидыПоступлений.БезналичныйРасчет;
//		Иначе
//			Поступление = Перечисления.ВидыПоступлений.НаличныйРасчет;
//		КонецЕсли;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		
		Если ТипЗнч(Сделка) =  Тип("ДокументСсылка.ЗаказНаряд") Тогда
			Если ВидОперации = Перечисления.ВидыОперацийПоступлениеДенежныхСредств.ОплатаПокупателя Тогда
				
				ЭтотОбъект.Заполнить(Сделка);
				
			ИначеЕсли ВидОперации = Перечисления.ВидыОперацийПоступлениеДенежныхСредств.ОплатаКомитента 
				И ЗначениеЗаполнено(Сделка) Тогда
				
				СвойстваОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Сделка, "Организация,СуммаАгентские,Комитент");
				
				Организация = СвойстваОснования.Организация;
				СуммаДокумента = СвойстваОснования.СуммаАгентские;
				Контрагент = СвойстваОснования.Комитент; 
				
			КонецЕсли;  
			
			
		КонецЕсли;
		
	КонецЕсли;
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект);
	Если Не ЗначениеЗаполнено(ВидОперации) Тогда
		ВидОперации = Перечисления.ВидыОперацийПоступлениеДенежныхСредств.ОплатаПокупателя;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Сделка) Тогда
		
		Если ПолучитьФункциональнуюОпцию("дт_ИспользоватьАвтосервис") Тогда
			Сделка = ПредопределенноеЗначение("Документ.ЗаказНаряд.ПустаяСсылка");
		ИначеЕсли ПолучитьФункциональнуюОпцию("дт_ИспользоватьГрузоперевозки") Тогда
			Сделка = ПредопределенноеЗначение("Документ.ЗаказНаДоставку.ПустаяСсылка");
		Иначе
			Сделка = ПредопределенноеЗначение("Документ.ПродажаЗапчастей.ПустаяСсылка");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры




Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат
	КонецЕсли;
	
	ИспользоватьАвтосервис = ПолучитьФункциональнуюОпцию("дт_ИспользоватьАвтосервис");
	ИспользоватьГрузоперевозки = ПолучитьФункциональнуюОпцию("дт_ИспользоватьГрузоперевозки");
	
	МассивНепроверяемыхРеквизитов = Новый Массив();

	Если ВидОперации = Перечисления.ВидыОперацийПоступлениеДенежныхСредств.Прочее Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Контрагент");	
		МассивНепроверяемыхРеквизитов.Добавить("Сделка");	
	КонецЕсли;
	
	Если НЕ ИспользоватьАвтосервис 
		И НЕ ИспользоватьГрузоперевозки Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ВидОперации");
		МассивНепроверяемыхРеквизитов.Добавить("Контрагент");
		//МассивНепроверяемыхРеквизитов.Добавить("Сделка");
		МассивНепроверяемыхРеквизитов.Добавить("Организация");
		МассивНепроверяемыхРеквизитов.Добавить("СуммаДокумента");
		
	КонецЕсли;
	
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	

	 
	
КонецПроцедуры
	


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПоЗаказНаряду(ЗаказНаряд)

	СвойстваОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЗаказНаряд, "Организация,СуммаДокумента,Клиент");
	
	Организация = СвойстваОснования.Организация;
	ВидОперации = Перечисления.ВидыОперацийПоступлениеДенежныхСредств.ОплатаПокупателя;
	СуммаДокумента = СвойстваОснования.СуммаДокумента;
	Контрагент = СвойстваОснования.Клиент; 
	Сделка = ЗаказНаряд;
	
		Если ТипЗнч(Сделка) = Тип("ДокументСсылка.ПродажаЗапчастей") тогда
		Менеджер = сделка.КтоПродал;
	ИначеЕсли ТипЗнч(Сделка) = Тип("ДокументСсылка.ЗаказНаряд") тогда
//		Менеджер = сделка.Инициатор.Пользователь;

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ЗаказНаряд.ЗаказКлиента КАК ЗаказКлиента
		|ИЗ
		|	Документ.ЗаказНаряд КАК ЗаказНаряд
		|ГДЕ
		|	ЗаказНаряд.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Сделка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СсылкаЗаявкаКлиента = ВыборкаДетальныеЗаписи.ЗаказКлиента; 
	КонецЦикла;
	
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ЗаказКлиента.Ответственный КАК Ответственный
		|ИЗ
		|	Документ.ЗаказКлиента КАК ЗаказКлиента
		|ГДЕ
		|	ЗаказКлиента.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", СсылкаЗаявкаКлиента);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ОтветственныеЗаказКлиента = ВыборкаДетальныеЗаписи.Ответственный;  
	КонецЦикла;
	
	Менеджер = ОтветственныеЗаказКлиента; 
		

	КонецЕсли;

	
	

КонецПроцедуры

Процедура СформироватьДвиженияОплатыПоСделкам(Отказ)

	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПриходДенегНаСчет.Ссылка КАК Ссылка,
		|	ПриходДенегНаСчет.Сделка КАК Сделка,
		|	ПриходДенегНаСчет.СуммаДокумента КАК Сумма
		|ПОМЕСТИТЬ ВТ_РасшифровкаПлатежа
		|ИЗ
		|	Документ.ПриходДенегНаСчет КАК ПриходДенегНаСчет
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПриходДенегНаСчет.ТабличнаяЧасть1 КАК ПриходДенегНаСчетТабличнаяЧасть1
		|		ПО (ПриходДенегНаСчетТабличнаяЧасть1.Ссылка = ПриходДенегНаСчет.Ссылка)
		|ГДЕ
		|	ПриходДенегНаСчет.Ссылка = &Ссылка
		|	И ПриходДенегНаСчетТабличнаяЧасть1.Ссылка ЕСТЬ NULL
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПриходДенегНаСчетТабличнаяЧасть1.Ссылка,
		|	ПриходДенегНаСчетТабличнаяЧасть1.Документ,
		|	ПриходДенегНаСчетТабличнаяЧасть1.Сумма
		|ИЗ
		|	Документ.ПриходДенегНаСчет.ТабличнаяЧасть1 КАК ПриходДенегНаСчетТабличнаяЧасть1
		|ГДЕ
		|	ПриходДенегНаСчетТабличнаяЧасть1.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Сделки.Ссылка КАК Ссылка,
		|	Сделки.Сделка КАК Сделка,
		|	СУММА(Сделки.Сумма) КАК Сумма,
		|	МАКСИМУМ(ВЫБОР
		|			КОГДА Сделки.Сделка ССЫЛКА Документ.ПродажаЗапчастей
		|				ТОГДА Сделки.Сделка.ИтогоРекв
		|			ИНАЧЕ Сделки.Сделка.СуммаДокумента
		|		КОНЕЦ) КАК СуммаДокумента
		|ПОМЕСТИТЬ ВТ_Сделки
		|ИЗ
		|	ВТ_РасшифровкаПлатежа КАК Сделки
		|ГДЕ
		|	Сделки.Ссылка.ВидОперации = &ВидОперации
		|
		|СГРУППИРОВАТЬ ПО
		|	Сделки.Ссылка,
		|	Сделки.Сделка
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Сделка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПриходДенегНаСчет.Дата КАК Период,
		|	ВТ_Сделки.Ссылка КАК Регистратор,
		|	ВТ_Сделки.Сделка КАК Документ,
		|	ВТ_Сделки.Сумма КАК Сумма,
		|	ЕСТЬNULL(Оплаты.СуммаОплачено, 0) КАК СуммаОплачено,
		|	ЕСТЬNULL(ВТ_Сделки.СуммаДокумента, 0) КАК СуммаДокумента
		|ИЗ
		|	ВТ_Сделки КАК ВТ_Сделки
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			ВложенныйЗапрос.Документ КАК Документ,
		|			СУММА(ВложенныйЗапрос.СуммаОплачено) КАК СуммаОплачено
		|		ИЗ
		|			(ВЫБРАТЬ
		|				БаланПоНакладнойОстатки.Измерение1 КАК Документ,
		|				БаланПоНакладнойОстатки.СуммаОстаток КАК СуммаОплачено
		|			ИЗ
		|				РегистрНакопления.БаланПоНакладной.Остатки(&МоментВремени, ) КАК БаланПоНакладнойОстатки
		|			
		|			ОБЪЕДИНИТЬ ВСЕ
		|			
		|			ВЫБРАТЬ
		|				ОплатыПоСделкамОбороты.Документ,
		|				СУММА(ОплатыПоСделкамОбороты.СуммаОборот)
		|			ИЗ
		|				РегистрНакопления.ОплатыПоСделкам.Обороты(, &МоментВремени, Регистратор, ) КАК ОплатыПоСделкамОбороты
		|			ГДЕ
		|				ОплатыПоСделкамОбороты.Регистратор <> &Ссылка
		|			
		|			СГРУППИРОВАТЬ ПО
		|				ОплатыПоСделкамОбороты.Документ) КАК ВложенныйЗапрос
		|		
		|		СГРУППИРОВАТЬ ПО
		|			ВложенныйЗапрос.Документ) КАК Оплаты
		|		ПО ВТ_Сделки.Сделка = Оплаты.Документ
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПриходДенегНаСчет КАК ПриходДенегНаСчет
		|		ПО ВТ_Сделки.Ссылка = ПриходДенегНаСчет.Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("МоментВремени", МоментВремени());
	Запрос.УстановитьПараметр("ВидОперации", ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеДенежныхСредств.ОплатаПокупателя"));
	
	ТаблицаОплатыПоСделкам = Запрос.Выполнить().Выгрузить();
	
    Для каждого СтрокаТаблицы Из ТаблицаОплатыПоСделкам Цикл
	
		//Если СтрокаТаблицы.Сумма + СтрокаТаблицы.СуммаОплачено > СтрокаТаблицы.СуммаДокумента Тогда
		//	
		//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		//		СтрШаблон("%1. Общая сумма оплаты (%2) превышает сумму по документу (%3)",
		//			СтрокаТаблицы.Документ,
		//			СтрокаТаблицы.Сумма + СтрокаТаблицы.СуммаОплачено,
		//			СтрокаТаблицы.СуммаДокумента
		//			),
		//		,
		//		,
		//		,
		//		Отказ
		//	);
		//		
		//	
		//КонецЕсли;
	
	КонецЦикла;
	
	Если Отказ Тогда
		Возврат
	КонецЕсли;
	
	Движения.ОплатыПоСделкам.Записывать = Истина;
	Движения.ОплатыПоСделкам.Загрузить(ТаблицаОплатыПоСделкам);
	

КонецПроцедуры // СформироватьДвиженияОплатыПоСделкам()

Процедура СформироватьДвиженияРасчетыСКомитентом(Отказ)

	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
		|	ПриходДенегНаСчет.Дата КАК Период,
		|	ПриходДенегНаСчет.Ссылка КАК Регистратор,
		|	ПриходДенегНаСчет.Организация КАК Организация,
	//	|	ПриходДенегНаСчет.Сделка КАК Сделка,
		|	ПриходДенегНаСчет.СуммаДокумента КАК Сумма,
		|	ПриходДенегНаСчет.Контрагент КАК Контрагент
		|ИЗ
		|	Документ.ПриходДенегНаСчет КАК ПриходДенегНаСчет
		|ГДЕ
		|	ПриходДенегНаСчет.Ссылка = &Ссылка
		|	И ПриходДенегНаСчет.ВидОперации = &ВидОперации";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ВидОперации", ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеДенежныхСредств.ОплатаКомитента"));
	
	ТаблицаОплатыПоСделкам = Запрос.Выполнить().Выгрузить();
	
	Движения.РасчетыСПоставщиками.Записывать = Истина;
	Движения.РасчетыСПоставщиками.Загрузить(ТаблицаОплатыПоСделкам);
	

КонецПроцедуры // СформироватьДвиженияОплатыПоСделкам()




#КонецОбласти

#КонецЕсли


