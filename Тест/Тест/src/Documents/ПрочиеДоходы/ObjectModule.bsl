
Процедура ОбработкаПроведения(Отказ,Режим)
	// регистр Баланс
	Движения.Баланс.Записывать = Истина;
	Движение = Движения.Баланс.Добавить();
	Движение.Период = Дата;
	Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
	Движение.Измерение1 = Счет;
	Движение.Баланс = СуммаПлатежа;

	// регистр ДвижениеТМЦВорктрак
	Движения.ДвижениеТМЦВорктрак.Записывать = Истина;
	Для Каждого ТекСтрокаТМЦ из ТМЦ Цикл
		Движение = Движения.ДвижениеТМЦВорктрак.Добавить();
		Движение.Период = Дата;
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.ТМЦ = ТекСтрокаТМЦ.Наименование;
		Движение.МестоХранения = ТекСтрокаТМЦ.МестоХраненияТМЦ;
		Движение.ИнвентарныйНомер = ТекСтрокаТМЦ.ИнвентарныйНомер;
		Движение.Количество = ТекСтрокаТМЦ.Количество;
		Движение.Цена = ТекСтрокаТМЦ.Стоимость;
	КонецЦикла;
КонецПроцедуры 

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
			Возврат;
	КонецЕсли;
	
	Если ПроверкаНаДублиВТаблицеТМЦ()  тогда 
		Сообщить (" Ошибка, в таблице ТМЦ есть Дубли");
		Отказ  = Истина; 
		Возврат; 
	ИначеЕСли ПроверкаОстатков() Тогда 
		Сообщить (" Ошибка, недостаточное колличество");
		Отказ  = Истина;
	КонецЕсли; 
КонецПроцедуры

Функция ПроверкаОстатков() 

	МассивИндкодов = Новый массив; 
	КоличествоОстаток = 0; 
	ФлагОстановкиЗаписи = ложь;
	  
	Для каждого Строка из ТМЦ Цикл 
		 КоличествоОстаток = ПроверкаОстатковЗапрос(Строка.ИнвентарныйНомер); 
		 Если КоличествоОстаток < Строка.Количество  Тогда 
		 	ФлагОстановкиЗаписи = Истина; 
		 	Возврат ФлагОстановкиЗаписи; 
		 	КонецЕсли;  
	конецЦикла;
	Возврат ФлагОстановкиЗаписи; 
КонецФункции

 Функция ПроверкаОстатковЗапрос(ИндКод)
 	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ДвижениеТМЦВорктракОстатки.ИнвентарныйНомер КАК ИнвентарныйНомер,
		|	ДвижениеТМЦВорктракОстатки.КоличествоОстаток КАК КоличествоОстаток
		|ИЗ
		|	РегистрНакопления.ДвижениеТМЦВорктрак.Остатки КАК ДвижениеТМЦВорктракОстатки
		|ГДЕ
		|	ДвижениеТМЦВорктракОстатки.ИнвентарныйНомер = &ИнвентарныйНомер";
	
	Запрос.УстановитьПараметр("ИнвентарныйНомер", ИндКод);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	КоличествоОстаток = 0; 
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		КоличествоОстаток = ВыборкаДетальныеЗаписи. КоличествоОстаток; 
	КонецЦикла;
 	
 	Возврат КоличествоОстаток;
 	 	 
 КонецФункции 
   
   Функция ПроверкаНаДублиВТаблицеТМЦ() 
	ИндНомер = "";
	ФлагОстановки= Ложь; 
	Для каждого Строка из ТМЦ Цикл 
		 
			Если ИндНомер = Строка.ИнвентарныйНомер Тогда 
				ФлагОстановки = истина; 
				Возврат ФлагОстановки ; 
			Иначе ИндНомер = Строка.ИнвентарныйНомер; 
			КонецЕсли; 
			
	конецЦикла; 
	Возврат ФлагОстановки; 
КонецФункции

