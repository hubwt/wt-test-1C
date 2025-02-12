
#Область ОбработчикиСобытийФормы

Процедура ОбработкаПроведения(Отказ, Режим)
	
	///+ГомзМА 07.04.2023
	Движения.ДвижениеТМЦСкладСнабжение.Записывать = Истина;
	
	// регистр ДвижениеТМЦСкладСнабжение Расход
	Для Каждого ТекСтрокаСписокТМЦ Из СписокТМЦ Цикл
		Движение 					= Движения.ДвижениеТМЦСкладСнабжение.Добавить();
		Движение.ВидДвижения 		= ВидДвиженияНакопления.Расход;
		Движение.Период 	 		= Дата;
		Движение.ТМЦ 		 		= ТекСтрокаСписокТМЦ.ТМЦ;
		Движение.МестоХранения 		= ТекСтрокаСписокТМЦ.СкладСписания;
		Движение.ИнвентарныйНомер 	= ТекСтрокаСписокТМЦ.ИнвентарныйНомер;
		Движение.Количество 		= ТекСтрокаСписокТМЦ.Количество;
		Движение.Цена 				= ТекСтрокаСписокТМЦ.Цена;
	КонецЦикла;
	///-ГомзМА 07.04.2023
	
	///+ГомзМА 05.04.2023
	Движения.Записать();
	
	Отказ = РегистрыНакопления.ДвижениеТМЦСкладСнабжение.ЕстьОтрицательныеОстатки(Ссылка, Дата, ТекСтрокаСписокТМЦ.СкладСписания); 
	///-ГомзМА 05.04.2023
	
КонецПроцедуры


Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Ответственный = Пользователи.ТекущийПользователь();
	СкладСписания = Справочники.Стеллаж.НайтиПоКоду("000000871");
		
	///+ГомзМА 21.06.2023
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПоступлениеТМЦСкладСнабжение") Тогда
		
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


Процедура ПриЗаписи(Отказ)
	
	///+ГомзМА 16.05.2023
	Если ВидСписания = Перечисления.ВидыСписания.ВПродажу Тогда
		Если ЗначениеЗаполнено(СписаниеВПродажу) Тогда
			Продажа 	= СписаниеВПродажу;
			ДокОбъект 	= Продажа.ПолучитьОбъект();
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
			ЗаказНаряд 	 = СписаниеВЗаказНаряд;
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
		|	ДвижениеТМЦСкладСнабжениеОстатки.МестоХранения КАК МестоХранения
		|ИЗ
		|	РегистрНакопления.ДвижениеТМЦСкладСнабжение.Остатки(&ДатаОстатков, ) КАК ДвижениеТМЦСкладСнабжениеОстатки
		|ГДЕ
		|	ДвижениеТМЦСкладСнабжениеОстатки.КоличествоОстаток > 0
		|	И ДвижениеТМЦСкладСнабжениеОстатки.ТМЦ = &ТМЦ
		|	И ДвижениеТМЦСкладСнабжениеОстатки.ИнвентарныйНомер = &ИнвентарныйНомер";
	
	Запрос.УстановитьПараметр("ДатаОстатков", 		ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("ТМЦ", 				ТМЦ);
	Запрос.УстановитьПараметр("ИнвентарныйНомер", 	ИнвентарныйНомер);
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	РезультатЗапроса.Следующий();
	
	Возврат РезультатЗапроса.МестоХранения;
	///-ГомзМА 27.04.2023

КонецФункции // ПолучитьТекущееМестоХраненияТМЦ()

&НаСервере
Функция ПолучитьТабличнуюЧастьДокументаПоступление(ТМЦ, ДокументПоступления)
	
	///+ГомзМА 21.06.2023
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПоступлениеТМЦСкладСнабжениеСписокТМЦ.Количество КАК Количество,
		|	ПоступлениеТМЦСкладСнабжениеСписокТМЦ.ТипУчета КАК ТипУчета,
		|	ПоступлениеТМЦСкладСнабжениеСписокТМЦ.Цена КАК Цена,
		|	ПоступлениеТМЦСкладСнабжениеСписокТМЦ.Сумма КАК Сумма,
		|	ПоступлениеТМЦСкладСнабжениеСписокТМЦ.Склад КАК Склад
		|ИЗ
		|	Документ.ПоступлениеТМЦСкладСнабжение.СписокТМЦ КАК ПоступлениеТМЦСкладСнабжениеСписокТМЦ
		|ГДЕ
		|	ПоступлениеТМЦСкладСнабжениеСписокТМЦ.ТМЦ = &ТМЦ
		|	И ПоступлениеТМЦСкладСнабжениеСписокТМЦ.Ссылка.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("ТМЦ", 	ТМЦ);
	Запрос.УстановитьПараметр("Ссылка", ДокументПоступления);
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	
	РезультатЗапроса.Следующий();
	
	Возврат РезультатЗапроса;
	///-ГомзМА 21.06.2023


КонецФункции // ПолучитьТабличнуюЧастьДокументаПоступление()

#КонецОбласти











