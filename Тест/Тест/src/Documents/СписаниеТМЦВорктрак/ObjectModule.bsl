
#Область ОбработчикиСобытийФормы

Процедура ОбработкаПроведения(Отказ, Режим)
	
	///+ГомзМА 07.04.2023
	Движения.ДвижениеТМЦВорктрак.Записывать = Истина;
	
	// регистр ДвижениеТМЦВорктрак Расход
	Для Каждого ТекСтрокаСписокТМЦ Из СписокТМЦ Цикл
		Движение 							= Движения.ДвижениеТМЦВорктрак.Добавить();
		Движение.ВидДвижения 			= ВидДвиженияНакопления.Расход;
		Движение.Период 	 				= Дата;
		Движение.ТМЦ 		 				= ТекСтрокаСписокТМЦ.ТМЦ;
		Движение.МестоХранения 		= ТекСтрокаСписокТМЦ.СкладСписания;
		Движение.ИнвентарныйНомер 	= ТекСтрокаСписокТМЦ.ИнвентарныйНомер;
		Движение.Количество 			= ТекСтрокаСписокТМЦ.Количество;
		Движение.Цена 					= ТекСтрокаСписокТМЦ.Цена;
	КонецЦикла;
	///-ГомзМА 07.04.2023
	
	///+ГомзМА 05.04.2023
	Движения.Записать();
	
	Отказ = РегистрыНакопления.ДвижениеТМЦВорктрак.ЕстьОтрицательныеОстатки(Ссылка, Дата, ТекСтрокаСписокТМЦ.СкладСписания); 
	///-ГомзМА 05.04.2023
	
	/// +++ Запись в регистр БюджетТМЦ (МазинЕС)
		
		// +++ Очищаем регистр от записей сделаных конкретным документом поступления
//			НаборЗаписей = РегистрыСведений.БюджетТМЦ.СоздатьНаборЗаписей();
//			НаборЗаписей.Отбор.ДокРег.Установить(Ссылка); 
//			НаборЗаписей.Очистить();
//			НаборЗаписей.Записать(); 
		// --- Очищаем регистр от записей сделаных конкретным документом поступления	
		
		Для каждого ТекСтрокаСписокТМЦ Из СписокТМЦ Цикл	
			
			Структура = НайтиРасходТМЦ(ТекСтрокаСписокТМЦ.ИнвентарныйНомер);
			
			МенеджерЗаписи 							= РегистрыСведений.БюджетТМЦ.СоздатьМенеджерЗаписи(); 
			МенеджерЗаписи.ТМЦ						= ТекСтрокаСписокТМЦ.ТМЦ;
			
			МенеджерЗаписи.Расход 					= Структура.Расход;
			МенеджерЗаписи.Статья 					= Статья;
			МенеджерЗаписи.ДокРег					= Ссылка;
					
			МенеджерЗаписи.ДатаРасхода			= Структура.ДатаРасхода;
			МенеджерЗаписи.Период					= Дата;
			МенеджерЗаписи.ИнвентарныйНомер 	= ТекСтрокаСписокТМЦ.ИнвентарныйНомер;
			МенеджерЗаписи.Количество				= ТекСтрокаСписокТМЦ.Количество;
			МенеджерЗаписи.Цена						= ТекСтрокаСписокТМЦ.Цена;
			МенеджерЗаписи.Сумма					= ТекСтрокаСписокТМЦ.Количество * ТекСтрокаСписокТМЦ.Цена; 
			МенеджерЗаписи.Коментарий				= Комментарий; 
					
			МенеджерЗаписи.Записать();
			
		КонецЦикла;

/// --- Запись в регистр БюджетТМЦ (МазинЕС)
	
КонецПроцедуры

Функция НайтиРасходТМЦ(ИнвентарныйНомер)

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	БюджетТМЦ.ИнвентарныйНомер,
		|	БюджетТМЦ.ДатаРасхода,
		|	БюджетТМЦ.Расход,
		|	БюджетТМЦ.Коментарий
		|ИЗ
		|	РегистрСведений.БюджетТМЦ КАК БюджетТМЦ
		|ГДЕ
		|	БюджетТМЦ.ИнвентарныйНомер = &ИнвентарныйНомер";
	
	Запрос.УстановитьПараметр("ИнвентарныйНомер", ИнвентарныйНомер);
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Структура= Новый Структура();  
	
	Структура.Вставить("Расход",Документы.Расходы.ПустаяСсылка());
	Структура.Вставить("ДатаРасхода",'20010101'); // Произвольная дата
	Структура.Вставить("Коментарий","");
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Структура.Вставить("Расход",ВыборкаДетальныеЗаписи.Расход );
		Структура.Вставить("ДатаРасхода",ВыборкаДетальныеЗаписи.ДатаРасхода);
		Структура.Вставить("Коментарий",ВыборкаДетальныеЗаписи.Коментарий);
	КонецЦикла;
			
	Возврат Структура;
КонецФункции

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Ответственный = Пользователи.ТекущийПользователь();
	СкладСписания = Справочники.Стеллаж.НайтиПоКоду("000000871");
		
	///+ГомзМА 21.06.2023
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПоступлениеТМЦВорктрак") Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИнвентарныеНомера.Ссылка КАК Ссылка,
		|	ИнвентарныеНомера.ДокументПоступления КАК ДокументПоступления,
		|	ИнвентарныеНомера.Владелец КАК Владелец,
		|	ИнвентарныеНомера.СерийныйНомер КАК СерийныйНомер
		|ИЗ
		|	Справочник.ИнвентарныеНомера КАК ИнвентарныеНомера
		|ГДЕ
		|	ИнвентарныеНомера.ДокументПоступления = &ДокументПоступления";
		
		Запрос.УстановитьПараметр("ДокументПоступления", ДанныеЗаполнения.Ссылка);
		
		РезультатЗапроса = Запрос.Выполнить().Выбрать();
		
		Пока РезультатЗапроса.Следующий() Цикл
			
			//Проверка на дубли в регистре накопления ДвижениеТМЦВорктрак
			Количество = РаботаСДокументамиТМЦВызовСервера.ПолучитьСуммуКоличестваЗадубленныхСтрок(РезультатЗапроса.ДокументПоступления, РезультатЗапроса.Ссылка);
			
			НоваяСтрока = СписокТМЦ.Добавить();
			НоваяСтрока.ИнвентарныйНомер 	= РезультатЗапроса.Ссылка;
			НоваяСтрока.ТМЦ 				= РезультатЗапроса.Владелец;
			НоваяСтрока.СерийныйНомер 		= РезультатЗапроса.СерийныйНомер;
			ДокументПоступленияТЧ = ПолучитьТабличнуюЧастьДокументаПоступление(РезультатЗапроса.Владелец, РезультатЗапроса.ДокументПоступления);
			
			Если ДокументПоступленияТЧ.ТипУчета = Перечисления.ТипУчетаТМЦ.УчестьПоштучно Тогда
				НоваяСтрока.Количество 			= 1;
				НоваяСтрока.Сумма 				= ДокументПоступленияТЧ.Цена;
			Иначе
				Если Количество = 0 Тогда
					НоваяСтрока.Количество 		= ДокументПоступленияТЧ.Количество;
				Иначе
					НоваяСтрока.Количество 		= Количество;
				КонецЕсли;
				НоваяСтрока.Сумма 				= ДокументПоступленияТЧ.Сумма;
			КонецЕсли;
			
			НоваяСтрока.Цена 					= ДокументПоступленияТЧ.Цена;
			НоваяСтрока.СкладСписания 			= ДокументПоступленияТЧ.Склад;
		КонецЦикла;
	КонецЕсли;
	///-ГомзМА 21.06.2023
	
КонецПроцедуры


Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	СуммаДокумента = СписокТМЦ.Итог("Сумма");
	
	///+ГомзМА 27.04.2023
	//смена статуса Инвентарного номера ТМЦ при списании
	Для каждого СтрокаСписокТМЦ Из СписокТМЦ Цикл
		СправочникОбъект = СтрокаСписокТМЦ.ИнвентарныйНомер.ПолучитьОбъект();
		СправочникОбъект.СтатусИнвентарногоНомераТМЦ = Перечисления.СтатусыИнвентарныхНомеровТМЦ.Списан;
		СправочникОбъект.Записать();
	КонецЦикла;
	///-ГомзМА 27.04.2023
	
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы



#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьТекущееМестоХраненияТМЦ(ТМЦ, ИнвентарныйНомер)

	///+ГомзМА 27.04.2023
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДвижениеТМЦВорктракОстатки.МестоХранения КАК МестоХранения
		|ИЗ
		|	РегистрНакопления.ДвижениеТМЦВорктрак.Остатки(&ДатаОстатков, ) КАК ДвижениеТМЦВорктракОстатки
		|ГДЕ
		|	ДвижениеТМЦВорктракОстатки.КоличествоОстаток > 0
		|	И ДвижениеТМЦВорктракОстатки.ТМЦ = &ТМЦ
		|	И ДвижениеТМЦВорктракОстатки.ИнвентарныйНомер = &ИнвентарныйНомер";
	
	Запрос.УстановитьПараметр("ДатаОстатков", 		ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("ТМЦ", 				ТМЦ);
	Запрос.УстановитьПараметр("ИнвентарныйНомер", 	ИнвентарныйНомер);
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	РезультатЗапроса.Следующий();
	
	Возврат РезультатЗапроса.МестоХранения;
	///-ГомзМА 27.04.2023

КонецФункции // ПолучитьТекущееМестоХраненияТМЦ()

Процедура ПриЗаписи(Отказ)
	
	///+ГомзМА 16.05.2023
	Если ВидСписания = Перечисления.ВидыСписания.ВПродажу Тогда
		Если ЗначениеЗаполнено(СписаниеВПродажу) Тогда
			ЗаказНаряд = СписаниеВПродажу;
			ДокОбъект 	 = ЗаказНаряд.ПолучитьОбъект();
			Если Проведен Тогда
				//Перезапись строк ТЧ по документу списание
				РаботаСДокументамиТМЦВызовСервера.УдалитьСтрокиТабличнойЧасти(ДокОбъект, Ссылка);
				
				Для каждого СтрокаСписокТМЦ Из СписокТМЦ Цикл
					СтрокаТЧ 	 				= ДокОбъект.ТМЦ.Добавить();
					СтрокаТЧ.ТМЦ 				= СтрокаСписокТМЦ.ТМЦ;
					СтрокаТЧ.Количество 		= СтрокаСписокТМЦ.Количество;
					СтрокаТЧ.Цена 				= СтрокаСписокТМЦ.Цена;
					СтрокаТЧ.Сумма 				= СтрокаСписокТМЦ.Сумма;
					СтрокаТЧ.ИнвентарныйНомер 	= СтрокаСписокТМЦ.ИнвентарныйНомер;
					СтрокаТЧ.СерийныйНомер 		= СтрокаСписокТМЦ.СерийныйНомер;
					СтрокаТЧ.СкладСписания 		= СтрокаСписокТМЦ.СкладСписания;
					СтрокаТЧ.Основание 			= Ссылка;
				КонецЦикла;
				
				ДокОбъект.Записать();
			Иначе
				//Удаление строк ТЧ по документу списание при отмене проведения
				РаботаСДокументамиТМЦВызовСервера.УдалитьСтрокиТабличнойЧасти(ДокОбъект, Ссылка);
				ДокОбъект.Записать();
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли ВидСписания = Перечисления.ВидыСписания.ВЗаказНаряд Тогда
		Если ЗначениеЗаполнено(СписаниеВЗаказНаряд) Тогда
			ЗаказНаряд = СписаниеВЗаказНаряд;
			ДокОбъект 	 = ЗаказНаряд.ПолучитьОбъект();
			Если Проведен Тогда
				//Перезапись строк ТЧ по документу списание
				РаботаСДокументамиТМЦВызовСервера.УдалитьСтрокиТабличнойЧасти(ДокОбъект, Ссылка);
				
				Для каждого СтрокаСписокТМЦ Из СписокТМЦ Цикл
					СтрокаТЧ 	 				= ДокОбъект.ТМЦ.Добавить();
					СтрокаТЧ.ТМЦ 				= СтрокаСписокТМЦ.ТМЦ;
					СтрокаТЧ.Количество 		= СтрокаСписокТМЦ.Количество;
					СтрокаТЧ.Цена 				= СтрокаСписокТМЦ.Цена;
					СтрокаТЧ.Сумма 				= СтрокаСписокТМЦ.Сумма;
					СтрокаТЧ.ИнвентарныйНомер 	= СтрокаСписокТМЦ.ИнвентарныйНомер;
					СтрокаТЧ.СерийныйНомер 		= СтрокаСписокТМЦ.СерийныйНомер;
					СтрокаТЧ.СкладСписания 		= СтрокаСписокТМЦ.СкладСписания;
					СтрокаТЧ.Основание 			= Ссылка;
				КонецЦикла;
				
				ДокОбъект.Записать();
			Иначе
				//Удаление строк ТЧ по документу списание при отмене проведения
				РаботаСДокументамиТМЦВызовСервера.УдалитьСтрокиТабличнойЧасти(ДокОбъект, Ссылка);
				ДокОбъект.Записать();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
///-ГомзМА 16.05.2023
	
КонецПроцедуры

&НаСервере
Функция ПолучитьТабличнуюЧастьДокументаПоступление(ТМЦ, ДокументПоступления)
	
	///+ГомзМА 21.06.2023
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПоступлениеТМЦВорктракСписокТМЦ.Количество КАК Количество,
		|	ПоступлениеТМЦВорктракСписокТМЦ.ТипУчета КАК ТипУчета,
		|	ПоступлениеТМЦВорктракСписокТМЦ.Цена КАК Цена,
		|	ПоступлениеТМЦВорктракСписокТМЦ.Сумма КАК Сумма,
		|	ПоступлениеТМЦВорктракСписокТМЦ.Склад КАК Склад
		|ИЗ
		|	Документ.ПоступлениеТМЦВорктрак.СписокТМЦ КАК ПоступлениеТМЦВорктракСписокТМЦ
		|ГДЕ
		|	ПоступлениеТМЦВорктракСписокТМЦ.ТМЦ = &ТМЦ
		|	И ПоступлениеТМЦВорктракСписокТМЦ.Ссылка.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("ТМЦ", 	ТМЦ);
	Запрос.УстановитьПараметр("Ссылка", ДокументПоступления);
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	
	РезультатЗапроса.Следующий();
	
	Возврат РезультатЗапроса;
	///-ГомзМА 21.06.2023


КонецФункции // ПолучитьТабличнуюЧастьДокументаПоступление()

#КонецОбласти











