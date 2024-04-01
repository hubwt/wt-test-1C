
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	///+ГомзМА 05.07.2023
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Машины") Тогда
		КодМашины 			= ДанныеЗаполнения.КодМашины;
		НаименованиеМашины 	= ДанныеЗаполнения.Ссылка;
	КонецЕсли	
	///-ГомзМА 05.07.2023
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	///+ГомзМА 06.07.2023
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Машины.Ссылка КАК Ссылка,
		|	Машины.ДокументФиксацииЗаказаМашины КАК ДокументФиксацииЗаказаМашины
		|ИЗ
		|	Справочник.Машины КАК Машины
		|ГДЕ
		|	Машины.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", НаименованиеМашины);
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	
	РезультатЗапроса.Следующий();

	Если РезультатЗапроса.Количество() > 0 Тогда
		Если РезультатЗапроса.ДокументФиксацииЗаказаМашины = Документы.ФиксацияЗаказаМашин.ПустаяСсылка() Тогда
			СправочникОбъект 								= РезультатЗапроса.Ссылка.ПолучитьОбъект();
			СправочникОбъект.ДокументФиксацииЗаказаМашины 	= Ссылка;
			СправочникОбъект.Записать();
		ИначеЕсли НЕ (ЗначениеЗаполнено(РезультатЗапроса.ДокументФиксацииЗаказаМашины) И РезультатЗапроса.ДокументФиксацииЗаказаМашины = Ссылка) Тогда
			Отказ = Истина;
			Сообщить("Невозможно записать, данная машина уже используется в документе: " + РезультатЗапроса.ДокументФиксацииЗаказаМашины);
		КонецЕсли;
	КонецЕсли;
	///-ГомзМА 06.07.2023
	
КонецПроцедуры



