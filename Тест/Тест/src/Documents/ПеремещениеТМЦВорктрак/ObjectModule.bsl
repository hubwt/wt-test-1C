
#Область ОбработчикиСобытийФормы

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Ответственный = Пользователи.ТекущийПользователь();

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



Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	///+ГомзМА 18.04.2023
	Движения.ДвижениеТМЦВорктрак.Записывать = Истина;
		
		// регистр ДвижениеТМЦВорктрак Расход
		Для Каждого ТекСтрокаСписокТМЦ Из СписокТМЦ Цикл
			Движение 					= Движения.ДвижениеТМЦВорктрак.Добавить();
			Движение.ВидДвижения 		= ВидДвиженияНакопления.Расход;
			Движение.Период 	 		= Дата;
			Движение.ТМЦ 		 		= ТекСтрокаСписокТМЦ.ТМЦ;
			Движение.МестоХранения 		= ТекСтрокаСписокТМЦ.СкладСписания;
			Движение.ИнвентарныйНомер 	= ТекСтрокаСписокТМЦ.ИнвентарныйНомер;
			Движение.Количество 		= ТекСтрокаСписокТМЦ.Количество;
			Движение.Цена 				= ТекСтрокаСписокТМЦ.Цена;
		КонецЦикла;
		
		// регистр ДвижениеТМЦВорктрак Приход
		Для Каждого ТекСтрокаСписокТМЦ Из СписокТМЦ Цикл
			Движение 					= Движения.ДвижениеТМЦВорктрак.Добавить();
			Движение.ВидДвижения 		= ВидДвиженияНакопления.Приход;
			Движение.Период 			= Дата;
			Движение.ТМЦ 				= ТекСтрокаСписокТМЦ.ТМЦ;
			Движение.МестоХранения 		= ТекСтрокаСписокТМЦ.Склад;
			Движение.ИнвентарныйНомер 	= ТекСтрокаСписокТМЦ.ИнвентарныйНомер;
			Движение.Количество 		= ТекСтрокаСписокТМЦ.Количество;
			Движение.Цена 				= ТекСтрокаСписокТМЦ.Цена;
		КонецЦикла;
	
	Движения.Записать();
	
	Отказ = РегистрыНакопления.ДвижениеТМЦВорктрак.ЕстьОтрицательныеОстатки(Ссылка, Дата, ТекСтрокаСписокТМЦ.СкладСписания);
	///-ГомзМА 18.04.2023

КонецПроцедуры


Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	///+ГомзМА 27.04.2023
	СуммаДокумента = СписокТМЦ.Итог("Сумма");
	///-ГомзМА 27.04.2023
		
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы



#КонецОбласти


#Область СлужебныеПроцедурыИФункции

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

//&НаСервере
//Функция ПолучитьСуммуКоличестваЗадубленныхСтрок(ДокументПоступления, ИнвентарныйНомер)

//	
//	Запрос = Новый Запрос;
//	Запрос.Текст = 
//		"ВЫБРАТЬ
//		|	ДвижениеТМЦВорктрак.Регистратор КАК Регистратор,
//		|	ДвижениеТМЦВорктрак.ИнвентарныйНомер КАК ИнвентарныйНомер,
//		|	ДвижениеТМЦВорктрак.Количество КАК Количество
//		|ИЗ
//		|	РегистрНакопления.ДвижениеТМЦВорктрак КАК ДвижениеТМЦВорктрак
//		|ГДЕ
//		|	ДвижениеТМЦВорктрак.ИнвентарныйНомер = &ИнвентарныйНомер
//		|	И ДвижениеТМЦВорктрак.Регистратор = &ДокументПоступления";
//	
//	Запрос.УстановитьПараметр("ИнвентарныйНомер", 		ИнвентарныйНомер);
//	Запрос.УстановитьПараметр("ДокументПоступления", 	ДокументПоступления); 
//	
//	РезультатЗапроса = Запрос.Выполнить().Выбрать();
//	
//	Результат = 0;
//	Если РезультатЗапроса.Количество() > 1 Тогда
//		Пока РезультатЗапроса.Следующий() Цикл
//			Результат = Результат + РезультатЗапроса.Количество;	
//		КонецЦикла;
//		Возврат Результат;
//	Иначе
//		Возврат Результат;
//	КонецЕсли;


//КонецФункции // ПолучитьСуммуКоличестваЗадубленныхСтрок()


#КонецОбласти



