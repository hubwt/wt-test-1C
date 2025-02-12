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
				//@skip-check query-in-loop
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
	
	Если ТипЗнч(Сделка) = Тип("ДокументСсылка.ПродажаЗапчастей") тогда
		Менеджер = сделка.КтоПродал;
	ИначеЕсли ТипЗнч(Сделка) = Тип("ДокументСсылка.ЗаказНаряд") тогда
		Менеджер = сделка.Инициатор.Пользователь;
	КонецЕсли;
	
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


